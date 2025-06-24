module "gitlab" {
    source = "./modules/gitlab"

    gitlab_base_url = var.gitlab_base_url
    gitlab_registry_url = var.gitlab_registry_url

    hetzner_location = var.hetzner_location
    hetzner_datacenter = var.hetzner_datacenter
    hetzner_image = "ubuntu-24.04"
    hetzner_server_type = "cpx31"

    hetzner_ssh_firewall_id = hcloud_firewall.shared_firewall_ssh.id
    hetzner_ssh_key_id = hcloud_ssh_key.shared_ssh_key.id
}