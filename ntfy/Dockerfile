FROM binwiederhier/ntfy:latest

# Install jq for JSON parsing
RUN apk add --no-cache jq

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Clear the base image's ENTRYPOINT
ENTRYPOINT []

# Run our script
CMD ["/run.sh"]
