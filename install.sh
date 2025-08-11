#!/usr/bin/env bash
set -e

BIN_NAME="asterisk"
INSTALL_DIR="/usr/local/bin"
REPO_URL="https://raw.githubusercontent.com/juddflamm/claude-code-accounts/main"

echo "Installing Claude Code Accounts' CLI as $BIN_NAME..."

# Download the CLI from main branch
curl -fsSL "$REPO_URL/$BIN_NAME" -o "$INSTALL_DIR/$BIN_NAME"

# Make it executable
chmod +x "$INSTALL_DIR/$BIN_NAME"

echo "Claude Code Accounts CLI command $BIN_NAME installed successfully to $INSTALL_DIR"
echo "You can run it with: $BIN_NAME"