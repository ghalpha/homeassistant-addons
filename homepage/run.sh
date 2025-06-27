#!/bin/bash
export HOMEPAGE_ALLOWED_HOSTS="$HOMEPAGE_ALLOWED_HOSTS"

echo "Allowed Hosts: $HOMEPAGE_ALLOWED_HOSTS"

# Start the app – change to whatever the actual command is
exec /app/homepage