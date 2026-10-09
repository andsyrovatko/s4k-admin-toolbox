#!/usr/bin/env bash
# =============================================================================
# Script Name : docker-network-manager.sh
# Description : Manage Docker external networks with automatic subnet allocation,
#               auto-syncing, and subnet-based sorting.
# Usage       : ./docker-network-manager.sh <COMMAND> [ARGUMENTS]
#               Commands:
#                 create [NAME] - Create a specific network by name or all networks from file if NO NAME provided.
#                 delete [NAME] - Delete a specific network by name or all networks from file if NO NAME provided.
#                 info          - Show current status and configuration.
#               For details - see README.md
# Author      : syr4ok (Andrii Syrovatko)
# Version     : 1.3.0
# =============================================================================

# --- STRICT MODE ---
set -euo pipefail

# Configuration Loader
CONFIG_FILE="$(dirname "$0")/docker-network-manager.conf"
if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
else
    echo "[Error]: Configuration file not found. Create docker-network-manager.conf from example."
    exit 1
fi

touch "$NET_FILE"

log() {
  local level="$1"; shift
  printf '%s [%s] %s\n' "$(date -Is)" "$level" "$*" | tee -a "$LOG_FILE"
}

confirm_action() {
  [[ "${FORCE:-false}" == "true" ]] && return 0

  read -rp "Are you sure you want to delete ALL networks from $NET_FILE? (y/N): " response
  case "$response" in
    [yY][eE][sS]|[yY]) return 0 ;;
    *) log INFO "Operation cancelled by user"; exit 0 ;;
  esac
}

# Check if a Docker network exists
network_exists() {
  docker network ls --format '{{.Name}}' | grep -Fxq "$1"
}

# Extract subnet for a specific network
get_network_subnet() {
  local name="$1"
  docker network inspect "$name" --format '{{range .IPAM.Config}}{{.Subnet}}{{end}}' 2>/dev/null || echo "N/A"
}

