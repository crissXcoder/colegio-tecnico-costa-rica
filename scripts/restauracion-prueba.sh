#!/bin/bash
# Restauración de ENSAYO del último respaldo SQL de Moodle en una base aparte.
#
# Nunca escribe sobre la base real `moodle`: crea `moodle_restore_test`, importa,
# compara tablas y cursos con la base real y borra la base de ensayo al final.
#
# Se instala junto a respaldo.sh, en la carpeta del proyecto del servidor
# (por ejemplo /home/criss/proyecto-moodle), y se ejecuta con sudo:
#   sudo ./restauracion-prueba.sh                      # usa el respaldo más reciente
#   sudo ./restauracion-prueba.sh /var/backups/moodle/ctcr_moodle_2026-10-30_16-46-51.sql.gz
#   sudo ./restauracion-prueba.sh --conservar          # no borra la base de ensayo
# Para guardar evidencia con fecha:
#   sudo ./restauracion-prueba.sh 2>&1 | tee "restauracion_$(date +%F_%H-%M).log"

set -euo pipefail
umask 077

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="/var/backups/moodle"
DB_REAL="moodle"
DB_TEST="moodle_restore_test"
CONSERVAR=0
BACKUP=""

for arg in "$@"; do
    case "$arg" in
        --conservar) CONSERVAR=1 ;;
        -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
        *) BACKUP="$arg" ;;
    esac
done

log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S %z')" "$*"; }
falla() { log "ERROR: $*" >&2; exit 1; }

# Defensa ante un cambio accidental de las variables de arriba.
[[ "$DB_TEST" != "$DB_REAL" ]] || falla "la base de ensayo no puede llamarse igual que la real"

cd "$PROJECT_DIR"
[[ -r .env ]] || falla "no se encuentra .env en $PROJECT_DIR (ejecutar con sudo desde la carpeta del proyecto)"
[[ -f compose.yaml || -f docker-compose.yml ]] || falla "no hay compose.yaml ni docker-compose.yml en $PROJECT_DIR"

set -a
# shellcheck disable=SC1091
source .env
set +a
: "${DB_ROOT_PASSWORD:?Falta DB_ROOT_PASSWORD en .env}"

sql() {
    # Ejecuta SQL en el contenedor db sin exponer la contraseña en la línea de comandos.
    docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -N -B "$@"
}

log "Servidor: $(hostname) | Proyecto: $PROJECT_DIR"

estado_db="$(docker compose ps --format '{{.Service}} {{.Health}}' 2>/dev/null | awk '$1=="db"{print $2}')"
[[ "$estado_db" == "healthy" ]] || falla "el contenedor db no está healthy (estado: ${estado_db:-desconocido})"

if [[ -z "$BACKUP" ]]; then
    BACKUP="$(find "$BACKUP_DIR" -maxdepth 1 -type f \
        \( -name 'ctcr_moodle_*.sql.gz' -o -name 'moodle_*.sql.gz' \) \
        -printf '%T@ %p\n' | sort -nr | head -1 | cut -d' ' -f2-)"
fi
[[ -n "$BACKUP" && -f "$BACKUP" ]] || falla "no hay respaldo para restaurar en $BACKUP_DIR"

log "Respaldo seleccionado: $BACKUP ($(du -h "$BACKUP" | cut -f1), modificado $(date -r "$BACKUP" '+%Y-%m-%d %H:%M'))"
gzip -t "$BACKUP" || falla "el archivo está dañado (gzip -t falló)"
log "gzip -t: OK"

existe="$(sql -e "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name='$DB_TEST';")"
if [[ "$existe" != "0" ]]; then
    falla "ya existe $DB_TEST de una prueba anterior; revisarla y borrarla a mano con DROP DATABASE $DB_TEST antes de repetir"
fi

limpiar() {
    if [[ "$CONSERVAR" -eq 0 ]]; then
        sql -e "DROP DATABASE IF EXISTS $DB_TEST;" && log "Base de ensayo $DB_TEST eliminada."
    else
        log "Se conserva $DB_TEST por --conservar. Borrarla después con DROP DATABASE $DB_TEST."
    fi
}
trap limpiar EXIT

sql -e "CREATE DATABASE $DB_TEST CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
log "Importando en $DB_TEST (puede tardar un minuto)..."
gzip -dc "$BACKUP" | docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root "$DB_TEST"
log "Importación terminada."

tablas_real="$(sql -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_REAL';")"
tablas_test="$(sql -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_TEST';")"
cursos_test="$(sql "$DB_TEST" -e "SELECT GROUP_CONCAT(shortname ORDER BY shortname) FROM mdl_course WHERE id>1;")"
usuarios_test="$(sql "$DB_TEST" -e "SELECT COUNT(*) FROM mdl_user WHERE deleted=0;")"

log "Tablas en $DB_REAL: $tablas_real | en $DB_TEST: $tablas_test"
log "Cursos restaurados: ${cursos_test:-ninguno}"
log "Usuarios activos restaurados: $usuarios_test"

if [[ "$tablas_test" -eq 0 ]]; then
    falla "la restauración no creó tablas"
elif [[ "$tablas_real" != "$tablas_test" ]]; then
    log "AVISO: el número de tablas difiere. Puede ser normal si Moodle cambió después del respaldo; revisar antes de dar la prueba por buena."
    exit 2
fi

log "RESULTADO: restauración de ensayo correcta. La base real $DB_REAL no se modificó."
