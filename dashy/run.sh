# Base image
FROM lissy93/dashy:latest

# Set working directory
WORKDIR /app

# Copy the run.sh script to the container
COPY run.sh /run.sh

# Make sure run.sh is executable
RUN chmod +x /run.sh

# Use run.sh as the entrypoint
ENTRYPOINT ["/run.sh"]

# Expose the required port
EXPOSE 8080