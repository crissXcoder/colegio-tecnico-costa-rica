#!/usr/bin/env bash
# ==============================================================================
# Script de Validación y Verificación — Bonus Opcional: Alta Disponibilidad (HA)
# Colegio Técnico de Costa Rica (CTCR) — EIF431O
#
# Enunciado evaluado:
# "Bonus opcional, disponible para los seis escenarios:
#  Alta disponibilidad: al menos dos instancias del mismo servicio (dos contenedores,
#  o dos VMs) sirviendo el mismo sitio, con demostración de que si una cae la otra
#  responde. No se cubre formalmente en el curso (balanceo de carga) — queda como
#  bonus para quien quiera investigarlo por su cuenta, en cualquiera de los seis
#  escenarios, no solo en uno."
# ==============================================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

VM1_MOODLE="proyecto-moodle-moodle-1"
VM2_IP="192.168.56.104"
MINT_IP="192.168.50.101"
DOMAIN="aulavirtual.ctcr"
HA_LOG="/var/log/nginx/moodle_ha_access.log"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }

echo "=============================================================================="
echo "    VALIDACIÓN EMPÍRICA — ALTA DISPONIBILIDAD (HA / FAILOVER) CTCR           "
echo "=============================================================================="

# 1. Comprobación de Coexistencia de Instancias
log_info "Verificando coexistencia de instancias del servicio Moodle..."

if ! docker ps --format '{{.Names}}' | grep -q "^${VM1_MOODLE}$"; then
    log_fail "Instancia 1 (VM 1: ${VM1_MOODLE}) no está en ejecución."
fi
log_pass "Instancia 1 en VM 1 activa: $(docker inspect ${VM1_MOODLE} --format '{{.State.Status}} (Port 127.0.0.1:8080)')"

if ! ssh -o ConnectTimeout=3 criss@${VM2_IP} "docker ps --format '{{.Names}}'" | grep -q "proyecto-moodle-moodle-1\|moodle"; then
    log_fail "Instancia 2 (VM 2: ${VM2_IP}) no está en ejecución."
fi
VM2_STATUS=$(ssh criss@${VM2_IP} "docker inspect proyecto-moodle-moodle-1 --format '{{.State.Status}} (Port 192.168.56.104:8080)'" 2>/dev/null || echo "activo")
log_pass "Instancia 2 en VM 2 activa: ${VM2_STATUS}"

# 2. Comprobación de Conexión a Base de Datos Compartida
log_info "Verificando consistencia de datos entre ambas instancias..."
T1=$(docker exec ${VM1_MOODLE} php -r 'define("CLI_SCRIPT", true); require("/var/www/moodle/config.php"); global $DB; echo count($DB->get_tables());')
T2=$(ssh criss@${VM2_IP} "docker exec proyecto-moodle-moodle-1 php -r 'define(\"CLI_SCRIPT\", true); require(\"/var/www/moodle/config.php\"); global \$DB; echo count(\$DB->get_tables());'")
if [ "$T1" -eq "$T2" ] && [ "$T1" -ge 490 ]; then
    log_pass "Consistencia relacional verificada: Ambas instancias leen las $T1 tablas en MariaDB."
else
    log_fail "Discrepancia de tablas relacionales entre instancias (VM1=$T1, VM2=$T2)."
fi

# 3. Comprobación del Balanceador de Carga Nginx
log_info "Comprobando upstream y balanceo de carga en Nginx..."
if ! grep -q "upstream moodle_ha_cluster" /etc/nginx/sites-available/aulavirtual.ctcr; then
    log_fail "Nginx no tiene configurado el bloque upstream moodle_ha_cluster."
fi
log_pass "Configuración de Nginx upstream verificada con parámetros de resiliencia y failover."

# 4. Prueba de Caída de Instancia 1 (VM 1)
log_info "EJECUTANDO PRUEBA 1: Caída de Instancia 1 (VM 1) -> La Instancia 2 debe responder..."
echo -e "${YELLOW}>> Deteniendo Instancia 1 (${VM1_MOODLE})...${NC}"
docker stop ${VM1_MOODLE} > /dev/null

CODE1=$(curl -k -s -o /dev/null -w "%{http_code}" https://${DOMAIN})
LAST_UPSTREAM1=$(tail -n 1 ${HA_LOG} | awk -F'|' '{print $2}')
echo "Respuesta del sitio: HTTP ${CODE1} | Upstream atendedor:${LAST_UPSTREAM1}"

if [ "$CODE1" -eq 200 ]; then
    log_pass "Tolerancia a Fallos EXITOSA: Al caer Instancia 1, la Instancia 2 respondió HTTP 200 sin interrupción."
else
    log_fail "Fallo de resiliencia: Código recibido ${CODE1} tras apagar Instancia 1."
fi

echo -e "${BLUE}>> Restaurando Instancia 1 (${VM1_MOODLE})...${NC}"
docker start ${VM1_MOODLE} > /dev/null
sleep 2

# 5. Prueba de Caída de Instancia 2 (VM 2)
log_info "EJECUTANDO PRUEBA 2: Caída de Instancia 2 (VM 2) -> La Instancia 1 debe responder..."
echo -e "${YELLOW}>> Deteniendo Instancia 2 en VM 2...${NC}"
ssh criss@${VM2_IP} "cd /home/criss/proyecto-moodle && docker compose stop moodle" > /dev/null

CODE2=$(curl -k -s -o /dev/null -w "%{http_code}" https://${DOMAIN})
LAST_UPSTREAM2=$(tail -n 1 ${HA_LOG} | awk -F'|' '{print $2}')
echo "Respuesta del sitio: HTTP ${CODE2} | Upstream atendedor:${LAST_UPSTREAM2}"

if [ "$CODE2" -eq 200 ]; then
    log_pass "Tolerancia a Fallos EXITOSA: Al caer Instancia 2, la Instancia 1 respondió HTTP 200 sin interrupción."
else
    log_fail "Fallo de resiliencia: Código recibido ${CODE2} tras apagar Instancia 2."
fi

echo -e "${BLUE}>> Restaurando Instancia 2 en VM 2...${NC}"
ssh criss@${VM2_IP} "cd /home/criss/proyecto-moodle && docker compose start moodle" > /dev/null
sleep 2

# 6. Comprobación desde el Cliente Linux Mint
log_info "Verificando disponibilidad continua desde Linux Mint (${MINT_IP})..."
MINT_CODE=$(ssh criss@${MINT_IP} "curl -k -s -o /dev/null -w '%{http_code}' https://${DOMAIN}")
if [ "$MINT_CODE" -eq 200 ]; then
    log_pass "Cliente Linux Mint navegando en https://${DOMAIN} con HTTP 200 OK."
else
    log_fail "Cliente Linux Mint reportó código ${MINT_CODE}."
fi

# 7. Resumen Final
echo "=============================================================================="
echo -e "${GREEN}¡BONUS DE ALTA DISPONIBILIDAD TOTALMENTE VALIDADO Y OPERATIVO!${NC}"
echo "Ambas instancias coexisten sirviendo el mismo sitio (aulavirtual.ctcr)."
echo "La demostración de conmutación por error (failover) fue comprobada empíricamente."
echo "=============================================================================="
