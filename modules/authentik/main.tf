resource "hcloud_primary_ip" "authentik" {
  name          = "ip-authentik"
  datacenter    = var.hetzner_datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
  labels = {
    "service" : "authentik"
  }
}

resource "random_password" "authentik_secret_key" {
  length  = 60
  special = false
}

resource "random_password" "authentik_akadmin" {
  length  = 60
  special = false
}

resource "random_password" "postgres_password" {
  length  = 40
  special = false
}

resource "hcloud_server" "authentik" {
  name        = "vm-authentik"
  image       = var.hetzner_image
  server_type = var.hetzner_server_type
  location    = var.hetzner_location

  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.authentik.id
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
    "service" : "authentik"
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

  user_data = templatefile("${path.module}/scripts/install_authentik.sh", {
    TLS_CERTIFICATE     = templatefile("${path.module}/templates/tls.crt.template", {})
    TLS_CERTIFICATE_KEY = templatefile("${path.module}/templates/tls.key.template", {})
    NGINX_CONFIG        = templatefile("${path.module}/templates/nginx.conf.template", {
      EXTERNAL_FQDN = "${var.authentik_fqdn}"
    })
    AUTHENTIK_SECRET_KEY         = random_password.authentik_secret_key.result
    AUTHENTIK_BOOTSTRAP_PASSWORD = random_password.authentik_akadmin.result
    PG_PASS                      = random_password.postgres_password.result
  })

  depends_on = [
    hcloud_primary_ip.authentik,
    random_password.authentik_secret_key,
    random_password.authentik_akadmin,
    random_password.postgres_password
  ]
}
