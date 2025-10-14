#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "Starting Ntfy server..."

# Read addon options and set environment variables
if bashio::config.has_value 'base_url'; then
    export NTFY_BASE_URL=$(bashio::config 'base_url')
    bashio::log.info "Base URL: ${NTFY_BASE_URL}"
fi

if bashio::config.has_value 'cache_file'; then
    export NTFY_CACHE_FILE=$(bashio::config 'cache_file')
fi

if bashio::config.has_value 'auth_file'; then
    export NTFY_AUTH_FILE=$(bashio::config 'auth_file')
fi

if bashio::config.has_value 'attachment_cache_dir'; then
    export NTFY_ATTACHMENT_CACHE_DIR=$(bashio::config 'attachment_cache_dir')
fi

if bashio::config.has_value 'enable_signup'; then
    export NTFY_ENABLE_SIGNUP=$(bashio::config 'enable_signup')
    bashio::log.info "Signup enabled: ${NTFY_ENABLE_SIGNUP}"
fi

if bashio::config.has_value 'enable_login'; then
    export NTFY_ENABLE_LOGIN=$(bashio::config 'enable_login')
    bashio::log.info "Login enabled: ${NTFY_ENABLE_LOGIN}"
fi

if bashio::config.has_value 'enable_reservations'; then
    export NTFY_ENABLE_RESERVATIONS=$(bashio::config 'enable_reservations')
    bashio::log.info "Reservations enabled: ${NTFY_ENABLE_RESERVATIONS}"
fi

# Set default upstream
export NTFY_UPSTREAM_BASE_URL="https://ntfy.sh"

# Create data directory
mkdir -p /data
bashio::log.info "Data directory: /data"

bashio::log.info "Starting Ntfy server on port 80..."

# Start ntfy server
exec ntfy serve
