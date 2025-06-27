#!/bin/bash

# Install supporting packages
sudo apt update && apt upgrade -y
sudo apt install -y curl openssh-server ca-certificates tzdata perl jq

# Add certificate for TLS termination on reverse-proxy
mkdir /etc/gitlab/ssl
cat <<EOF > /etc/gitlab/ssl/tls.crt
${TLS_CERTIFICATE}
EOF
cat <<EOF > /etc/gitlab/ssl/tls.key
${TLS_CERTIFICATE_KEY}
EOF

# Install GitLab Omnibus
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo apt install gitlab-ee

# Gitlab config
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template
cat <<EOF > /etc/gitlab/gitlab.rb
${GITLAB_CONFIG}
EOF
sudo gitlab-ctl reconfigure

# Apply some security patches to default configurations
sudo gitlab-rails runner "ApplicationSetting.last.update_attribute(:signup_enabled, false)"

# Install GitLab Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install -y gitlab-runner

# Register GitLab Runner
ACCESS_TOKEN=$(curl -k --request POST --header "Content-Type: application/json" --data "{ \
    \"grant_type\": \"password\", \
    \"username\": \"root\", \
    \"password\": \"$GITLAB_ROOT_PASSWORD\" \
  }" "${EXTERNAL_URL}/oauth/token" | jq .access_token | tr -d '"')

RUNNER_TOKEN=$(curl -k --silent --request POST --url "${EXTERNAL_URL}/api/v4/user/runners" \
  --data "runner_type=instance_type" \
  --data "run_untagged=true" \
  --data "paused=false" \
  --data "description=docker-runner" \
  --data "tag_list=shell,linux,xenial,ubuntu,docker" \
  --header "Authorization: Bearer $ACCESS_TOKEN" | jq .token | tr -d '"')

sudo sed -i 's/concurrent.*/concurrent = 10/' /etc/gitlab-runner/config.toml
sudo gitlab-runner register --url "${EXTERNAL_URL}" \
    --token "$RUNNER_TOKEN" \
    --non-interactive \
    --executor docker \
    --docker-image "alpine:latest"

# Install Docker
sudo apt-get install ca-certificates curl gnupg lsb-release
    
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker gitlab-runner