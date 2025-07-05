gitlab_rails['initial_root_password'] = "${GITLAB_ROOT_PASSWORD}"

letsencrypt['enable'] = false

external_url '${EXTERNAL_URL}'

nginx['ssl_certificate'] = "/etc/ssl/nginx/tls.crt"
nginx['ssl_certificate_key'] = "/etc/ssl/nginx/tls.key"
nginx['ssl_protocols'] = "TLSv1.2 TLSv1.3"
nginx['ssl_ciphers'] = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
nginx['ssl_prefer_server_ciphers'] = "on"
nginx['ssl_session_cache'] = "shared:SSL:10m"

nginx['real_ip_trusted_addresses'] = [
%{ for IP_ADDR in IP_ADDRS ~}
    '${IP_ADDR}',
%{ endfor ~}  
]
nginx['real_ip_header'] = 'X-Forwarded-For'
nginx['real_ip_recursive'] = 'on'

nginx['listen_https'] = true
nginx['listen_port'] = 443
nginx['redirect_http_to_https'] = false

nginx['proxy_set_headers'] = {
  "X-Forwarded-Proto" => "https",
  "X-Forwarded-Ssl" => "on"
}

gitlab_rails['registry_enabled'] = true

registry_external_url '${REGISTRY_EXTERNAL_URL}'

registry_nginx['ssl_certificate'] = "/etc/ssl/nginx/tls.crt"
registry_nginx['ssl_certificate_key'] = "/etc/ssl/nginx/tls.key"
registry_nginx['ssl_protocols'] = "TLSv1.2 TLSv1.3"
registry_nginx['ssl_ciphers'] = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
registry_nginx['ssl_prefer_server_ciphers'] = "on"
registry_nginx['ssl_session_cache'] = "shared:SSL:10m"

registry_nginx['enable'] = true
registry_nginx['real_ip_trusted_addresses'] = [
%{ for INDEX, IP_ADDR in IP_ADDRS ~}
    '${IP_ADDR}',
%{ endfor ~}
]
registry_nginx['real_ip_header'] = 'X-Forwarded-For'
registry_nginx['real_ip_recursive'] = 'on'

registry_nginx['listen_https'] = true
registry_nginx['listen_port'] = 443
registry_nginx['redirect_http_to_https'] = false

registry_nginx['proxy_set_headers'] = {
  "Host" => "$$http_host",
  "X-Real-IP" => "$$remote_addr",
  "X-Forwarded-For" => "$$proxy_add_x_forwarded_for",
  "X-Forwarded-Proto" => "https",
  "X-Forwarded-Ssl" => "on"
}

# Optimize Gitlab for memory constrained environments
# https://docs.gitlab.com/omnibus/settings/memory_constrained_envs/
puma['worker_processes'] = 0

sidekiq['concurrency'] = 5

prometheus_monitoring['enable'] = false

gitaly['configuration'] = {
    concurrency: [
      {
        'rpc' => "/gitaly.SmartHTTPService/PostReceivePack",
        'max_per_repo' => 3,
      }, {
        'rpc' => "/gitaly.SSHService/SSHUploadPack",
        'max_per_repo' => 3,
      },
    ],
    cgroups: {
        repositories: {
            count: 2,
        },
        mountpoint: '/sys/fs/cgroup',
        hierarchy_root: 'gitaly',
        memory_bytes: 500000,
        cpu_shares: 512,
    },
}
gitaly['env'] = {
  'GITALY_COMMAND_SPAWN_MAX_PARALLEL' => '2'
}
gitaly['env'] = {
  'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000'
}

gitlab_rails['env'] = {
  'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000'
}