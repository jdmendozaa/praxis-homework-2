#!/usr/bin/env bash
echo "Hello from frontend!"

# Install and start nginx
sudo yum -y install nginx
sudo systemctl --now enable nginx

# Store dist in different folder to avoid bind mounts to manipulate it and F* up.
rm -rf /app
mkdir /app
cp /shared/spa/spa_dist.tar.gz /app/spa_dist.tar.gz
cd /app
tar -zxvf spa_dist.tar.gz

# Create certificate
# https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-apache-for-centos-7


mkdir -p /etc/ssl/private
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vuego-demoapp.key -out /etc/ssl/certs/vuego-demoapp.crt \
-subj "/C=CO/ST=Antioquia/L=Medellin/O=Praxis_Perficient/CN=localhost"

cat <<-'default_config' > /etc/nginx/nginx.conf
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
  worker_connections  1024;
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  65;
  server {
    listen       80;
    server_name  localhost;
    location / {
      root   /app/dist;
      index  index.html;
      try_files $uri $uri/ /index.html;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
  server {
    listen       443 ssl;
    server_name  localhost;
    ssl_certificate /etc/ssl/certs/vuego-demoapp.crt;
    ssl_certificate_key /etc/ssl/private/vuego-demoapp.key;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    location / {
      root   /app/dist;
      index  index.html;
      try_files $uri $uri/ /index.html;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
} 
default_config

nginx -t && systemctl reload nginx