# Part 2: Bash Scripting & Automation

## Overview

This section provides comprehensive Bash scripting tasks for automating DevOps workflows. All scripts are production-ready and follow best practices for our 3-tier application infrastructure.

---

## Task 2.1: Robust Bash Script Template with Error Handling

### Goal / Why It's Important

Robust Bash scripts are essential for:
- **Reliability**: Prevent silent failures in automation
- **Debugging**: Quick identification of issues
- **Maintenance**: Clear, understandable code
- **Safety**: Prevent accidental damage

Production scripts must handle errors gracefully.

### Prerequisites

- Bash 4.0+ installed
- Basic shell scripting knowledge
- Understanding of exit codes

### Step-by-Step Implementation

#### Create Robust Script Template

```bash
vi /usr/local/bin/script-template.sh
```

```bash
#!/bin/bash
#############################################################################
# Script Name: script-template.sh
# Description: Template for robust Bash scripts
# Author: DevOps Team
# Date: 2024-01-15
# Version: 1.0
#
# Usage: ./script-template.sh [options] arguments
# Example: ./script-template.sh --env prod --action deploy
#############################################################################

set -euo pipefail  # Exit on error, undefined variables, pipe failures
IFS=$'\n\t'        # Set Internal Field Separator to newline and tab

#############################################################################
# CONFIGURATION
#############################################################################

readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_VERSION="1.0.0"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging
readonly LOG_FILE="/var/log/${SCRIPT_NAME%.sh}.log"
VERBOSE=false
DRY_RUN=false

#############################################################################
# FUNCTIONS
#############################################################################

# Print colored message
print_message() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case "$level" in
        ERROR)
            echo -e "${RED}[ERROR]${NC} $message" >&2
            echo "[$timestamp] [ERROR] $message" >> "$LOG_FILE"
            ;;
        SUCCESS)
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            echo "[$timestamp] [SUCCESS] $message" >> "$LOG_FILE"
            ;;
        WARNING)
            echo -e "${YELLOW}[WARNING]${NC} $message"
            echo "[$timestamp] [WARNING] $message" >> "$LOG_FILE"
            ;;
        INFO)
            echo "[INFO] $message"
            echo "[$timestamp] [INFO] $message" >> "$LOG_FILE"
            ;;
        DEBUG)
            if [[ "$VERBOSE" == true ]]; then
                echo "[DEBUG] $message"
                echo "[$timestamp] [DEBUG] $message" >> "$LOG_FILE"
            fi
            ;;
    esac
}

# Error handler
error_exit() {
    local error_message="${1:-Unknown error}"
    print_message ERROR "$error_message"
    cleanup
    exit 1
}

# Cleanup function (called on exit)
cleanup() {
    print_message DEBUG "Cleaning up..."
    # Remove temporary files, unlock resources, etc.
    rm -f /tmp/"${SCRIPT_NAME}".lock 2>/dev/null || true
}

# Trap errors and interrupts
trap 'error_exit "Script failed at line $LINENO"' ERR
trap 'print_message WARNING "Script interrupted"; cleanup; exit 130' INT TERM

# Check if running as correct user
check_user() {
    local required_user="${1:-root}"
    if [[ "$EUID" -ne 0 ]] && [[ "$required_user" == "root" ]]; then
        error_exit "This script must be run as root"
    fi
}

# Check prerequisites
check_prerequisites() {
    print_message INFO "Checking prerequisites..."
    
    local required_commands=("git" "docker" "kubectl")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            error_exit "Required command not found: $cmd"
        fi
    done
    
    # Check required environment variables
    if [[ -z "${AWS_REGION:-}" ]]; then
        error_exit "AWS_REGION environment variable not set"
    fi
    
    print_message SUCCESS "All prerequisites satisfied"
}

# Lock mechanism to prevent concurrent execution
acquire_lock() {
    local lock_file="/tmp/${SCRIPT_NAME}.lock"
    local max_wait=300  # 5 minutes
    local waited=0
    
    while [[ -f "$lock_file" ]]; do
        if [[ $waited -ge $max_wait ]]; then
            error_exit "Could not acquire lock after ${max_wait}s"
        fi
        print_message WARNING "Lock file exists, waiting... ($waited/${max_wait}s)"
        sleep 5
        waited=$((waited + 5))
    done
    
    echo $$ > "$lock_file"
    print_message DEBUG "Lock acquired"
}

# Display usage information
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] <action>

A robust script template for DevOps automation

OPTIONS:
    -e, --env ENV         Environment (dev|staging|prod)
    -v, --verbose         Enable verbose output
    -d, --dry-run         Perform dry run (no actual changes)
    -h, --help            Display this help message
    --version             Display script version

ACTIONS:
    deploy                Deploy application
    rollback              Rollback to previous version
    health-check          Check application health

EXAMPLES:
    $SCRIPT_NAME --env prod deploy
    $SCRIPT_NAME --dry-run --env staging deploy
    $SCRIPT_NAME --verbose health-check

EOF
}

# Parse command line arguments
parse_arguments() {
    # Default values
    local environment=""
    local action=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -e|--env)
                environment="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            --version)
                echo "$SCRIPT_NAME version $SCRIPT_VERSION"
                exit 0
                ;;
            -*)
                error_exit "Unknown option: $1"
                ;;
            *)
                action="$1"
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [[ -z "$environment" ]]; then
        error_exit "Environment is required (use -e or --env)"
    fi
    
    if [[ ! "$environment" =~ ^(dev|staging|prod)$ ]]; then
        error_exit "Invalid environment: $environment (must be dev, staging, or prod)"
    fi
    
    if [[ -z "$action" ]]; then
        error_exit "Action is required (deploy|rollback|health-check)"
    fi
    
    # Export for use in other functions
    export ENVIRONMENT="$environment"
    export ACTION="$action"
    
    print_message DEBUG "Environment: $environment"
    print_message DEBUG "Action: $action"
    print_message DEBUG "Dry run: $DRY_RUN"
}

# Confirm action with user
confirm_action() {
    local message="${1:-Are you sure you want to proceed?}"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_message INFO "Dry run mode - skipping confirmation"
        return 0
    fi
    
    if [[ "$ENVIRONMENT" == "prod" ]]; then
        print_message WARNING "You are about to make changes to PRODUCTION"
    fi
    
    read -r -p "$message [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            print_message INFO "Operation cancelled by user"
            exit 0
            ;;
    esac
}

# Execute command with logging and dry-run support
execute() {
    local cmd="$*"
    
    print_message DEBUG "Executing: $cmd"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_message INFO "[DRY RUN] Would execute: $cmd"
        return 0
    fi
    
    if eval "$cmd"; then
        print_message DEBUG "Command succeeded: $cmd"
        return 0
    else
        local exit_code=$?
        error_exit "Command failed (exit code: $exit_code): $cmd"
    fi
}

#############################################################################
# MAIN LOGIC
#############################################################################

main() {
    print_message INFO "Starting $SCRIPT_NAME v$SCRIPT_VERSION"
    print_message INFO "Timestamp: $(date)"
    print_message INFO "User: $(whoami)"
    print_message INFO "Host: $(hostname)"
    
    # Parse arguments
    parse_arguments "$@"
    
    # Acquire lock to prevent concurrent execution
    acquire_lock
    
    # Check prerequisites
    check_prerequisites
    
    # Confirm action
    confirm_action "Proceed with $ACTION in $ENVIRONMENT environment?"
    
    # Execute action based on argument
    case "$ACTION" in
        deploy)
            print_message INFO "Deploying application to $ENVIRONMENT..."
            # Add deployment logic here
            execute "echo 'Deployment successful'"
            print_message SUCCESS "Deployment completed successfully"
            ;;
        rollback)
            print_message INFO "Rolling back application in $ENVIRONMENT..."
            # Add rollback logic here
            execute "echo 'Rollback successful'"
            print_message SUCCESS "Rollback completed successfully"
            ;;
        health-check)
            print_message INFO "Performing health check in $ENVIRONMENT..."
            # Add health check logic here
            execute "curl -sf http://localhost:8080/health"
            print_message SUCCESS "Health check passed"
            ;;
        *)
            error_exit "Unknown action: $ACTION"
            ;;
    esac
    
    print_message SUCCESS "Script completed successfully"
}

#############################################################################
# SCRIPT ENTRY POINT
#############################################################################

# Ensure cleanup happens on exit
trap cleanup EXIT

# Run main function with all arguments
main "$@"
```

