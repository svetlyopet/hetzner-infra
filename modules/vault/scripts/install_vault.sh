#!/bin/bash

# Install supporting packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl ca-certificates

# Install Hashicorp Vault
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vault

# Substitute the default Vault configuration file with our custom config
cat <<EOF > /etc/vault.d/vault.hcl
${VAULT_CONFIG}
EOF

# Allow Vault to use mlock syscall without root permissions
sudo setcap cap_ipc_lock=+ep /usr/bin/vault

sudo chown vault:vault /etc/vault.d/vault.hcl
sudo chmod 640 /etc/vault.d/vault.hcl

# Add a systemd service for Hashicorp Vault
cat <<EOF > /etc/systemd/system/vault.service
${VAULT_SYSTEMD_SERVICE}
EOF

# Enable vault service on system startup
sudo systemctl enable vault.service
sudo systemctl start vault.service

VAULT_BIN=$(which vault)

$VAULT_BIN operator init -key-shares=$VAULT_KEY_SHARES -key-threshold=$VAULT_KEY_THRESHOLD -tls-skip-verify > /etc/vault.d/initial_setup

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