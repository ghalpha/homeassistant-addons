ARG BUILD_FROM=boky/postfix:latest
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required packages for Home Assistant addon compatibility
RUN apk add --no-cache \
    bash \
    curl \
    jq \
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
RUN mkdir -p /config

# Labels
LABEL \
    io.hass.name="Postfix Relay" \
    io.hass.description="SMTP relay for sending emails" \
    io.hass.arch="aarch64|amd64|armv7" \
    io.hass.type="addon" \
    io.hass.version="1.0.0" \
    maintainer="ghalpha <brandon@teksyn.net>" \
    org.opencontainers.image.title="Postfix Relay Home Assistant Addon" \
    org.opencontainers.image.description="SMTP relay for sending emails from Home Assistant" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="ghalpha" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/ghalpha/homeassistant-addons" \
    org.opencontainers.image.source="https://github.com/ghalpha/homeassistant-addons/tree/main/postfix-relay"

CMD [ "/run.sh" ]
