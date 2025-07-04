variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "hetzner_location" {
  type    = string
  default = "fsn1"
}

variable "hetzner_datacenter" {
  type    = string
  default = "fsn1-dc14"
}

variable "hetzner_network_zone" {
  type    = string
  default = "eu-central"
}

variable "ssh_allowed_ips" {
  type = list
}

variable "base_domain" {
  type = string
}

variable "subdomain_gitlab" {
  type    = string
  default = "gitlab"
}

variable "subdomain_gitlab_registry" {
  type    = string
  default = "registry"
}

variable "subdomain_authentik" {
  type    = string
  default = "auth"
}

variable "subdomain_vault" {
  type    = string
  default = "vault"
}