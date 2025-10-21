# Outline Server Development Container

This directory contains the configuration for a VS Code development container that provides a complete development environment for the Outline Server project.

## What's Included

### Base Image & Runtime

- **Base**: Microsoft's TypeScript-Node dev container (Node.js 18.x on Debian Bookworm)
- **Node.js**: Version 18.x (as specified in package.json)
- **Go**: Version 1.21 (for Task and other Go tools)

### Development Tools

- **Docker-in-Docker**: For building and running containers
- **GitHub CLI**: For seamless GitHub integration
- **Zsh with Oh My Zsh**: Enhanced shell experience
- **Task**: Go-based task runner (built from source)

### VS Code Extensions

- TypeScript/JavaScript development tools
- Prettier code formatter
- ESLint for code linting
- Go language support
- Docker tools
- YAML and JSON support
- GitHub Copilot (if available)

### Port Forwarding

The container automatically forwards these ports:

- `3000`: Shadowbox Server
- `8080`: Metrics Server
- `8081`: Sentry Webhook
- `9090`: Prometheus (when used)

## Quick Start

1. **Open in Container**:

   - Install the "Dev Containers" VS Code extension
   - Open this repository in VS Code
   - When prompted, click "Reopen in Container" or use `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

2. **First Build**:

   ```bash
   # The post-create script runs automatically, but you can also run:
   task --list          # See available commands
   task build           # Build all services
   task test            # Run tests
   ```

3. **Development**:
   ```bash
   # Start services in development mode
   task shadowbox:dev
   task metrics_server:dev
   ```

## Environment Features

### Persistent Storage

- **Node modules**: Cached in a Docker volume for faster installs
- **Go packages**: Cached in `/go/pkg` volume

### Helpful Aliases

The setup script creates these aliases:

- `task-list` → `task --list`
- `build-all` → `task build`
- `test-all` → `task test`
- `lint-all` → `task lint`
- `format-all` → `task format`
- `shadowbox-dev` → `task shadowbox:dev`
- `metrics-dev` → `task metrics_server:dev`

### Git Integration

- Husky git hooks are automatically installed
- GitHub CLI is available for repository operations

## Workspace Structure

The development container is configured to work with the multi-service architecture:

```
outline-server/
├── src/
│   ├── shadowbox/          # Core proxy server
│   ├── metrics_server/     # Metrics collection service
│   └── sentry_webhook/     # Error reporting webhook
├── .devcontainer/          # This configuration
└── Taskfile.yml           # Main task definitions
```

## Customization

### Adding Extensions

Edit `.devcontainer/devcontainer.json` and add extension IDs to the `extensions` array:

```json
"extensions": [
  "existing.extension",
  "your.new-extension"
]
```

### Environment Variables

Add environment variables in the `containerEnv` section:

```json
"containerEnv": {
  "NODE_ENV": "development",
  "YOUR_VAR": "value"
}
```

### Additional Tools

Modify `.devcontainer/post-create.sh` to install additional tools or run setup commands.

## Troubleshooting

### Build Failures

If builds fail initially, this is normal. The post-create script will show warnings for expected failures during first setup.

### Port Conflicts

If ports are already in use on your host, VS Code will automatically remap them. Check the "Ports" tab in VS Code's terminal panel.

### Performance

The dev container uses volumes for node_modules and Go packages to improve performance. If you experience issues, try:

```bash
# Rebuild the container without cache
# Command Palette → "Dev Containers: Rebuild Container"
```

## Architecture Notes

This dev container is designed for the Outline Server's multi-language, multi-service architecture:

- **TypeScript/Node.js** for the main services
- **Go** for build tools and utilities
- **Docker** for containerization and integration testing
- **Task** for unified build automation across all services

The configuration supports the project's development workflow including linting, formatting, testing, and running services in development mode.
