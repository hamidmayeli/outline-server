#!/bin/bash

# Copyright 2024 The Outline Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

echo "🚀 Setting up Outline Server development environment..."

# Fix permissions for mounted volumes first
echo "🔐 Fixing permissions for mounted volumes..."
sudo chown -R vscode:vscode /workspaces/outline-server/node_modules 2>/dev/null || true
sudo chown -R vscode:vscode /go/pkg 2>/dev/null || true
sudo mkdir -p /go/pkg/mod && sudo chown -R vscode:vscode /go/pkg/mod

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Install Go dependencies and build task
echo "🔨 Building Go tools..."
go mod download
go build github.com/go-task/task/v3/cmd/task

# Make task executable and add to PATH
chmod +x task
sudo mv task /usr/local/bin/task

# Install Go tools for development
echo "🔧 Installing Go development tools..."
go install github.com/go-delve/delve/cmd/dlv@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install golang.org/x/tools/cmd/goimports@latest

# Set up git hooks
echo "🪝 Setting up git hooks..."
npx husky install

# Install workspace dependencies
echo "📂 Installing workspace dependencies..."
npm run postinstall || true

# Build all services
echo "🏗️  Building services..."
task shadowbox:build || echo "⚠️  Shadowbox build failed - this is normal on first setup"
task metrics_server:build || echo "⚠️  Metrics server build failed - this is normal on first setup"

# Set proper permissions
echo "🔐 Setting file permissions..."
chmod +x scripts/shellcheck.sh
find . -name "*.sh" -exec chmod +x {} \;

# Ensure all workspace files have correct ownership
echo "📁 Fixing workspace ownership..."
sudo chown -R vscode:vscode /workspaces/outline-server/ 2>/dev/null || true

# Create useful aliases
echo "💡 Setting up helpful aliases..."
cat >> ~/.bashrc << 'EOF'

# Outline Server aliases
alias task-list='task --list'
alias build-all='task build'
alias test-all='task test'
alias lint-all='task lint'
alias format-all='task format'
alias shadowbox-dev='task shadowbox:dev'
alias metrics-dev='task metrics_server:dev'
EOF

cat >> ~/.zshrc << 'EOF'

# Outline Server aliases
alias task-list='task --list'
alias build-all='task build'
alias test-all='task test'
alias lint-all='task lint'
alias format-all='task format'
alias shadowbox-dev='task shadowbox:dev'
alias metrics-dev='task metrics_server:dev'
EOF

echo "✅ Development environment setup complete!"
echo ""
echo "🎯 Quick start commands:"
echo "  - task --list        : List all available tasks"
echo "  - task build         : Build all services"
echo "  - task test          : Run all tests"
echo "  - task lint          : Lint all code"
echo "  - task format        : Format all code"
echo ""
echo "🔧 Service-specific commands:"
echo "  - task shadowbox:dev     : Start shadowbox in development mode"
echo "  - task metrics_server:dev : Start metrics server in development mode"
echo ""
echo "Happy coding! 🎉"