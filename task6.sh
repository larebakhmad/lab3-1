hashit() {
  algo=${1:-sha256}
  shift
  if [ -z "$algo" ]; then
    echo "Usage: hashit <algo> <string_or_file> or pipe data"
    return 1
  fi
  if [ ! -t 0 ]; then
    # piped data
    python3 - "$algo" <<'PY'
PY
    return
  fi
  for t in "$@"; do
    if [ -f "$t" ]; then
      python3 - "$algo" "$t" <<'PY'
PY
    else
      python3 - "$algo" "$t" <<'PY'
PY
    fi
  done
}

#which hashit || command -v hashit || echo 'HASHIT_NOT_FOUND'

#sha256sum /etc/hosts || openssl dgst -sha256 /etc/hosts

#python3 -c "import hashlib; print(hashlib.sha256(open('/etc/hosts','rb').read()).hexdigest())"