#!/bin/sh
set -e

echo "Starting Ntfy server..."

# Create data directory
mkdir -p /data

# Read config from /data/options.json and create ntfy config file
if [ -f /data/options.json ]; then
    # Basic settings
    BASE_URL=$(jq -r '.base_url // "http://homeassistant.local:8080"' /data/options.json)
    WEB_ROOT=$(jq -r '.web_root // "app"' /data/options.json)
    
    # Authentication settings
    ENABLE_SIGNUP=$(jq -r '.enable_signup // false' /data/options.json)
    ENABLE_LOGIN=$(jq -r '.enable_login // true' /data/options.json)
    ENABLE_RESERVATIONS=$(jq -r '.enable_reservations // true' /data/options.json)
    AUTH_DEFAULT_ACCESS=$(jq -r '.auth_default_access // "deny-all"' /data/options.json)
    
    # Proxy settings
    BEHIND_PROXY=$(jq -r '.behind_proxy // false' /data/options.json)
    
    # Cache and storage
    CACHE_DURATION=$(jq -r '.cache_duration // "12h"' /data/options.json)
    ATTACHMENT_TOTAL_SIZE=$(jq -r '.attachment_total_size_limit // "5G"' /data/options.json)
    ATTACHMENT_FILE_SIZE=$(jq -r '.attachment_file_size_limit // "15M"' /data/options.json)
    ATTACHMENT_EXPIRY=$(jq -r '.attachment_expiry_duration // "3h"' /data/options.json)
    
    # Rate limiting
    REQUEST_BURST=$(jq -r '.visitor_request_limit_burst // 60' /data/options.json)
    REQUEST_REPLENISH=$(jq -r '.visitor_request_limit_replenish // "5s"' /data/options.json)
    MESSAGE_DAILY=$(jq -r '.visitor_message_daily_limit // 0' /data/options.json)
    
    # Logging
    LOG_LEVEL=$(jq -r '.log_level // "info"' /data/options.json)
    
    # Create ntfy config file
    cat > /data/server.yml <<EOF
# Base configuration
base-url: "${BASE_URL}"
upstream-base-url: "https://ntfy.sh"
web-root: ${WEB_ROOT}

# Authentication
auth-file: "/data/user.db"
auth-default-access: "${AUTH_DEFAULT_ACCESS}"
enable-signup: ${ENABLE_SIGNUP}
enable-login: ${ENABLE_LOGIN}
enable-reservations: ${ENABLE_RESERVATIONS}

# Storage
cache-file: "/data/cache.db"
cache-duration: "${CACHE_DURATION}"
attachment-cache-dir: "/data/attachments"
attachment-total-size-limit: "${ATTACHMENT_TOTAL_SIZE}"
attachment-file-size-limit: "${ATTACHMENT_FILE_SIZE}"
attachment-expiry-duration: "${ATTACHMENT_EXPIRY}"

# Rate limiting
visitor-request-limit-burst: ${REQUEST_BURST}
visitor-request-limit-replenish: "${REQUEST_REPLENISH}"
visitor-message-daily-limit: ${MESSAGE_DAILY}

# Logging
log-level: ${LOG_LEVEL}
EOF

    # Add behind-proxy if enabled
    if [ "$BEHIND_PROXY" = "true" ]; then
        echo "behind-proxy: true" >> /data/server.yml
    fi
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo " Ntfy Configuration"
echo "═══════════════════════════════════════════════════════"
echo " Base URL: ${BASE_URL}"
echo " Web Root: ${WEB_ROOT}"
echo " Login Enabled: ${ENABLE_LOGIN}"
echo " Signup Enabled: ${ENABLE_SIGNUP}"
echo " Default Access: ${AUTH_DEFAULT_ACCESS}"
echo " Cache Duration: ${CACHE_DURATION}"
echo " Log Level: ${LOG_LEVEL}"
echo " Config File: /data/server.yml"
echo "═══════════════════════════════════════════════════════"
echo ""

# Show authentication instructions if login is enabled
if [ "$ENABLE_LOGIN" = "true" ]; then
    echo "Authentication is ENABLED"
    if [ "$ENABLE_SIGNUP" = "true" ]; then
        echo "→ Public signup is ENABLED - anyone can create accounts"
        echo "→ First user will be admin automatically"
    else
        echo "→ Public signup is DISABLED"
        echo "→ Create users via addon terminal:"
        echo "  ntfy user add --role=admin username"
    fi
    echo ""
fi

# Start ntfy with config file
exec ntfy serve --config /data/server.yml
