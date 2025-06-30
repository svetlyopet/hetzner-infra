#!/bin/bash

# Install supporting packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release

# Install Docker
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add Authentik setup for Docker compose
AUTHENTIK_DIR=/opt/authentik
mkdir -m 0755 -p $AUTHENTIK_DIR
curl -fsSL https://goauthentik.io/docker-compose.yml -o $AUTHENTIK_DIR/docker-compose.yml

cat <<EOF > $AUTHENTIK_DIR/.env 
AUTHENTIK_SECRET_KEY=${AUTHENTIK_SECRET_KEY}
AUTHENTIK_BOOTSTRAP_PASSWORD=${AUTHENTIK_BOOTSTRAP_PASSWORD}
PG_PASS=${PG_PASS}
EOF

# Start the Authentik and all its supporting services
sudo docker compose -f $AUTHENTIK_DIR/docker-compose.yml pull
sudo docker compose -f $AUTHENTIK_DIR/docker-compose.yml --env-file $AUTHENTIK_DIR/.env up -d

# Install NGINX
sudo apt install -y nginx

# Add certificate for TLS termination on reverse-proxy
mkdir -p /etc/ssl/nginx
cat <<EOF > /etc/ssl/nginx/tls.crt
${TLS_CERTIFICATE}
EOF
cat <<EOF > /etc/ssl/nginx/tls.key
${TLS_CERTIFICATE_KEY}
EOF

# Remove default config for NGINX and add our custom config
sudo rm -f /etc/nginx/sites-enabled/default
sudo rm -f /etc/nginx/sites-available/default
cat <<EOF > /etc/nginx/conf.d/nginx.conf
${NGINX_CONFIG}
EOF

# Start the NGINX server
sudo systemctl restart nginx