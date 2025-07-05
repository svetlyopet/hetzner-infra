resource "hcloud_primary_ip" "gitlab" {
  name          = "ip-gitlab"
  datacenter    = var.hetzner_datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
  labels = {
    "service" : "gitlab"
  }
}

resource "random_password" "gitlab_root" {
  length  = 50
  special = false
}

resource "hcloud_server" "gitlab" {
  name        = "vm-gitlab"
  image       = var.hetzner_image
  server_type = var.hetzner_server_type
  location    = var.hetzner_location

  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.gitlab.id
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
    "service" : "gitlab"
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

  user_data = templatefile("${path.module}/scripts/install_gitlab.sh", {
    SWAP_ENABLED         = var.swap_enabled ? "true" : "false"
    SWAP_SIZE            = var.swap_size
    TLS_CERTIFICATE      = templatefile("${path.module}/templates/tls.crt.template", {})
    TLS_CERTIFICATE_KEY  = templatefile("${path.module}/templates/tls.key.template", {})
    EXTERNAL_URL         = var.gitlab_base_url
    GITLAB_ROOT_PASSWORD = random_password.gitlab_root.result
    GITLAB_CONFIG = templatefile("${path.module}/templates/gitlab.rb.template", {
      EXTERNAL_URL          = var.gitlab_base_url
      REGISTRY_EXTERNAL_URL = var.gitlab_registry_url
      IP_ADDRS              = var.http_allowed_ips
      GITLAB_ROOT_PASSWORD  = random_password.gitlab_root.result
    })
  })

  depends_on = [
    hcloud_primary_ip.gitlab,
    random_password.gitlab_root
  ]
}