#!/usr/bin/env bash

# verifica si esta instalado
# si lo esta no lo instala
if ! command -v git &> /dev/null
then
    sudo yum install -y git
fi
git --version

# ----------------------------------------------

# descarga, instala y agrega al path
if [[ ! -f go1.17.2.linux-amd64.tar.gz ]]
then
    wget -c https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
    sudo sh -c "echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile"
    source /etc/profile
else
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
    sudo sh -c "echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile"
    source /etc/profile
fi
go version

# ----------------------------------------------

if [[ ! -f node-v16.13.0-linux-x64.tar.gz ]]
then
    wget -c https://nodejs.org/download/release/latest-gallium/node-v16.13.0-linux-x64.tar.gz
    sudo tar -C /bin -xzf node-v16.13.0-linux-x64.tar.gz
    sudo sh -c "echo export PATH=$PATH:/bin/node-v16.13.0-linux-x64/bin >> /etc/profile"
    source /etc/profile
else
    sudo rm -rf /bin/node-v16.13.0-linux-x64
    sudo tar -C /bin -xzf node-v16.13.0-linux-x64.tar.gz
    sudo sh -c "echo export PATH=$PATH:/bin/node-v16.13.0-linux-x64/bin >> /etc/profile"
    source /etc/profile
fi
node --version
npm --version