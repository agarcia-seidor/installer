#!/usr/bin/env bash
set -euo pipefail

if [ -z "${BASH_VERSION:-}" ]; then
  printf 'ERROR: run this uninstaller with bash, not sh. Use: bash ./uninstall-daiana.sh [-y]\n' >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

auto_confirm=0
purge_env=0
for arg in "$@"; do
  case "$arg" in
    -y|--yes) auto_confirm=1 ;;
    -p|--purge|--purge-env) purge_env=1 ;;
  esac
done

log() { printf '===> %s\n' "$*"; }
confirm() {
  if [ "$auto_confirm" = "1" ]; then
    return 0
  fi
  printf 'Are you sure you want to uninstall Daiana and reset the project? (y/N) '
  read -r reply
  case "$reply" in
    [Yy]*) return 0 ;;
    *) echo 'Canceled.'; exit 1 ;;
  esac
}

confirm

echo ""
if [ "$purge_env" = "1" ]; then
  echo "*** WARNING: This will remove Daiana/Portainer runtime data, stop related containers, and delete .env + .env.old ***"
else
  echo "*** WARNING: This will remove Daiana/Portainer runtime data, stop related containers, and remove only .env (keeps .env.old) ***"
fi
echo ""
confirm

if [ "$purge_env" = "1" ]; then
  if [ -f "reset.sh" ]; then
    log "Running project reset (Supabase baseline)"
    sh reset.sh -y --purge-env
  else
    log "reset.sh not found; skipping baseline reset"
  fi
fi

log "Stopping Portainer bootstrap stack if present"
if command -v docker >/dev/null 2>&1; then
  docker compose -f docker-compose.portainer.yml down -v --remove-orphans >/dev/null 2>&1 || true
fi

log "Removing running Daiana/Portainer/Supabase containers if any remain"
if command -v docker >/dev/null 2>&1; then
  ids="$(docker ps -aq --filter name=portainer --filter name=npm --filter name=daiana --filter name=supabase || true)"
  if [ -n "$ids" ]; then
    # shellcheck disable=SC2086
    docker rm -f $ids >/dev/null 2>&1 || true
  fi
fi

log "Removing shared network"
docker network rm daiana-mgmt >/dev/null 2>&1 || true

if [ "$purge_env" = "1" ]; then
  log "Removing Daiana and Portainer data directories"
  rm -rf ./volumes/daiana ./volumes/portainer
  log "Removing active .env and backup .env.old"
  rm -f .env .env.old
else
  if [ -f ".env" ]; then
    log "Updating .env.old backup from active .env"
    cp .env .env.old
    rm -f .env
  else
    log "No active .env found; keeping existing .env.old"
  fi
fi

log "Cleanup complete"
echo "You can now run: bash ./install-daiana.sh"