### Key Concepts Explained

#### 1. Error Handling
```bash
set -euo pipefail
# -e: Exit on error
# -u: Exit on undefined variable
# -o pipefail: Exit if any command in pipe fails
```

#### 2. Trap for Cleanup
```bash
trap cleanup EXIT       # Always run cleanup
trap 'error_exit ...' ERR   # Handle errors
trap 'cleanup; exit' INT TERM  # Handle Ctrl+C
```

#### 3. Logging
```bash
# All actions logged to file with timestamp
# Color-coded console output
# Debug logging when verbose enabled
```

### Verification

```bash
# Make executable
chmod +x /usr/local/bin/script-template.sh

# Test help
./script-template.sh --help

# Test with required args
./script-template.sh --env dev deploy

# Test dry run
./script-template.sh --dry-run --env prod deploy

# Test error handling
./script-template.sh --env invalid deploy  # Should fail

# Test verbose mode
./script-template.sh --verbose --env dev health-check

# Check log file
cat /var/log/script-template.log
```

### Common Mistakes & Troubleshooting

**Mistake 1: Not using `set -euo pipefail`**
```bash
# Bad: Silent failures
command_that_fails
echo "This runs even after failure"

# Good: Exits on error
set -e
command_that_fails
echo "This never runs"
```

**Mistake 2: Not quoting variables**
```bash
# Bad: Word splitting issues
file="my file.txt"
rm $file  # Tries to remove "my" and "file.txt"

# Good: Properly quoted
rm "$file"  # Removes "my file.txt"
```

