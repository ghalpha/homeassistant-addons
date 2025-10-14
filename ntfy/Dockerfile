ARG BUILD_FROM=binwiederhier/ntfy:latest
FROM $BUILD_FROM

# Switch to root for installations
USER root

# Install bashio for Home Assistant integration
RUN apk add --no-cache \
    bash \
    curl \
    jq

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
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
