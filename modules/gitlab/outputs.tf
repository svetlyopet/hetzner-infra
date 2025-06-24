output "gitlab_root_password" {
  value = nonsensitive(random_password.gitlab_root.result)
}