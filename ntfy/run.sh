#!/bin/sh
set -e

echo "Starting Ntfy server..."

# Read config from /data/options.json
if [ -f /data/options.json ]; then
    # Basic settings
    export NTFY_BASE_URL=$(jq -r '.base_url // "http://homeassistant.local:8080"' /data/options.json)
    export NTFY_WEB_ROOT=$(jq -r '.web_root // "app"' /data/options.json)
    
    # Authentication settings
    export NTFY_ENABLE_SIGNUP=$(jq -r '.enable_signup // false' /data/options.json)
    export NTFY_ENABLE_LOGIN=$(jq -r '.enable_login // true' /data/options.json)
    export NTFY_ENABLE_RESERVATIONS=$(jq -r '.enable_reservations // true' /data/options.json)
    export NTFY_AUTH_DEFAULT_ACCESS=$(jq -r '.auth_default_access // "deny-all"' /data/options.json)
    
    # Proxy settings
    BEHIND_PROXY=$(jq -r '.behind_proxy // false' /data/options.json)
    if [ "$BEHIND_PROXY" = "true" ]; then
        export NTFY_BEHIND_PROXY="true"
    fi
    
    # Cache and storage
    export NTFY_CACHE_DURATION=$(jq -r '.cache_duration // "12h"' /data/options.json)
    export NTFY_ATTACHMENT_TOTAL_SIZE_LIMIT=$(jq -r '.attachment_total_size_limit // "5G"' /data/options.json)
    export NTFY_ATTACHMENT_FILE_SIZE_LIMIT=$(jq -r '.attachment_file_size_limit // "15M"' /data/options.json)
    export NTFY_ATTACHMENT_EXPIRY_DURATION=$(jq -r '.attachment_expiry_duration // "3h"' /data/options.json)
    
    # Rate limiting
    export NTFY_VISITOR_REQUEST_LIMIT_BURST=$(jq -r '.visitor_request_limit_burst // 60' /data/options.json)
    export NTFY_VISITOR_REQUEST_LIMIT_REPLENISH=$(jq -r '.visitor_request_limit_replenish // "5s"' /data/options.json)
    export NTFY_VISITOR_MESSAGE_DAILY_LIMIT=$(jq -r '.visitor_message_daily_limit // 0' /data/options.json)
    
    # Logging
    export NTFY_LOG_LEVEL=$(jq -r '.log_level // "info"' /data/options.json)
fi

# Fixed values
export NTFY_UPSTREAM_BASE_URL="https://ntfy.sh"
export NTFY_CACHE_FILE="/data/cache.db"
export NTFY_AUTH_FILE="/data/user.db"
export NTFY_ATTACHMENT_CACHE_DIR="/data/attachments"

# Create data directory
mkdir -p /data

echo ""
echo "═══════════════════════════════════════════════════════"
echo " Ntfy Configuration"
echo "═══════════════════════════════════════════════════════"
echo " Base URL: ${NTFY_BASE_URL}"
echo " Web Root: ${NTFY_WEB_ROOT}"
echo " Login Enabled: ${NTFY_ENABLE_LOGIN}"
echo " Signup Enabled: ${NTFY_ENABLE_SIGNUP}"
echo " Default Access: ${NTFY_AUTH_DEFAULT_ACCESS}"
echo " Cache Duration: ${NTFY_CACHE_DURATION}"
echo " Log Level: ${NTFY_LOG_LEVEL}"
echo "═══════════════════════════════════════════════════════"
echo ""

# Show authentication instructions if login is enabled
if [ "$NTFY_ENABLE_LOGIN" = "true" ]; then
    echo "Authentication is ENABLED"
    if [ "$NTFY_ENABLE_SIGNUP" = "true" ]; then
        echo "→ Public signup is ENABLED - anyone can create accounts"
        echo "→ First user will be admin automatically"
    else
        echo "→ Public signup is DISABLED"
        echo "→ Create users via addon terminal:"
        echo "  ntfy user add --role=admin username"
    fi
    echo ""
fi

# Start ntfy
exec ntfy serve
