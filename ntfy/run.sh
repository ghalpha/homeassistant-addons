#!/bin/sh
set -e

echo "Starting Ntfy server..."

# Create data directory if it doesn't exist
mkdir -p /data

# Start ntfy server
# All NTFY_* environment variables are automatically picked up
exec ntfy serve
