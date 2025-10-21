#!/usr/bin/env bash

# Usage: url_checker.sh [urls_file]
infile=${1:-urls.txt}

if [[ ! -f "$infile" ]]; then
  echo "URLs file not found: $infile" >&2
  exit 2
fi

while IFS= read -r url; do
  # skip empty lines and lines starting with #
  [[ -z "$url" || "$url" =~ ^# ]] && continue
  code=$(curl -o /dev/null -s -w "%{http_code}" "$url")
  if [[ "$code" == "200" ]]; then
    echo "$url"
  fi
done < "$infile"

#chmod +x url_checker.sh && ./url_checker.sh urls.txt