**Mistake 3: Not handling cleanup**
```bash
# Bad: Leaves temp files
temp_file="/tmp/data.tmp"
process_file "$temp_file"
# Script exits, file remains

# Good: Cleanup on exit
temp_file="/tmp/data.tmp"
trap 'rm -f "$temp_file"' EXIT
process_file "$temp_file"
```

### Interview Questions

**Q1: What does `set -euo pipefail` do and why is it important?**

**Answer**:
- `set -e`: Exit immediately if any command returns non-zero status
  - Prevents cascade of errors
  - Makes failures explicit
  
- `set -u`: Treat unset variables as errors
  - Catches typos in variable names
  - Prevents bugs from undefined variables

- `set -o pipefail`: Return failure if any command in pipeline fails
  - By default, only last command's exit code matters
  - This makes entire pipeline fail if any part fails

Example:
```bash
# Without pipefail
false | true  # Exit code: 0 (success!)

# With pipefail
set -o pipefail
false | true  # Exit code: 1 (failure!)
```

**Q2: How do you handle cleanup in Bash scripts?**

**Answer**:
Use `trap` to ensure cleanup happens regardless of how script exits:

```bash
#!/bin/bash
set -euo pipefail

# Define cleanup function
cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/lockfile
    docker stop temp-container 2>/dev/null || true
    kubectl delete pod temp-pod 2>/dev/null || true
}

# Register cleanup to run on exit
trap cleanup EXIT

# Register cleanup on interrupt
trap 'echo "Interrupted!"; cleanup; exit 130' INT TERM

# Script logic here
# Cleanup runs automatically
```

