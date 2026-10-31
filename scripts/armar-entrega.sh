#!/bin/bash
# Arma la carpeta de entrega del profesor COPIANDO lo que corre en el servidor.
#
# No modifica servicios ni configuraciones: solo lee y escribe en la carpeta de salida.
# Uso en Ubuntu Server (el servidor de la demostración):
#   sudo ./armar-entrega.sh /home/criss/proyecto-moodle [carpeta-salida]
#
# Resultado: <salida>/entrega-ctcr/ y entrega-ctcr-<fecha>.tar.gz (y .zip si existe zip).
# Antes de subirlo, revisar a mano cada archivo; ver docs/entrega/PAQUETE-ENTREGA.md.

set -euo pipefail
umask 022
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

PROJECT_DIR="${1:-}"
SALIDA_BASE="${2:-$PWD}"
[[ -n "$PROJECT_DIR" && -d "$PROJECT_DIR" ]] || { echo "Uso: sudo $0 <carpeta-del-proyecto> [carpeta-salida]" >&2; exit 1; }
[[ $EUID -eq 0 ]] || { echo "Ejecutar con sudo (lee el crontab de root y /etc)." >&2; exit 1; }
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

FECHA="$(date +%Y-%m-%d_%H-%M)"
OUT="$SALIDA_BASE/entrega-ctcr"
[[ ! -e "$OUT" ]] || { echo "Ya existe $OUT. Moverlo o borrarlo antes de volver a armar el paquete." >&2; exit 1; }
mkdir -p "$OUT"/{configuraciones/bind,configuraciones/nginx,configuraciones/vsftpd,scripts,evidencia,documentacion}

MAPA="$OUT/mapa-origen.txt"
echo "# ruta-en-paquete|ruta-en-servidor (verificar-servicios.sh compara ambos hashes)" > "$MAPA"
pendientes=()

copiar() {  # copiar <origen> <destino-relativo>
    local origen="$1" rel="$2"
    if [[ -f "$origen" ]]; then
        cp --preserve=timestamps "$origen" "$OUT/$rel"
        echo "$rel|$origen" >> "$MAPA"
        echo "  copiado: $origen -> $rel"
    else
        pendientes+=("$rel (no existe $origen)")
        echo "  FALTA:   $origen"
    fi
}

echo "== Compose"
cd "$PROJECT_DIR"
if [[ -f docker-compose.yml ]]; then
    COMPOSE_ORIGEN="$PROJECT_DIR/docker-compose.yml"
else
    COMPOSE_ORIGEN="$PROJECT_DIR/compose.yaml"
fi
copiar "$COMPOSE_ORIGEN" docker-compose.yml
cmp -s "$COMPOSE_ORIGEN" "$OUT/docker-compose.yml" || { echo "La copia del compose no es idéntica." >&2; exit 1; }
# Validar el archivo entregado con el .env real, sin imprimir la configuración resultante.
docker compose -f "$OUT/docker-compose.yml" --project-directory "$PROJECT_DIR" --env-file "$PROJECT_DIR/.env" config --quiet
echo "  docker compose config --quiet: OK"
# Plantilla sin valores: solo los nombres de las variables.
grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$PROJECT_DIR/.env" | sed -E 's/=.*/=/' > "$OUT/.env.example"
echo "  .env.example generado (sin valores)"
[[ -f "$PROJECT_DIR/Dockerfile" ]] && copiar "$PROJECT_DIR/Dockerfile" Dockerfile

echo "== Configuraciones"
copiar /etc/bind/named.conf.local   configuraciones/bind/named.conf.local
copiar /etc/bind/named.conf.options configuraciones/bind/named.conf.options
copiar /etc/bind/db.ctcr            configuraciones/bind/db.ctcr
copiar /etc/nginx/sites-available/aulavirtual.ctcr configuraciones/nginx/aulavirtual.ctcr.conf
copiar /etc/vsftpd.conf             configuraciones/vsftpd/vsftpd.conf
ls -l /etc/nginx/sites-enabled/ > "$OUT/configuraciones/nginx/sites-enabled.txt"

echo "== Scripts y Cron"
copiar "$PROJECT_DIR/respaldo.sh"            scripts/respaldo.sh
copiar "$PROJECT_DIR/restauracion-prueba.sh" scripts/restauracion-prueba.sh
copiar "$PROJECT_DIR/verificar-servicios.sh" scripts/verificar-servicios.sh
{
    echo "# Crontab de root en $(hostname), exportado $(date '+%Y-%m-%d %H:%M %z') con: crontab -l -u root"
    crontab -l -u root 2>/dev/null || echo "# (root no tiene crontab)"
} > "$OUT/crontab.txt"

