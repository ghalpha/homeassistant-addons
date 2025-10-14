#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Add-on: Homarr
# Configures and starts the Homarr dashboard service
# ==============================================================================

bashio::log.info "Starting Homarr addon..."

# Declare variables
declare secret_encryption_key
declare port
declare enable_docker_integration
declare log_level

# Get addon options
port=$(bashio::config 'port')
enable_docker_integration=$(bashio::config 'enable_docker_integration')
log_level=$(bashio::config 'log_level')

# Debug logging
bashio::log.info "Configuration values:"
bashio::log.info "Port: ${port}"
bashio::log.info "Docker integration: ${enable_docker_integration}"
bashio::log.info "Log level: ${log_level}"

# Handle encryption key
if bashio::config.has_value 'secret_encryption_key'; then
    secret_encryption_key=$(bashio::config 'secret_encryption_key')
    bashio::log.info "Using provided SECRET_ENCRYPTION_KEY from configuration"
    
    # Validate encryption key length (should be 64 characters for hex)
    if [ ${#secret_encryption_key} -ne 64 ]; then
        bashio::log.warning "SECRET_ENCRYPTION_KEY should be exactly 64 characters (32 bytes in hex format)"
        bashio::log.warning "Current length: ${#secret_encryption_key}"
    fi
else
    bashio::log.info "Generating SECRET_ENCRYPTION_KEY..."
    secret_encryption_key=$(openssl rand -hex 32)
    bashio::log.warning "Generated new encryption key. Save this in your addon configuration to persist across restarts:"
    bashio::log.warning "${secret_encryption_key}"
fi

# Set environment variables for Homarr
export SECRET_ENCRYPTION_KEY="${secret_encryption_key}"
export PORT="${port}"
export NODE_ENV="production"
export LOG_LEVEL="${log_level}"

# Homarr expects data in /app/data
export DATA_DIR="/data"

# Docker socket configuration
if bashio::var.true "${enable_docker_integration}"; then
    export DOCKER_HOST="unix:///var/run/docker.sock"
    bashio::log.info "Docker integration enabled - socket mounted at /var/run/docker.sock"
else
    unset DOCKER_HOST
    bashio::log.info "Docker integration disabled"
fi

# Create data directory structure if it doesn't exist
mkdir -p /data/configs
mkdir -p /data/icons
mkdir -p /data/data

# Create symbolic link if Homarr expects /app/data but we're using /data
if [ ! -L /app/data ]; then
    ln -sf /data /app/data
    bashio::log.info "Created symlink: /app/data -> /data"
fi

# Set proper permissions
chown -R node:node /data
chmod -R 755 /data

# Log configuration
bashio::log.info "Homarr Configuration:"
bashio::log.info "  Port: ${port}"
bashio::log.info "  Docker integration: ${enable_docker_integration}"
bashio::log.info "  Data directory: /data"
bashio::log.info "  Log level: ${log_level}"

# Check if encryption key is properly configured
if ! bashio::config.has_value 'secret_encryption_key'; then
    bashio::log.warning ""
    bashio::log.warning "================================================================"
    bashio::log.warning " IMPORTANT: No SECRET_ENCRYPTION_KEY in configuration!"
    bashio::log.warning " "
    bashio::log.warning " A temporary key was generated. To persist data across restarts,"
    bashio::log.warning " add this to your addon configuration:"
    bashio::log.warning " "
    bashio::log.warning ' "secret_encryption_key": "'${secret_encryption_key}'"'
    bashio::log.warning " "
    bashio::log.warning "================================================================"
    bashio::log.warning ""
fi

bashio::log.info "Starting Homarr dashboard..."
bashio::log.info ""
bashio::log.info "================================================================"
bashio::log.info " Homarr will be available at:"
bashio::log.info " - Web UI: http://[HOST]:${port}"
bashio::log.info " - Ingress: Through Home Assistant sidebar"
bashio::log.info "================================================================"
bashio::log.info ""

# Change to node user for security
cd /app || exit 1

# Start Homarr
# The base Homarr image uses 'next start' or similar
# Check what the actual CMD/ENTRYPOINT is in the base image
exec su-exec node node server.js
