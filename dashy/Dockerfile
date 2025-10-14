ARG BUILD_FROM=ghcr.io/lissy93/dashy:latest
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Switch to root for installations
USER root

# Install required packages for Home Assistant addon compatibility
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        curl \
        jq \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install bashio
RUN curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
        /tmp/bashio.tar.gz \
        --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -fr \
        /tmp/bashio.tar.gz \
        /tmp/bashio

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Create necessary directories
RUN mkdir -p /config /app/public \
    && chown -R node:node /config /app/public

# Labels
LABEL \
    io.hass.name="Dashy" \
    io.hass.description="A highly customizable dashboard for your self-hosted applications" \
    io.hass.arch="aarch64|amd64|armv7" \
    io.hass.type="addon" \
    io.hass.version="1.0.0" \
    maintainer="ghalpha <brandon@teksyn.net>" \
    org.opencontainers.image.title="Dashy Home Assistant Addon" \
    org.opencontainers.image.description="A highly customizable dashboard" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="ghalpha" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/ghalpha/homeassistant-addons" \
    org.opencontainers.image.source="https://github.com/ghalpha/homeassistant-addons/tree/main/dashy"

# Switch back to node user for runtime
USER node

# Start with our custom script
CMD [ "/run.sh" ]