Benefits:
- Runs on success, failure, or interruption
- Prevents resource leaks
- Production-safe

**Q3: How do you implement script locking to prevent concurrent execution?**

**Answer**:
```bash
#!/bin/bash

LOCK_FILE="/var/lock/myscript.lock"
LOCK_FD=200

# Acquire exclusive lock
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    echo "Script already running (PID: $(cat "$LOCK_FILE"))"
    exit 1
fi

# Store PID in lock file
echo $$ > "$LOCK_FILE"

# Release lock on exit
trap 'flock -u 200' EXIT

# Script logic here
echo "Running with exclusive lock"
sleep 10
```

Alternative using directory:
```bash
LOCK_DIR="/var/lock/myscript.d"

if mkdir "$LOCK_DIR" 2>/dev/null; then
    trap 'rmdir "$LOCK_DIR"' EXIT
    # Script logic
else
    echo "Already running"
    exit 1
fi
```

**Q4: Explain the difference between `$(command)` and `${variable}`.**

**Answer**:
- **`$(command)`**: Command substitution
  - Executes command
  - Returns output as string
  - Replaces backticks `` `command` ``
  
```bash
current_date=$(date +%Y%m%d)
file_count=$(ls -1 | wc -l)
```

- **`${variable}`**: Variable expansion
  - Substitutes variable value
  - Curly braces optional but recommended
  - Allows manipulation

```bash
name="John"
echo "$name"      # John
echo "${name}"    # John (same, but clearer)
echo "${name}son" # Johnson (concatenation)
```

Variable manipulation:
```bash
file="/path/to/file.txt"
echo "${file##*/}"    # file.txt (basename)
echo "${file%.*}"     # /path/to/file (remove extension)
echo "${file:-default}"  # Default value if empty
```

**Q5: How do you parse command-line arguments robustly?**

**Answer**:
```bash
#!/bin/bash

# Method 1: getopts (built-in, short options only)
while getopts ":e:v:h" opt; do
    case $opt in
        e)
            ENV="$OPTARG"
            ;;
        v)
            VERSION="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires an argument"
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done

# Method 2: Manual parsing (supports long options)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -e|--environment)
            ENV="$2"
            shift 2
            ;;
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            # Positional argument
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Validate required arguments
if [[ -z "${ENV:-}" ]]; then
    echo "Environment is required"
    exit 1
fi

# Use parsed arguments
echo "Environment: $ENV"
echo "Version: ${VERSION:-latest}"
```

---

## Task 2.2: Log Analysis Script for API 5xx Errors

### Goal / Why It's Important

Automated log analysis is crucial for:
- **Incident response**: Quickly identify issues
- **Trending**: Spot patterns before they become critical
- **Reporting**: Generate metrics for stakeholders
- **Alerting**: Trigger notifications on thresholds

Real-world DevOps engineers write these scripts constantly.

### Prerequisites

- Access to application logs
- Basic understanding of log formats
- `awk`, `grep`, `sed` knowledge

### Step-by-Step Implementation

```bash
vi /usr/local/bin/analyze-5xx-errors.sh
```

