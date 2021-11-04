#!/usr/bin/env bash
echo "Hello from backend!"

# Store bin in different folder to avoid bind mounts to manipulate it and F* up.
rm -rf /app
mkdir -p /app
cp /shared/server/vuego-demoapp /app
cd /app

# Export env var
sudo echo "export PORT=$PORT" >> /etc/profile
# Run server. Append & to start as backgrounded
echo $PORT
./vuego-demoapp &

# TODO: Create service using systemd and enable it.
