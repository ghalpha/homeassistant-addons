#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Add-on: Postfix Relay
# Configures and starts the Postfix SMTP relay service
# ==============================================================================

bashio::log.info "Starting Postfix Relay addon..."

# Declare variables
declare relay_host
declare relay_port
declare relay_username
declare relay_password
declare relay_use_tls
declare allowed_sender_domains
declare message_size_limit
declare mynetworks
declare relay_myhostname
declare masquerade_domains
declare smtp_header_checks
declare always_add_missing_headers
declare overwrite_from
declare log_level

# Get addon options
relay_host=$(bashio::config 'relay_host')
relay_port=$(bashio::config 'relay_port')
relay_username=$(bashio::config 'relay_username')
relay_password=$(bashio::config 'relay_password')
relay_use_tls=$(bashio::config 'relay_use_tls')
allowed_sender_domains=$(bashio::config 'allowed_sender_domains')
message_size_limit=$(bashio::config 'message_size_limit')
mynetworks=$(bashio::config 'mynetworks')
relay_myhostname=$(bashio::config 'relay_myhostname')

# Optional configurations
if bashio::config.has_value 'masquerade_domains'; then
    masquerade_domains=$(bashio::config 'masquerade_domains')
fi

if bashio::config.has_value 'smtp_header_checks'; then
    smtp_header_checks=$(bashio::config 'smtp_header_checks')
fi

if bashio::config.has_value 'always_add_missing_headers'; then
    always_add_missing_headers=$(bashio::config 'always_add_missing_headers')
fi

if bashio::config.has_value 'overwrite_from'; then
    overwrite_from=$(bashio::config 'overwrite_from')
fi

if bashio::config.has_value 'log_level'; then
    log_level=$(bashio::config 'log_level')
fi

# Validate required configuration
if bashio::var.is_empty "${relay_host}"; then
    bashio::log.fatal "relay_host is required! Please configure your SMTP relay server."
    bashio::exit.nok
fi

if bashio::var.is_empty "${relay_username}"; then
    bashio::log.warning "relay_username is empty. Relay will work without authentication."
fi

bashio::log.info "Configuring Postfix Relay..."

# Set environment variables for the base image
export RELAYHOST="${relay_host}:${relay_port}"
export RELAYHOST_USERNAME="${relay_username}"
export RELAYHOST_PASSWORD="${relay_password}"
export ALLOWED_SENDER_DOMAINS="${allowed_sender_domains}"
export MESSAGE_SIZE_LIMIT="${message_size_limit}"
export MYNETWORKS="${mynetworks}"
export HOSTNAME="${relay_myhostname}"

# Optional environment variables
if [ -n "${masquerade_domains}" ]; then
    export MASQUERADED_DOMAINS="${masquerade_domains}"
    bashio::log.info "Masquerading domains: ${masquerade_domains}"
fi

if [ -n "${smtp_header_checks}" ]; then
    export SMTP_HEADER_CHECKS="${smtp_header_checks}"
    bashio::log.info "SMTP header checks configured"
fi

if bashio::var.true "${always_add_missing_headers}"; then
    export ALWAYS_ADD_MISSING_HEADERS="yes"
    bashio::log.info "Always adding missing headers"
fi

if [ -n "${overwrite_from}" ]; then
    export OVERWRITE_FROM="${overwrite_from}"
    bashio::log.info "Overwriting FROM address to: ${overwrite_from}"
fi

if [ -n "${log_level}" ]; then
    export LOG_LEVEL="${log_level}"
fi

# Set TLS configuration
if bashio::var.true "${relay_use_tls}"; then
    export USE_TLS="yes"
    export TLS_VERIFY="may"
    bashio::log.info "TLS enabled for relay connection"
else
    export USE_TLS="no"
    bashio::log.warning "TLS disabled - emails will be sent without encryption!"
fi

# Log configuration (without sensitive data)
bashio::log.info "Postfix Relay Configuration:"
bashio::log.info "  Relay Host: ${relay_host}:${relay_port}"
bashio::log.info "  Relay Username: ${relay_username}"
bashio::log.info "  TLS Enabled: ${relay_use_tls}"
bashio::log.info "  Hostname: ${relay_myhostname}"
bashio::log.info "  Message Size Limit: ${message_size_limit} bytes"
bashio::log.info "  My Networks: ${mynetworks}"

if [ -n "${allowed_sender_domains}" ]; then
    bashio::log.info "  Allowed Sender Domains: ${allowed_sender_domains}"
else
    bashio::log.info "  Allowed Sender Domains: All domains allowed"
fi

bashio::log.info ""
bashio::log.info "================================================================"
bashio::log.info " Postfix Relay is starting..."
bashio::log.info " "
bashio::log.info " To send emails from Home Assistant, use:"
bashio::log.info " SMTP Server: localhost or 172.30.32.1"
bashio::log.info " SMTP Port: 587 (or 25)"
bashio::log.info " SMTP Security: None (relay handles TLS to external server)"
bashio::log.info " SMTP Username: (leave empty)"
bashio::log.info " SMTP Password: (leave empty)"
bashio::log.info "================================================================"
bashio::log.info ""

# Start Postfix using the original entrypoint
exec /docker-init.sh
