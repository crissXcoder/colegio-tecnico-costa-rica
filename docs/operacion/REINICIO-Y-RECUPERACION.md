# Manual Operativo: Reinicio, Verificación Integral y Recuperación ante Desastres (DRP)

Este documento contiene los runbooks y procedimientos técnicos oficiales para operar, verificar la resiliencia y restaurar la infraestructura del **Colegio Técnico de Costa Rica** tras apagados de las máquinas virtuales, reinicios programados o contingencias operativas.

---

## 1. Arranque y Comprobación Diaria tras Reinicio de VMs

Cuando la máquina virtual de Ubuntu Server (`192.168.50.1`) se enciende o reinicia, la infraestructura debe alcanzar su estado operativo siguiendo este orden estricto de verificación.

### 1.1. Verificación del Proyecto Docker Compose (Moodle y MariaDB)
1. Ingrese a la carpeta del proyecto institucional:
   ```bash
   cd ~/proyecto-moodle
   ```
2. Compruebe el estado de los contenedores:
   ```bash
   sudo docker compose ps
   ```
   **Resultado esperado:** Ambos contenedores deben figurar en estado `Up` con salud `(healthy)`:
   - `proyecto-moodle-moodle-1` (`oksigenia/moodle:4.5.15`)
   - `proyecto-moodle-db-1` (`mariadb:11.4.13`)

3. **Si los contenedores no están iniciados:**
   ```bash
   sudo docker compose up -d
   ```
   > [!CAUTION]
   > **Prohibido el uso de `-v`:** Bajo ninguna circunstancia ejecute `docker compose down -v` ni comandos de limpieza destructiva (`docker system prune -a --volumes`), pues destruirán los volúmenes con nombre (`proyecto-moodle_moodle_data`, `proyecto-moodle_moodle_code` y `proyecto-moodle_mariadb_data`) que almacenan los cursos, calificaciones y usuarios del colegio.

4. Verifique la URL canónica de Moodle sin romper la protección CLI:
   ```bash
   sudo docker compose exec moodle php -r 'define("CLI_SCRIPT", true); require "/var/www/moodle/config.php"; echo $CFG->wwwroot, PHP_EOL;'
   ```
   **Resultado esperado:** `https://aulavirtual.ctcr`.

---

### 1.2. Verificación de Servicios del Host en Ubuntu Server
Los cuatro servicios de soporte en el sistema operativo anfitrión deben encontrarse activos y habilitados:
```bash
sudo systemctl is-active named nginx vsftpd cron
```
**Resultado esperado:**
```text
active
active
active
active
```

Si alguno se encuentra detenido:
```bash
sudo systemctl start <servicio>
```

> [!IMPORTANT]
> **Coexistencia de Apache2 y Nginx:** `apache2` debe permanecer **apagado y deshabilitado** (`sudo systemctl stop apache2 && sudo systemctl disable apache2`). El proxy inverso oficial en los puertos `80` y `443` es Nginx (`nginx.service`).

---

### 1.3. Auditoría de Puertos y Sockets en Red
Ejecute la inspección de sockets de escucha:
```bash
sudo ss -lntup | grep -E ':(21|53|80|443|8080|3306)\b'
```

| Puerto / Protocolo | Proceso / Servicio | Alcance / Bind | Propósito Institucional |
|---|---|---|---|
| `21/TCP` | `vsftpd` | `0.0.0.0:21` | Servidor FTPS con TLS explícito para funcionarios |
| `53/TCP, UDP` | `named` (BIND9) | `192.168.50.1:53` | DNS autoritativo para la zona `ctcr` |
| `80/TCP` | `nginx` | `0.0.0.0:80` | Redirección obligatoria HTTP 301 hacia HTTPS |
| `443/TCP` | `nginx` | `0.0.0.0:443` | Terminación TLS con certificado `aulavirtual.ctcr` |
| `8080/TCP` | `docker-proxy` | `127.0.0.1:8080` | Bind local exclusivo hacia Moodle (aislado de LAN) |
| `3306/TCP` | `mariadb` | Red Docker interna | Aislado del host; accesible solo por Moodle en `backend` |

