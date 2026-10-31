#!/bin/bash
# Chequeo previo a la demostración. SOLO LECTURA: no reinicia, no instala, no borra.
#
# Uso en Ubuntu Server (con sudo, para leer el crontab de root y los respaldos):
#   sudo ./verificar-servicios.sh /home/criss/proyecto-moodle
#   sudo ./verificar-servicios.sh /home/criss/proyecto-moodle /ruta/al/paquete-entrega
#
# Con el segundo argumento compara los archivos que corren en el servidor con los
# hashes del paquete entregado (usa mapa-origen.txt y hashes.txt del paquete).
# Termina con código 0 si todo pasó y 1 si hubo al menos un FALLO.

set -uo pipefail
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

PROJECT_DIR="${1:-}"
PAQUETE="${2:-}"
DOMINIO="aulavirtual.ctcr"
IP_SERVIDOR="192.168.50.1"
BACKUP_DIR="/var/backups/moodle"

[[ -n "$PROJECT_DIR" && -d "$PROJECT_DIR" ]] || { echo "Uso: sudo $0 <carpeta-del-proyecto> [paquete-entrega]" >&2; exit 1; }
[[ $EUID -eq 0 ]] || { echo "Ejecutar con sudo." >&2; exit 1; }

fallos=0
ok()    { printf '  [OK]    %s\n' "$*"; }
falla() { printf '  [FALLO] %s\n' "$*"; fallos=$((fallos + 1)); }
aviso() { printf '  [AVISO] %s\n' "$*"; }
titulo() { printf '\n== %s\n' "$*"; }

printf 'Verificación CTCR — %s — %s\n' "$(hostname)" "$(date '+%Y-%m-%d %H:%M:%S %z')"

titulo "Red y hora"
if ip -br -4 addr | grep -q "$IP_SERVIDOR/"; then ok "IP $IP_SERVIDOR presente"; else falla "no está la IP $IP_SERVIDOR (¿cambió la red interna de VirtualBox?)"; fi
if timedatectl show -p NTPSynchronized --value 2>/dev/null | grep -q yes; then ok "hora sincronizada: $(date '+%H:%M %Z')"; else aviso "hora NO sincronizada; revisar 'timedatectl' (afecta Cron y certificados)"; fi

titulo "Espacio"
uso="$(df --output=pcent / | tail -1 | tr -dc '0-9')"
if [[ "$uso" -lt 85 ]]; then ok "raíz al ${uso}%"; else falla "raíz al ${uso}% (ver INC-001; no borrar volúmenes)"; fi

titulo "Servicios del host"
for s in docker named nginx vsftpd cron; do
    if systemctl is-active --quiet "$s"; then ok "$s activo"; else falla "$s inactivo"; fi
    systemctl is-enabled --quiet "$s" 2>/dev/null || aviso "$s no arranca solo al reiniciar (systemctl is-enabled)"
done

titulo "Contenedores"
cd "$PROJECT_DIR" || exit 1
if [[ -f compose.yaml && -f docker-compose.yml ]] && ! cmp -s compose.yaml docker-compose.yml; then
    falla "compose.yaml y docker-compose.yml existen y son DISTINTOS: Compose usa compose.yaml, no lo entregado"
fi
for svc in db moodle; do
    salud="$(docker compose ps --format '{{.Service}} {{.Health}}' 2>/dev/null | awk -v s="$svc" '$1==s{print $2}')"
    case "$salud" in
        healthy) ok "$svc healthy" ;;
        starting) aviso "$svc todavía en 'starting'; esperar antes de la demo" ;;
        *) falla "$svc no está healthy (estado: ${salud:-no encontrado})" ;;
    esac
done
docker compose images 2>/dev/null | sed 's/^/          /'
vols="$(docker volume ls --format '{{.Name}}' | grep -c -E '_(mariadb_data|moodle_code|moodle_data)$' || true)"
if [[ "$vols" -ge 3 ]]; then ok "volúmenes del proyecto presentes ($vols)"; else falla "faltan volúmenes del proyecto (encontrados: $vols)"; fi

titulo "Configuraciones"
if nginx -t >/dev/null 2>&1; then ok "nginx -t"; else falla "nginx -t falla"; fi
if named-checkconf >/dev/null 2>&1; then ok "named-checkconf"; else falla "named-checkconf falla"; fi
if named-checkzone ctcr /etc/bind/db.ctcr >/dev/null 2>&1; then ok "named-checkzone ctcr"; else falla "named-checkzone ctcr falla"; fi

titulo "Puertos"
puertos="$(ss -lntu)"
for p in "$IP_SERVIDOR:53" "$IP_SERVIDOR:80" "$IP_SERVIDOR:443" "127.0.0.1:8080" ":21"; do
    if grep -q -- "$p " <<<"$puertos"; then ok "escuchando $p"; else falla "nada escucha en $p"; fi
