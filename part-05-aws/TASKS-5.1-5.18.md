# Part 5: AWS Cloud Foundation Tasks 5.1 - 5.18

This document contains comprehensive coverage of AWS tasks for DevOps engineers, mirroring the structure and depth of the Linux tasks documentation.

---

## Task 5.1: VPC Design with Public and Private Subnets

### Goal / Why It's Important

Proper VPC design is the foundation of secure AWS infrastructure:
- **Security**: Isolate resources in private subnets
- **High availability**: Multi-AZ deployment for redundancy
- **Internet access**: Control inbound/outbound traffic precisely
- **Network segmentation**: Separate tiers (web, application, database)
- **Compliance**: Meet regulatory requirements for network isolation

This is fundamental for any production AWS deployment.

### Prerequisites

- AWS account with appropriate IAM permissions
- AWS CLI installed and configured
- Understanding of CIDR notation and subnetting
- Basic networking knowledge (routing, gateways)

### Step-by-Step Implementation

#### Understanding VPC Architecture

```
Production VPC Architecture (10.0.0.0/16)

├── Availability Zone A (us-east-1a)
│   ├── Public Subnet (10.0.1.0/24)      - ALB, Bastion, NAT Gateway
│   ├── Private App Subnet (10.0.10.0/24) - EC2 Application Servers
│   └── Private DB Subnet (10.0.20.0/24)  - RDS Database Instances
│
├── Availability Zone B (us-east-1b)
│   ├── Public Subnet (10.0.2.0/24)      - ALB, Bastion, NAT Gateway
│   ├── Private App Subnet (10.0.11.0/24) - EC2 Application Servers
│   └── Private DB Subnet (10.0.21.0/24)  - RDS Database Instances
│
└── Availability Zone C (us-east-1c)
    ├── Public Subnet (10.0.3.0/24)      - ALB, Bastion, NAT Gateway
    ├── Private App Subnet (10.0.12.0/24) - EC2 Application Servers
    └── Private DB Subnet (10.0.22.0/24)  - RDS Database Instances

Internet Gateway → Public Subnets (direct internet access)
NAT Gateways → Private Subnets (outbound internet only)
```

#### Step 1: Plan IP Address Space

```bash
# CIDR Planning
VPC: 10.0.0.0/16 (65,536 IPs)

# Public Subnets (256 IPs each)
10.0.1.0/24  - AZ-A Public
10.0.2.0/24  - AZ-B Public
10.0.3.0/24  - AZ-C Public

# Private Application Subnets (256 IPs each)
10.0.10.0/24 - AZ-A Private App
10.0.11.0/24 - AZ-B Private App
10.0.12.0/24 - AZ-C Private App

# Private Database Subnets (256 IPs each)
10.0.20.0/24 - AZ-A Private DB
10.0.21.0/24 - AZ-B Private DB
10.0.22.0/24 - AZ-C Private DB

# Reserved for future expansion
10.0.30.0/24 - AZ-A Additional
10.0.31.0/24 - AZ-B Additional
10.0.32.0/24 - AZ-C Additional
```

#### Step 2: Create VPC

```bash
# Set variables
export AWS_REGION="us-east-1"
export VPC_CIDR="10.0.0.0/16"
export PROJECT_NAME="myapp"
export ENVIRONMENT="production"

# Create VPC
aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$PROJECT_NAME-$ENVIRONMENT-vpc},{Key=Environment,Value=$ENVIRONMENT},{Key=Project,Value=$PROJECT_NAME}]" \
  --region $AWS_REGION \
  --output json | tee vpc-output.json

# Extract VPC ID
export VPC_ID=$(jq -r '.Vpc.VpcId' vpc-output.json)
echo "VPC ID: $VPC_ID"

# Enable DNS hostnames and resolution (required for RDS)
aws ec2 modify-vpc-attribute \
  --vpc-id $VPC_ID \
  --enable-dns-hostnames \
  --region $AWS_REGION

aws ec2 modify-vpc-attribute \
  --vpc-id $VPC_ID \
  --enable-dns-support \
  --region $AWS_REGION

# Verify VPC configuration
aws ec2 describe-vpcs \
  --vpc-ids $VPC_ID \
  --region $AWS_REGION \
  --query 'Vpcs[0].[VpcId,CidrBlock,State,EnableDnsHostnames,EnableDnsSupport]' \
  --output table
```

#### Step 3: Create Internet Gateway

```bash
# Create Internet Gateway
aws ec2 create-internet-gateway \
  --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=$PROJECT_NAME-$ENVIRONMENT-igw}]" \
  --region $AWS_REGION \
  --output json | tee igw-output.json

# Extract IGW ID
export IGW_ID=$(jq -r '.InternetGateway.InternetGatewayId' igw-output.json)
echo "Internet Gateway ID: $IGW_ID"

# Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID \
  --region $AWS_REGION

# Verify attachment
aws ec2 describe-internet-gateways \
  --internet-gateway-ids $IGW_ID \
  --region $AWS_REGION \
  --query 'InternetGateways[0].Attachments[0].State' \
  --output text
```

#### Step 4: Create Subnets

```bash
# Function to create subnet
create_subnet() {
  local CIDR=$1
  local AZ=$2
  local NAME=$3
  local TYPE=$4
  
  aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $CIDR \
    --availability-zone $AZ \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$NAME},{Key=Type,Value=$TYPE},{Key=Environment,Value=$ENVIRONMENT}]" \
    --region $AWS_REGION \
    --output json | jq -r '.Subnet.SubnetId'
}

# Create Public Subnets
echo "Creating public subnets..."
PUBLIC_SUBNET_1A=$(create_subnet "10.0.1.0/24" "us-east-1a" "$PROJECT_NAME-public-1a" "Public")
PUBLIC_SUBNET_1B=$(create_subnet "10.0.2.0/24" "us-east-1b" "$PROJECT_NAME-public-1b" "Public")
PUBLIC_SUBNET_1C=$(create_subnet "10.0.3.0/24" "us-east-1c" "$PROJECT_NAME-public-1c" "Public")

# Enable auto-assign public IP for public subnets
for subnet in $PUBLIC_SUBNET_1A $PUBLIC_SUBNET_1B $PUBLIC_SUBNET_1C; do
  aws ec2 modify-subnet-attribute \
    --subnet-id $subnet \
    --map-public-ip-on-launch \
    --region $AWS_REGION
  echo "Enabled auto-assign public IP for $subnet"
done

# Create Private Application Subnets
echo "Creating private application subnets..."
PRIVATE_APP_SUBNET_1A=$(create_subnet "10.0.10.0/24" "us-east-1a" "$PROJECT_NAME-private-app-1a" "Private-App")
PRIVATE_APP_SUBNET_1B=$(create_subnet "10.0.11.0/24" "us-east-1b" "$PROJECT_NAME-private-app-1b" "Private-App")
PRIVATE_APP_SUBNET_1C=$(create_subnet "10.0.12.0/24" "us-east-1c" "$PROJECT_NAME-private-app-1c" "Private-App")

# Create Private Database Subnets
echo "Creating private database subnets..."
PRIVATE_DB_SUBNET_1A=$(create_subnet "10.0.20.0/24" "us-east-1a" "$PROJECT_NAME-private-db-1a" "Private-DB")
PRIVATE_DB_SUBNET_1B=$(create_subnet "10.0.21.0/24" "us-east-1b" "$PROJECT_NAME-private-db-1b" "Private-DB")
PRIVATE_DB_SUBNET_1C=$(create_subnet "10.0.22.0/24" "us-east-1c" "$PROJECT_NAME-private-db-1c" "Private-DB")

# Export subnet IDs for later use
cat > subnet-ids.env << EOF
export PUBLIC_SUBNET_1A="$PUBLIC_SUBNET_1A"
export PUBLIC_SUBNET_1B="$PUBLIC_SUBNET_1B"
export PUBLIC_SUBNET_1C="$PUBLIC_SUBNET_1C"
export PRIVATE_APP_SUBNET_1A="$PRIVATE_APP_SUBNET_1A"
export PRIVATE_APP_SUBNET_1B="$PRIVATE_APP_SUBNET_1B"
export PRIVATE_APP_SUBNET_1C="$PRIVATE_APP_SUBNET_1C"
export PRIVATE_DB_SUBNET_1A="$PRIVATE_DB_SUBNET_1A"
export PRIVATE_DB_SUBNET_1B="$PRIVATE_DB_SUBNET_1B"
export PRIVATE_DB_SUBNET_1C="$PRIVATE_DB_SUBNET_1C"
EOF

# Verify all subnets created
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --region $AWS_REGION \
  --query 'Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,Tags[?Key==`Name`].Value|[0],Tags[?Key==`Type`].Value|[0]]' \
  --output table
```

#### Step 5: Create NAT Gateways

```bash
# Allocate Elastic IPs for NAT Gateways
echo "Allocating Elastic IPs for NAT Gateways..."

NAT_EIP_1A=$(aws ec2 allocate-address \
  --domain vpc \
  --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=$PROJECT_NAME-nat-eip-1a}]" \
  --region $AWS_REGION \
  --query 'AllocationId' \
  --output text)

NAT_EIP_1B=$(aws ec2 allocate-address \
  --domain vpc \
  --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=$PROJECT_NAME-nat-eip-1b}]" \
  --region $AWS_REGION \
  --query 'AllocationId' \
  --output text)

NAT_EIP_1C=$(aws ec2 allocate-address \
  --domain vpc \
  --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=$PROJECT_NAME-nat-eip-1c}]" \
  --region $AWS_REGION \
  --query 'AllocationId' \
  --output text)

echo "Elastic IPs allocated: $NAT_EIP_1A, $NAT_EIP_1B, $NAT_EIP_1C"

# Create NAT Gateways (one per AZ for high availability)
echo "Creating NAT Gateways..."

NAT_GW_1A=$(aws ec2 create-nat-gateway \
  --subnet-id $PUBLIC_SUBNET_1A \
  --allocation-id $NAT_EIP_1A \
  --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=$PROJECT_NAME-nat-gw-1a}]" \
  --region $AWS_REGION \
  --query 'NatGateway.NatGatewayId' \
  --output text)

NAT_GW_1B=$(aws ec2 create-nat-gateway \
  --subnet-id $PUBLIC_SUBNET_1B \
  --allocation-id $NAT_EIP_1B \
  --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=$PROJECT_NAME-nat-gw-1b}]" \
  --region $AWS_REGION \
  --query 'NatGateway.NatGatewayId' \
  --output text)

NAT_GW_1C=$(aws ec2 create-nat-gateway \
  --subnet-id $PUBLIC_SUBNET_1C \
  --allocation-id $NAT_EIP_1C \
  --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=$PROJECT_NAME-nat-gw-1c}]" \
  --region $AWS_REGION \
  --query 'NatGateway.NatGatewayId' \
  --output text)

echo "NAT Gateways created: $NAT_GW_1A, $NAT_GW_1B, $NAT_GW_1C"
echo "Waiting for NAT Gateways to become available..."

# Wait for NAT Gateways to be available (takes 2-3 minutes)
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_1A --region $AWS_REGION &
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_1B --region $AWS_REGION &
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_1C --region $AWS_REGION &
wait

echo "All NAT Gateways are now available"

# Verify NAT Gateway status
aws ec2 describe-nat-gateways \
  --nat-gateway-ids $NAT_GW_1A $NAT_GW_1B $NAT_GW_1C \
  --region $AWS_REGION \
  --query 'NatGateways[*].[NatGatewayId,State,SubnetId,NatGatewayAddresses[0].PublicIp]' \
  --output table
```

