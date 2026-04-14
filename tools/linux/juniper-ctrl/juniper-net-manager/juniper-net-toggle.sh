#!/usr/bin/env bash
# =============================================================================
# Script Name : juniper-net-toggle.sh
# Description : Activate/Deactivate Juniper network interfaces or static routes via SSH.
# Usage:      : ./juniper-net-toggle.sh <HOSTNAME/HOST-IP> <NETWORK/CIDR> <ACTIONS>
#               For details - see README.md
# Author      : syr4ok (Andrii Syrovatko)
# Version     : 1.0.0b
# =============================================================================

# --- STRICT MODE ---
set -uo pipefail
IFS=$'\n\t'
if [[ $# -lt 3 ]]; then
	{
		echo "[ERROR]: Not enough arguments!"
    	echo "Usage: $0 <HOSTNAME/HOST-IP> <NETWORK/CIDR> <ACTIONS>"
    	echo "Actions: OFF (deactivate), ON (activate)"
	}
    exit 1
fi

# Configuration Loader
CONFIG_FILE="$(dirname "$0")/juniper-net-toggle.conf"

if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
else
    echo "[Error]: Configuration file not found. Create ip_manager.conf from example."
    exit 1
fi

# Received variables
JUNIPER_HOST="$1"
NET_TO_DISABLE="$2"
ACT="$3"

# Environment & Tools
SSH_BIN=$(which ssh 2>/dev/null || true)
IPCALC_BIN=$(command -v ipcalc)

if [[ -z "$IPCALC_BIN" ]]; then
    echo "[Error]: 'ipcalc' is not installed. Run: sudo apt install ipcalc"
    exit 1
fi

# Logic for Dynamic Masks
# Extract CIDR mask (e.g., from 192.168.1.0/24 it gets 24)
MASK=$(echo "$NET_TO_DISABLE" | cut -d'/' -f2)
# If no mask provided, default to 32
if [[ "$NET_TO_DISABLE" == "$MASK" ]]; then
    MASK=32
fi

# Clear network for static routes
NET_ONLY=$(echo "$NET_TO_DISABLE" | cut -d'/' -f1)

# Get the network/gateway address
# For /32 it's just the IP, for others it's the HostMin
if [[ "$MASK" -eq 32 ]]; then
    net_to_gw_cvrt=$(echo "$NET_TO_DISABLE" | cut -d'/' -f1)
else
    net_to_gw_cvrt=$($IPCALC_BIN -b "$NET_TO_DISABLE" | grep HostMin | awk '{print $NF}')
fi

echo "[INFO]: Searching for $NET_ONLY (interface or route) on ${JUNIPER_HOST}..."

# Get config line via SSH
config_line=$($SSH_BIN -o ConnectTimeout=5 ${JUNIPER_USER}@${JUNIPER_HOST} "show configuration | display set | match \"address ${net_to_gw_cvrt}/${MASK}\"" | head -n1)
if [ -z "$config_line" ]; then
	# If static route
    config_line=$($SSH_BIN -o ConnectTimeout=5 "${JUNIPER_USER}@${JUNIPER_HOST}" \
    "show configuration | display set | match \"route $NET_ONLY/${MASK}\"" | head -n1)
fi

if [ -z "$config_line" ]; then
    echo "[Error]: Address for network ${NET_TO_DISABLE} not found on Juniper."
    exit 1
fi

# Prepare commands
deactivate_cmd="${config_line/set/deactivate}"
activate_cmd="${config_line/set/activate}"

case "${ACT^^}" in # Convert to uppercase for robustness
    "DELETE"|"REJECT"|"RESTRICT"|"OFF")
        echo "[INFO]: Deactivating network (${NET_TO_DISABLE})..."
        COMMAND="$deactivate_cmd"
        MSG="Address ${NET_TO_DISABLE} deactivated!"
        ;;
    "NEW"|"RESUME"|"ON")
        echo "[INFO]: Activating network (${NET_TO_DISABLE})..."
        COMMAND="$activate_cmd"
        MSG="Address ${NET_TO_DISABLE} activated!"
        ;;
    *)
        echo "[!] Unsupported or unknown ACT value (${ACT})"
        exit 1
        ;;
esac

echo "$COMMAND" # DEBUG

# Execute on Juniper
 ssh -tt ${JUNIPER_USER}@${JUNIPER_HOST} << EOF
configure
$COMMAND
commit
exit
exit
EOF

echo "[SUCCESS] $MSG"

exit 0
