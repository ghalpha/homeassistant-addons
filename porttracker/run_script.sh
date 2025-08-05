#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Community Add-on: Portracker
# Configures and starts the Portracker service
# ==============================================================================

bashio::log.info "Starting Portracker addon..."

# Declare variables
declare port
declare cache_timeout_ms
declare disable_cache
declare include_udp
declare debug
declare truenas_api_key

# Get addon options
port=$(bashio::config 'port')
cache_timeout_ms=$(bashio::config 'cache_timeout_ms')
disable_cache=$(bashio::config 'disable_cache')
include_udp=$(bashio::config 'include_udp')
debug=$(bashio::config 'debug')
truenas_api_key=$(bashio::config 'truenas_api_key')

# Set environment variables
export PORT="${port}"
export DATABASE_PATH="/data/portracker.db"
export CACHE_TIMEOUT_MS="${cache_timeout_ms}"
export DISABLE_CACHE="${disable_cache}"
export INCLUDE_UDP="${include_udp}"
export DEBUG="${debug}"

# Set TrueNAS API key if provided
if bashio::config.has_value 'truenas_api_key'; then
    export TRUENAS_API_KEY="${truenas_api_key}"
    bashio::log.info "TrueNAS API key configured for enhanced features"
fi

# Create data directory if it doesn't exist
mkdir -p /data

# Log configuration
bashio::log.info "Portracker will run on port: ${port}"
bashio::log.info "Cache timeout: ${cache_timeout_ms}ms"
bashio::log.info "Cache disabled: ${disable_cache}"
bashio::log.info "Include UDP ports: ${include_udp}"
bashio::log.info "Debug mode: ${debug}"

# Ensure proper permissions
chown -R root:root /data
chmod 755 /data

bashio::log.info "Starting Portracker service..."

# Start the original Portracker application
exec node /app/server.js