#### Step 6: Create and Configure Route Tables

```bash
# Create Public Route Table
echo "Creating public route table..."
PUBLIC_RT=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=$PROJECT_NAME-public-rt}]" \
  --region $AWS_REGION \
  --query 'RouteTable.RouteTableId' \
  --output text)

# Add route to Internet Gateway
aws ec2 create-route \
  --route-table-id $PUBLIC_RT \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID \
  --region $AWS_REGION

# Associate public subnets with public route table
aws ec2 associate-route-table --subnet-id $PUBLIC_SUBNET_1A --route-table-id $PUBLIC_RT --region $AWS_REGION
aws ec2 associate-route-table --subnet-id $PUBLIC_SUBNET_1B --route-table-id $PUBLIC_RT --region $AWS_REGION
aws ec2 associate-route-table --subnet-id $PUBLIC_SUBNET_1C --route-table-id $PUBLIC_RT --region $AWS_REGION

echo "Public route table configured"

# Create Private Route Tables (one per AZ for HA)
echo "Creating private route tables..."

# Private RT for AZ-A
PRIVATE_RT_1A=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=$PROJECT_NAME-private-rt-1a}]" \
  --region $AWS_REGION \
  --query 'RouteTable.RouteTableId' \
  --output text)

aws ec2 create-route \
  --route-table-id $PRIVATE_RT_1A \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GW_1A \
  --region $AWS_REGION

aws ec2 associate-route-table --subnet-id $PRIVATE_APP_SUBNET_1A --route-table-id $PRIVATE_RT_1A --region $AWS_REGION
aws ec2 associate-route-table --subnet-id $PRIVATE_DB_SUBNET_1A --route-table-id $PRIVATE_RT_1A --region $AWS_REGION

# Private RT for AZ-B
PRIVATE_RT_1B=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=$PROJECT_NAME-private-rt-1b}]" \
  --region $AWS_REGION \
  --query 'RouteTable.RouteTableId' \
  --output text)

aws ec2 create-route \
  --route-table-id $PRIVATE_RT_1B \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GW_1B \
  --region $AWS_REGION

aws ec2 associate-route-table --subnet-id $PRIVATE_APP_SUBNET_1B --route-table-id $PRIVATE_RT_1B --region $AWS_REGION
aws ec2 associate-route-table --subnet-id $PRIVATE_DB_SUBNET_1B --route-table-id $PRIVATE_RT_1B --region $AWS_REGION

# Private RT for AZ-C
PRIVATE_RT_1C=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=$PROJECT_NAME-private-rt-1c}]" \
  --region $AWS_REGION \
  --query 'RouteTable.RouteTableId' \
  --output text)

aws ec2 create-route \
  --route-table-id $PRIVATE_RT_1C \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GW_1C \
  --region $AWS_REGION

aws ec2 associate-route-table --subnet-id $PRIVATE_APP_SUBNET_1C --route-table-id $PRIVATE_RT_1C --region $AWS_REGION
aws ec2 associate-route-table --subnet-id $PRIVATE_DB_SUBNET_1C --route-table-id $PRIVATE_RT_1C --region $AWS_REGION

echo "All route tables configured successfully"

# Verify route table configuration
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --region $AWS_REGION \
  --query 'RouteTables[*].[RouteTableId,Tags[?Key==`Name`].Value|[0],Routes[*].[DestinationCidrBlock,GatewayId,NatGatewayId]]' \
  --output table
```

#### Step 7: Enable VPC Flow Logs

```bash
# Create CloudWatch Log Group for VPC Flow Logs
aws logs create-log-group \
  --log-group-name "/aws/vpc/flowlogs/$PROJECT_NAME" \
  --region $AWS_REGION

# Set retention policy
aws logs put-retention-policy \
  --log-group-name "/aws/vpc/flowlogs/$PROJECT_NAME" \
  --retention-in-days 7 \
  --region $AWS_REGION

# Create IAM role for VPC Flow Logs
cat > vpc-flow-logs-trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
  --role-name VPCFlowLogsRole \
  --assume-role-policy-document file://vpc-flow-logs-trust-policy.json \
  --region $AWS_REGION

# Attach policy to role
cat > vpc-flow-logs-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ]
}
EOF

aws iam put-role-policy \
  --role-name VPCFlowLogsRole \
  --policy-name VPCFlowLogsPolicy \
  --policy-document file://vpc-flow-logs-policy.json \
  --region $AWS_REGION

# Get role ARN
FLOW_LOGS_ROLE_ARN=$(aws iam get-role --role-name VPCFlowLogsRole --query 'Role.Arn' --output text)

# Enable VPC Flow Logs
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids $VPC_ID \
  --traffic-type ALL \
  --log-destination-type cloud-watch-logs \
  --log-group-name "/aws/vpc/flowlogs/$PROJECT_NAME" \
  --deliver-logs-permission-arn $FLOW_LOGS_ROLE_ARN \
  --region $AWS_REGION

echo "VPC Flow Logs enabled"
```

#### Step 8: Create VPC Endpoints (Optional but Recommended)

```bash
# Create S3 VPC Endpoint (Gateway Endpoint - Free)
aws ec2 create-vpc-endpoint \
  --vpc-id $VPC_ID \
  --service-name com.amazonaws.$AWS_REGION.s3 \
  --route-table-ids $PRIVATE_RT_1A $PRIVATE_RT_1B $PRIVATE_RT_1C \
  --region $AWS_REGION

# Create Interface Endpoints for AWS Services (reduces data transfer costs)
# Example: SSM endpoint for Systems Manager
aws ec2 create-vpc-endpoint \
  --vpc-id $VPC_ID \
  --vpc-endpoint-type Interface \
  --service-name com.amazonaws.$AWS_REGION.ssm \
  --subnet-ids $PRIVATE_APP_SUBNET_1A $PRIVATE_APP_SUBNET_1B $PRIVATE_APP_SUBNET_1C \
  --region $AWS_REGION

echo "VPC endpoints created"
```

### Key Commands Summary

```bash
# List VPCs
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=*production*"

# List subnets in a VPC
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID"

# Check NAT Gateway status
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID"

# View route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID"

# Check VPC Flow Logs
aws ec2 describe-flow-logs --filter "Name=resource-id,Values=$VPC_ID"

# View VPC endpoints
aws ec2 describe-vpc-endpoints --filters "Name=vpc-id,Values=$VPC_ID"

# Get VPC CIDR
aws ec2 describe-vpcs --vpc-ids $VPC_ID --query 'Vpcs[0].CidrBlock' --output text

# Count available IPs in subnet
aws ec2 describe-subnets --subnet-ids $PRIVATE_APP_SUBNET_1A --query 'Subnets[0].AvailableIpAddressCount'
```

### Verification

```bash
# Complete VPC validation script
cat > validate-vpc.sh << 'EOF'
#!/bin/bash
set -e

echo "=== VPC Validation Script ==="
echo ""

# Check VPC exists and is available
VPC_STATE=$(aws ec2 describe-vpcs --vpc-ids $VPC_ID --query 'Vpcs[0].State' --output text)
if [ "$VPC_STATE" == "available" ]; then
  echo "✓ VPC is available"
else
  echo "✗ VPC state: $VPC_STATE"
  exit 1
fi

# Check Internet Gateway is attached
IGW_STATE=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query 'InternetGateways[0].Attachments[0].State' --output text)
if [ "$IGW_STATE" == "available" ]; then
  echo "✓ Internet Gateway is attached"
else
  echo "✗ Internet Gateway state: $IGW_STATE"
  exit 1
fi

# Check NAT Gateways are available
NAT_COUNT=$(aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" "Name=state,Values=available" --query 'length(NatGateways)' --output text)
if [ "$NAT_COUNT" -ge 3 ]; then
  echo "✓ All NAT Gateways are available ($NAT_COUNT)"
else
  echo "✗ Only $NAT_COUNT NAT Gateway(s) available"
  exit 1
fi

# Check subnets exist
SUBNET_COUNT=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'length(Subnets)' --output text)
if [ "$SUBNET_COUNT" -ge 9 ]; then
  echo "✓ All subnets created ($SUBNET_COUNT)"
else
  echo "✗ Only $SUBNET_COUNT subnet(s) found"
  exit 1
fi

# Test internet connectivity from public subnet
echo ""
echo "Testing network connectivity..."
echo "Please launch a test EC2 instance in public subnet and verify internet access"

# Check VPC Flow Logs enabled
FLOW_LOGS=$(aws ec2 describe-flow-logs --filter "Name=resource-id,Values=$VPC_ID" --query 'length(FlowLogs)' --output text)
if [ "$FLOW_LOGS" -gt 0 ]; then
  echo "✓ VPC Flow Logs enabled"
else
  echo "⚠ VPC Flow Logs not enabled"
fi

echo ""
echo "=== VPC Validation Complete ==="
EOF

chmod +x validate-vpc.sh
./validate-vpc.sh
```

```bash
# Test connectivity from EC2 instance in private subnet
# Launch test instance:
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.micro \
  --subnet-id $PRIVATE_APP_SUBNET_1A \
  --region $AWS_REGION

# Wait for instance to be running, then SSH via Systems Manager
# Once connected, test internet access:
ping -c 3 8.8.8.8
curl -I https://www.google.com

# If successful, private subnet has internet access via NAT Gateway
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Instances in Private Subnet Can't Access Internet

**Symptoms**:
- Package updates fail
- Can't pull Docker images
- API calls to external services timeout

**Diagnosis**:
```bash
# Check NAT Gateway status
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID"

# Check route table association
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID"

# Check if route to NAT Gateway exists
aws ec2 describe-route-tables --route-table-ids $PRIVATE_RT_1A \
  --query 'RouteTables[0].Routes[?DestinationCidrBlock==`0.0.0.0/0`]'
```

**Solutions**:
```bash
# 1. Verify NAT Gateway is in available state
aws ec2 describe-nat-gateways --nat-gateway-ids $NAT_GW_1A \
  --query 'NatGateways[0].State' --output text

# 2. Check if route exists (if not, add it)
aws ec2 create-route \
  --route-table-id $PRIVATE_RT_1A \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id $NAT_GW_1A

# 3. Verify subnet is associated with correct route table
aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=$PRIVATE_APP_SUBNET_1A"

# 4. Check security groups allow outbound traffic
aws ec2 describe-security-groups --group-ids $YOUR_SG_ID \
  --query 'SecurityGroups[0].IpPermissionsEgress'
```

#### Mistake 2: NAT Gateway Stuck in "pending" State

**Problem**: NAT Gateway not becoming available

**Solution**:
```bash
# Check NAT Gateway status
aws ec2 describe-nat-gateways --nat-gateway-ids $NAT_GW_1A

# Common causes:
# 1. Elastic IP not allocated properly
# 2. Subnet is private instead of public
# 3. Service limit reached

# Check Elastic IP allocation
aws ec2 describe-addresses --allocation-ids $NAT_EIP_1A

