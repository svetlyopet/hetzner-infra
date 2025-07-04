module "gitlab" {
    source = "./modules/gitlab"

    gitlab_base_url     = "https://${local.gitlab_fqdn}"
    gitlab_registry_url = "https://${local.gitlab_registry_fqdn}"

    hetzner_location    = var.hetzner_location
    hetzner_datacenter  = var.hetzner_datacenter
    hetzner_image       = "ubuntu-24.04"
    hetzner_server_type = "cpx21"

    swap_enabled = true
    swap_size    = "2G"

    shared_network_id       = hcloud_network.shared_network.id
    shared_firewall_ssh_id  = hcloud_firewall.shared_firewall_ssh.id
    shared_firewall_http_id = hcloud_firewall.shared_firewall_http.id
    shared_ssh_key_id       = hcloud_ssh_key.shared_ssh_key.id

    http_allowed_ips = local.http_allowed_ips

    depends_on = [
        hcloud_network.shared_network,
        hcloud_firewall.shared_firewall_ssh,
        hcloud_firewall.shared_firewall_http,
        hcloud_ssh_key.shared_ssh_key
    ]
}

module "authentik" {
    source = "./modules/authentik"

    authentik_fqdn = local.authentik_fqdn

    hetzner_location    = var.hetzner_location
    hetzner_datacenter  = var.hetzner_datacenter
    hetzner_image       = "ubuntu-24.04"
    hetzner_server_type = "cx22"

    shared_network_id       = hcloud_network.shared_network.id
    shared_firewall_ssh_id  = hcloud_firewall.shared_firewall_ssh.id
    shared_firewall_http_id = hcloud_firewall.shared_firewall_http.id
    shared_ssh_key_id       = hcloud_ssh_key.shared_ssh_key.id

    http_allowed_ips = local.http_allowed_ips

    depends_on = [
        hcloud_network.shared_network,
        hcloud_firewall.shared_firewall_ssh,
        hcloud_firewall.shared_firewall_http,
        hcloud_ssh_key.shared_ssh_key
    ]
}

module "vault" {
    source = "./modules/vault"

    vault_fqdn = local.vault_fqdn

    hetzner_location    = var.hetzner_location
    hetzner_datacenter  = var.hetzner_datacenter
    hetzner_image       = "ubuntu-24.04"
    hetzner_server_type = "cx22"

    shared_network_id       = hcloud_network.shared_network.id
    shared_firewall_ssh_id  = hcloud_firewall.shared_firewall_ssh.id
    shared_firewall_http_id = hcloud_firewall.shared_firewall_http.id
    shared_ssh_key_id       = hcloud_ssh_key.shared_ssh_key.id

    http_allowed_ips = local.http_allowed_ips

    depends_on = [
        hcloud_network.shared_network,
        hcloud_firewall.shared_firewall_ssh,
        hcloud_firewall.shared_firewall_http,
        hcloud_ssh_key.shared_ssh_key
    ]
}