echo "== Firewall"
if command -v ufw >/dev/null 2>&1; then
    { echo "# sudo ufw status verbose — $(date '+%Y-%m-%d %H:%M %z')"; ufw status verbose; } > "$OUT/ufw.txt"
else
    {
        echo "# UFW no está instalado en $(hostname) ($(date '+%Y-%m-%d %H:%M %z'))."
        echo "# El filtrado y el NAT se manejan con iptables (ver firewall-iptables.txt y ADR-0003)."
    } > "$OUT/ufw.txt"
fi
{ echo "# iptables -S — $(date '+%Y-%m-%d %H:%M %z')"; iptables -S; echo; echo "# iptables -t nat -S"; iptables -t nat -S; } \
    > "$OUT/firewall-iptables.txt" 2>&1 || true

echo "== Versiones"
{
    echo "# Inventario de versiones — $(hostname) — $(date '+%Y-%m-%d %H:%M %z')"
    grep -E '^(PRETTY_NAME|VERSION_ID)=' /etc/os-release
    docker --version
    docker compose version
    echo; echo "# docker compose ps"; docker compose ps
    echo; echo "# docker images --digests"; docker images --digests
    echo; echo "# docker volume ls"; docker volume ls
    echo; echo "# paquetes del host"; dpkg-query -W nginx bind9 vsftpd ufw 2>/dev/null || true
    named -v; nginx -v 2>&1
} > "$OUT/versiones.txt"

echo "== Revisión de secretos"
riesgo=0
if find "$OUT" -type f \( -name '.env' -o -name '*.key' -o -name '*.pem' -o -name '*.sql' -o -name '*.sql.gz' \) | grep -q .; then
    echo "  Hay archivos prohibidos en el paquete (.env, .key, .pem, .sql)." >&2; riesgo=1
fi
# Un valor literal tras PASSWORD= es sospechoso; una referencia como ${DB_PASSWORD} o "$VAR" no.
if grep -RInE '(PASSWORD|PASS|SECRET|TOKEN)[A-Z_]*=[^[:space:]$\"]|BEGIN [A-Z ]*PRIVATE KEY' "$OUT" --exclude=.env.example; then
    echo "  Las líneas de arriba parecen contener secretos." >&2; riesgo=1
fi
[[ $riesgo -eq 0 ]] && echo "  Sin secretos detectados (revisar igual a mano)."

echo "== Hashes"
(cd "$OUT" && find . -type f ! -name hashes.txt ! -name mapa-origen.txt -print0 | sort -z | xargs -0 sha256sum > hashes.txt)
echo "  hashes.txt con $(wc -l < "$OUT/hashes.txt") archivos"

cat > "$OUT/LEEME.txt" <<EOF
Paquete de entrega CTCR — Escenario 3 (Moodle) — armado $FECHA en $(hostname).
Los archivos de configuración, Compose, scripts y crontab se copiaron SIN EDITAR desde el servidor.
hashes.txt: SHA-256 de cada archivo. mapa-origen.txt: de qué ruta del servidor salió cada uno.
No se usa Dockerfile propio: las imágenes son públicas (ver versiones.txt).
Agregar antes de comprimir para la entrega: documentación técnica (documentacion/) y evidencias con fecha (evidencia/).
EOF

chown -R "${SUDO_USER:-root}:" "$OUT"

if [[ $riesgo -ne 0 ]]; then
    echo "No se comprimió el paquete porque hay posibles secretos. Corregir y volver a armar." >&2
    exit 1
fi

if [[ ${#pendientes[@]} -gt 0 ]]; then
    echo; echo "ATENCIÓN, faltan archivos:"; printf '  - %s\n' "${pendientes[@]}"
fi
echo
echo "Carpeta lista para revisión: $OUT"
echo "Después de agregar documentacion/ y evidencia/, volver a generar hashes.txt y comprimir:"
echo "  cd $OUT && find . -type f ! -name hashes.txt ! -name mapa-origen.txt -print0 | sort -z | xargs -0 sha256sum > hashes.txt"
echo "  cd $SALIDA_BASE && tar -czf entrega-ctcr-$FECHA.tar.gz entrega-ctcr"
command -v zip >/dev/null 2>&1 && echo "  cd $SALIDA_BASE && zip -r entrega-ctcr-$FECHA.zip entrega-ctcr" \
    || echo "  (zip no está instalado; ver INC-006. El .tar.gz es válido como carpeta comprimida.)"
