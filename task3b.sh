#!/usr/bin/env bash

# check_ips <file>
# Extract IPv4 addresses from <file>, ping each, print live ones and save to alive_hosts.txt

check_ips() {
  local file="$1"
  local out_file="alive_hosts.txt"

  if [[ -z "$file" || ! -f "$file" ]]; then
    echo "Usage: check_ips <file_with_ips>"
    return 2
  fi

  # empty output file
  : > "$out_file"

  # extract IPv4 addresses (simple regex), uniq them
    ips=$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$file" | sort -u)

  if [[ -z "$ips" ]]; then
    echo "No IPv4 addresses found in $file"
    return 0
  fi

  echo "Testing $(echo "$ips" | wc -l) addresses..."

  while IFS= read -r ip; do
    # basic sanity check to avoid pinging invalid octets >255
    if ! [[ "$ip" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
      continue
    fi
    valid=true
    for i in 1 2 3 4; do
      octet=$(echo "$ip" | cut -d. -f$i)
      if (( octet < 0 || octet > 255 )); then
        valid=false
        break
      fi
    done
    $valid || continue

    if ping -c1 -W1 "$ip" &>/dev/null; then
      echo "$ip"
      echo "$ip" >> "$out_file"
    fi
  done <<< "$ips"

  echo "Live hosts (saved to $out_file):"
  cat "$out_file"
}

# If script executed directly, accept a filename arg
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  check_ips "$1"
fi
