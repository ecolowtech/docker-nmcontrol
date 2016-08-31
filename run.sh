#!/bin/bash
#
# Docker container entrypoint
#

set -eo pipefail

# -- Namecoin configuration --
echo "rpcuser=${RPC_USER}
rpcpassword=${RPC_PASS}
rpcport=${RPC_PORT}
rpcconnect=${RPC_CONNECT}" > /data/namecoin/namecoin.conf

# -- NMControl DNS configuration --
echo "[dns]
; Launch at startup
start=1

; Listen on ip
host=${NM_DNS_HOST}

; Disable lookups for standard domains
disable_standard_lookups=${NM_DNS_DISABLE_STD_LOOKUPS}

; Listen on port
port=${NM_DNS_PORT}

; Forward standard requests to
resolver=${NM_DNS_RESOLVER}" > /etc/nmcontrol/conf/service-dns.conf

# -- NMControl HTTP configuration --
echo "[http]
; Launch at startup
start=1

; Listen on ip - choices: <ip>
host=${NM_HTTP_HOST}

; Listen on port - choices: <port>
port=${NM_HTTP_PORT}" > /etc/nmcontrol/conf/plugin-http.conf

# -- NMControl RPC configuration --
echo "[rpc]
; Launch at startup
start=1

; Listen on ip - choices: <ip>
host=${NM_RPC_HOST}

; Listen on port - choices: <port>
port=${NM_RPC_PORT}" > /etc/nmcontrol/conf/plugin-rpc.conf

exec "$@"
