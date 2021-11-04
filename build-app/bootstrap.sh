#!/usr/bin/env bash
echo "Building app..."

### Dependencies ###
# Install Git and Golang
sudo yum -y install git Golang

# Install Node.js and npm
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum -y install nodejs

# Install Vue CLI
npm install -g @vue/cli

# Remove old builds, remake dir and clone repo
rm -rf /app
mkdir -p /app
cd /app
git clone https://github.com/jdmendozaa/vuego-demoapp.git .

### Build Go Server ###
# Create output folder
mkdir -p /shared/server
# Build Go
cd /app/server
go build -o /shared/server
# Cross-compiling:
# env GOOS=target-OS GOARCH=target-architecture go build package-import-path
# https://www.digitalocean.com/community/tutorials/how-to-build-go-executables-for-multiple-platforms-on-ubuntu-16-04

### Build Vue SPA ###
cd /app/spa
# Install and build using yarn
sudo npm ci
# Set environment variables into .env file
echo "VUE_APP_API_ENDPOINT=$VUE_APP_API_ENDPOINT" > .env.production
sudo npm run build
# Create output folder
rm -rf /shared/spa
mkdir -p /shared/spa
# Compress and move to /shared/spa
tar -zcvf spa_dist.tar.gz ./dist
mv spa_dist.tar.gz /shared/spa