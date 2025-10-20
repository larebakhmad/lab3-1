#!/usr/bin/env bash
# whoami.sh - print user, current directory, and date

set -euo pipefail

# Get the username. Prefer $USER, fallback to whoami.
USERNAME="${USER:-$(whoami)}"

# Current directory (absolute)
CURRENT_DIR="$(pwd -P)"

# Current date in ISO-like readable format
CURRENT_DATE="$(date '+%Y-%m-%d %H:%M:%S %z')"

printf 'User: %s\n' "$USERNAME"
printf 'Current dir: %s\n' "$CURRENT_DIR"
printf 'Date: %s\n' "$CURRENT_DATE"
