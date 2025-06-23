#!/bin/bash
#
# This script is intended to help satisfy the prerequisites for AWS CDK v2.
# For more info, see the official AWS CDK prerequisites documentation:
# https://docs.aws.amazon.com/cdk/v2/guide/prerequisites.html?utm_source=chatgpt.com

set -e

echo "Checking AWS CDK v2 prerequisites."

# 1. AWS CLI installed & configured
if ! command -v aws &> /dev/null; then
  echo "❌ AWS CLI not found. Please install AWS CLI v2."
  exit 1
fi

if ! aws sts get-caller-identity &> /dev/null; then
  echo "AWS CLI credentials are not configured or invalid."
  exit 1
else
  echo "✅ AWS CLI installed and configured."
fi

# 2. Node.js installed and >= 22.x
if ! command -v npm &>/dev/null; then
  echo "❌ npm is not installed. It usually comes with Node.js."
  exit 1
fi

if ! command -v node &> /dev/null; then
  echo "❌ Node.js is not installed. Please install Node.js 22.x or later."
  exit 1
fi

NODE_VERSION_FULL="$(node -v)"
NODE_MAJOR=$(echo "$NODE_VERSION_FULL" | cut -d. -f1 | tr -d 'v')
REQUIRED_NODE_MAJOR=22

if (( NODE_MAJOR < REQUIRED_NODE_MAJOR )); then
  echo "❌ Node.js version is too old. Required: 22.x or later. Found: $NODE_VERSION_FULL"
  exit 1
else
  echo "✅ Node.js version $NODE_VERSION_FULL is sufficient."
fi

echo -e "🎉 All AWS CDK v2 prerequisites are met!"