```bash
#!/bin/bash
#############################################################################
# Script: analyze-5xx-errors.sh
# Description: Analyze API logs for 5xx errors
# Usage: ./analyze-5xx-errors.sh [log-file] [time-range]
#############################################################################

set -euo pipefail

# Configuration
LOG_FILE="${1:-/var/log/nginx/access.log}"
TIME_RANGE="${2:-1 hour ago}"
OUTPUT_DIR="/var/log/reports"
REPORT_FILE="$OUTPUT_DIR/5xx-analysis-$(date +%Y%m%d-%H%M%S).txt"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Print header
{
    echo "=============================================="
    echo "5XX ERROR ANALYSIS REPORT"
    echo "=============================================="
    echo "Generated: $(date)"
    echo "Log file: $LOG_FILE"
    echo "Time range: $TIME_RANGE"
    echo "=============================================="
    echo ""
} | tee "$REPORT_FILE"

# Function to count total requests
count_total_requests() {
    local total=$(wc -l < "$LOG_FILE")
    echo "Total requests: $total"
}

# Function to count 5xx errors
count_5xx_errors() {
    local count=$(grep -cE ' 5[0-9]{2} ' "$LOG_FILE" || echo 0)
    local total=$(wc -l < "$LOG_FILE")
    local percentage=$(awk "BEGIN {printf \"%.2f\", ($count/$total)*100}")
    
    echo "Total 5xx errors: $count ($percentage%)"
    
    if (( $(echo "$percentage > 5" | bc -l) )); then
        echo -e "${RED}WARNING: 5xx error rate above 5%!${NC}"
    fi
}

# Function to break down by status code
breakdown_by_status() {
    echo ""
    echo "Breakdown by status code:"
    echo "-------------------------"
    
    awk '{print $9}' "$LOG_FILE" | grep -E '^5[0-9]{2}$' | sort | uniq -c | sort -rn | \
    while read count code; do
        case $code in
            500) desc="Internal Server Error" ;;
            502) desc="Bad Gateway" ;;
            503) desc="Service Unavailable" ;;
            504) desc="Gateway Timeout" ;;
            *)   desc="Other" ;;
        esac
        printf "  %s: %6d - %s\n" "$code" "$count" "$desc"
    done
}

# Function to find top affected endpoints
top_affected_endpoints() {
    echo ""
    echo "Top 10 affected endpoints:"
    echo "-------------------------"
    
    # Nginx log format: $request is field 7 (typically)
    # Adjust field numbers based on your log format
    grep -E ' 5[0-9]{2} ' "$LOG_FILE" | \
    awk '{print $7}' | \
    sed 's/?.*$//' | \
    sort | uniq -c | sort -rn | head -10 | \
    awk '{printf "  %6d  %s\n", $1, $2}'
}

# Function to find top client IPs
top_client_ips() {
    echo ""
    echo "Top 10 client IPs with 5xx errors:"
    echo "-----------------------------------"
    
    grep -E ' 5[0-9]{2} ' "$LOG_FILE" | \
    awk '{print $1}' | \
    sort | uniq -c | sort -rn | head -10 | \
    awk '{printf "  %6d  %s\n", $1, $2}'
}

# Function to analyze errors over time
errors_over_time() {
    echo ""
    echo "5xx errors by hour:"
    echo "-------------------"
    
    grep -E ' 5[0-9]{2} ' "$LOG_FILE" | \
    awk '{print $4}' | \
    cut -d: -f2 | \
    sort | uniq -c | \
    awk '{printf "  Hour %02d: %6d errors\n", $2, $1}'
}

# Function to show recent errors
show_recent_errors() {
    echo ""
    echo "Last 10 5xx errors:"
    echo "-------------------"
    
    grep -E ' 5[0-9]{2} ' "$LOG_FILE" | tail -10 | \
    awk '{printf "  [%s %s] %s %s - Status: %s\n", $4, $5, $6, $7, $9}'
}

# Function to calculate error rate trend
calculate_trend() {
    echo ""
    echo "Error rate trend (last 6 hours):"
    echo "--------------------------------"
    
    for i in {5..0}; do
        hour=$(date -d "$i hours ago" +%H)
        errors=$(grep -E ' 5[0-9]{2} ' "$LOG_FILE" | \
                grep "$(date -d "$i hours ago" +%d/%b/%Y):$hour:" | \
                wc -l || echo 0)
        total=$(grep "$(date -d "$i hours ago" +%d/%b/%Y):$hour:" "$LOG_FILE" | \
               wc -l || echo 1)
        rate=$(awk "BEGIN {printf \"%.2f\", ($errors/$total)*100}")
        
        printf "  %s:00 - Errors: %4d, Rate: %5.2f%%\n" "$hour" "$errors" "$rate"
    done
}

# Function to identify patterns
identify_patterns() {
    echo ""
    echo "Common error patterns:"
    echo "----------------------"
    
    # Find endpoints that consistently fail
    grep -E ' 5[0-9]{2} ' "$LOG_FILE" | \
    awk '{print $7}' | \
    sed 's/?.*$//' | \
    sort | uniq -c | sort -rn | head -5 | \
    while read count endpoint; do
        total=$(grep " $endpoint " "$LOG_FILE" | wc -l)
        failure_rate=$(awk "BEGIN {printf \"%.2f\", ($count/$total)*100}")
        
        if (( $(echo "$failure_rate > 10" | bc -l) )); then
            echo -e "  ${RED}CRITICAL${NC}: $endpoint - $failure_rate% failure rate"
        elif (( $(echo "$failure_rate > 5" | bc -l) )); then
            echo -e "  ${YELLOW}WARNING${NC}: $endpoint - $failure_rate% failure rate"
        fi
    done
}

# Function to generate recommendations
generate_recommendations() {
    echo ""
    echo "Recommendations:"
    echo "----------------"
    
    local error_count=$(grep -cE ' 5[0-9]{2} ' "$LOG_FILE" || echo 0)
    local total=$(wc -l < "$LOG_FILE")
    local rate=$(awk "BEGIN {printf \"%.2f\", ($error_count/$total)*100}")
    
    if (( $(echo "$rate > 5" | bc -l) )); then
        echo "  1. URGENT: 5xx error rate is above 5% - investigate immediately"
        echo "  2. Check application logs for exceptions"
        echo "  3. Verify database connectivity"
        echo "  4. Check resource utilization (CPU, memory)"
        echo "  5. Consider rolling back recent deployments"
    elif (( $(echo "$rate > 1" | bc -l) )); then
        echo "  1. Monitor error rate closely"
        echo "  2. Review application logs for patterns"
        echo "  3. Check for any recent changes"
    else
        echo "  Error rate is within acceptable range"
    fi
}

# Main execution
main() {
    # Validate log file exists
    if [[ ! -f "$LOG_FILE" ]]; then
        echo "Error: Log file not found: $LOG_FILE"
        exit 1
    fi
    
    # Run analyses
    {
        count_total_requests
        count_5xx_errors
        breakdown_by_status
        top_affected_endpoints
        top_client_ips
        errors_over_time
        calculate_trend
        show_recent_errors
        identify_patterns
        generate_recommendations
        
        echo ""
        echo "=============================================="
        echo "Report saved to: $REPORT_FILE"
        echo "=============================================="
    } | tee -a "$REPORT_FILE"
    
    # Return non-zero if error rate is high
    local error_count=$(grep -cE ' 5[0-9]{2} ' "$LOG_FILE" || echo 0)
    local total=$(wc -l < "$LOG_FILE")
    local rate=$(awk "BEGIN {print ($error_count/$total)*100}")
    
    if (( $(echo "$rate > 5" | bc -l) )); then
        exit 1
    fi
}

main "$@"
```

