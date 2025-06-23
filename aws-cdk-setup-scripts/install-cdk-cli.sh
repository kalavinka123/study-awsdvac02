#!/bin/bash

set -e

CDK_VERSION="2.1019.1"

if command -v cdk &> /dev/null; then
  echo "AWS CDK CLI is already installed."
  echo -n "Installed version: "
  cdk --version
  exit 0
fi

echo "Installing AWS CDK CLI version ${CDK_VERSION}..."
sudo npm install -g aws-cdk@${CDK_VERSION}

echo -n "Installed AWS CDK version: "
cdk --version