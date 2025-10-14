ARG BUILD_FROM=ghcr.io/homarr-labs/homarr:latest
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# Switch to root for installations
USER root

# Install required packages for Home Assistant addon compatibility
# Homarr uses Alpine Linux (Node.js base), so use apk not apt-get
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    openssl \
    su-exec \
    ca-certificates

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
RUN mkdir -p /data /app/data \
    && chown -R node:node /data /app/data

# Labels
LABEL \
    io.hass.name="Homarr" \
    io.hass.description="A sleek, modern dashboard for your self-hosted applications" \
    io.hass.arch="armhf|armv7|aarch64|amd64|i386" \
    io.hass.type="addon" \
    io.hass.version="1.0.0" \
    maintainer="ghalpha <brandon@teksyn.net>" \
    org.opencontainers.image.title="Homarr Home Assistant Addon" \
    org.opencontainers.image.description="A sleek, modern dashboard for your self-hosted applications" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="ghalpha" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.url="https://github.com/ghalpha/homeassistant-addons" \
    org.opencontainers.image.source="https://github.com/ghalpha/homeassistant-addons/tree/main/homarr" \
    org.opencontainers.image.documentation="https://github.com/ghalpha/homeassistant-addons/tree/main/homarr/README.md"

# Start with our custom script
CMD [ "/run.sh" ]
