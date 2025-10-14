#!/bin/sh
set -e

echo "Starting Ntfy server..."

# Read config from /data/options.json (Home Assistant provides this)
if [ -f /data/options.json ]; then
    export NTFY_BASE_URL=$(jq -r '.base_url // "http://homeassistant.local:8080"' /data/options.json)
    export NTFY_WEB_ROOT=$(jq -r '.web_root // "app"' /data/options.json)
    export NTFY_CACHE_DURATION=$(jq -r '.cache_duration // "12h"' /data/options.json)
    export NTFY_ATTACHMENT_TOTAL_SIZE_LIMIT=$(jq -r '.attachment_total_size_limit // "5G"' /data/options.json)
    export NTFY_ATTACHMENT_FILE_SIZE_LIMIT=$(jq -r '.attachment_file_size_limit // "15M"' /data/options.json)
    export NTFY_ATTACHMENT_EXPIRY_DURATION=$(jq -r '.attachment_expiry_duration // "3h"' /data/options.json)
    export NTFY_LOG_LEVEL=$(jq -r '.log_level // "info"' /data/options.json)
fi

# Set fixed values
export NTFY_UPSTREAM_BASE_URL="https://ntfy.sh"
export NTFY_CACHE_FILE="/data/cache.db"
export NTFY_AUTH_FILE="/data/user.db"
export NTFY_ATTACHMENT_CACHE_DIR="/data/attachments"

# Create data directory
mkdir -p /data

echo "Configuration:"
echo "  Base URL: ${NTFY_BASE_URL}"
echo "  Web Root: ${NTFY_WEB_ROOT}"
echo "  Cache Duration: ${NTFY_CACHE_DURATION}"
echo "  Log Level: ${NTFY_LOG_LEVEL}"
echo ""

# Start ntfy
exec ntfy serve