---

### 1.4. Comprobación desde Linux Mint (Cliente de Red Interna)
Desde la terminal de Linux Mint (`192.168.50.101`):

1. **Prueba de enlace ICMP:**
   ```bash
   ping -c 4 192.168.50.1
   ```
   *Debe arrojar 0% de pérdida de paquetes.*

2. **Resolución DNS privada:**
   ```bash
   getent ahostsv4 aulavirtual.ctcr
   ```
   *Debe responder `192.168.50.1`.*

3. **Verificación de redirección y certificado:**
   ```bash
   curl -k -I http://aulavirtual.ctcr
   # HTTP/1.1 301 Moved Permanently -> Location: https://aulavirtual.ctcr/

   curl -k -I https://aulavirtual.ctcr
   # HTTP/1.1 200 OK
   ```

4. **Acceso Web Gráfico:**
   Abra Firefox en Linux Mint e ingrese a:
   **`https://aulavirtual.ctcr`**
   *Debe desplegarse el portal oficial con los cursos de Administración, Docencia e Informática.*

---

## 2. Prueba de Seguridad y Aislamiento FTPS

Para comprobar que el enjaulamiento chroot de los funcionarios se mantiene activo y sin fugas:

1. Pruebe la conexión con una de las cuentas departamentales (ej. `carlos.mendez`):
   ```bash
   lftp -u carlos.mendez -e "set ssl:verify-certificate no; ls; quit" ftps://192.168.50.1
   ```
2. Intente un escape de directorio:
   ```bash
   lftp -u carlos.mendez -e "set ssl:verify-certificate no; cd /etc; quit" ftps://192.168.50.1
   ```
   **Resultado esperado:** El servidor debe rechazar la acción con:
   ```text
   cd: Access failed: 550 Failed to change directory.
   ```
3. Estructura de permisos en el host:
   - Raíz `/srv/ftp/<usuario>`: `0755` y propietario `root:root`.
   - Carpeta `/srv/ftp/<usuario>/archivos`: `0700` y propietario `<usuario>:<usuario>`.

---

## 3. Plan de Respaldos Diarios con Cron

La política institucional de respaldos del CTCR opera de forma automatizada:
- **Horario:** Todos los días a las `02:00 AM CST`.
- **Script:** `/home/criss/proyecto-moodle/respaldo.sh` (permisos `0700`).
- **Destino:** `/var/backups/moodle/ctcr_moodle_<FECHA>.sql.gz`.
- **Retención:** 7 días móviles (depuración automática de volcados antiguos).

### 3.1. Ejecución de un Respaldo Manual Inmediato
Si se requiere generar una copia de seguridad previa a un mantenimiento:
```bash
sudo /home/criss/proyecto-moodle/respaldo.sh
```
Verifique la integridad del archivo resultante:
```bash
sudo sh -c 'gzip -t /var/backups/moodle/ctcr_moodle_*.sql.gz'
```

---

## 4. Procedimiento de Recuperación ante Desastres (DRP)

Existen dos escenarios de recuperación:
- **Escenario A (Auditoría / DRP de Ensayo):** Demostrar la recuperabilidad en un esquema separado (`moodle_restore_test`) sin alterar la producción.
- **Escenario B (Recuperación Real ante Desastre):** Restaurar la base institucional `moodle` tras un fallo crítico o corrupción de datos.

### 4.1. Escenario A: Prueba de Recuperación en Esquema Aislado
1. Identifique el volcado de respaldo más reciente:
   ```bash
   BACKUP=$(sudo find /var/backups/moodle -name 'ctcr_moodle_*.sql.gz' -type f | sort -nr | head -1)
   echo "Volcado a restaurar: $BACKUP"
   ```

2. Cree la base de datos de ensayo en MariaDB:
   ```bash
   cd ~/proyecto-moodle
   set -a; source .env; set +a
   docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -e "CREATE DATABASE IF NOT EXISTS moodle_restore_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
   ```

3. Importe el volcado mediante descompresión en memoria:
   ```bash
   sudo gzip -dc "$BACKUP" | docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root moodle_restore_test
   ```

