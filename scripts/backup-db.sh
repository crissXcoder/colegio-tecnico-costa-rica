#!/usr/bin/env bash
set -euo pipefail
umask 077
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT/infra/compose/.env"
COMPOSE="$ROOT/infra/compose/compose.yaml"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/moodle}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
[[ -r "$ENV_FILE" ]] || { echo 'Falta .env privado (infra/compose/.env)' >&2; exit 1; }
[[ -f "$COMPOSE" ]] || { echo 'Falta compose.yaml' >&2; exit 1; }
[[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]] || { echo 'RETENTION_DAYS inválido' >&2; exit 1; }
# Cargar credenciales privadas; nunca imprimir env ni comandos con secretos.
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a
: "${DB_ROOT_PASSWORD:?}"
mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"
TMP="$(mktemp "$BACKUP_DIR/.moodle.XXXXXXXX.sql.gz")"
trap 'rm -f "$TMP"' EXIT
# La contraseña pasa solo a la sesión exec; proteger acceso de administrador Docker.
docker compose -p "${COMPOSE_PROJECT_NAME:-proyecto-moodle}" --env-file "$ENV_FILE" -f "$COMPOSE" exec -T \
  -e MYSQL_PWD="$DB_ROOT_PASSWORD" db \
  mariadb-dump -u root --single-transaction --quick --routines --events moodle | gzip -c > "$TMP"
test -s "$TMP"
gzip -t "$TMP"
DATE="$(date +%Y%m%dT%H%M%S%z)"
FINAL="$BACKUP_DIR/moodle_$DATE.sql.gz"
mv "$TMP" "$FINAL"
trap - EXIT
find "$BACKUP_DIR" -type f -name 'moodle_*.sql.gz' -mtime "+$RETENTION_DAYS" -delete
printf 'Respaldo SQL creado y gzip validado: %s\n' "$FINAL"
printf 'ATENCIÓN: falta prueba de restauración y copia coherente de moodledata.\n'
