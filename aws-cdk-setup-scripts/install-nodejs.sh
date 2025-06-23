#!/bin/bash

set -e

# Default Node.js version if not provided as argument
NODE_VERSION="${1:-22.x}"

echo "Installing Node.js version $NODE_VERSION using NodeSource..."

# Download and run NodeSource setup script for the desired version
curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}" | sudo -E bash -

# Install nodejs package (includes npm)
sudo apt-get install -y nodejs

# Verify installation
echo -n "Node.js version: "
node -v || echo "Node.js not found."

echo -n "npm version: "
npm -v || echo "npm not found."

echo "Installation of Node.js $NODE_VERSION complete."

echo -e "\nYou can verify the installation anytime by running:"
echo "  node -v"
echo "  npm -v"
