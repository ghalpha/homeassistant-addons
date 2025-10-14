ARG BUILD_FROM=binwiederhier/ntfy:latest
FROM $BUILD_FROM

# Simple entrypoint wrapper to ensure 'serve' command is used
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
