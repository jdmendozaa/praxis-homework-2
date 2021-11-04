#!/usr/bin/env bash
echo "Building app..."

### Dependencies ###
# Install Git and Golang
sudo yum -y install git golang
# Install nvm @see https://github.com/nvm-sh/nvm#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bash_profile
# Install Node and npm with nvm
nvm install 14
nvm alias default 14

# Since installing @vue/cli was giving an error with npm
# I decided to use yarn for now
# Pretty sure it has something to do with how npm is installed by nvm
# since it installs it for the user.
npm install -g yarn

# Install Vue CLI
yarn global add @vue/cli
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
# Generate yarn.lock from package-lock
yarn import
# Remove package-lock 
rm -f package-lock.json
# Install and build using yarn
yarn install
yarn upgrade
# Set environment variables into .env file
echo "VUE_APP_API_ENDPOINT=$VUE_APP_API_ENDPOINT" > .env.production
yarn build
# Create output folder
rm -rf /shared/spa
mkdir -p /shared/spa
# Compress and move to /shared/spa
tar -zcvf spa_dist.tar.gz ./dist
mv spa_dist.tar.gz /shared/spa