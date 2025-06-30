output "gitlab_root_password" {
  description = "This is the root password created for Gitlab"
  value       = module.gitlab.gitlab_root_password
}

output "authentik_akadmin_password" {
  description = "This is the akadmin password created for Authentik"
  value       = module.authentik.authentik_akadmin_password
}