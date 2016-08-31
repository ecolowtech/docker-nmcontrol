#!/bin/bash
#
# Docker container entrypoint
#

set -eo pipefail

# -- DNS Resolver 1 variable --
if [ -n "${NM_DNS_RESOLVER1}" ]; then
  lastchar=$(echo -n ${NM_DNS_RESOLVER1} | tail -c 1)
 [ $lastchar != "," ] && NM_DNS_RESOLVER1="${NM_DNS_RESOLVER1},"
fi

# -- DNS Resolver 2 variable --
if [ -n "${NM_DNS_RESOLVER2}" ]; then
  lastchar=$(echo -n ${NM_DNS_RESOLVER2} | tail -c 1)
 [ $lastchar != "," ] && NM_DNS_RESOLVER2="${NM_DNS_RESOLVER2},"
fi

# -- Namecoin configuration --
echo "rpcuser=${RPC_USER}
rpcpassword=${RPC_PASS}
rpcport=${RPC_PORT}
rpcconnect=${RPC_CONNECT}" > ${NMC_DATA_DIR}/namecoin.conf

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
resolver=${NM_DNS_RESOLVER1} ${NM_DNS_RESOLVER2}" > ${NM_CONF_DIR}/service-dns.conf

# -- NMControl HTTP configuration --
echo "[http]
; Launch at startup
start=1

; Listen on ip - choices: <ip>
host=${NM_HTTP_HOST}

; Listen on port - choices: <port>
port=${NM_HTTP_PORT}" > ${NM_CONF_DIR}/plugin-http.conf

# -- NMControl RPC configuration --
echo "[rpc]
; Launch at startup
start=1

; Listen on ip - choices: <ip>
host=${NM_RPC_HOST}

; Listen on port - choices: <port>
port=${NM_RPC_PORT}" > ${NM_CONF_DIR}/plugin-rpc.conf

# -- NMControl data configuration --
echo "[data]
; Launch at startup
start=1

; Path of namecoin.conf
update.namecoin=${NMC_DATA_DIR}/namecoin.conf

; Path of namecoin.conf
import.namecoin=${NMC_DATA_DIR}/namecoin.conf" > ${NM_CONF_DIR}/plugin-data.conf

exec "$@"