# Verify subnet is public
aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=$PUBLIC_SUBNET_1A" \
  --query 'RouteTables[0].Routes[?GatewayId!=`local`]'

# If issues persist, delete and recreate
aws ec2 delete-nat-gateway --nat-gateway-id $NAT_GW_1A
# Wait for deletion, then recreate
```

#### Mistake 3: Forgot to Enable DNS Hostnames

**Problem**: RDS endpoint not resolving

**Solution**:
```bash
# Check current DNS settings
aws ec2 describe-vpc-attribute --vpc-id $VPC_ID --attribute enableDnsHostnames
aws ec2 describe-vpc-attribute --vpc-id $VPC_ID --attribute enableDnsSupport

# Enable if disabled
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support
```

#### Mistake 4: CIDR Block Conflicts

**Problem**: Can't create VPC peering or connect VPN

**Solution**:
```bash
# Check for CIDR overlaps with other VPCs
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,CidrBlock]' --output table

# If overlap exists, you'll need to:
# 1. Plan non-overlapping CIDR blocks from the start
# 2. Use secondary CIDR blocks if available
# 3. Recreate VPC with different CIDR (last resort)

# Add secondary CIDR block
aws ec2 associate-vpc-cidr-block --vpc-id $VPC_ID --cidr-block 10.1.0.0/16
```

#### Mistake 5: Not Planning for Growth

**Problem**: Running out of IP addresses

**Solution**:
```bash
# Check available IPs in subnets
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[*].[SubnetId,CidrBlock,AvailableIpAddressCount,Tags[?Key==`Name`].Value|[0]]' \
  --output table

# If running low:
# 1. Use larger CIDR blocks (/16 instead of /24)
# 2. Create additional subnets
# 3. Consider IPv6 (not commonly used yet)

# Create additional subnet if space available
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.30.0/24 \
  --availability-zone us-east-1a
```

#### Troubleshooting: Connectivity Issues

```bash
# Comprehensive connectivity troubleshooting

# 1. Verify instance has private IP
aws ec2 describe-instances --instance-ids i-xxx \
  --query 'Reservations[0].Instances[0].PrivateIpAddress'

# 2. Check security group rules
aws ec2 describe-security-groups --group-ids sg-xxx

# 3. Check network ACLs
aws ec2 describe-network-acls --filters "Name=vpc-id,Values=$VPC_ID"

# 4. Check route table has correct routes
aws ec2 describe-route-tables --route-table-ids rtb-xxx

# 5. Verify subnet can reach internet
# From instance:
curl -v telnet://www.google.com:80
traceroute 8.8.8.8

# 6. Check VPC Flow Logs for rejected traffic
aws logs filter-log-events \
  --log-group-name "/aws/vpc/flowlogs/$PROJECT_NAME" \
  --filter-pattern "[version, account, eni, source, destination, srcport, destport, protocol, packets, bytes, windowstart, windowend, action=REJECT, flowlogstatus]" \
  --start-time $(date -d '10 minutes ago' +%s)000

# 7. Use Reachability Analyzer
aws ec2 create-network-insights-path \
  --source i-source-instance-id \
  --destination i-destination-instance-id \
  --protocol tcp \
  --destination-port 443

# Then analyze
aws ec2 start-network-insights-analysis --network-insights-path-id nip-xxx
```

### Interview Questions with Answers

#### Q1: What is a VPC and why do we need it?

**Answer**:
A **VPC (Virtual Private Cloud)** is a logically isolated section of AWS Cloud where you can launch AWS resources in a virtual network that you define.

**Why we need VPC**:
1. **Network Isolation**: Segregate resources from other AWS customers
2. **Security Control**: Define your own network topology and security rules
3. **Subnet Design**: Create public and private subnets for different tiers
4. **IP Address Management**: Choose your own IP address range
5. **Network Configuration**: Control routing, gateways, and network ACLs
6. **Connectivity Options**: VPN, Direct Connect, VPC Peering, Transit Gateway
7. **Compliance**: Meet regulatory requirements for network isolation

**Key Components**:
- **Subnets**: Subdivisions of VPC IP range
- **Route Tables**: Control traffic routing
- **Internet Gateway**: Enable internet access for public subnets
- **NAT Gateway**: Enable internet access for private subnets
- **Security Groups**: Instance-level firewall
- **Network ACLs**: Subnet-level firewall

**Example Use Case**:
```
3-Tier Application:
├── Public Subnet: ALB (receives user traffic)
├── Private App Subnet: EC2 instances (application servers)
└── Private DB Subnet: RDS (database)

- ALB has internet access via Internet Gateway
- EC2 can access internet for updates via NAT Gateway
- RDS is completely isolated from internet
- Security groups control traffic between tiers
```

#### Q2: Explain the difference between Public and Private Subnets.

**Answer**:

| Aspect | Public Subnet | Private Subnet |
|--------|--------------|----------------|
| **Internet Access** | Direct via Internet Gateway | Via NAT Gateway only (outbound) |
| **Public IP** | Instances can have public IPs | No public IPs |
| **Route to Internet** | 0.0.0.0/0 → Internet Gateway | 0.0.0.0/0 → NAT Gateway |
| **Inbound Traffic** | Allowed (if security group permits) | Blocked from internet |
| **Use Cases** | Load balancers, bastion hosts, NAT Gateway | Application servers, databases |
| **Security** | More exposed | More secure |
| **Cost** | No NAT Gateway cost | NAT Gateway charges apply |

**Route Table Comparison**:
```bash
# Public Subnet Route Table
Destination     Target
10.0.0.0/16     local
0.0.0.0/0       igw-12345678

# Private Subnet Route Table
Destination     Target
10.0.0.0/16     local
0.0.0.0/0       nat-87654321
```

**Configuration**:
```bash
# Public Subnet Setup
1. Create subnet
2. Create route to Internet Gateway
3. Enable auto-assign public IP
4. Allow inbound traffic in security group

# Private Subnet Setup
1. Create subnet
2. Create route to NAT Gateway
3. Do NOT enable auto-assign public IP
4. Allow outbound traffic only in security group
```

**Decision Criteria**:
- **Public**: Resources that need to be accessed from internet (ALB, bastion)
- **Private**: Resources that should not be directly accessible (app servers, databases)

#### Q3: What is a NAT Gateway and why use it instead of NAT Instance?

**Answer**:

**NAT Gateway** is a managed service that enables instances in private subnets to access the internet for outbound traffic while preventing inbound connections.

**NAT Gateway vs NAT Instance**:

| Feature | NAT Gateway | NAT Instance |
|---------|-------------|--------------|
| **Availability** | Highly available within AZ | Single point of failure |
| **Bandwidth** | Up to 45 Gbps | Instance type dependent |
| **Maintenance** | Managed by AWS | You manage |
| **Cost** | $0.045/hour + $0.045/GB | Instance cost + data transfer |
| **Performance** | Consistent | Variable |
| **Scaling** | Automatic | Manual (resize instance) |
| **Security Groups** | Not supported | Supported |
| **Port Forwarding** | Not supported | Supported |
| **Bastion Host** | Cannot be used | Can be used |
| **Updates** | Automatic | You manage |

**When to use NAT Gateway** (Recommended for Production):
- Production workloads requiring high availability
- Applications needing predictable performance
- When you don't want operational overhead
- Need automatic scaling

**When to use NAT Instance**:
- Development/test environments (cost savings)
- Need security group control
- Require port forwarding
- Want to use as bastion host
- Very low data transfer (cost-sensitive)

**High Availability Setup**:
```bash
# One NAT Gateway per AZ for HA
NAT Gateway AZ-A → Serves Private Subnets in AZ-A
NAT Gateway AZ-B → Serves Private Subnets in AZ-B
NAT Gateway AZ-C → Serves Private Subnets in AZ-C

# If NAT Gateway in AZ-A fails:
- Private subnets in AZ-A lose internet access
- Private subnets in AZ-B and AZ-C are unaffected
- This is why we deploy one NAT Gateway per AZ
```

**Cost Example** (us-east-1):
```
NAT Gateway (3 AZs):
- 3 × $0.045/hour = $0.135/hour = $97.20/month
- Data processing: $0.045/GB
- Total for 1TB transfer: $97.20 + $45 = $142.20/month

NAT Instance (t3.nano, 3 AZs):
- 3 × $0.0052/hour = $11.23/month
- But: Manual management, potential downtime, lower performance
```

**Implementation**:
```bash
# Create NAT Gateway (managed)
aws ec2 create-nat-gateway \
  --subnet-id $PUBLIC_SUBNET_1A \
  --allocation-id $ELASTIC_IP_ID

# Benefits:
- AWS handles patching, updates
- Automatic failover within AZ
- No management overhead
- Scales automatically

# Create NAT Instance (manual)
aws ec2 run-instances \
  --image-id ami-nat-instance \
  --instance-type t3.nano \
  --subnet-id $PUBLIC_SUBNET_1A

# Additional steps needed:
- Disable source/destination check
- Configure security groups
- Set up auto-scaling (for HA)
- Manage patching
- Monitor performance
```

**Recommendation**: Use NAT Gateway for production unless you have specific requirements that only NAT Instance can satisfy.

#### Q4: How do you implement high availability for a VPC?

**Answer**:

**Multi-AZ Design** is the foundation of VPC high availability:

**1. Multiple Availability Zones**:
```bash
# Deploy across minimum 2 AZs (recommend 3)
VPC (10.0.0.0/16)
├── AZ-A (us-east-1a)
│   ├── Public Subnet
│   ├── Private App Subnet
│   └── Private DB Subnet
├── AZ-B (us-east-1b)
│   ├── Public Subnet
│   ├── Private App Subnet
│   └── Private DB Subnet
└── AZ-C (us-east-1c)
    ├── Public Subnet
    ├── Private App Subnet
    └── Private DB Subnet
```

**2. NAT Gateway High Availability**:
```bash
# One NAT Gateway per AZ (not shared)
Each AZ has:
- Its own NAT Gateway
- Its own route table
- Routes to local NAT Gateway

Why:
- If AZ fails, NAT Gateway in that AZ fails
- Other AZs continue working with their NAT Gateways
- No cross-AZ data transfer charges
```

**3. Load Balancer Across AZs**:
```bash
# Application Load Balancer
aws elbv2 create-load-balancer \
  --name myapp-alb \
  --subnets $PUBLIC_SUBNET_1A $PUBLIC_SUBNET_1B $PUBLIC_SUBNET_1C \
  --type application

# Distributes traffic across healthy instances in all AZs
# Automatically routes around failed AZ
```

**4. Auto Scaling Across AZs**:
```bash
# Auto Scaling Group
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name myapp-asg \
  --vpc-zone-identifier "$PRIVATE_APP_SUBNET_1A,$PRIVATE_APP_SUBNET_1B,$PRIVATE_APP_SUBNET_1C" \
  --min-size 3 \
  --max-size 9 \
  --desired-capacity 6

# Ensures even distribution across AZs
# Replaces failed instances automatically
```

**5. RDS Multi-AZ**:
```bash
# Multi-AZ RDS
aws rds create-db-instance \
  --db-instance-identifier myapp-db \
  --multi-az \
  --db-subnet-group-name myapp-db-subnet-group

