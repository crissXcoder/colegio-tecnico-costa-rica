# Sesión 2026-10-31 — Auditoría Técnica Integral y Ejecución de Scripts en Producción

- **Tipo:** sesión operativa y de auditoría integral en VMs (Ubuntu Server `192.168.50.1` y Linux Mint `192.168.50.101`).
- **Responsable:** Cristhian Altamirano Montes (VM #1) con soporte de agente.
- **Objetivo:** Auditar exhaustivamente la documentación del repositorio (guías, versiones, directrices y rúbrica), auditar en vivo ambas VMs, contrastar discrepancias (Nginx `.12` vs `.11`, UFW vs iptables), instalar los nuevos scripts en `/home/criss/proyecto-moodle/`, ejecutar las pruebas DRP y chequeo de servicios, y verificar la correspondencia con el paquete de entrega.

---

## 1. Auditoría en Vivo de las Máquinas Virtuales

### 1.1. VM #1: Ubuntu Server (`192.168.50.1`)
- **Sistema y Kernel:** Ubuntu 26.04.1 LTS (Resolute Raccoon), Kernel `7.0.0-38-generic`, LVM en raíz al 73% de capacidad (~12 GB libres).
- **Servicios Host:**
  - `docker.service`: `active` y `enabled`.
  - `named.service`: `active` y `enabled`, escuchando en `192.168.50.1:53` y resolviendo autoritativamente `aulavirtual.ctcr`.
  - `nginx.service`: `active` y `enabled` (`nginx/1.28.3`), escuchando en `192.168.50.1:80` (redirección 301) y `192.168.50.1:443 ssl` con certificado SAN válido hasta octubre de 2027.
  - `vsftpd.service`: `active` y `enabled` (`3.0.5`), escuchando en `192.168.50.1:21` con pasivos `40000:40010`, TLS forzado y chroot `0700`.
  - `cron.service`: `active` y `enabled`. Tarea programada en crontab de root a las 02:00 AM para `respaldo.sh`.
  - `apache2.service`: `inactive` y `disabled` permanentemente (previniendo colisión en 80/443).
- **Pila Docker Moodle:**
  - Contenedores: `proyecto-moodle-db-1` (`mariadb:11.4.13`) y `proyecto-moodle-moodle-1` (`oksigenia/moodle:4.5.15`) en estado `Up (healthy)`.
  - Enlace local exclusivo: `127.0.0.1:8080:8080` (aislado de la red LAN).
  - Volúmenes presentes y vinculados: `mariadb_data`, `moodle_code`, `moodle_data`.

### 1.2. VM #2: Linux Mint (`192.168.50.101`)
- **Conectividad:** Enlace `enp0s3` en `192.168.50.101/24`, ping hacia `8.8.8.8` vía NAT con 0% de pérdida.
- **DNS:** Resolución directa con `dig aulavirtual.ctcr` devolviendo `192.168.50.1`.
- **Navegación Web:** Petición HTTP al puerto 80 responde `301 Moved Permanently`. Petición HTTPS al puerto 443 responde `200 OK`.
- **FTPS y Confinamiento Chroot:** Conexión mediante `curl --ftp-ssl` con cuenta `marta.jimenez` autenticando con éxito y visualizando `archivos/expediente-administrativo.txt`. Intento de escape traversal hacia `../carlos.mendez/` rechazado por el servidor con error `550 Failed to change directory` (código curl 9).

---

## 2. Análisis de Discrepancias Técnicas

### 2.1. Versión de Nginx: `1.28.3-2ubuntu1.12` vs `1.28.3-2ubuntu1.11`
- **Diagnóstico:** Ambas revisiones de empaquetado corresponden upstream exactamente a **Nginx 1.28.3**. Al ejecutar `nginx -v`, ambas VMs reportan de forma idéntica:  
  `nginx version: nginx/1.28.3 (Ubuntu)`.
- **Causa raíz:** Canonical promovió la revisión de seguridad en los repositorios oficiales de Ubuntu 26.04 a `.12`, retornando 404 para `.11` (documentado en `INC-003`). En VM #1 se instaló la versión oficial mantenida `.12` vía APT, mientras que en la segunda VM se instaló forzando un `.deb` descargado.
- **Conclusión:** Ambas cumplen la versión pactada Nginx 1.28.3. La VM #1 está alineada con `docs/00-proyecto/versiones.md` y `ADR-0004`.

### 2.2. Política de Firewall: UFW vs iptables
- **Diagnóstico:** En la VM #1, el comando `ufw` no está instalado (estado `deinstall ok config-files`). Todo el filtrado, reenvío y NAT de Linux Mint se gestiona con `iptables` y `iptables-persistent` en `/etc/iptables/rules.v4`.
- **Justificación (ADR-0003):** Activar UFW rompe las cadenas de enrutamiento dinámico de Docker y corta la salida NAT de Linux Mint.
- **Comprobación:** El script oficial de verificación del grupo `verificar-servicios.sh` reconoce y valida esta arquitectura:  
  `[OK] UFW no instalado; filtrado con iptables (ver ADR-0003)`.

---

## 3. Acciones Ejecutadas en el Servidor (Cierre de P-02)

1. **Instalación de Scripts Nuevos:** Se copiaron a `/home/criss/proyecto-moodle/`:
   - `restauracion-prueba.sh` (permisos `0700`, UTF-8 sin CRLF).
   - `verificar-servicios.sh` (permisos `0700`, UTF-8 sin CRLF).
   - `armar-entrega.sh` (permisos `0700`, UTF-8 sin CRLF).
2. **Ejecución de Prueba DRP (`restauracion-prueba.sh`):**
   - Ejecutado desatendido generando la bitácora `restauracion_2026-10-31_19-48.log`.
   - Se importó el último respaldo `ctcr_moodle_2026-10-30_18-14-19.sql.gz` en el esquema aislado `moodle_restore_test`.
   - **Resultado:** **494 tablas** idénticas entre `moodle` y `moodle_restore_test` (100% paridad), 3 cursos y 12 usuarios verificados. Destrucción segura de la base de prueba mediante `trap`.
3. **Generación y Verificación del Paquete de Entrega:**
   - Se ejecutó `armar-entrega.sh` generando la carpeta `/tmp/entrega-ctcr` con `hashes.txt` (15 archivos).
   - Se ejecutó `verificar-servicios.sh` cruzando los archivos del servidor contra los hashes del paquete entregado:  
     **Resultado:** `TODO OK` (0 fallos, 9/9 archivos de configuración idénticos byte a byte). Bitácora guardada en `verificacion_2026-10-31_19-53.log`.
