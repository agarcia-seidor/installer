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

resolve_domain_for_prefix() {
  local prefix="$1"
  if [[ "$BASE_DOMAIN" == "${prefix}."* ]]; then
    printf '%s' "$BASE_DOMAIN"
  else
    printf '%s.%s' "$prefix" "$BASE_DOMAIN"
  fi
}

sanitize_tls_suffix() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9._-' '-'
}

local_cert_paths_for_prefix() {
  local prefix="$1"
  local cert_path key_path cert_dir key_dir cert_base key_base cert_ext key_ext suffix
  suffix="$(sanitize_tls_suffix "$prefix")"
  cert_path="${NPM_LOCAL_CERT_FILE/#~/$HOME}"
  key_path="${NPM_LOCAL_KEY_FILE/#~/$HOME}"
  cert_dir="$(dirname "$cert_path")"
  key_dir="$(dirname "$key_path")"
  cert_base="$(basename "$cert_path")"
  key_base="$(basename "$key_path")"
  cert_ext=""
  key_ext=""
  case "$cert_base" in
    *.*) cert_ext=".${cert_base##*.}"; cert_base="${cert_base%.*}" ;;
  esac
  case "$key_base" in
    *.*) key_ext=".${key_base##*.}"; key_base="${key_base%.*}" ;;
  esac
  printf '%s\n%s\n' "${cert_dir}/${cert_base}-${suffix}${cert_ext}" "${key_dir}/${key_base}-${suffix}${key_ext}"
}

ensure_local_certificate_files() {
  local domain="$1"
  local cert_path="${NPM_LOCAL_CERT_FILE/#~/$HOME}"
  local key_path="${NPM_LOCAL_KEY_FILE/#~/$HOME}"

  if [ -f "$cert_path" ] && [ -f "$key_path" ]; then
    return 0
  fi

  command -v openssl >/dev/null 2>&1 || die "openssl is required to generate local certificates"
  log "Generating local self-signed certificate for $domain"
  mkdir -p "$(dirname "$cert_path")"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$key_path" \
    -out "$cert_path" \
    -subj "/CN=$domain" >/dev/null 2>&1
  chmod 640 "$key_path"
  chgrp 65533 "$key_path" 2>/dev/null || true
}

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
        declare -gx "$key"
        ;;
    esac
  done < "$file"
}

load_dotenv .env

persist_env_value() {
  local key="$1"
  local value="$2"
  local tmp
  tmp="$(mktemp)"
  awk -v key="$key" -v value="$value" '
    BEGIN { done = 0 }
    $0 ~ "^[[:space:]]*#?[[:space:]]*" key "=" { print key "=" value; done = 1; next }
    { print }
    END { if (done == 0) print key "=" value }
  ' .env > "$tmp"
  mv "$tmp" .env
}

refresh_public_urls_in_env() {
  local public_scheme="https"
  case "$BASE_DOMAIN" in
    *.nip.io) public_scheme="http" ;;
  esac

  persist_env_value STUDIO_BASE_URL "${public_scheme}://studio.${BASE_DOMAIN}"
  persist_env_value SUPABASE_PUBLIC_URL "${public_scheme}://supa.${BASE_DOMAIN}"
  persist_env_value API_EXTERNAL_URL "${public_scheme}://supa.${BASE_DOMAIN}/auth/v1"
  persist_env_value SITE_URL "${public_scheme}://daiana.${BASE_DOMAIN}"
  persist_env_value WEBUI_BASE_URL "${public_scheme}://webui.${BASE_DOMAIN}"
  persist_env_value BACKEND_BASE_URL "${public_scheme}://api.${BASE_DOMAIN}"
  persist_env_value WS_BASE_URL "${public_scheme}://whatsapp.${BASE_DOMAIN}"
  persist_env_value MS_BASE_URL "${public_scheme}://msteams.${BASE_DOMAIN}"
  persist_env_value VANNA_BASE_URL "${public_scheme}://vanna.${BASE_DOMAIN}"
  persist_env_value QDRANT_BASE_URL "${public_scheme}://qdrant.${BASE_DOMAIN}"
  persist_env_value CORS_ALLOW_ORIGIN "${public_scheme}://daiana.${BASE_DOMAIN}"
  persist_env_value NEXT_PUBLIC_APP_URL "${public_scheme}://daiana.${BASE_DOMAIN}"
}

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
- refresh persisted public URLs in .env for non-nip.io domains
- refresh Portainer stacks after the env update
EOF
  exit 0
fi

if [ "$TLS_MODE" = "local" ]; then
  if [ -n "${ONLY_PREFIX:-}" ]; then
    mapfile -t cert_paths < <(local_cert_paths_for_prefix "$ONLY_PREFIX")
    NPM_LOCAL_CERT_FILE="${cert_paths[0]}"
    NPM_LOCAL_KEY_FILE="${cert_paths[1]}"
    ensure_local_certificate_files "$(resolve_domain_for_prefix "$ONLY_PREFIX")"
  else
    ensure_local_certificate_files "$BASE_DOMAIN"
  fi
  log "Applying local self-signed certificates in NPM"
elif [ "$TLS_MODE" = "custom" ]; then
  [ -f "$NPM_CUSTOM_CERT_FILE" ] || die "Certificate file not found: $NPM_CUSTOM_CERT_FILE"
  [ -f "$NPM_CUSTOM_KEY_FILE" ] || die "Key file not found: $NPM_CUSTOM_KEY_FILE"
  log "Applying user-provided certificates in NPM"
else
  log "Applying Let's Encrypt certificates in NPM"
fi

BASE_DOMAIN="$BASE_DOMAIN" NPM_ADMIN_EMAIL="$NPM_ADMIN_EMAIL" NPM_ADMIN_PASS="$NPM_ADMIN_PASS" \
TLS_MODE="$TLS_MODE" ENSURE_PROXY_HOSTS=0 ONLY_PREFIX="${ONLY_PREFIX:-}" NPM_LOCAL_CERT_FILE="$NPM_LOCAL_CERT_FILE" NPM_LOCAL_KEY_FILE="$NPM_LOCAL_KEY_FILE" \
NPM_CUSTOM_CERT_NAME="$NPM_CUSTOM_CERT_NAME" NPM_CUSTOM_CERT_FILE="$NPM_CUSTOM_CERT_FILE" NPM_CUSTOM_KEY_FILE="$NPM_CUSTOM_KEY_FILE" \
  bash utils/npm_ssl_bootstrap.sh

if [[ "$BASE_DOMAIN" != *.nip.io ]]; then
  log "Refreshing persisted public URLs in .env to https"
  refresh_public_urls_in_env
  log "Refreshing Portainer stacks after certificate update"
  bash update-daiana.sh --update
fi
