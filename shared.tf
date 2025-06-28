resource "hcloud_ssh_key" "shared_ssh_key" {
  name       = "ssh-admin"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_firewall" "shared_firewall_ssh" {
  name = "fw-ssh"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "${var.ssh_allowed_ip}/32"
    ]
  }
}

resource "hcloud_firewall" "shared_firewall_http" {
  name = "fw-http"
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

resource "hcloud_network" "shared_network" {
  name     = "shared-network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "shared_network" {
  network_id   = hcloud_network.shared_network.id
  type         = "cloud"
  network_zone = var.hetzner_network_zone
  ip_range     = "10.0.1.0/24"
}