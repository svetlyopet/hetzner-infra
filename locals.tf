locals {
  # Taken from https://www.cloudflare.com/en-gb/ips/
  http_allowed_ips = [
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
    
    # TTL must be set to 1 when DNS records are proxied in Cloudflare
    cloudflare_dns_records_ttl = 1
    cloudflare_dns_proxied     = true

    # FQDN of the services
    gitlab_fqdn          = "${var.subdomain_gitlab}.${var.base_domain}"
    gitlab_registry_fqdn = "${var.subdomain_gitlab_registry}.${var.base_domain}"
    authentik_fqdn       = "${var.subdomain_authentik}.${var.base_domain}"
    vault_fqdn           = "${var.subdomain_vault}.${var.base_domain}"
}