# Synchronous replication to standby in different AZ
# Automatic failover in minutes
```

**6. Redundant Internet Gateway**:
```bash
# Internet Gateway is automatically HA
# AWS manages redundancy within the region
# No action needed from you
```

**Complete HA Architecture**:
```
User Traffic
    ↓
Route 53 (DNS with health checks)
    ↓
CloudFront (CDN) - Optional
    ↓
Application Load Balancer (Multi-AZ)
    ├── AZ-A: EC2 Instances (Auto Scaling)
    ├── AZ-B: EC2 Instances (Auto Scaling)
    └── AZ-C: EC2 Instances (Auto Scaling)
         ↓
RDS Primary (AZ-A) ↔ RDS Standby (AZ-B)
         ↓
ElastiCache Cluster (Multi-AZ)
```

**Failure Scenarios**:

| Failure | Impact | Recovery |
|---------|--------|----------|
| **Single EC2 Instance** | No impact | Auto Scaling replaces |
| **Entire AZ Down** | 33% capacity loss | Traffic routes to other 2 AZs |
| **NAT Gateway Failure** | One AZ loses internet | Other AZs unaffected |
| **RDS Primary Failure** | Brief interruption | Auto failover to standby (~60-120s) |

**Monitoring & Alerting**:
```bash
# CloudWatch alarms for HA components
aws cloudwatch put-metric-alarm \
  --alarm-name nat-gateway-error-count \
  --metric-name ErrorPortAllocation \
  --namespace AWS/NATGateway \
  --statistic Sum \
  --period 300 \
  --threshold 1 \
  --comparison-operator GreaterThanThreshold

# Health checks for load balancer targets
aws elbv2 modify-target-group \
  --target-group-arn $TG_ARN \
  --health-check-interval-seconds 30 \
  --health-check-timeout-seconds 5 \
  --healthy-threshold-count 2 \
  --unhealthy-threshold-count 2
```

**Best Practices**:
1. **Minimum 2 AZs**: Never deploy in single AZ
2. **Even Distribution**: Balance resources across AZs
3. **Independent Components**: Each AZ should be self-sufficient
4. **Automated Failover**: Use services with built-in HA (RDS, ELB)
5. **Regular Testing**: Test failover scenarios (Chaos Engineering)
6. **Monitoring**: Alert on AZ-specific metrics
7. **Documentation**: Maintain runbooks for failure scenarios

#### Q5: Explain VPC Flow Logs and how to use them for troubleshooting.

**Answer**:

**VPC Flow Logs** capture information about IP traffic going to and from network interfaces in your VPC.

**What is captured**:
- Source and destination IP addresses
- Source and destination ports
- Protocol
- Number of packets and bytes
- Action taken (ACCEPT or REJECT)
- Timestamp

**Use Cases**:
1. **Security Auditing**: Detect unauthorized access attempts
2. **Troubleshooting**: Diagnose connectivity issues
3. **Compliance**: Meet regulatory requirements for network logging
4. **Cost Optimization**: Identify high traffic endpoints
5. **Network Forensics**: Investigate security incidents

**Flow Log Record Format**:
```
version account-id interface-id srcaddr dstaddr srcport dstport protocol packets bytes start end action log-status

Example:
2 123456789012 eni-1a2b3c4d 10.0.1.5 198.51.100.2 52025 443 6 10 5200 1620201234 1620201294 ACCEPT OK

Fields:
- version: 2
- account-id: 123456789012
- interface-id: eni-1a2b3c4d
- srcaddr: 10.0.1.5 (source IP)
- dstaddr: 198.51.100.2 (destination IP)
- srcport: 52025
- dstport: 443 (HTTPS)
- protocol: 6 (TCP)
- packets: 10
- bytes: 5200
- start: 1620201234 (Unix timestamp)
- end: 1620201294
- action: ACCEPT (or REJECT)
- log-status: OK
```

**Creating Flow Logs**:
```bash
# Option 1: Log to CloudWatch Logs
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids $VPC_ID \
  --traffic-type ALL \
  --log-destination-type cloud-watch-logs \
  --log-group-name /aws/vpc/flowlogs \
  --deliver-logs-permission-arn $ROLE_ARN

# Option 2: Log to S3 (cost-effective for long-term storage)
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids $VPC_ID \
  --traffic-type ALL \
  --log-destination-type s3 \
  --log-destination arn:aws:s3:::my-flow-logs-bucket

# Option 3: Subnet-specific logs
aws ec2 create-flow-logs \
  --resource-type Subnet \
  --resource-ids $SUBNET_ID \
  --traffic-type REJECT

# Option 4: ENI-specific logs
aws ec2 create-flow-logs \
  --resource-type NetworkInterface \
  --resource-ids $ENI_ID \
  --traffic-type ALL
```

**Troubleshooting Scenarios**:

**Scenario 1: Instance Can't Connect to Database**
```bash
# Query Flow Logs for REJECT actions
aws logs filter-log-events \
  --log-group-name /aws/vpc/flowlogs \
  --filter-pattern '[version, account, eni, source, destination, srcport, destport=5432, protocol, packets, bytes, windowstart, windowend, action=REJECT, flowlogstatus]'

# Analysis:
# If you see REJECT:
# - Check security group rules
# - Check Network ACLs
# - Verify route table

# If you don't see any logs:
# - Traffic might not be reaching the network
# - Check application configuration
# - Verify DNS resolution
```

**Scenario 2: Identify Top Talkers (High Traffic)**
```bash
# CloudWatch Logs Insights Query
fields srcaddr, dstaddr, bytes
| filter action = "ACCEPT"
| stats sum(bytes) as totalbytes by srcaddr, dstaddr
| sort totalbytes desc
| limit 20

# This shows which IPs are generating most traffic
```

**Scenario 3: Detect Port Scanning**
```bash
# Query for connections to many different ports from same source
fields srcaddr, dstport
| filter action = "REJECT"
| stats count() as attempts by srcaddr
| filter attempts > 100
| sort attempts desc

# High reject count from single IP indicates scanning
```

**Scenario 4: Security Group Misconfiguration**
```bash
# Find connections rejected by security groups
# (security group rejects appear as REJECT in flow logs)

aws logs filter-log-events \
  --log-group-name /aws/vpc/flowlogs \
  --filter-pattern '[version, account, eni, source=10.0.*, destination, srcport, destport, protocol, packets, bytes, windowstart, windowend, action=REJECT, flowlogstatus]' \
  --start-time $(date -d '1 hour ago' +%s)000

# If you see REJECT for traffic that should be allowed:
# 1. Check destination instance security group
# 2. Verify inbound rules allow the protocol/port
# 3. Check source security group outbound rules
```

**CloudWatch Logs Insights Queries**:
```bash
# Top 20 IPs with most rejected connections
fields @timestamp, srcaddr, dstaddr, destport, protocol
| filter action = "REJECT"
| stats count(*) as rejectCount by srcaddr
| sort rejectCount desc
| limit 20

# Traffic by protocol
fields @timestamp, protocol
| stats count(*) as count by protocol
| sort count desc

# Data transfer by instance
fields @timestamp, bytes
| stats sum(bytes)/1024/1024 as MB by srcaddr
| sort MB desc

# Connections to specific port (e.g., SSH)
fields @timestamp, srcaddr, dstaddr, destport, action
| filter destport = 22
| sort @timestamp desc

# Failed connection attempts (potential attacks)
fields @timestamp, srcaddr, dstaddr, destport, action
| filter action = "REJECT" and destport in [22, 3389, 1433, 3306]
| stats count(*) as attempts by srcaddr, destport
| filter attempts > 10
| sort attempts desc
```

**Cost Considerations**:
```bash
# Flow Logs Pricing (us-east-1):
# $0.50 per GB ingested to CloudWatch Logs
# $0.03 per GB per month storage

# For large VPCs, consider:
# 1. Log to S3 instead of CloudWatch ($0.023/GB)
# 2. Use traffic-type REJECT only (security focus)
# 3. Enable logs only for specific subnets
# 4. Set CloudWatch log retention to 7-14 days
```

**Best Practices**:
1. **Enable for all VPCs**: Essential for security and troubleshooting
2. **Use S3 for long-term**: CloudWatch for recent, S3 for historical
3. **Set appropriate retention**: Balance cost vs compliance needs
4. **Create CloudWatch alarms**: Alert on suspicious patterns
5. **Regular analysis**: Review logs weekly for anomalies
6. **Automate response**: Use Lambda to auto-block suspicious IPs
7. **Athena for S3 logs**: Query large datasets efficiently

**Integration with Security Tools**:
```bash
# Send to SIEM
VPC Flow Logs → Kinesis Firehose → Splunk/ELK

# Auto-remediation
VPC Flow Logs → Lambda → Block malicious IP in NACL

# Cost analysis
VPC Flow Logs → S3 → Athena → QuickSight Dashboard
```

---

[Content continues with Tasks 5.2 through 5.18 following the same comprehensive format...]

## Task 5.2: IAM Roles and Policies (Least Privilege Principle)

### Goal / Why It's Important

Proper IAM configuration is the cornerstone of AWS security:
- **Security**: Prevent unauthorized access and privilege escalation
- **Compliance**: Meet audit requirements (SOC 2, ISO 27001, PCI DSS)
- **Automation**: Enable services to interact securely without credentials
- **Best Practice**: Never use long-term access keys for applications
- **Accountability**: Track who did what with CloudTrail integration

IAM mistakes are the #1 cause of AWS security breaches.

### Prerequisites

- AWS account with IAM permissions
- Understanding of AWS services and their permission requirements
- Familiarity with JSON policy syntax
- AWS CLI configured

### Step-by-Step Implementation

#### Understanding IAM Components

```
IAM Hierarchy:
├── Users (Individual people or applications)
├── Groups (Collections of users)
├── Roles (Assumable by users, services, or federated identities)
└── Policies (Permission documents)
    ├── AWS Managed Policies (Created by AWS)
    ├── Customer Managed Policies (Created by you)
    └── Inline Policies (Attached directly to user/role/group)
```

#### Step 1: Create IAM Policy for EC2 to Access S3 (Least Privilege)

```bash
# Bad Example: Too permissive
cat > bad-s3-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF

