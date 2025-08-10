#!/bin/bash
#
# Adding the repo to apt sources, refers to https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
#

set -e

if docker buildx version &>/dev/null; then
  echo "docker-buildx-plugin is already installed."
  docker buildx version
  exit 0
fi

echo "Installing docker-buildx-plugin..."
sudo apt update
sudo apt install -y docker-buildx-plugin

echo "Installation complete."
docker buildx version
