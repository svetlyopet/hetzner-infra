data "cloudflare_zone" "zone_data" {
    filter = {
        name = var.base_domain
    }
}

resource "cloudflare_dns_record" "auth" {
    zone_id = data.cloudflare_zone.zone_data.zone_id
    name = local.authentik_fqdn
    type = "A"
    content = module.authentik.authentik_primary_ip
    proxied = local.cloudflare_dns_proxied
    ttl = local.cloudflare_dns_records_ttl

    depends_on = [
        module.authentik.authentik_primary_ip
    ]
}

resource "cloudflare_dns_record" "vault" {
    zone_id = data.cloudflare_zone.zone_data.zone_id
    name = local.vault_fqdn
    type = "A"
    content = module.vault.vault_primary_ip
    proxied = local.cloudflare_dns_proxied
    ttl = local.cloudflare_dns_records_ttl

    depends_on = [
        module.vault.vault_primary_ip
    ]
}

resource "cloudflare_dns_record" "gitlab" {
    zone_id = data.cloudflare_zone.zone_data.zone_id
    name = local.gitlab_fqdn
    type = "A"
    content = module.gitlab.gitlab_primary_ip
    proxied = local.cloudflare_dns_proxied
    ttl = local.cloudflare_dns_records_ttl

    depends_on = [
        module.gitlab.gitlab_primary_ip
    ]
}

resource "cloudflare_dns_record" "gitlab_registry" {
    zone_id = data.cloudflare_zone.zone_data.zone_id
    name = local.gitlab_registry_fqdn
    type = "A"
    content = module.gitlab.gitlab_primary_ip
    proxied = local.cloudflare_dns_proxied
    ttl = local.cloudflare_dns_records_ttl

    depends_on = [
        module.gitlab.gitlab_primary_ip
    ]
}