#!/usr/bin/env bash
set -euo pipefail

if [ -z "${BASH_VERSION:-}" ]; then
  printf 'ERROR: run this script with bash, not sh. Use: bash ./apply-certs.sh [--dry-run]\n' >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

DRY_RUN=0
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
  esac
done

log() { printf '===> %s\n' "$*" >&2; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

prompt() {
  local label="$1"
  local default_value="${2:-}"
  local reply=""
  if [ -t 0 ] && [ -r /dev/tty ]; then
    if [ -n "$default_value" ]; then
      printf '%s [%s]: ' "$label" "$default_value" >&2
    else
      printf '%s: ' "$label" >&2
    fi
    read -r reply </dev/tty
  fi
  if [ -z "$reply" ]; then
    reply="$default_value"
  fi
  printf '%s' "$reply"
}

load_dotenv() {
  local file="$1"
  [ -f "$file" ] || return 0
  local line key value
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|'#'*) continue ;;
      export\ *) line="${line#export }" ;;
    esac
    case "$line" in
      *=*)
        key="${line%%=*}"
        value="${line#*=}"
        [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || continue
        if [[ "$value" == \"*\" && "$value" == *\" ]]; then
          value="${value:1:${#value}-2}"
        elif [[ "$value" == \'*\' && "$value" == *\' ]]; then
          value="${value:1:${#value}-2}"
        fi
        printf -v "$key" '%s' "$value"
        export "$key"
        ;;
    esac
  done < "$file"
}

load_dotenv .env

BASE_DOMAIN="${BASE_DOMAIN:-}"
NPM_ADMIN_EMAIL="${NPM_ADMIN_EMAIL:-}"
NPM_ADMIN_PASS="${NPM_ADMIN_PASS:-}"
TLS_MODE="${TLS_MODE:-}"
NPM_LOCAL_CERT_FILE="${NPM_LOCAL_CERT_FILE:-volumes/api/server.crt}"
NPM_LOCAL_KEY_FILE="${NPM_LOCAL_KEY_FILE:-volumes/api/server.key}"
NPM_CUSTOM_CERT_NAME="${NPM_CUSTOM_CERT_NAME:-daiana-custom-tls}"
NPM_CUSTOM_CERT_FILE="${NPM_CUSTOM_CERT_FILE:-}"
NPM_CUSTOM_KEY_FILE="${NPM_CUSTOM_KEY_FILE:-}"

BASE_DOMAIN="${BASE_DOMAIN:-$(prompt 'BASE_DOMAIN' '')}"
[ -n "$BASE_DOMAIN" ] || die "BASE_DOMAIN is required"
NPM_ADMIN_EMAIL="${NPM_ADMIN_EMAIL:-$(prompt 'NPM_ADMIN_EMAIL' 'admin@example.com')}"
[ -n "$NPM_ADMIN_EMAIL" ] || die "NPM_ADMIN_EMAIL is required"
NPM_ADMIN_PASS="${NPM_ADMIN_PASS:-$(prompt 'NPM_ADMIN_PASS' '')}"
[ -n "$NPM_ADMIN_PASS" ] || die "NPM_ADMIN_PASS is required"

if [ -z "$TLS_MODE" ]; then
  echo "Select certificate mode:" >&2
  echo "  1) Let's Encrypt" >&2
  echo "  2) Self-signed / local certs" >&2
  echo "  3) Custom cert files" >&2
  choice="$(prompt 'Choose [1/3]' '1')"
  case "$choice" in
    2) TLS_MODE=local ;;
    3) TLS_MODE=custom ;;
    *) TLS_MODE=letsencrypt ;;
  esac
fi

if [ "$TLS_MODE" = "local" ]; then
  NPM_LOCAL_CERT_FILE="${NPM_LOCAL_CERT_FILE:-$(prompt 'NPM_LOCAL_CERT_FILE' 'volumes/api/server.crt')}"
  NPM_LOCAL_KEY_FILE="${NPM_LOCAL_KEY_FILE:-$(prompt 'NPM_LOCAL_KEY_FILE' 'volumes/api/server.key')}"
elif [ "$TLS_MODE" = "custom" ]; then
  NPM_CUSTOM_CERT_FILE="${NPM_CUSTOM_CERT_FILE:-$(prompt 'NPM_CUSTOM_CERT_FILE' '')}"
  NPM_CUSTOM_KEY_FILE="${NPM_CUSTOM_KEY_FILE:-$(prompt 'NPM_CUSTOM_KEY_FILE' '')}"
  NPM_CUSTOM_CERT_NAME="${NPM_CUSTOM_CERT_NAME:-$(prompt 'NPM_CUSTOM_CERT_NAME' 'daiana-custom-tls')}"
fi

if [ "$DRY_RUN" = "1" ]; then
  cat <<EOF
DRY RUN ONLY
Would:
- use BASE_DOMAIN=$BASE_DOMAIN
- use certificate mode: $TLS_MODE
- apply certificates to existing NPM proxy hosts only
EOF
  exit 0
fi

if [ "$TLS_MODE" = "local" ]; then
  [ -f "$NPM_LOCAL_CERT_FILE" ] || die "Certificate file not found: $NPM_LOCAL_CERT_FILE"
  [ -f "$NPM_LOCAL_KEY_FILE" ] || die "Key file not found: $NPM_LOCAL_KEY_FILE"
  log "Applying local self-signed certificates in NPM"
elif [ "$TLS_MODE" = "custom" ]; then
  [ -f "$NPM_CUSTOM_CERT_FILE" ] || die "Certificate file not found: $NPM_CUSTOM_CERT_FILE"
  [ -f "$NPM_CUSTOM_KEY_FILE" ] || die "Key file not found: $NPM_CUSTOM_KEY_FILE"
  log "Applying user-provided certificates in NPM"
else
  log "Applying Let's Encrypt certificates in NPM"
fi

BASE_DOMAIN="$BASE_DOMAIN" NPM_ADMIN_EMAIL="$NPM_ADMIN_EMAIL" NPM_ADMIN_PASS="$NPM_ADMIN_PASS" \
TLS_MODE="$TLS_MODE" ENSURE_PROXY_HOSTS=0 NPM_LOCAL_CERT_FILE="$NPM_LOCAL_CERT_FILE" NPM_LOCAL_KEY_FILE="$NPM_LOCAL_KEY_FILE" \
NPM_CUSTOM_CERT_NAME="$NPM_CUSTOM_CERT_NAME" NPM_CUSTOM_CERT_FILE="$NPM_CUSTOM_CERT_FILE" NPM_CUSTOM_KEY_FILE="$NPM_CUSTOM_KEY_FILE" \
  bash utils/npm_ssl_bootstrap.sh
