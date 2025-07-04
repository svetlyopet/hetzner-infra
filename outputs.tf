output "access_url_authentik" {
  description = "Access URL for the Authentik service"
  value       = "https://${local.authentik_fqdn}"
}

output "access_url_gitlab" {
  description = "Access URL for the Gitlab service"
  value       = "https://${local.gitlab_fqdn}"
}

output "access_url_vault" {
  description = "Access URL for the Vault service"
  value       = "https://${local.vault_fqdn}"
}

output "password_gitlab_root" {
  description = "This is the root password created for Gitlab"
  value       = module.gitlab.gitlab_root_password
}

output "password_authentik_akadmin" {
  description = "This is the akadmin password created for Authentik"
  value       = module.authentik.authentik_akadmin_password
}