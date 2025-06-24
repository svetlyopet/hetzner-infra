#! /bin/bash

# Install supporting packages
sudo apt update
sudo apt install -y curl openssh-server ca-certificates tzdata perl jq

# Install GitLab Omnibus
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
sudo apt install gitlab-ee

# Gitlab config
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template?_gl=1%2a1x2reot%2a_ga%2aMjAxODc0NTkxNi4xNjc2NzE0NzE2%2a_ga_ENFH3X7M5Y%2aMTY3NzAxMzY3OC41LjEuMTY3NzAxNDcwMS4wLjAuMA
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
AUTHORIZATION_TOKEN=$(curl --request POST --header "Content-Type: application/json" --data "{ \
    \"grant_type\": \"password\", \
    \"username\": \"root\", \
    \"password\": \"$GITLAB_ROOT_PASSWORD\" \
  }" http://127.0.0.1/oauth/token)

RUNNER_TOKEN=$(curl -k -H "Authorization: Bearer $AUTHORIZATION_TOKEN" -X POST 'http://127.0.0.1/api/v4/user/runners?runner_type=instance_type' | jq .token)

sudo sed -i 's/concurrent.*/concurrent = 10/' /etc/gitlab-runner/config.toml
sudo gitlab-runner register --url "${EXTERNAL_URL}" \
    --token "$RUNNER_TOKEN" \
    --non-interactive \
    --executor docker \
    --description "docker-runner" \
    --tag-list "shell,linux,xenial,ubuntu,docker" \
    --run-untagged \
    --locked="false" \
    --docker-image "alpine:latest"

# Install Docker 
sudo apt-get install ca-certificates curl gnupg lsb-release
    
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker gitlab-runner