#!/usr/bin/env bash
echo "Hello from backend!"

# Store bin in different folder to avoid bind mounts to manipulate it and F* up.
rm -rf /app
mkdir /app
cp /shared/server/vuego-demoapp /app
cd /app
# Run server. Append & to start as backgrounded
./vuego-demoapp &

# TODO: Create service using systemd and enable it.
