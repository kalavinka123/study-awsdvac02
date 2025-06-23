#!/bin/bash

set -e

GO_VERSION="1.24.4"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/$GO_TAR"
GO_INSTALL_DIR="/usr/local/go"
BASHRC="$HOME/.bashrc"

# Check prerequisites
if ! command -v wget &>/dev/null; then
    echo "wget is not installed. Please install it and rerun this script."
    exit 1
fi

if ! command -v sudo &>/dev/null; then
    echo "sudo is not available. Please run as root or install sudo."
    exit 1
fi

# Download only if the file doesn't already exist
if [ ! -f "$GO_TAR" ]; then
    echo "Downloading Go $GO_VERSION."
    wget "$GO_URL"
else
    echo "$GO_TAR already exists. Skipping download."
fi

# Remove previous installation
if [ -d "$GO_INSTALL_DIR" ]; then
    echo "Removing previous Go installation."
    sudo rm -rf "$GO_INSTALL_DIR"
fi

# Extract archive
echo "Extracting Go archive."
sudo tar -C /usr/local -xzf "$GO_TAR"

# Add Go to PATH in .bashrc if not already present
if ! grep -q '/usr/local/go/bin' "$BASHRC"; then
    echo "Adding Go to PATH in $BASHRC..."
    echo 'export PATH=$PATH:/usr/local/go/bin' >> "$BASHRC"
    echo "PATH updated in $BASHRC"
else
    echo "Go path already exists in $BASHRC"
fi

# Remove archive
echo "Cleaning up installer archive."
rm -f "$GO_TAR"

# Final instructions
echo -e "Go $GO_VERSION installed successfully."
echo "Please run: source ~/.bashrc"
echo "Then verify with: go version"