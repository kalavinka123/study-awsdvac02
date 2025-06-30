#!/bin/bash

set -e

VENV_NAME="${1:-venv}"

echo "Checking if python3-venv is installed..."
if ! dpkg -s python3-venv >/dev/null 2>&1; then
  echo "Installing python3-venv..."
  sudo apt update
  sudo apt install -y python3-venv
fi

echo "Creating virtual environment '$VENV_NAME'..."
python3 -m venv "$VENV_NAME"

echo "✅ Virtual environment '$VENV_NAME' created."

echo "To activate, run:"
echo "source $VENV_NAME/bin/activate"
