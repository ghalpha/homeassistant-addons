FROM binwiederhier/ntfy:latest

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Clear the base image's ENTRYPOINT
ENTRYPOINT []

# Run our script
CMD ["/run.sh"]
