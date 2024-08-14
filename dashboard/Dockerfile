# Use the base image from Docker Hub
FROM phntxx/dashboard:latest

# Set environment variables (these can be overwritten at runtime)
ENV CLOUDFLARE_ZONE_ID=""
ENV CLOUDFLARE_PURGE_TOKEN=""

# Expose the necessary port
EXPOSE 8080

# Optionally copy any additional configuration or setup files
# COPY ./config /path/inside/container

# Specify the command to run on container start
CMD ["npm", "start"]  # or the specific command to start the dashboard, if different