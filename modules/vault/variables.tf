variable "vault_fqdn" {
  description = "FQDN of the Vault instance"
  type        = string
}

variable "hetzner_location" {
  description = "Hetzner Cloud Location"
  type        = string
}

variable "hetzner_datacenter" {
  description = "Hetzner Cloud Datacenter"
  type        = string
}

variable "hetzner_image" {
  type        = string
  description = "Hetzner Cloud Image"
  default     = "ubuntu-24.04"
}

variable "hetzner_server_type" {
  type        = string
  description = "Hetzner Cloud Server Type"
  default     = "cpx31"
}

variable "shared_firewall_ssh_id" {
  description = "Value for existing hcloud_firewall.id"
  type        = string
}

variable "shared_firewall_http_id" {
  description = "Value for existing hcloud_firewall.id"
  type        = string
}

variable "shared_ssh_key_id" {
  description = "Value for existing hcloud_ssh_key.id"
  type        = string
}

variable "shared_network_id" {
  description = "Value for existing hcloud_network.id"
  type        = string
}