done
if grep -qE '0\.0\.0\.0:(3306|5432) ' <<<"$puertos"; then
    aviso "hay una base de datos del host abierta en 0.0.0.0 (3306/5432): no es de Moodle; saber explicarlo si el profesor ve 'ss -lntup'"
fi

titulo "DNS y HTTPS"
if [[ "$(dig +short @"$IP_SERVIDOR" "$DOMINIO" A 2>/dev/null)" == "$IP_SERVIDOR" ]]; then ok "dig @$IP_SERVIDOR $DOMINIO -> $IP_SERVIDOR"; else falla "BIND9 no resuelve $DOMINIO a $IP_SERVIDOR"; fi
codigo80="$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 --resolve "$DOMINIO:80:$IP_SERVIDOR" "http://$DOMINIO/")"
[[ "$codigo80" == "301" ]] && ok "HTTP 301 hacia HTTPS" || falla "HTTP devolvió $codigo80 (se esperaba 301)"
codigo443="$(curl -sk -o /dev/null -w '%{http_code}' --max-time 20 --resolve "$DOMINIO:443:$IP_SERVIDOR" "https://$DOMINIO/")"
case "$codigo443" in
    200|303) ok "HTTPS respondió $codigo443" ;;
    502) falla "HTTPS 502: Nginx no llega a Moodle (127.0.0.1:8080); ver INC-015" ;;
    *) falla "HTTPS devolvió $codigo443" ;;
esac
fin_cert="$(echo | openssl s_client -connect "$IP_SERVIDOR:443" -servername "$DOMINIO" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)"
if [[ -n "$fin_cert" ]]; then
    if [[ "$(date -d "$fin_cert" +%s)" -gt "$(date -d '+30 days' +%s)" ]]; then ok "certificado vence: $fin_cert"; else falla "certificado vence pronto o ya venció: $fin_cert"; fi
else
    falla "no se pudo leer el certificado de $IP_SERVIDOR:443"
fi

titulo "Respaldos"
if crontab -l -u root 2>/dev/null | grep -q 'respaldo.sh'; then ok "Cron de root tiene respaldo.sh"; else falla "el crontab de root no contiene respaldo.sh"; fi
ultimo="$(find "$BACKUP_DIR" -maxdepth 1 -type f -name '*moodle_*.sql.gz' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2-)"
if [[ -n "$ultimo" ]]; then
    edad=$(( ( $(date +%s) - $(stat -c %Y "$ultimo") ) / 86400 ))
    ok "último respaldo: $(basename "$ultimo") (hace $edad días)"
    [[ "$edad" -le 1 ]] || aviso "el último respaldo tiene más de 1 día: la VM estuvo apagada a las 02:00; correr respaldo.sh antes de la demo"
    gzip -t "$ultimo" 2>/dev/null && ok "gzip -t del último respaldo" || falla "el último respaldo está dañado"
else
    falla "no hay respaldos en $BACKUP_DIR"
fi
[[ -x "$PROJECT_DIR/restauracion-prueba.sh" ]] && ok "restauracion-prueba.sh instalado" || aviso "falta restauracion-prueba.sh en $PROJECT_DIR"

titulo "Firewall"
if command -v ufw >/dev/null 2>&1; then
    aviso "UFW instalado: $(ufw status | head -1) (ver ADR-0003 y ufw.txt)"
else
    ok "UFW no instalado; filtrado con iptables (ver ADR-0003)"
fi

if [[ -n "$PAQUETE" ]]; then
    titulo "Correspondencia con el paquete entregado"
    if [[ -f "$PAQUETE/mapa-origen.txt" && -f "$PAQUETE/hashes.txt" ]]; then
        while IFS='|' read -r rel origen; do
            [[ -z "$rel" || "$rel" == \#* ]] && continue
            # sha256sum puede marcar el nombre con '*' (modo binario); se ignora ese prefijo.
            esperado="$(awk -v f="./$rel" '{n=$2; sub(/^\*/,"",n)} n==f{print $1}' "$PAQUETE/hashes.txt")"
            if [[ ! -f "$origen" ]]; then falla "$rel: no existe en el servidor ($origen)"; continue; fi
            actual="$(sha256sum "$origen" | cut -d' ' -f1)"
            if [[ "$actual" == "$esperado" ]]; then ok "$rel coincide con $origen"; else falla "$rel DIFIERE de $origen (se editó después de armar el paquete)"; fi
        done < "$PAQUETE/mapa-origen.txt"
    else
        falla "el paquete no tiene mapa-origen.txt o hashes.txt"
    fi
fi

printf '\nResultado: %s\n' "$([[ $fallos -eq 0 ]] && echo 'TODO OK' || echo "$fallos FALLO(S)")"
[[ $fallos -eq 0 ]]
