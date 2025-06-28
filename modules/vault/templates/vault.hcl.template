api_addr = "https://127.0.0.1:8200"

ui = true

max_lease_ttl     = "10h"
default_lease_ttl = "10h"

listener "tcp" {
        address       = "127.0.0.1:8200"
        tls_cert_file = "${VAULT_INSTALL_DIR}/tls/tls.crt"
        tls_key_file  = "${VAULT_INSTALL_DIR}/tls/tls.key"
}

storage "file" {
        path = "${VAULT_INSTALL_DIR}/data"
}