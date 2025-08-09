## About The Project

This project aims to bootstrap several open source services which can be used to manage small software organisations and their development pipelines.

[Hetzner Cloud](https://hetzner.com) is used to provide cloud resources as it is a reliable and cost-effective cloud provider with multiple data centers around the world.

The services spin up from this project are tied to a base domain managed in [Cloudflare](https://www.cloudflare.com/en-gb/).

## Services

- Gitlab for hosting Git repositories, CI/CD pipelines and project management.
- Authentik as an Identity provider.
- Vault as a secrets manager.

**Why Cloudflare**

- Manage DNS for the services using the free-tier plan.
- Offers DDoS protection and geolocation IP blocking.
- Terraform provider available.

**Why Gitlab (and not Gitea)?**

- More customizable for different setups and projects.
- Easy initial setup and low maintenance for small environments.
- CI/CD pipelines and runners included.

**Why Authentik (and not Keycloak or Authelia)?**

- Shorter learning curve.
- Good focus on security and privacy.
- Easy setup for applications.
- Supports GitOps(blueprints) for its configuration.

**Why Vault?**

- Provides secrets lifecycle management.
- Fast deployment, as it is a single binary and can be deployed with a single command.
- Well-mainteined kubernetes operator for fetching secrets from the API.

## Getting Started

### Prerequisites

1. Hetzner Cloud account. You can sign up for free [here](https://hetzner.com/cloud/).


2. Cloudflare account and a domain. You can sign up for free [here](https://www.cloudflare.com/en-gb/)
and add your domain to your account. 

3. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed

    ```sh
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

4. (Optional) [hcloud](https://github.com/hetznercloud/cli) for using the [manage.sh](./scripts/manage.sh) script.

    ```sh
    brew install hcloud
    ```

## Usage

1. Create an API token for your Hetzner account.

2. Create an API token for your Cloudflare account with EDIT permissions for your DNS zone.

3. Generate [Origin certificates](https://developers.cloudflare.com/ssl/origin-configuration/) for your domain from Cloudflare. 

    The certificate is used for the TLS termination done on the reverse proxies in front of the services. 
    
    Generate the certificate and private key and place their contents in the global [templates directory](./templates) with names `tls.crt.tpl` for the public key, and `tls.key.tpl` for the private key.

4. Create a .tfvars file for your project and add set following variables in it:

    ```sh
    cat <<EOF > example.tfvars
    hcloud_token         = "your-hetzner-token"
    cloudflare_api_token = "your-cloudflare-token"
    ssh_allowed_ips      = ["127.0.0.1/32"]
    base_domain          = "example.com"
    EOF
    ```

5. Run terraform apply

## High Availability

Since the target for this bootstrap setup is small and low-cost development environments, HA is not supported for the installed services.
