#!/bin/bash
set -e

PYTHON_VERSION="3.8"

echo "Updating package list..."
sudo apt update

echo "Installing Python $PYTHON_VERSION and pip..."
sudo apt install -y python${PYTHON_VERSION} python3-pip python${PYTHON_VERSION}-venv python${PYTHON_VERSION}-distutils

echo "Setting python3 to point to python$PYTHON_VERSION..."
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
sudo update-alternatives --set python3 /usr/bin/python${PYTHON_VERSION}

echo "✅ Python $PYTHON_VERSION and pip installation complete!"
python3 --version
pip3 --version
