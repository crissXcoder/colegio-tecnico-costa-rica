#!/usr/bin/env bash
set -euo pipefail
umask 077
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="$ROOT/infra/compose/.env"
if [[ -e "$TARGET" ]]; then
  echo "ERROR: ya existe $TARGET; no se sobreescribe." >&2
  exit 1
fi
command -v openssl >/dev/null || { echo 'Falta openssl' >&2; exit 1; }
{
  printf 'MOODLE_IMAGE=oksigenia/moodle:4.5.15-r17\n'
  printf 'MARIADB_IMAGE=mariadb:11.4.13\n'
  printf 'MOODLE_URL=http://192.168.50.1:8080\n'
  printf 'MOODLE_BIND_IP=192.168.50.1\nMOODLE_BIND_PORT=8080\nMOODLE_SSL_PROXY=auto\n'
  printf 'DB_ROOT_PASSWORD=%s\n' "$(openssl rand -hex 24)"
  printf 'DB_PASSWORD=%s\n' "$(openssl rand -hex 24)"
  printf 'MOODLE_ADMIN_PASSWORD=%s\n' "$(openssl rand -hex 24)"
} > "$TARGET"
chmod 600 "$TARGET"
echo 'Archivo de variables generado con permisos 600 (contenido oculto). Revisar imagen y URL antes de desplegar.'
