output "gitlab_primary_ip" {
  value = nonsensitive(hcloud_primary_ip.gitlab.ip_address)
}

output "gitlab_root_password" {
  value = nonsensitive(random_password.gitlab_root.result)
}