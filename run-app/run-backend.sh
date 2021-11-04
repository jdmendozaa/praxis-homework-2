#!/usr/bin/env bash
echo "Hello from backend!"

# Store bin in different folder to avoid bind mounts to manipulate it and F* up.
rm -rf /app
mkdir -p /app
cp /shared/server/vuego-demoapp /app

cd /etc/systemd/system

cat << EOF > go-server.service
[Unit]
Description=Go server for vuego-demoapp

[Service]
Environment="PORT=$PORT"
ExecStart=/app/vuego-demoapp &

[Install]
WantedBy=multi-user.target
EOF

# Reload daemon
systemctl daemon-reload
systemctl --now disable go-server.service

# Enable and start server
systemctl --now enable go-server.service