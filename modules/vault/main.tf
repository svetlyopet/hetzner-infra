resource "hcloud_primary_ip" "vault" {
  name          = "ip-vault"
  datacenter    = var.hetzner_datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
  labels = {
    "service" : "vault"
  }
}

resource "hcloud_server" "vault" {
  name        = "vm-vault"
  image       = var.hetzner_image
  server_type = var.hetzner_server_type
  location    = var.hetzner_location

  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.vault.id
    ipv6_enabled = false
  }

  firewall_ids = [
    var.shared_firewall_ssh_id,
    var.shared_firewall_http_id
  ]

  ssh_keys = [
    var.shared_ssh_key_id
  ]

  labels = {
    "service" : "vault"
  }

  network {
    network_id = var.shared_network_id
    # Add alias_ips to suppress diff causing terraform to modify the server without any changes
    # https://github.com/hetznercloud/terraform-provider-hcloud/issues/650#issuecomment-1497160625
    alias_ips = []
  }

  keep_disk = false
  delete_protection = false
  rebuild_protection = false
  shutdown_before_deletion = false

  user_data = templatefile("${path.module}/scripts/install_vault.sh", {
    TLS_CERTIFICATE      = templatefile("${path.module}/templates/tls.crt.template", {})
    TLS_CERTIFICATE_KEY  = templatefile("${path.module}/templates/tls.key.template", {})
    VAULT_CONFIG          = templatefile("${path.module}/templates/vault.hcl.template", {
      VAULT_INSTALL_DIR = "/opt/vault"
    })
    VAULT_SYSTEMD_SERVICE = templatefile("${path.module}/templates/vault.service.template", {})
    NGINX_CONFIG          = templatefile("${path.module}/templates/nginx.conf.template", {
      EXTERNAL_FQDN     = "${var.vault_fqdn}"
    })
  })

  depends_on = [
    hcloud_primary_ip.vault
  ]
}