4. Verifique la coincidencia estructural de tablas:
   ```bash
   TABLAS_PROD=$(docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'moodle';")
   TABLAS_TEST=$(docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'moodle_restore_test';")
   echo "Producción: $TABLAS_PROD tablas | Ensayo: $TABLAS_TEST tablas"
   ```
   *Ambas cifras deben coincidir exactamente (**494 tablas** en Moodle 4.5.15).*

5. Limpie el esquema temporal:
   ```bash
   docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -e "DROP DATABASE moodle_restore_test;"
   ```

---

### 4.2. Escenario B: Recuperación Total de la Base de Producción
En caso de corrupción de datos o pérdida accidental en la base `moodle`:

1. Detenga el tráfico web hacia Moodle cerrando temporalmente el proxy inverso:
   ```bash
   sudo systemctl stop nginx
   ```

2. Cargue las variables de entorno de producción:
   ```bash
   cd ~/proyecto-moodle
   set -a; source .env; set +a
   ```

3. Seleccione el archivo de respaldo verificado:
   ```bash
   BACKUP="/var/backups/moodle/ctcr_moodle_<FECHA_SELECCIONADA>.sql.gz"
   sudo gzip -t "$BACKUP"
   ```

4. Recree el esquema limpio de producción:
   ```bash
   docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -e "DROP DATABASE IF EXISTS moodle; CREATE DATABASE moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
   ```

5. Inyecte los datos del respaldo:
   ```bash
   sudo gzip -dc "$BACKUP" | docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root moodle
   ```

6. Purgue la caché interna de Moodle para regenerar índices y sesiones:
   ```bash
   docker compose exec moodle php /var/www/moodle/admin/cli/purge_caches.php
   ```

7. Restablezca el servicio Nginx y verifique el acceso:
   ```bash
   sudo systemctl start nginx
   curl -k -I https://aulavirtual.ctcr
   ```

---

## 5. Tabla de Diagnóstico Rápido ante Incidencias Comunes

| Síntoma Observado | Causa Frecuente | Solución Inmediata | Incidencia Documentada |
|---|---|---|---|
| `Command line scripts must define CLI_SCRIPT...` | Ejecución de PHP CLI en Moodle sin constante de seguridad | Agregar `define("CLI_SCRIPT", true);` antes de `require` | [`INC-005`](../../bitacora/incidentes/INC-005-moodle-cli-script-constant.md) |
| `NameResolutionError: Failed to resolve aulavirtual.ctcr` en Server | `systemd-resolved` no consulta BIND9 en IP local LAN | Agregar `192.168.50.1 aulavirtual.ctcr` en `/etc/hosts` | [`INC-013`](../../bitacora/incidentes/INC-013-dns-local-loopback-systemd-resolved.md) |
| `500 OOPS: vsftpd: refusing to run with writable root inside chroot()` | Raíz de usuario FTP tiene permisos de escritura | Asignar `root:root` con permisos `0755` a `/srv/ftp/<user>` | [`INC-010`](../../bitacora/incidentes/INC-010-vsftpd-writable-root-chroot-500.md) |
| Fallo en comodín `ctcr_moodle_*.sql.gz` bajo `sudo` | Bash evalúa comodín antes de elevar con sudo en carpeta 0700 | Ejecutar vía subshell `sudo sh -c 'gzip -t /var/backups/...'` | [`INC-012`](../../bitacora/incidentes/INC-012-wildcard-expansion-permisos-0700.md) |
| Nginx no inicia por conflicto en puerto 80/443 | Apache2 se activó en segundo plano | Ejecutar `sudo systemctl stop apache2 && sudo systemctl disable apache2` | [`INC-004`](../../bitacora/incidentes/INC-004-apache2-nginx-port-collision.md) |
| BIND9 falla al iniciar en puerto 53 | Colisión de socket con `systemd-resolved` en `127.0.0.1` | Asegurar `listen-on { 192.168.50.1; };` en `named.conf.options` | [`INC-002`](../../bitacora/incidentes/INC-002-bind9-systemd-resolved-port53.md) |
