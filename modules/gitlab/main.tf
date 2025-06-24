resource "hcloud_firewall" "gitlab_http" {
  name = "fw-gitlab-http"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = [
        "103.21.244.0/22",
        "103.22.200.0/22",
        "103.31.4.0/22",
        "104.16.0.0/13",
        "104.24.0.0/14",
        "108.162.192.0/18",
        "131.0.72.0/22",
        "141.101.64.0/18",
        "162.158.0.0/15",
        "172.64.0.0/13",
        "173.245.48.0/20",
        "188.114.96.0/20",
        "190.93.240.0/20",
        "197.234.240.0/22",
        "198.41.128.0/17"
    ]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = [
        "103.21.244.0/22",
        "103.22.200.0/22",
        "103.31.4.0/22",
        "104.16.0.0/13",
        "104.24.0.0/14",
        "108.162.192.0/18",
        "131.0.72.0/22",
        "141.101.64.0/18",
        "162.158.0.0/15",
        "172.64.0.0/13",
        "173.245.48.0/20",
        "188.114.96.0/20",
        "190.93.240.0/20",
        "197.234.240.0/22",
        "198.41.128.0/17"
    ]
  }
}

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
  length  = 40
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
    var.hetzner_ssh_firewall_id,
    hcloud_firewall.gitlab_http.id
  ]
  keep_disk = false
  ssh_keys = [
    var.hetzner_ssh_key_id
  ]
  labels = {
    "service" : "gitlab"
  }
  delete_protection = false
  rebuild_protection = false
  shutdown_before_deletion = false
  user_data = templatefile("${path.module}/scripts/install_gitlab.sh", {
    EXTERNAL_URL         = var.gitlab_base_url
    GITLAB_ROOT_PASSWORD = random_password.gitlab_root.result
    GITLAB_CONFIG = templatefile("${path.module}/templates/gitlab.rb.template", {
      EXTERNAL_URL          = "${var.gitlab_base_url}"
      REGISTRY_EXTERNAL_URL = "${var.gitlab_registry_url}"
      GITLAB_ROOT_PASSWORD  = random_password.gitlab_root.result
    })
  })
}
