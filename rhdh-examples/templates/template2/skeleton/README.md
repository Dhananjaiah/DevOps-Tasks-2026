# Database Configuration for ${{ values.applicationName }}

## Database Type
${{ values.databaseType }}

## Overview

This repository contains database configuration and setup for the ${{ values.applicationName }} application.

## Configuration Files

- `docker-compose.yml`: Local development setup
- `kubernetes/`: Kubernetes manifests for production (to be added)
- `migrations/`: Database migration scripts (to be added)

## Local Development

### Prerequisites

- Docker or Podman installed
- Docker Compose installed (or podman-compose)

### Starting the Database

```bash
# Set required environment variables
export DB_PASSWORD="your-secure-password"
{%- if values.databaseType == 'mysql' %}
export DB_ROOT_PASSWORD="your-root-password"
{%- endif %}

# Start the database
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### Connecting to the Database

{%- if values.databaseType == 'postgresql' %}
```bash
# Using psql
psql -h localhost -p 5432 -U dbuser -d ${{ values.applicationName }}

# Connection string
postgresql://dbuser:password@localhost:5432/${{ values.applicationName }}
```
{%- elif values.databaseType == 'mysql' %}
```bash
# Using mysql client
mysql -h localhost -P 3306 -u dbuser -p ${{ values.applicationName }}

# Connection string
mysql://dbuser:password@localhost:3306/${{ values.applicationName }}
```
{%- else %}
```bash
# Using mongosh
mongosh --host localhost --port 27017 -u dbuser -p --authenticationDatabase admin

# Connection string
mongodb://dbuser:password@localhost:27017/${{ values.applicationName }}?authSource=admin
```
{%- endif %}

### Stopping the Database

```bash
docker-compose down

# To remove volumes as well
docker-compose down -v
```

## Production Deployment

Production deployment manifests will be added in the `kubernetes/` directory.

## Backup and Restore

Backup and restore procedures will be documented here.

## Owner

${{ values.owner }}

## License

MIT
