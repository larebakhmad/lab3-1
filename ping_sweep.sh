#!/usr/bin/env bash



ping_sweep() {
  local subnet_prefix="${1:-172.17.0}"
  local start=${2:-1}
  local end=${3:-10}

  # basic validation: ensure prefix looks like X.Y.Z (three dot-separated fields)
  if ! [[ "$subnet_prefix" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Usage: $0 <subnet_prefix> [start] [end]"
    echo "Example: $0 10.0.0 1 254"
    return 2
  fi

  for i in $(seq "$start" "$end"); do
    ip="$subnet_prefix.$i"
    (ping -c1 -W1 "$ip" &>/dev/null && echo "[+] $ip alive") &
  done
  wait
}


# If this script is sourced, don't auto-run. If executed, call the function.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # call with positional args: subnet_prefix [start] [end]
  ping_sweep "$1" "$2" "$3"
fi