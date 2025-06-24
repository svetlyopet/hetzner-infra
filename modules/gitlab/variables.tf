variable "gitlab_base_url" {
  description = "Base URL of the Gitlab instance"
  type        = string
}

variable "gitlab_registry_url" {
  description = "Base URL of the Gitlab registry"
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

variable "hetzner_ssh_firewall_id" {
  description = "Value for existing hcloud_firewall.id"
  type        = string
}

variable "hetzner_ssh_key_id" {
  description = "Value for existing hcloud_ssh_key.id"
  type        = string
}