#!/usr/bin/env bash
set -e

BIN_NAME="asterisk"
REPO_URL="https://raw.githubusercontent.com/juddflamm/asterisk/main"

echo "Installing Asterisk..."

# Choose install dir
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif [ -d "/usr/local/bin" ] || [ ! -e "/usr/local/bin" ]; then
    # Try sudo if /usr/local/bin exists but not writable
    if command -v sudo >/dev/null 2>&1; then
        INSTALL_DIR="/usr/local/bin"
        USE_SUDO="true"
    else
        INSTALL_DIR="$HOME/.local/bin"
    fi
else
    INSTALL_DIR="$HOME/.local/bin"
fi

# Create install dir if missing
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating $INSTALL_DIR..."
    if [ "$USE_SUDO" = "true" ]; then
        sudo mkdir -p "$INSTALL_DIR"
    else
        mkdir -p "$INSTALL_DIR"
    fi
fi

# Download binary
echo "Downloading $BIN_NAME to $INSTALL_DIR..."
if [ "$USE_SUDO" = "true" ]; then
    curl -fsSL "$REPO_URL/$BIN_NAME" | sudo tee "$INSTALL_DIR/$BIN_NAME" >/dev/null
    sudo chmod +x "$INSTALL_DIR/$BIN_NAME"
else
    curl -fsSL "$REPO_URL/$BIN_NAME" -o "$INSTALL_DIR/$BIN_NAME"
    chmod +x "$INSTALL_DIR/$BIN_NAME"
fi

echo "✅ Asterisk installed successfully to $INSTALL_DIR"

# PATH check
IN_PATH=true
if ! echo "$PATH" | tr ":" "\n" | grep -qx "$INSTALL_DIR"; then
    IN_PATH=false
    echo "⚠️  $INSTALL_DIR is not in your PATH."
fi

# Next steps
echo
echo "🍺 Next steps:"
if [ "$IN_PATH" = false ]; then
    echo "  1. Add this line to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo "       export PATH=\"$INSTALL_DIR:\$PATH\""
    echo "     Then restart your terminal or run:"
    echo "       source ~/.bashrc    # or ~/.zshrc"
    echo "  2. Run:"
    echo "       $BIN_NAME"
else
    echo "  1. Run:"
    echo "       $BIN_NAME"
fi
echo
echo "📚 Documentation: https://github.com/juddflamm/asterisk"
