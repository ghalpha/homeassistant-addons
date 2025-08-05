#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Community Add-on: Homarr
# Configures and starts the Homarr dashboard service
# ==============================================================================

bashio::log.info "Starting Homarr addon..."

# Declare variables
declare secret_encryption_key
declare port
declare enable_docker_integration

# Get addon options
secret_encryption_key=$(bashio::config 'secret_encryption_key')
port=$(bashio::config 'port')
enable_docker_integration=$(bashio::config 'enable_docker_integration')

# Debug logging
bashio::log.info "Configuration values:"
bashio::log.info "Port: ${port}"
bashio::log.info "Docker integration: ${enable_docker_integration}"
bashio::log.info "Secret key length: ${#secret_encryption_key}"

# Handle encryption key
if bashio::config.has_value 'secret_encryption_key'; then
    secret_encryption_key=$(bashio::config 'secret_encryption_key')
    bashio::log.info "Using provided SECRET_ENCRYPTION_KEY from configuration"
else
    bashio::log.info "Generating SECRET_ENCRYPTION_KEY..."
    secret_encryption_key=$(openssl rand -hex 32)
    bashio::log.info "Generated new encryption key. Save this in your addon configuration to persist across restarts:"
    bashio::log.info "${secret_encryption_key}"
fi

# Validate encryption key length (should be 64 characters for hex)
if [ ${#secret_encryption_key} -ne 64 ]; then
    bashio::log.warning "SECRET_ENCRYPTION_KEY should be exactly 64 characters (32 bytes in hex format)"
    bashio::log.warning "Current length: ${#secret_encryption_key}"
fi

# Set environment variables
export SECRET_ENCRYPTION_KEY="${secret_encryption_key}"
export PORT="${port}"

# Create appdata directory if it doesn't exist
mkdir -p /appdata

# Create config directory structure
mkdir -p /appdata/configs
mkdir -p /appdata/icons

# Set proper permissions
chown -R root:root /appdata
chmod -R 755 /appdata

# Log configuration
bashio::log.info "Homarr will run on port: ${port}"
bashio::log.info "Docker integration enabled: ${enable_docker_integration}"

if bashio::var.true "${enable_docker_integration}"; then
    bashio::log.info "Docker socket will be mounted for container management"
else
    bashio::log.info "Docker integration disabled - some features may be limited"
fi

# Check if encryption key is set
if bashio::config.has_value 'secret_encryption_key'; then
    bashio::log.info "Using provided SECRET_ENCRYPTION_KEY from configuration"
else
    bashio::log.warning "No SECRET_ENCRYPTION_KEY provided in configuration!"
    bashio::log.warning "A temporary key was generated. Add the key shown above to your addon config to persist data across restarts."
fi

bashio::log.info "Starting Homarr dashboard..."

# Start the original Homarr application
# The base image already has the proper entrypoint configured
exec /usr/local/bin/docker-entrypoint.sh node server.js