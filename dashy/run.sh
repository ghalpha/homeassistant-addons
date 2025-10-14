#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Add-on: Dashy
# Configures and starts the Dashy dashboard
# ==============================================================================

bashio::log.info "Starting Dashy addon..."

# Declare variables
declare page_title
declare description
declare theme
declare language
declare layout
declare icon_size
declare hide_settings
declare hide_footer
declare enable_multi_tasking
declare custom_css

# Get addon options
page_title=$(bashio::config 'page_title')
description=$(bashio::config 'description')
theme=$(bashio::config 'theme')
language=$(bashio::config 'language')
layout=$(bashio::config 'layout')
icon_size=$(bashio::config 'icon_size')
hide_settings=$(bashio::config 'hide_settings')
hide_footer=$(bashio::config 'hide_footer')
enable_multi_tasking=$(bashio::config 'enable_multi_tasking')
custom_css=$(bashio::config 'custom_css')

bashio::log.info "Generating Dashy configuration..."

# Create config directory if it doesn't exist
mkdir -p /config

# Check if user has a custom conf.yml, if so, use it instead
if [ -f /config/conf.yml.custom ]; then
    bashio::log.info "Found custom configuration file (conf.yml.custom), using that instead..."
    cp /config/conf.yml.custom /config/conf.yml
else
    # Generate conf.yml from options
    bashio::log.info "Generating conf.yml from addon options..."
    
    cat > /config/conf.yml <<EOF
---
pageInfo:
  title: ${page_title}
  description: ${description}
  navLinks: []

appConfig:
  theme: ${theme}
  language: ${language}
  layout: ${layout}
  iconSize: ${icon_size}
  hideSettings: ${hide_settings}
  hideFooter: ${hide_footer}
  enableMultiTasking: ${enable_multi_tasking}
  allowConfigEdit: true
  enableErrorReporting: false
  enableServiceWorker: false
  disableSmartSort: false
  disableUpdateChecks: true
  showSplashScreen: false
  preventWriteToDisk: false
  preventLocalSave: false
  disableConfiguration: false

sections:
  - name: Getting Started
    icon: fas fa-rocket
    items:
      - title: Dashy Documentation
        description: View the Dashy documentation
        icon: hl-dashy
        url: https://dashy.to/docs/
        target: newtab
      - title: Home Assistant
        description: Return to Home Assistant
        icon: hl-home-assistant
        url: /
        target: newtab
      - title: Edit Config
        description: Edit your Dashy configuration
        icon: fas fa-edit
        url: https://dashy.to/docs/configuring/
        target: newtab
EOF

    # Add custom CSS if provided
    if [ -n "${custom_css}" ]; then
        cat >> /config/conf.yml <<EOF

  customCss: |
    ${custom_css}
EOF
    fi

    bashio::log.info "Configuration file generated successfully"
fi

# Copy config to where Dashy expects it
bashio::log.info "Copying configuration to /app/public/conf.yml..."
mkdir -p /app/public
cp /config/conf.yml /app/public/conf.yml

# Set proper permissions
chown -R node:node /app/public
chmod -R 755 /app/public

# Log configuration
bashio::log.info "Dashy Configuration:"
bashio::log.info "  Page Title: ${page_title}"
bashio::log.info "  Theme: ${theme}"
bashio::log.info "  Language: ${language}"
bashio::log.info "  Layout: ${layout}"
bashio::log.info "  Icon Size: ${icon_size}"

bashio::log.info ""
bashio::log.info "================================================================"
bashio::log.info " To customize further, you can:"
bashio::log.info " 1. Edit /addon_configs/dashy/conf.yml directly, OR"
bashio::log.info " 2. Create /addon_configs/dashy/conf.yml.custom for full control"
bashio::log.info "    (This will override all addon options)"
bashio::log.info "================================================================"
bashio::log.info ""

bashio::log.info "Starting Dashy dashboard..."

# Start Dashy
exec node /app/server.js