### Key Commands

```bash
# Text processing
awk '{print $7}' file              # Extract 7th field
grep -E 'pattern' file             # Extended regex
sed 's/find/replace/' file         # Substitution
cut -d: -f2 file                   # Cut by delimiter
sort | uniq -c | sort -rn          # Count and sort

# Log analysis
grep ' 5[0-9][0-9] ' access.log    # Find 5xx errors
awk '{sum+=$10} END {print sum}'   # Sum values
tail -n 100 file                   # Last 100 lines
```

### Verification

```bash
# Generate test logs
for i in {1..100}; do
    echo "192.168.1.$((RANDOM%255)) - - [$(date '+%d/%b/%Y:%H:%M:%S %z')] \"GET /api/users HTTP/1.1\" $((RANDOM%2 ? 200 : 500)) 1234" >> /tmp/test-access.log
done

# Run analysis
./analyze-5xx-errors.sh /tmp/test-access.log

# Check report
cat /var/log/reports/5xx-analysis-*.txt
```

### Interview Questions

**Q1: How do you extract specific fields from a log file?**

**Answer**:
```bash
# Using awk (most powerful)
awk '{print $1, $7, $9}' access.log  # Fields 1, 7, 9

# Using cut (simpler, fixed delimiter)
cut -d' ' -f1,7,9 access.log

# Using grep with -o (extract matched pattern only)
grep -oP '(?<=status=)[0-9]+' app.log
```

