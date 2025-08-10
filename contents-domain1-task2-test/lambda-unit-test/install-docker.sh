#!/bin/bash

# Check if docker command exists
if command -v docker &> /dev/null; then
    echo "Docker is already installed."
    docker --version
else
    echo "Docker is not installed. Installing docker.io..."
    sudo apt update
    sudo apt install -y docker.io

    echo "Docker installed. Version:"
    docker --version
fi
