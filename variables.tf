variable "hcloud_token" {
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

variable "ssh_allowed_ip" {
  type = string
}

variable "gitlab_base_fqdn" {
  type = string
}

variable "gitlab_registry_fqdn" {
  type = string
}

variable "authentik_fqdn" {
  type = string
}

variable "vault_fqdn" {
  type = string
}