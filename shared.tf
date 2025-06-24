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