# Sort networks by the 3rd octet of their IP subnet and rewrite NET_FILE
sort_and_rewrite_config() {
  [[ ! -s "$NET_FILE" ]] && return 0

  local temp_file
  temp_file=$(mktemp)

  # Read each network from NET_FILE, fetch its subnet, and format for sorting
  while read -u 3 -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    local subnet
    subnet=$(get_network_subnet "$line")
    
    # Extract 3rd octet if subnet matches BASE_NET pattern, otherwise assign high rank (999)
    local octet=999
    if [[ "$subnet" =~ ^${BASE_NET//./\\.}\.([0-9]+)\. ]]; then
      octet="${BASH_REMATCH[1]}"
    fi

    # Format: <3rd_octet> <network_name>
    printf "%03d %s\n" "$octet" "$line" >> "$temp_file"
  done 3< "$NET_FILE"

  # Sort numerically by 3rd octet and overwrite NET_FILE with sorted names
  sort -n "$temp_file" | awk '{print $2}' > "$NET_FILE"
  rm -f "$temp_file"
}

# Auto-discover active Docker bridge networks and add missing ones to NET_FILE
sync_networks() {
  local active_nets
  active_nets=$(docker network ls --filter "driver=bridge" --format '{{.Name}}' | grep -vE '^(bridge|host|none)$' || true)

  while read -r net; do
    [[ -z "$net" ]] && continue
    if ! grep -Fxq "$net" "$NET_FILE"; then
      echo "$net" >> "$NET_FILE"
      log INFO "Auto-synced: added missing network '$net' to $NET_FILE"
    fi
  done <<< "$active_nets"

  # Clean empty lines
  sed -i '/^$/d' "$NET_FILE"

  # Sort config file by subnet rank
  sort_and_rewrite_config
}

# Get list of all subnets currently in use
used_subnets() {
  local escaped_base="${BASE_NET//./\\.}"
  
  # Safely extract subnets via Docker Go template
  docker network ls -q | while read -r net_id; do
    docker network inspect "$net_id" --format '{{range .IPAM.Config}}{{.Subnet}}{{"\n"}}{{end}}' 2>/dev/null
  done | grep -E "^${escaped_base}\." || echo ""
}

# Find next available /24 subnet in configured range
next_free_subnet() {
  local used="$1"
  for i in $(seq "$START_OCTET" "$END_OCTET"); do
    local subnet="${BASE_NET}.${i}.0/24"
    if ! grep -q "$subnet" <<<"$used"; then
      echo "$subnet"
      return
    fi
  done
  log ERROR "no free /24 subnet found in ${BASE_NET}.x.x"
  exit 1
}

# Validate Linux bridge interface name length limit
name_length_check() {
  local name="$1"
  if [[ ${#name} -gt 15 ]]; then
      log WARN "Network name '$name' is too long for a Linux bridge (max 15 chars). It might be truncated."
      return 1
  fi
  return 0
}

# Provision a single Docker network
provision_single() {
  local name="$1"
  if ! name_length_check "$name"; then
    return 1
  fi
  if network_exists "$name"; then
    log INFO "network already exists name=$name"
    return
  fi

  local used
  local subnet
  used="$(used_subnets)"
  subnet="$(next_free_subnet "$used")"
  local gw="${subnet%0/24}1"

  log INFO "creating network name=$name subnet=$subnet gateway=$gw"
  docker network create --driver bridge --subnet "$subnet" --gateway "$gw" \
    --opt com.docker.network.bridge.name="$name" "$name" >/dev/null

  if ! grep -Fxq "$name" "$NET_FILE"; then
    echo "$name" >> "$NET_FILE"
    log INFO "network name=$name added to $NET_FILE"
    sed -i '/^$/d' "$NET_FILE"
  fi

  sort_and_rewrite_config
}

# Provision all networks listed in NET_FILE
provision_from_file() {
  [[ ! -s "$NET_FILE" ]] && { log WARN "NET_FILE is empty"; return; }
  log INFO "starting mass provisioning from $NET_FILE"
  while read -u 3 -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    provision_single "$line" || true
  done 3< "$NET_FILE"
}

# Delete a single Docker network
delete_network() {
  local name="$1"
  if network_exists "$name"; then
    log INFO "deleting network name=$name"
    docker network rm "$name" >/dev/null
    log INFO "network name=$name deleted from docker"
  else
    log WARN "network not found in docker name=$name — cleanup config anyway"
  fi

  # Remove from NET_FILE if exists
  if grep -Fxq "$name" "$NET_FILE"; then
    sed -i "/^$name$/d" "$NET_FILE"
    log INFO "network name=$name removed from $NET_FILE"
  else
    log INFO "network name=$name not found in $NET_FILE, no cleanup needed"
  fi
}

# Delete all networks listed in NET_FILE
delete_all_from_file() {
  log INFO "deleting all networks listed in $NET_FILE"
  while read -u 3 -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    delete_network "$line"
  done 3< "$NET_FILE"
}

# Show status and information
show_info() {
  # Sync and sort networks before display
  sync_networks

  local tracked_count
  tracked_count=$(grep -cE '^\s*[^#]' "$NET_FILE" || true)

  echo "--- Docker Network Manager v1.3.0 ---"
  echo "Configured Base : ${BASE_NET}.0.0/16 (Range: .${START_OCTET}.x to .${END_OCTET}.x)"
  echo "Config File     : $(basename "$NET_FILE")"
  echo "Log File        : $(basename "$LOG_FILE")"
  echo "Tracked Networks: $tracked_count"

  echo -e "\n[Current Status]"
  if [[ "$tracked_count" -gt 0 ]]; then
    printf "%-20s %-18s %-10s\n" "NETWORK NAME" "IP RANGE" "STATUS"
    echo "--------------------------------------------------------"
    while read -u 3 -r line; do
      [[ -z "$line" || "$line" =~ ^# ]] && continue

      local status="OFFLINE"
      local subnet="N/A"

      if network_exists "$line"; then
        status="ONLINE"
        subnet=$(get_network_subnet "$line")
      fi
      printf "%-20s %-18s %-10s\n" "$line" "$subnet" "$status"
    done 3< "$NET_FILE"
  else
    echo "No networks tracked in $NET_FILE"
  fi

  echo -e "\n[Usage]"
  echo "  $0 create (c) [name]  - Create single network and add to file"
  echo "  $0 create (c)         - Create all networks from file"
  echo "  $0 delete (d) [name]  - Remove network and clean file"
  echo "  $0 delete (d)         - Remove all networks from file"
  echo "  $0 sync (s)           - Sync active Docker networks with config file"
}

case "${1:-info}" in
  [Cc][Rr][Ee][Aa][Tt][Ee]|[Cc])
    if [[ ${2:-} ]]; then
      provision_single "$2"
    else
      provision_from_file
    fi
    ;;
  [Dd][Ee][Ll][Ee][Tt][Ee]|[Dd])
    if [[ ${2:-} ]]; then
      delete_network "$2"
    else
      count=$( (grep -vE '^\s*(#|$)' "$NET_FILE" || true) | wc -l | xargs)

      if (( count == 0 )); then
        log INFO "Nothing to delete. $NET_FILE is empty or contains only comments."
        exit 0
      fi

      confirm_action
      delete_all_from_file
    fi
    ;;
  [Ss][Yy][Nn][Cc]|[Ss])
    sync_networks
    log INFO "Synchronization and sorting complete."
    ;;
  [Ii][Nn][Ff][Oo]|[Ii])
    show_info
    ;;
  *)
    log ERROR "Unknown command: $1"
    show_info
    exit 1
    ;;
esac

exit 0
