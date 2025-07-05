## About The Project

[Hetzner Cloud](https://hetzner.com) is a reliable and cost-effective cloud provider with multiple data centers around the world.

This project aims to provide a bootstrap for several open source services which can be used to manage small software organisations and their software development pipelines.

Creating infrastructure to run the software(also referred as a data plane) is out of scope for this project.

Services are tied to a base domain managed in [Cloudflare](https://www.cloudflare.com/en-gb/).

## Services

- Gitlab for hosting Git repositories, CI/CD pipelines and project management.
- Authentik as an Identity provider.
- Vault as a secrets manager.

**Why Cloudflare**

- Manage DNS for the services using the free-tier plan.
- Offers DDoS protection and geolocation IP blocking.
- Terraform provider available.
- Traffic analytics.

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

First and foremost, you need to have a Hetzner Cloud account. You can sign up for free [here](https://hetzner.com/cloud/).

Then you'll need to have [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and [hcloud](https://github.com/hetznercloud/cli) the Hetzner cli for using the [manage.sh](./scripts/manage.sh) script. The easiest way is to use the [homebrew](https://brew.sh/) package manager to install them (available on Linux, Mac, and Windows Linux Subsystem).

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew install hcloud
```

## High Availability

Since the target for this bootstrap setup is small and low-cost development environments, HA is not supported for the installed services.