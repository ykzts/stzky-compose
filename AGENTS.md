# Agents

This document provides information about agents and automation used in this repository.

## GitHub Actions

This repository may use GitHub Actions for continuous integration and automation tasks.

## Renovate

This repository uses Renovate for automated dependency updates. The configuration can be found in `.github/renovate.json5`.

Renovate automatically:
- Updates Docker image versions in `compose.yaml` files
- Updates Go dependencies in `go.mod`
- Creates pull requests for dependency updates
- Keeps dependencies secure and up-to-date

## Development Tools

### yamlfmt

The repository uses `yamlfmt` as a Go tool (defined in `go.mod`) to ensure consistent YAML formatting across all compose files.

To run the formatter:

```bash
go run github.com/google/yamlfmt/cmd/yamlfmt .
```

## Service Management

Each service in this repository is designed to be:
- **Self-contained**: Each service directory contains its own `compose.yaml` and configuration
- **Independent**: Services can be deployed and managed independently
- **Automated**: Using container orchestration for automatic restarts and health checks

## Security

- All services use specific image versions with SHA256 digests for reproducibility
- Renovate keeps images updated with security patches
- Environment variables are used for sensitive configuration
- Health checks are configured where applicable

## Contributing

When contributing to this repository:
1. Ensure YAML files are formatted with `yamlfmt`
2. Use specific image versions with SHA256 digests
3. Add appropriate health checks for new services
4. Document required environment variables
5. Test services locally before submitting pull requests
