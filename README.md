# stzky-compose

A collection of Docker Compose configurations for self-hosted services.

## Overview

This repository contains Docker Compose configurations for various self-hosted services, designed to be easily deployable and maintainable.

## Services

### Caddy

Web server with automatic HTTPS powered by Caddy.

- **Location**: `caddy/`
- **Image**: caddy:2.10.2
- **Ports**: 80, 443, 2019 (admin)
- **Features**: 
  - Automatic HTTPS with Let's Encrypt
  - Reverse proxy capabilities
  - Prometheus authentication

### Grafana

Complete monitoring stack including Grafana, Prometheus, Alloy, and exporters.

- **Location**: `grafana/`
- **Services**:
  - Grafana (visualization)
  - Prometheus (metrics storage)
  - Alloy (telemetry collector)
  - Node Exporter (system metrics)
  - SNMP Exporter (SNMP device metrics)
  - PostgreSQL (database)
  - Valkey/Redis (cache)
- **Ports**:
  - 3000 (Grafana)
  - 9090 (Prometheus)

### Immich

Self-hosted photo and video management solution.

- **Location**: `immich/`
- **Services**:
  - Immich Server
  - Immich Machine Learning
  - PostgreSQL with vector support
  - Valkey/Redis
- **Ports**:
  - 2283 (main server)
  - 8081, 8082 (additional services)

### Uptime Kuma

Self-hosted monitoring tool for uptime tracking.

- **Location**: `uptime-kuma/`
- **Services**:
  - Uptime Kuma
  - MariaDB
- **Ports**: 3001

## Usage

### Prerequisites

- Docker
- Docker Compose
- Go 1.24.3 (for yamlfmt tool)

### Deployment

Each service can be deployed independently:

```bash
cd <service-directory>
docker compose up -d
```

For example, to deploy Grafana:

```bash
cd grafana
docker compose up -d
```

### Configuration

Each service requires environment variables. Create a `.env` file in the respective service directory with the necessary variables. Refer to each service's `compose.yaml` file for required environment variables.

### Stopping Services

```bash
cd <service-directory>
docker compose down
```

## Development

### YAML Formatting

This project uses `yamlfmt` for YAML file formatting. The tool is specified in `go.mod`:

```bash
go run github.com/google/yamlfmt/cmd/yamlfmt .
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Yamagishi Kazutoshi
