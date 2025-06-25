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