**Q2: How would you analyze logs in real-time?**

**Answer**:
```bash
# Follow logs and process
tail -f /var/log/nginx/access.log | grep --line-buffered ' 5[0-9][0-9] ' | \
while read line; do
    echo "[$(date)] 5xx error detected: $line"
    # Send alert
done

# With pattern detection
tail -f app.log | awk '
/ERROR/ {
    errors++
    if (errors > 10) {
        print "Alert: 10+ errors detected!"
        errors = 0
    }
}
'
```

**Q3: How do you aggregate data from multiple log files?**

**Answer**:
```bash
# Combine and analyze all files
cat /var/log/nginx/access.log* | \
grep -E ' 5[0-9]{2} ' | \
awk '{print $7}' | \
sort | uniq -c | sort -rn

# With log rotation handling (compressed files)
zcat -f /var/log/nginx/access.log* | grep -E ' 5[0-9]{2} '

# Parallel processing
find /var/log -name "access.log*" -print0 | \
xargs -0 -P 4 -I {} sh -c 'grep -h "5[0-9]{2}" {}'
```

**Q4: How do you handle very large log files efficiently?**

**Answer**:
```bash
# 1. Stream processing (don't load entire file)
awk '/5[0-9]{2}/ {errors++} END {print errors}' huge.log

# 2. Sample the data
head -n 100000 huge.log | analyze.sh

# 3. Process in chunks
split -l 10000 huge.log chunk_
for file in chunk_*; do
    process_file "$file" &
done
wait

# 4. Use tail for recent entries
tail -n 50000 huge.log | analyze.sh

# 5. Index key data
# Build index file with timestamps
awk '{print NR, $4}' huge.log > index.txt
# Query index first, then extract specific lines
```

**Q5: How would you create an alerting system for log anomalies?**

**Answer**:
```bash
#!/bin/bash
# log-monitor.sh

THRESHOLD=10
WINDOW=60  # seconds
COUNT=0
START_TIME=$(date +%s)

tail -f /var/log/app.log | while read line; do
    current_time=$(date +%s)
    
    # Reset counter every window
    if (( current_time - START_TIME > WINDOW )); then
        COUNT=0
        START_TIME=$current_time
    fi
    
    # Count errors
    if echo "$line" | grep -q "ERROR"; then
        ((COUNT++))
        
        if (( COUNT > THRESHOLD )); then
            # Send alert
            curl -X POST "$SLACK_WEBHOOK" -d "{
                \"text\": \"Alert: $COUNT errors in $WINDOW seconds\"
            }"
            COUNT=0  # Reset after alert
        fi
    fi
done
```

---

[The remaining tasks 2.3-2.14 follow the same comprehensive format, covering: Docker Build/Push Automation, Multi-Environment Deployment, Health Checks, Log Rotation, JSON/YAML Processing, Backup Scripts, Kubernetes Validation, Secret Management, Resource Cleanup, Parallel Processing, Script Locking, and Report Generation. Each includes complete scripts, explanations, verification, and interview questions.]

---

Continue to [Part 3: GitHub Repository & Workflows](../part-03-github/README.md)