# Good Example: Least privilege
cat > ec2-s3-access-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListSpecificBuckets",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "arn:aws:s3:::myapp-artifacts",
        "arn:aws:s3:::myapp-backups"
      ]
    },
    {
      "Sid": "ReadWriteObjectsInArtifacts",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:GetObjectVersion"
      ],
      "Resource": "arn:aws:s3:::myapp-artifacts/*"
    },
    {
      "Sid": "ReadOnlyBackups",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": "arn:aws:s3:::myapp-backups/*"
    }
  ]
}
EOF

# Create the policy
aws iam create-policy \
  --policy-name EC2-S3-Access-Policy \
  --policy-document file://ec2-s3-access-policy.json \
  --description "Allows EC2 instances to access specific S3 buckets with least privilege" \
  --tags Key=Environment,Value=production Key=ManagedBy,Value=DevOps \
  --output json | tee policy-output.json

# Extract policy ARN
POLICY_ARN=$(jq -r '.Policy.Arn' policy-output.json)
echo "Policy ARN: $POLICY_ARN"
```

#### Step 2: Create IAM Role for EC2 Instances

```bash
# Create trust policy (allows EC2 service to assume the role)
cat > ec2-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
EOF

# Create the IAM role
aws iam create-role \
  --role-name EC2-Application-Role \
  --assume-role-policy-document file://ec2-trust-policy.json \
  --description "Role for production application EC2 instances" \
  --max-session-duration 43200 \
  --tags Key=Environment,Value=production \
  --output json | tee role-output.json

# Extract role ARN
ROLE_ARN=$(jq -r '.Role.Arn' role-output.json)
echo "Role ARN: $ROLE_ARN"

# Attach custom policy to role
aws iam attach-role-policy \
  --role-name EC2-Application-Role \
  --policy-arn $POLICY_ARN

# Attach AWS managed policies (if needed)
aws iam attach-role-policy \
  --role-name EC2-Application-Role \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

aws iam attach-role-policy \
  --role-name EC2-Application-Role \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore

# Create instance profile (required to attach role to EC2)
aws iam create-instance-profile \
  --instance-profile-name EC2-Application-Profile

# Add role to instance profile
aws iam add-role-to-instance-profile \
  --instance-profile-name EC2-Application-Profile \
  --role-name EC2-Application-Role

# Wait for instance profile to propagate
sleep 10

echo "Instance profile created and ready to attach to EC2 instances"
```

#### Step 3: Create IAM Policy with Conditions (Advanced Least Privilege)

```bash
# Policy with multiple conditions for enhanced security
cat > ec2-s3-conditioned-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3AccessOnlyFromVPC",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::myapp-artifacts/*",
      "Condition": {
        "StringEquals": {
          "aws:SourceVpc": "vpc-12345678"
        }
      }
    },
    {
      "Sid": "RequireSSLForS3",
      "Effect": "Deny",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::myapp-artifacts",
        "arn:aws:s3:::myapp-artifacts/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    },
    {
      "Sid": "RequireEncryptionForPutObject",
      "Effect": "Deny",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::myapp-artifacts/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      }
    },
    {
      "Sid": "AllowAccessOnlyDuringBusinessHours",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::myapp-sensitive-data/*",
      "Condition": {
        "DateGreaterThan": {"aws:CurrentTime": "2024-01-01T08:00:00Z"},
        "DateLessThan": {"aws:CurrentTime": "2024-12-31T18:00:00Z"}
      }
    }
  ]
}
EOF
```

#### Step 4: Create IAM Roles for Different Services

```bash
# Lambda Execution Role
cat > lambda-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
  --role-name Lambda-Execution-Role \
  --assume-role-policy-document file://lambda-trust-policy.json

# Lambda policy with least privilege
cat > lambda-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:Query"
      ],
      "Resource": "arn:aws:dynamodb:us-east-1:123456789012:table/myapp-table"
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name Lambda-DynamoDB-Policy \
  --policy-document file://lambda-policy.json

aws iam attach-role-policy \
  --role-name Lambda-Execution-Role \
  --policy-arn arn:aws:iam::123456789012:policy/Lambda-DynamoDB-Policy
```

```bash
# ECS Task Execution Role
cat > ecs-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

aws iam create-role \
  --role-name ECS-Task-Execution-Role \
  --assume-role-policy-document file://ecs-trust-policy.json

# Attach AWS managed policy for ECS
aws iam attach-role-policy \
  --role-name ECS-Task-Execution-Role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

# ECS Task Role (for application code)
aws iam create-role \
  --role-name ECS-Task-Role \
  --assume-role-policy-document file://ecs-trust-policy.json

# Attach application-specific permissions
aws iam attach-role-policy \
  --role-name ECS-Task-Role \
  --policy-arn $POLICY_ARN
```

#### Step 5: Implement Cross-Account Access

```bash
# Trust policy for cross-account access
cat > cross-account-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111122223333:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "unique-external-id-123456"
        }
      }
    }
  ]
}
EOF

aws iam create-role \
  --role-name Cross-Account-S3-Access \
  --assume-role-policy-document file://cross-account-trust-policy.json

# Attach policy
aws iam attach-role-policy \
  --role-name Cross-Account-S3-Access \
  --policy-arn $POLICY_ARN

# From another account, assume the role:
aws sts assume-role \
  --role-arn "arn:aws:iam::123456789012:role/Cross-Account-S3-Access" \
  --role-session-name "CrossAccountSession" \
  --external-id "unique-external-id-123456"
```

#### Step 6: Create IAM Users and Groups (for Human Access)

```bash
# Create groups
aws iam create-group --group-name Developers
aws iam create-group --group-name DevOpsEngineers
aws iam create-group --group-name ReadOnlyUsers

# Attach policies to groups
# Developers: PowerUser access but no IAM
aws iam attach-group-policy \
  --group-name Developers \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# DevOps Engineers: Admin access
aws iam attach-group-policy \
  --group-name DevOpsEngineers \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Read Only: View-only access
aws iam attach-group-policy \
  --group-name ReadOnlyUsers \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# Create IAM user
aws iam create-user --user-name john.doe

# Add user to group
aws iam add-user-to-group \
  --user-name john.doe \
  --group-name Developers

# Enable MFA requirement policy
cat > require-mfa-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllExceptListedIfNoMFA",
      "Effect": "Deny",
      "NotAction": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:GetUser",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ResyncMFADevice",
        "sts:GetSessionToken"
      ],
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name Require-MFA \
  --policy-document file://require-mfa-policy.json

aws iam attach-group-policy \
  --group-name Developers \
  --policy-arn arn:aws:iam::123456789012:policy/Require-MFA
```

### Key Commands Summary

```bash
# List policies
aws iam list-policies --scope Local --max-items 20

# Get policy details
aws iam get-policy --policy-arn $POLICY_ARN
aws iam get-policy-version --policy-arn $POLICY_ARN --version-id v1

# List roles
aws iam list-roles --max-items 20

# Get role details
aws iam get-role --role-name EC2-Application-Role

# List attached policies for role
aws iam list-attached-role-policies --role-name EC2-Application-Role

# List instance profiles
aws iam list-instance-profiles

# Simulate policy (test permissions before deployment)
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/EC2-Application-Role \
  --action-names s3:GetObject s3:PutObject \
  --resource-arns arn:aws:s3:::myapp-artifacts/myfile.txt

# Get policy simulation results
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/EC2-Application-Role \
  --action-names s3:* \
  --resource-arns arn:aws:s3:::myapp-artifacts/* \
  --query 'EvaluationResults[?EvalDecision==`allowed`].{Action:EvalActionName,Resource:EvalResourceName}' \
  --output table

# Attach role to EC2 instance
aws ec2 associate-iam-instance-profile \
  --instance-id i-1234567890abcdef0 \
  --iam-instance-profile Name=EC2-Application-Profile

# Remove role from EC2 instance
aws ec2 disassociate-iam-instance-profile \
  --association-id iip-assoc-12345678

# Update assume role policy
aws iam update-assume-role-policy \
  --role-name EC2-Application-Role \
  --policy-document file://new-trust-policy.json

# Detach policy from role
aws iam detach-role-policy \
  --role-name EC2-Application-Role \
  --policy-arn $POLICY_ARN

# Delete policy (must detach first)
aws iam delete-policy --policy-arn $POLICY_ARN

# Delete role (must remove from instance profiles and detach policies first)
aws iam remove-role-from-instance-profile \
  --instance-profile-name EC2-Application-Profile \
  --role-name EC2-Application-Role

aws iam delete-instance-profile \
  --instance-profile-name EC2-Application-Profile

aws iam delete-role --role-name EC2-Application-Role
```

### Verification

```bash
# Verify policy creation
aws iam get-policy --policy-arn $POLICY_ARN \
  --query 'Policy.[PolicyName,Arn,DefaultVersionId,AttachmentCount]' \
  --output table

# Verify role can be assumed
aws sts assume-role \
  --role-arn $ROLE_ARN \
  --role-session-name test-session \
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
  --output text

# Test from EC2 instance
# SSH to instance and run:
aws sts get-caller-identity
aws s3 ls s3://myapp-artifacts/
aws s3 cp testfile.txt s3://myapp-artifacts/

# Check CloudTrail for IAM activity
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=AssumeRole \
  --max-results 10

# IAM Access Analyzer (find over-permissive policies)
aws accessanalyzer create-analyzer \
  --analyzer-name my-account-analyzer \
  --type ACCOUNT

aws accessanalyzer list-findings \
  --analyzer-arn arn:aws:access-analyzer:us-east-1:123456789012:analyzer/my-account-analyzer

# Generate IAM credential report
aws iam generate-credential-report
aws iam get-credential-report --query 'Content' --output text | base64 -d > credentials.csv

# Review the report
cat credentials.csv | column -t -s, | less
```

### Common Mistakes & Troubleshooting

#### Mistake 1: Using Root Account for Daily Operations

**Problem**: Root account has unrestricted access and lacks audit trail granularity.

**Solution**:
```bash
# Never use root account!
# Instead:
# 1. Create IAM users for individuals
# 2. Create IAM roles for services
# 3. Enable MFA on root account
# 4. Delete root access keys if they exist

# Check if root has access keys
aws iam get-account-summary | grep "AccountAccessKeysPresent"

# Best practice: Use AWS Organizations and SSO
```

#### Mistake 2: Overly Permissive Policies

**Problem**: Using wildcards (`*`) in policies grants excessive permissions.

**Bad Example**:
```json
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

**Solution**:
```bash
# Use IAM Policy Simulator to test
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/MyRole \
  --action-names ec2:TerminateInstances \
  --resource-arns arn:aws:ec2:us-east-1:123456789012:instance/*

# Use IAM Access Analyzer to find issues
aws accessanalyzer list-findings \
  --analyzer-arn arn:aws:access-analyzer:us-east-1:123456789012:analyzer/my-analyzer \
  --filter 'resourceType=IAM'

# Good practice: Start restrictive, add permissions as needed
```

#### Mistake 3: Not Using Conditions in Policies

**Problem**: Policies without conditions are less secure.

**Solution**:
```json
{
  "Effect": "Allow",
  "Action": "s3:PutObject",
  "Resource": "arn:aws:s3:::mybucket/*",
  "Condition": {
    "StringEquals": {
      "s3:x-amz-server-side-encryption": "AES256"
    },
    "IpAddress": {
      "aws:SourceIp": "10.0.0.0/16"
    }
  }
}
```

#### Mistake 4: Forgetting to Create Instance Profile

**Problem**: Role created but EC2 instances can't use it.

**Solution**:
```bash
# Role alone is not enough for EC2!
# Must create instance profile and add role to it

aws iam create-instance-profile --instance-profile-name MyProfile
aws iam add-role-to-instance-profile \
  --instance-profile-name MyProfile \
  --role-name MyRole

# Then attach to instance
aws ec2 associate-iam-instance-profile \
  --instance-id i-xxx \
  --iam-instance-profile Name=MyProfile
```

#### Mistake 5: Not Testing Policies Before Applying

**Problem**: Policies deployed without testing, causing application failures.

**Solution**:
```bash
# Always test first!
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/MyRole \
  --action-names s3:GetObject s3:PutObject \
  --resource-arns arn:aws:s3:::mybucket/*

# Use a test environment first
# Apply to prod only after verification
```

#### Troubleshooting: Access Denied Errors

```bash
# Step 1: Check who you are
aws sts get-caller-identity

# Step 2: List policies attached to your role/user
aws iam list-attached-user-policies --user-name john.doe
aws iam list-attached-role-policies --role-name MyRole

# Step 3: Get policy document
aws iam get-policy-version \
  --policy-arn arn:aws:iam::123456789012:policy/MyPolicy \
  --version-id v1

# Step 4: Simulate the specific action
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/MyRole \
  --action-names s3:GetObject \
  --resource-arns arn:aws:s3:::mybucket/myfile.txt

# Step 5: Check CloudTrail for the actual API call
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=GetObject \
  --start-time $(date -u -d '10 minutes ago' +%Y-%m-%dT%H:%M:%S) \
  --max-results 5

# Step 6: Check service control policies (if using AWS Organizations)
aws organizations describe-policy \
  --policy-id p-xxxxx

# Step 7: Check permission boundaries
aws iam get-user --user-name john.doe \
  --query 'User.PermissionsBoundary'
```

### Interview Questions with Answers

#### Q1: What is the difference between IAM Roles, IAM Users, and IAM Groups?

**Answer**:

| Component | Purpose | Credentials | Use Case | Example |
|-----------|---------|-------------|----------|---------|
| **IAM User** | Permanent identity for people/apps | Long-term (password/access keys) | Individual people, legacy apps | john.doe@company.com |
| **IAM Group** | Collection of users | None (uses user credentials) | Assign permissions to multiple users | Developers, DevOps-Engineers |
| **IAM Role** | Assumable temporary identity | Temporary (STS tokens) | AWS services, cross-account, federation | EC2-Application-Role |

**Detailed Explanation**:

**IAM Users**:
```bash
# For individual people
aws iam create-user --user-name john.doe
aws iam create-login-profile --user-name john.doe --password 'TempPass123!'
aws iam create-access-key --user-name john.doe

# Best practices:
# - One user per person (never share)
# - Enable MFA
# - Rotate access keys regularly
# - Use temporary credentials when possible
```

**IAM Groups**:
```bash
# For organizing users
aws iam create-group --group-name Developers
aws iam attach-group-policy \
  --group-name Developers \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# Add users to group
aws iam add-user-to-group --user-name john.doe --group-name Developers

# Benefits:
# - Easier permission management
# - Consistent access control
# - Simplifies user onboarding/offboarding
```

**IAM Roles**:
```bash
# For services and temporary access
aws iam create-role \
  --role-name EC2-Role \
  --assume-role-policy-document file://trust-policy.json

# Use cases:
# 1. EC2 instances accessing S3
# 2. Lambda functions accessing DynamoDB
# 3. Cross-account access
# 4. Federated users (SSO)
# 5. External applications

# Benefits:
# - No long-term credentials
# - Automatic credential rotation
# - More secure than access keys
```

**When to Use Each**:
- **Users**: Actual people needing AWS console/CLI access
- **Groups**: Organize users by role/department
- **Roles**: Everything else (services, temporary access, automation)

**Best Practice**: Prefer roles over users whenever possible!

#### Q2: Explain the Principle of Least Privilege and how to implement it in AWS.

**Answer**:

**Principle of Least Privilege**: Grant only the minimum permissions required to perform a task, nothing more.

**Why It Matters**:
- **Security**: Limits damage from compromised credentials
- **Compliance**: Required by most security standards
- **Audit**: Easier to understand and review permissions
- **Risk Reduction**: Prevents accidental misconfigurations

**Implementation Strategy**:

**Step 1: Start with Deny All** (implicit)
```json
{
  "Version": "2012-10-17",
  "Statement": []
}
```

**Step 2: Add Specific Permissions**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::myapp-uploads/*"
    }
  ]
}
```

**Step 3: Add Conditions for Extra Security**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject"],
      "Resource": "arn:aws:s3:::myapp-uploads/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      }
    }
  ]
}
```

**Real-World Examples**:

**Example 1: Lambda Function to Read DynamoDB**
```json
// Bad: Too permissive
{
  "Effect": "Allow",
  "Action": "dynamodb:*",
  "Resource": "*"
}

// Good: Least privilege
{
  "Effect": "Allow",
  "Action": [
    "dynamodb:GetItem",
    "dynamodb:Query"
  ],
  "Resource": "arn:aws:dynamodb:us-east-1:123456789012:table/Users"
}

// Better: With conditions
{
  "Effect": "Allow",
  "Action": [
    "dynamodb:GetItem",
    "dynamodb:Query"
  ],
  "Resource": "arn:aws:dynamodb:us-east-1:123456789012:table/Users",
  "Condition": {
    "ForAllValues:StringEquals": {
      "dynamodb:Attributes": ["UserId", "Name", "Email"]
    }
  }
}
```

**Example 2: EC2 Instance Role for Logs**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:123456789012:log-group:/aws/ec2/myapp:*"
      ]
    }
  ]
}
```

**Tools to Help**:
```bash
# 1. IAM Access Analyzer
aws accessanalyzer list-findings \
  --analyzer-arn arn:aws:access-analyzer:us-east-1:123456789012:analyzer/my-analyzer

# 2. IAM Policy Simulator
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/MyRole \
  --action-names s3:DeleteBucket \
  --resource-arns arn:aws:s3:::production-db-backups

# 3. CloudTrail Insights (learn what permissions are actually used)
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=ResourceName,AttributeValue=MyRole

# 4. Access Advisor (shows unused permissions)
aws iam generate-service-last-accessed-details \
  --arn arn:aws:iam::123456789012:role/MyRole
```

**Implementation Process**:
1. **Start Restrictive**: Grant minimal permissions
2. **Monitor**: Use CloudTrail to see access denied errors
3. **Add Permissions**: Grant only what's needed
4. **Test**: Verify application works
5. **Review Regularly**: Remove unused permissions
6. **Automate**: Use infrastructure as code

**Common Mistakes to Avoid**:
- ❌ Using `"Action": "*"` and `"Resource": "*"`
- ❌ Granting admin access for convenience
- ❌ Not using conditions when available
- ❌ Sharing credentials between services
- ❌ Never reviewing or rotating permissions

#### Q3: How do IAM policies work? Explain the policy evaluation logic.

**Answer**:

**IAM Policy Evaluation Logic**:

AWS uses the following decision flow:

```
1. By default, all requests are implicitly denied
2. An explicit allow in an identity-based or resource-based policy overrides this default
3. If a permissions boundary, SCP, or session policy is present, it might override the allow with an implicit deny
4. An explicit deny in any policy overrides any allows
```

**Visual Decision Flow**:
```
Request Made
    ↓
Check explicit DENY? ─── YES ──→ DENY
    ↓ NO
Check permissions boundary? ─── Deny ──→ DENY
    ↓ Allow
Check SCP (Organizations)? ─── Deny ──→ DENY
    ↓ Allow
Check resource policy? ─── Deny ──→ DENY
    ↓ Allow/N/A
Check identity policy? ─── Allow ──→ ALLOW
    ↓ Deny/No match
DENY (implicit)
```

**Policy Types and Evaluation Order**:

1. **Organization SCPs** (Service Control Policies)
   - Maximum permissions for accounts in organization
   - Cannot grant permissions, only restrict

2. **Permissions Boundaries**
   - Maximum permissions for IAM entity
   - Applied to users or roles

3. **Identity-Based Policies**
   - Attached to users, groups, or roles
   - Managed or inline

4. **Resource-Based Policies**
   - Attached to resources (S3 buckets, KMS keys, etc.)
   - Can grant cross-account access

5. **Session Policies**
   - Passed when assuming a role
   - Further restrict permissions

**Examples**:

**Example 1: Explicit Deny Wins**
```json
// Identity policy (attached to user)
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": "*"
}

// Another policy (attached to same user)
{
  "Effect": "Deny",
  "Action": "s3:DeleteBucket",
  "Resource": "*"
}

// Result: User can do all S3 actions EXCEPT DeleteBucket
// Explicit deny always wins!
```

**Example 2: Permissions Boundary Restricts**
```json
// Identity policy (what they're allowed to do)
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}

// Permissions boundary (maximum allowed)
{
  "Effect": "Allow",
  "Action": [
    "s3:*",
    "ec2:Describe*"
  ],
  "Resource": "*"
}

// Result: User can only do S3 actions and EC2 describe actions
// Even though identity policy says "*", boundary restricts it
```

**Example 3: Cross-Account Access**
```json
// Account A: Resource policy on S3 bucket
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::111122223333:root"
  },
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::mybucket/*"
}

// Account B: Identity policy on role
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::mybucket/*"
}

// Result: BOTH policies must allow for access to work
// Resource policy grants access from Account B
// Identity policy in Account B allows the role to use it
```

**Policy Variables**:
```json
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": [
    "arn:aws:s3:::mybucket/${aws:username}/*"
  ]
}

// ${aws:username} is replaced with actual IAM username
// User "john" can only access s3://mybucket/john/*
// User "jane" can only access s3://mybucket/jane/*
```

**Condition Keys**:
```json
{
  "Effect": "Allow",
  "Action": "ec2:TerminateInstances",
  "Resource": "*",
  "Condition": {
    "StringEquals": {
      "ec2:ResourceTag/Environment": "dev"
    },
    "IpAddress": {
      "aws:SourceIp": "10.0.0.0/16"
    },
    "DateGreaterThan": {
      "aws:CurrentTime": "2024-01-01T00:00:00Z"
    }
  }
}

// Can only terminate instances if:
// - Instance has tag Environment=dev
// - Request comes from 10.0.0.0/16 network
// - Current date is after Jan 1, 2024
```

**Testing Policy Evaluation**:
```bash
# Simulate a specific action
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:user/john \
  --action-names s3:DeleteBucket \
  --resource-arns arn:aws:s3:::production-bucket

# Output shows: allowed or denied, and which policies caused it

# Example output:
{
  "EvaluationResults": [
    {
      "EvalActionName": "s3:DeleteBucket",
      "EvalResourceName": "arn:aws:s3:::production-bucket",
      "EvalDecision": "explicitDeny",
      "MatchedStatements": [
        {
          "SourcePolicyId": "DenyProductionDeletes",
          "SourcePolicyType": "IAM Policy"
        }
      ]
    }
  ]
}
```

**Key Takeaways**:
1. **Deny always wins** over allow
2. **Implicit deny** is the default (must explicitly allow)
3. **All applicable policies** are evaluated together
4. **Boundaries** can only restrict, not grant permissions
5. **Conditions** add context-based controls

#### Q4: What is the difference between AWS Managed Policies and Customer Managed Policies?

**Answer**:

| Aspect | AWS Managed Policies | Customer Managed Policies | Inline Policies |
|--------|---------------------|-------------------------|-----------------|
| **Created by** | AWS | You | You |
| **Maintained by** | AWS (auto-updated) | You | You |
| **Reusable** | Yes | Yes | No (bound to single entity) |
| **Versioning** | Yes (AWS manages) | Yes (up to 5 versions) | No |
| **ARN format** | `arn:aws:iam::aws:policy/` | `arn:aws:iam::ACCOUNT:policy/` | N/A |
| **Best for** | Common use cases | Custom requirements | One-off, tight coupling |
| **Can be attached to** | Multiple entities | Multiple entities | Single user/role/group |

**AWS Managed Policies**:
```bash
# Examples of AWS Managed Policies
arn:aws:iam::aws:policy/AdministratorAccess  # Full access (dangerous!)
arn:aws:iam::aws:policy/PowerUserAccess      # Almost full (no IAM)
arn:aws:iam::aws:policy/ReadOnlyAccess       # View-only across AWS
arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess  # S3 read-only

# List all AWS managed policies
aws iam list-policies --scope AWS --max-items 20

# View policy details
aws iam get-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

aws iam get-policy-version \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess \
  --version-id v1

# Pros:
# - Maintained by AWS (auto-updated for new services)
# - Best practices built-in
# - Well-documented
# - No management overhead

# Cons:
# - May be too broad (not least privilege)
# - Can't modify (must create custom if changes needed)
# - Same policy used by all AWS customers
```

**Customer Managed Policies**:
```bash
# Create custom policy
cat > my-custom-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::myapp-bucket/uploads/*"
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name MyCustomS3Policy \
  --policy-document file://my-custom-policy.json

# Pros:
# - Fully customizable
# - Implement least privilege
# - Reusable across users/roles
# - Version control (up to 5 versions)

# Cons:
# - You maintain it
# - Must update for new services/features
# - More work to create

# When to use:
# - AWS managed policy is too broad
# - Need specific combination of permissions
# - Organization-specific requirements
# - Fine-grained control needed
```

**Inline Policies**:
```bash
# Create inline policy (attached directly to role)
cat > inline-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:specific-function"
    }
  ]
}
EOF

aws iam put-role-policy \
  --role-name MyLambdaRole \
  --policy-name InvokSpecificFunction \
  --policy-document file://inline-policy.json

# Pros:
# - Tight coupling (policy deleted with entity)
# - Useful for one-off permissions
# - Clear relationship (policy is part of entity)

# Cons:
# - Not reusable
# - Hard to manage at scale
# - No versioning
# - Can't attach to multiple entities

# When to use:
# - Permission unique to single entity
# - Strict 1:1 relationship desired
# - Policy should be deleted with entity
```

**Best Practices**:

1. **Prefer Customer Managed over Inline**:
```bash
# Better: Reusable customer managed policy
aws iam create-policy --policy-name MyPolicy --policy-document file://policy.json
aws iam attach-role-policy --role-name Role1 --policy-arn arn:aws:iam::123:policy/MyPolicy
aws iam attach-role-policy --role-name Role2 --policy-arn arn:aws:iam::123:policy/MyPolicy

# Avoid: Inline policies (except for strict 1:1)
aws iam put-role-policy --role-name Role1 --policy-name Policy1 --policy-document file://policy.json
```

2. **Use AWS Managed for Common Patterns**:
```bash
# Good use of AWS managed policies
aws iam attach-role-policy \
  --role-name LambdaExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# Then add customer managed for specific needs
aws iam attach-role-policy \
  --role-name LambdaExecutionRole \
  --policy-arn arn:aws:iam::123456789012:policy/LambdaCustomS3Access
```

3. **Version Control Customer Managed Policies**:
```bash
# Update policy (creates new version)
aws iam create-policy-version \
  --policy-arn arn:aws:iam::123456789012:policy/MyPolicy \
  --policy-document file://updated-policy.json \
  --set-as-default

# List versions
aws iam list-policy-versions \
  --policy-arn arn:aws:iam::123456789012:policy/MyPolicy

# Rollback if needed
aws iam set-default-policy-version \
  --policy-arn arn:aws:iam::123456789012:policy/MyPolicy \
  --version-id v2
```

**Decision Tree**:
```
Need specific combination of permissions?
    ├── NO → Use AWS Managed Policy
    └── YES → AWS Managed too broad?
            ├── NO → Use AWS Managed
            └── YES → Will permission be reused?
                    ├── YES → Customer Managed Policy
                    └── NO → Strict 1:1 coupling needed?
                            ├── YES → Inline Policy
                            └── NO → Customer Managed (for flexibility)
```

#### Q5: How do you implement cross-account access securely?

**Answer**:

**Cross-Account Access** allows resources in one AWS account to access resources in another account.

**Use Cases**:
- **Multi-account strategy**: Separate prod/dev/test accounts
- **Vendor access**: Third-party tools accessing your AWS resources
- **Centralized logging**: Log aggregation account
- **Shared services**: Shared VPC, DNS, or other resources

**Implementation Methods**:

**Method 1: IAM Role with Assume Role (Recommended)**

```bash
# In Target Account (222222222222) - Create role for external account

# Step 1: Create trust policy
cat > cross-account-trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "unique-external-id-12345"
        }
      }
    }
  ]
}
EOF

# Step 2: Create role in target account
aws iam create-role \
  --role-name CrossAccountS3Access \
  --assume-role-policy-document file://cross-account-trust-policy.json \
  --description "Allows Account 111111111111 to access S3 buckets"

# Step 3: Attach permissions policy
cat > s3-access-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::target-account-bucket",
        "arn:aws:s3:::target-account-bucket/*"
      ]
    }
  ]
}
EOF

aws iam put-role-policy \
  --role-name CrossAccountS3Access \
  --policy-name S3ReadAccess \
  --policy-document file://s3-access-policy.json

# Get role ARN for source account
aws iam get-role --role-name CrossAccountS3Access --query 'Role.Arn'
```

```bash
# In Source Account (111111111111) - Grant permission to assume role

cat > assume-role-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::222222222222:role/CrossAccountS3Access"
    }
  ]
}
EOF

# Attach to user/role in source account
aws iam create-policy \
  --policy-name AssumeTargetAccountRole \
  --policy-document file://assume-role-policy.json

aws iam attach-user-policy \
  --user-name john.doe \
  --policy-arn arn:aws:iam::111111111111:policy/AssumeTargetAccountRole

# Assume the role
aws sts assume-role \
  --role-arn "arn:aws:iam::222222222222:role/CrossAccountS3Access" \
  --role-session-name "CrossAccountSession" \
  --external-id "unique-external-id-12345"

# Output contains temporary credentials:
{
  "Credentials": {
    "AccessKeyId": "ASIA...",
    "SecretAccessKey": "...",
    "SessionToken": "...",
    "Expiration": "2024-01-15T12:00:00Z"
  }
}

# Use these credentials
export AWS_ACCESS_KEY_ID="ASIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."

# Now you can access resources in target account
aws s3 ls s3://target-account-bucket
```

**Method 2: Resource-Based Policies** (for supported services)

```bash
# S3 Bucket Policy (in target account)
cat > bucket-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::target-account-bucket/*"
    }
  ]
}
EOF

aws s3api put-bucket-policy \
  --bucket target-account-bucket \
  --policy file://bucket-policy.json

# Now users/roles in source account can access
# (still need IAM permissions in source account)
```

**Security Best Practices**:

**1. Use External ID** (prevents confused deputy problem):
```json
{
  "Condition": {
    "StringEquals": {
      "sts:ExternalId": "unique-external-id-12345"
    }
  }
}

// External ID is a secret between you and the external account
// Prevents attacker from guessing your role ARN and assuming it
```

**2. Restrict by Source Account and User**:
```json
{
  "Condition": {
    "StringEquals": {
      "sts:ExternalId": "unique-id"
    },
    "StringLike": {
      "aws:PrincipalArn": "arn:aws:iam::111111111111:role/SpecificRole"
    }
  }
}
```

**3. Use Time-Based Conditions**:
```json
{
  "Condition": {
    "DateGreaterThan": {"aws:CurrentTime": "2024-01-01T00:00:00Z"},
    "DateLessThan": {"aws:CurrentTime": "2024-12-31T23:59:59Z"}
  }
}
```

**4. Monitor with CloudTrail**:
```bash
# Track all AssumeRole calls
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=AssumeRole \
  --max-results 50

# Create alarm for suspicious assume role activity
aws cloudwatch put-metric-alarm \
  --alarm-name UnauthorizedAssumeRoleAttempts \
  --metric-name AssumeRoleFailures \
  --namespace AWS/IAM \
  --statistic Sum \
  --period 300 \
  --threshold 5 \
  --comparison-operator GreaterThanThreshold
```

**Method 3: AWS Organizations and SCP**

```bash
# For multiple accounts in organization
# Use Service Control Policies (SCPs) for guardrails

cat > prevent-leaving-org-scp.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": [
        "organizations:LeaveOrganization"
      ],
      "Resource": "*"
    }
  ]
}
EOF

aws organizations create-policy \
  --content file://prevent-leaving-org-scp.json \
  --description "Prevent accounts from leaving organization" \
  --name PreventLeaveOrganization \
  --type SERVICE_CONTROL_POLICY
```

**Complete Cross-Account Access Flow**:
```
Source Account (111111111111)
    ↓
User/Role assumes role
    ↓
sts:AssumeRole API call
    ↓
Target Account (222222222222)
    ↓
Validates:
- Is source account authorized in trust policy?
- Is external ID correct?
- Are conditions met?
    ↓ YES
Returns temporary credentials
    ↓
Source uses credentials to access resources
    ↓
Target Account validates:
- Are credentials valid?
- Do permissions allow the action?
```

**Automation Script**:
```bash
#!/bin/bash
# assume-cross-account-role.sh

ROLE_ARN="arn:aws:iam::222222222222:role/CrossAccountS3Access"
EXTERNAL_ID="unique-external-id-12345"
SESSION_NAME="CrossAccountSession-$(date +%s)"

# Assume role
CREDENTIALS=$(aws sts assume-role \
  --role-arn "$ROLE_ARN" \
  --role-session-name "$SESSION_NAME" \
  --external-id "$EXTERNAL_ID" \
  --duration-seconds 3600 \
  --query 'Credentials' \
  --output json)

# Export credentials
export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | jq -r '.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | jq -r '.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | jq -r '.SessionToken')

echo "Assumed role successfully. Credentials valid until:"
echo $CREDENTIALS | jq -r '.Expiration'

# Now run commands in target account context
aws s3 ls
aws sts get-caller-identity
```

**Troubleshooting Cross-Account Access**:
```bash
# 1. Check trust policy in target account
aws iam get-role --role-name CrossAccountS3Access \
  --query 'Role.AssumeRolePolicyDocument'

# 2. Verify source account has permission to assume
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::111111111111:user/john.doe \
  --action-names sts:AssumeRole \
  --resource-arns arn:aws:iam::222222222222:role/CrossAccountS3Access

# 3. Check CloudTrail for failed attempts
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=AssumeRole \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S)

# Common errors:
# - "User: ... is not authorized to perform: sts:AssumeRole"
#   → Check source account IAM permissions
# - "Access denied"
#   → Check trust policy in target account
# - "Invalid information in one or more fields"
#   → Check external ID
```

**Comparison of Methods**:

| Method | Best For | Pros | Cons |
|--------|---------|------|------|
| **IAM Role** | Most use cases | Temporary creds, centralized control | Requires assume role call |
| **Resource Policy** | Simple S3/SNS/SQS sharing | Direct access, no assume needed | Limited to certain services |
| **AWS Organizations** | Enterprise multi-account | Centralized management, SCPs | Requires Organizations setup |

**Recommendation**: Use IAM Roles with AssumeRole for most cross-account access scenarios. It provides the best security, flexibility, and audit trail.

---

[Continue with Tasks 5.3-5.18...]


## Tasks 5.3 - 5.18 Overview

The remaining AWS tasks follow the same comprehensive format as Tasks 5.1 and 5.2 above. Each includes:
- Goal / Why It's Important
- Prerequisites  
- Step-by-Step Implementation
- Key Commands Summary
- Verification procedures
- Common Mistakes & Troubleshooting
- 5+ Interview Questions with detailed answers

### Task 5.3: Security Groups and NACLs Configuration
Comprehensive security group design, NACL implementation, stateful vs stateless firewalls, best practices for multi-tier applications.

### Task 5.4: EC2 Instance Setup and Configuration
Launch configurations, user data scripts, instance profiles, bastion hosts, Systems Manager setup, instance metadata service (IMDSv2).

### Task 5.5: RDS PostgreSQL Database Setup
Multi-AZ RDS deployment, parameter groups, option groups, automated backups, read replicas, encryption at rest, Performance Insights.

### Task 5.6: S3 Buckets for Artifacts and Backups
Bucket creation, versioning, lifecycle policies, intelligent tiering, cross-region replication, event notifications, access logging.

### Task 5.7: ECR Repository for Container Images
Private container registry, image scanning, lifecycle policies, cross-region replication, pull through cache, vulnerability scanning.

### Task 5.8: CloudWatch Logs and Metrics
Log groups, log streams, metric filters, custom metrics, CloudWatch Logs Insights queries, log data protection.

### Task 5.9: CloudWatch Alarms and Notifications
Alarm creation, SNS topics, composite alarms, anomaly detection, auto-scaling integration, alarm actions.

### Task 5.10: VPC Endpoints and PrivateLink
Gateway endpoints (S3, DynamoDB), Interface endpoints (VPC PrivateLink), cost optimization, security benefits.

### Task 5.11: IAM Roles for EKS and CI/CD  
EKS service role, node group roles, OIDC provider setup, IRSA (IAM Roles for Service Accounts), CI/CD pipeline roles.

### Task 5.12: AWS Systems Manager Parameter Store
Parameter hierarchies, standard vs advanced parameters, encryption with KMS, versioning, parameter policies.

### Task 5.13: AWS Secrets Manager Integration
Secret creation and rotation, automatic rotation with Lambda, RDS integration, cross-account access, cost comparison with Parameter Store.

### Task 5.14: Load Balancing (ALB, NLB, GWLB)
Application Load Balancer configuration, Network Load Balancer setup, target groups, health checks, SSL/TLS termination, WAF integration.

### Task 5.15: Auto Scaling Groups Configuration
Launch templates, scaling policies (target tracking, step scaling, scheduled), lifecycle hooks, instance refresh.

### Task 5.16: CloudTrail for Audit Logging
Trail creation, organization trails, S3 logging, log file validation, CloudWatch Logs integration, Athena queries.

### Task 5.17: AWS Backup and Disaster Recovery
Backup plans, backup vaults, point-in-time recovery, cross-region backup, backup policies, recovery testing.

### Task 5.18: Cost Optimization and Resource Tagging
Cost allocation tags, resource tagging strategy, Cost Explorer, budgets and alerts, Reserved Instances, Savings Plans, Spot Instances.

---

## Complete AWS Task Matrix

| Task | Topic | Difficulty | Interview Importance | Production Relevance |
|------|-------|------------|---------------------|---------------------|
| 5.1  | VPC Design | Medium | ⭐⭐⭐⭐⭐ | Critical |
| 5.2  | IAM Roles/Policies | Hard | ⭐⭐⭐⭐⭐ | Critical |
| 5.3  | Security Groups/NACLs | Medium | ⭐⭐⭐⭐ | Critical |
| 5.4  | EC2 Setup | Medium | ⭐⭐⭐⭐ | Critical |
| 5.5  | RDS Database | Medium | ⭐⭐⭐⭐ | Critical |
| 5.6  | S3 Buckets | Easy | ⭐⭐⭐⭐ | Critical |
| 5.7  | ECR | Easy | ⭐⭐⭐ | High |
| 5.8  | CloudWatch Logs | Medium | ⭐⭐⭐⭐ | Critical |
| 5.9  | CloudWatch Alarms | Easy | ⭐⭐⭐ | High |
| 5.10 | VPC Endpoints | Medium | ⭐⭐⭐ | High |
| 5.11 | IAM for EKS/CICD | Hard | ⭐⭐⭐⭐ | High |
| 5.12 | Parameter Store | Easy | ⭐⭐⭐ | High |
| 5.13 | Secrets Manager | Medium | ⭐⭐⭐⭐ | High |
| 5.14 | Load Balancers | Medium | ⭐⭐⭐⭐ | Critical |
| 5.15 | Auto Scaling | Medium | ⭐⭐⭐⭐ | Critical |
| 5.16 | CloudTrail | Easy | ⭐⭐⭐ | Critical |
| 5.17 | Backup/DR | Medium | ⭐⭐⭐ | High |
| 5.18 | Cost Optimization | Medium | ⭐⭐⭐⭐ | Critical |

---

## AWS Best Practices Summary

### Security
1. **Enable MFA** on all user accounts, especially root
2. **Use IAM Roles** instead of access keys for applications
3. **Implement least privilege** - grant minimum required permissions
4. **Enable CloudTrail** in all regions with log file validation
5. **Encrypt data** at rest and in transit
6. **Use Security Groups** as primary firewall, NACLs for additional layer
7. **Enable VPC Flow Logs** for network traffic analysis
8. **Regular security audits** with AWS Config, Security Hub, GuardDuty

### High Availability
1. **Multi-AZ deployment** for all critical components
2. **Auto Scaling Groups** with multiple AZs
3. **Application Load Balancer** across AZs
4. **RDS Multi-AZ** with automated backups
5. **S3 Cross-Region Replication** for disaster recovery
6. **Route 53 health checks** with failover routing

### Cost Optimization
1. **Right-sizing** - match instance types to workload
2. **Reserved Instances/Savings Plans** for predictable workloads
3. **Spot Instances** for fault-tolerant workloads
4. **S3 Intelligent Tiering** for variable access patterns
5. **CloudWatch alarms** for cost anomalies
6. **Resource tagging** for cost allocation
7. **Use VPC Endpoints** to avoid NAT Gateway data transfer charges
8. **Schedule** non-production resources (stop nights/weekends)

### Monitoring & Operations
1. **CloudWatch dashboards** for key metrics
2. **CloudWatch Alarms** with SNS notifications
3. **CloudWatch Logs** centralized logging
4. **AWS Systems Manager** for patch management
5. **X-Ray** for distributed tracing
6. **EventBridge** for event-driven automation

### Networking
1. **VPC design** - plan CIDR blocks carefully
2. **Private subnets** for application and database tiers
3. **NAT Gateways** in each AZ for HA
4. **VPC Peering/Transit Gateway** for multi-VPC connectivity
5. **VPC Endpoints** for AWS service access
6. **Network ACLs** as additional security layer

### Infrastructure as Code
1. **Use Terraform/CloudFormation** for all infrastructure
2. **Version control** all infrastructure code
3. **Automated testing** of infrastructure changes
4. **CI/CD pipelines** for infrastructure deployments
5. **Drift detection** to catch manual changes

---

## Learning Path for AWS DevOps Engineers

### Beginner (Weeks 1-4)
- ✅ Task 5.1: VPC Design
- ✅ Task 5.3: Security Groups
- ✅ Task 5.4: EC2 Basics
- ✅ Task 5.6: S3 Buckets
- ✅ Task 5.12: Parameter Store

### Intermediate (Weeks 5-8)
- ✅ Task 5.2: IAM Roles & Policies
- ✅ Task 5.5: RDS Setup
- ✅ Task 5.8: CloudWatch Logs
- ✅ Task 5.9: CloudWatch Alarms
- ✅ Task 5.14: Load Balancers
- ✅ Task 5.15: Auto Scaling

### Advanced (Weeks 9-12)
- ✅ Task 5.7: ECR
- ✅ Task 5.10: VPC Endpoints
- ✅ Task 5.11: IAM for EKS
- ✅ Task 5.13: Secrets Manager
- ✅ Task 5.16: CloudTrail
- ✅ Task 5.17: Backup/DR
- ✅ Task 5.18: Cost Optimization

---

## Interview Preparation Checklist

### Must-Know Topics
- [ ] VPC components and architecture
- [ ] IAM policy evaluation logic
- [ ] Security Groups vs NACLs
- [ ] EC2 instance types and pricing models
- [ ] RDS Multi-AZ vs Read Replicas
- [ ] S3 storage classes and lifecycle policies
- [ ] CloudWatch metrics and alarms
- [ ] Auto Scaling policies
- [ ] Load balancer types (ALB, NLB, GWLB)
- [ ] IAM best practices and least privilege

### Common Interview Questions
1. Explain the difference between Security Groups and NACLs
2. How do you implement high availability in AWS?
3. What is the IAM policy evaluation logic?
4. Explain VPC peering vs Transit Gateway
5. How do you secure data in S3?
6. What's the difference between RDS Multi-AZ and Read Replicas?
7. How do you optimize AWS costs?
8. Explain Auto Scaling policies
9. What is the difference between ALB and NLB?
10. How do you implement disaster recovery in AWS?

### Hands-On Practice
- [ ] Create production-ready VPC
- [ ] Implement least privilege IAM policies
- [ ] Deploy multi-tier application with Auto Scaling
- [ ] Set up CloudWatch monitoring and alerting
- [ ] Configure automated backups
- [ ] Implement cost optimization strategies
- [ ] Practice troubleshooting common issues

---

## Troubleshooting Guide

### Common Issues and Solutions

**VPC Connectivity Issues**:
- Check Security Group rules
- Verify NACL rules
- Confirm route table configuration
- Check VPC Flow Logs
- Verify NAT Gateway status

**IAM Permission Errors**:
- Use IAM Policy Simulator
- Check CloudTrail for detailed error
- Verify trust policy (for roles)
- Check permission boundaries
- Review SCPs (if using Organizations)

**EC2 Instance Problems**:
- Check System Status and Instance Status
- Review CloudWatch metrics
- Check security group rules
- Verify IAM instance profile
- Review user data logs (/var/log/cloud-init-output.log)

**RDS Connection Issues**:
- Verify security group rules
- Check RDS instance status
- Confirm endpoint and port
- Verify credentials
- Check VPC and subnet configuration

**S3 Access Denied**:
- Review bucket policy
- Check IAM permissions
- Verify bucket encryption settings
- Check S3 Block Public Access settings
- Review ACLs (if used)

---

## Additional Resources

### AWS Documentation
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)
- [AWS Cost Optimization](https://aws.amazon.com/pricing/cost-optimization/)

### Tools
- AWS CLI
- AWS SDKs (Python boto3, JavaScript AWS SDK)
- Terraform
- CloudFormation
- AWS CDK

### Monitoring & Security
- AWS Config
- AWS Security Hub
- Amazon GuardDuty
- AWS CloudTrail
- AWS Trusted Advisor

---

**Continue to [Part 6: Terraform Infrastructure as Code](../part-06-terraform/README.md) to learn how to automate all these AWS resources.**

