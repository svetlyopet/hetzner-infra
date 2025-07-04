output "vault_primary_ip" {
  value = nonsensitive(hcloud_primary_ip.vault.ip_address)
}