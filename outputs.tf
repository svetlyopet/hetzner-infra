output "gitlab_root_password" {
  description = "This is the root password created for Gitlab"
  value       = module.gitlab.gitlab_root_password
}