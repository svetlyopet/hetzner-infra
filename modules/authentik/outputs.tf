output "authentik_primary_ip" {
  value = nonsensitive(hcloud_primary_ip.authentik.ip_address)
}

output "authentik_akadmin_password" {
  value = nonsensitive(random_password.authentik_akadmin.result)
}