#!/bin/bash

# ====================
# Usage examples:
# Base64URL → Base64
# ./b64convert.sh --to-base64 "c2lnbmF0dXJlX3ZhbHVl"
# 
# Base64 → Base64URL
# ./b64convert.sh --to-base64url "c2lnbmF0dXJlX3ZhbHVl=="
# ====================

usage() {
  echo "Usage: $0 (--to-base64 | --to-base64url) <string>"
  exit 1
}

# Ensure two arguments
if [ "$#" -ne 2 ]; then
  usage
fi

MODE="$1"
INPUT="$2"

convert_to_base64() {
  local b64url="$1"
  local b64=$(echo "$b64url" | tr '_-' '/+')
  local len=${#b64}
  local pad=$(( (4 - len % 4) % 4 )) # Counting how many paddings need to be added.
  for ((i = 0; i < pad; i++)); do b64="${b64}="; done
  echo "$b64"
}

convert_to_base64url() {
  local b64="$1"
  echo "$b64" | tr '+/' '_-' | tr --delete '='
}

case "$MODE" in
  --to-base64)
    convert_to_base64 "$INPUT"
    ;;
  --to-base64url)
    convert_to_base64url "$INPUT"
    ;;
  *)
    usage
    ;;
esac

