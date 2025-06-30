output "authentik_akadmin_password" {
  value = nonsensitive(random_password.authentik_akadmin.result)
}