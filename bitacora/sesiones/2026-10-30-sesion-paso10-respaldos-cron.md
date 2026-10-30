# Minuta de Sesión de Bitácora — Despliegue y Validación del Paso 10 (Respaldos Automáticos con Cron y Restauración DRP)

- **Fecha:** 2026-10-30 (16:45 a 17:00 CST)
- **Bloque:** `10-respaldos` (Fase 8: Respaldos automáticos con Cron y Restauración de Ensayo)
- **Integrantes / Operador:** criss (Estudiante EIF431O)
- **Revisor Técnico:** Antigravity AI Pair Programmer
- **Máquinas involucradas:**
  - VM #1 Ubuntu Server (`192.168.50.1`) — Hostname: `server`
- **Objetivo:** Implementar la política oficial de respaldo del Colegio Técnico de Costa Rica para el aula virtual Moodle (MariaDB 11.4.13 en contenedor Docker Compose), automatizar la ejecución diaria a las 02:00 AM CST mediante Cron de root, configurar una retención móvil de 7 días en `/var/backups/moodle` con permisos `0700`, validar la integridad gzip del volcado SQL y ejecutar una prueba formal de recuperación ante desastres (DRP) en un esquema aislado (`moodle_restore_test`), verificando la coincidencia estructural del 100% de las 494 tablas de Moodle 4.5.15 y la preservación de cursos y usuarios institucionales.

---

## 1. Comandos Ejecutados y Resultados

1. **Creación y Protección del Directorio de Respaldos (Paso 10.1):**
   - Comando: `sudo mkdir -p /var/backups/moodle && sudo chmod 700 /var/backups/moodle`
   - Comprobación: `stat -c "%a %U:%G %n" /var/backups/moodle` -> `700 root:root /var/backups/moodle`.

2. **Creación del Script Institucional de Respaldo (Paso 10.2):**
   - Ubicación: `/home/criss/proyecto-moodle/respaldo.sh`.
   - Propiedades:
     - `set -euo pipefail` y `umask 077`.
     - Carga dinámica de variables protegidas desde `.env` (`MYSQL_PWD="$DB_ROOT_PASSWORD"`).
     - Volcado atómico mediante tubería directa:
       `docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb-dump -u root --single-transaction --quick --routines --events moodle | gzip > "$ARCHIVO"`.
     - Validación de no vacuidad con `test -s "$ARCHIVO"`.
     - Verificación de integridad con `gzip -t "$ARCHIVO"`.
     - Depuración y retención móvil de 7 días: `find "$BACKUP_DIR" -type f -name "ctcr_moodle_*.sql.gz" -mtime +7 -delete`.

3. **Asignación de Permisos y Validación Sintáctica (Paso 10.3):**
   - Comandos: `chmod 700 /home/criss/proyecto-moodle/respaldo.sh` y `bash -n /home/criss/proyecto-moodle/respaldo.sh`.
   - Salida: código 0 (sin errores sintácticos).
   - Evidencia capturada: `EV-096`.

4. **Ejecución del Respaldo Manual y Validación Gzip (Paso 10.4):**
   - Comando: `sudo ./respaldo.sh`.
   - Salida: `Respaldo completado correctamente: 2026-10-30_16-46-51`.
   - Archivo generado: `/var/backups/moodle/ctcr_moodle_2026-10-30_16-46-51.sql.gz` (384 KB).
   - Verificación de integridad: `sudo sh -c 'gzip -t /var/backups/moodle/ctcr_moodle_*.sql.gz'` -> OK.
   - Diagnóstico de comodines documentado como `INC-012`.
   - Evidencia capturada: `EV-097`.

5. **Configuración de Zona Horaria y Automatización Cron (Paso 10.5):**
   - Verificación de zona horaria: `timedatectl` -> `Time zone: America/Costa_Rica (CST, -0600)`.
   - Estado del servicio: `systemctl is-active cron` -> `active`, `systemctl is-enabled cron` -> `enabled`.
   - Programación en crontab de root (`sudo crontab -l`):
     `0 2 * * * /home/criss/proyecto-moodle/respaldo.sh >> /var/log/moodle-backup.log 2>&1`.
   - Evidencia capturada: `EV-098`.

6. **Prueba de Recuperación ante Desastres (DRP) en Base Independiente (Paso 10.6):**
   - Creación de base de prueba aislada:
     `docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -e "CREATE DATABASE IF NOT EXISTS moodle_restore_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"`.
   - Selección automática del volcado más reciente: `BACKUP=$(sudo find /var/backups/moodle -name 'ctcr_moodle_*.sql.gz' -type f | sort -nr | head -1)`.
   - Importación por tubería desatendida:
     `sudo gzip -dc "$BACKUP" | docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root moodle_restore_test`.
   - Comprobación estructural y comparativa de tablas:
     - Tablas en `moodle`: **494 tablas**.
     - Tablas en `moodle_restore_test`: **494 tablas**.
     - Coincidencia estructural: **100%**.
   - Comprobación de consistencia de datos recuperados:
     - 4 cursos institucionales presentes (`CTCR`, `CTCR-ADM-101`, `CTCR-DOC-101`, `CTCR-INF-101`).
     - 12 usuarios institucionales intactos (incluyendo administradores, profesores y estudiantes por cohorte).
   - Limpieza posterior del entorno:
     `docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db mariadb -u root -e "DROP DATABASE moodle_restore_test;"`.
   - Evidencia capturada: `EV-099`.

---

## 2. Evidencias Integradas al Manifiesto y Catálogo

| Identificador | Descripción Técnica | Subpaso | Formato / Tamaño | SHA-256 |
|---|---|---|---|---|
| `EV-096` | Inspección de script `respaldo.sh` (permisos 0700, mariadb-dump, gzip) y validación sintáctica `bash -n` | 10-02 | WebP (105 KB) | `48964e8e102901e18ae41605aa06bd6787f1e576355927dc76292c01ca0343a3` |
| `EV-097` | Ejecución de respaldo manual `respaldo.sh`, archivo `ctcr_moodle_*.sql.gz` (384 KB) e integridad gzip | 10-04 | WebP (117 KB) | `6d9be2e6a6787d81d83ce115abbd2973f5a212559cc1b935b444723ee44b0f4b` |
| `EV-098` | Zona horaria `America/Costa_Rica`, estado activo de `cron.service` y crontab de root (diario a las 02:00 AM) | 10-05 | WebP (108 KB) | `65d31517e48acaaaf8d7eba3404ccb48e7c19cc98821be99619e8cf448225186` |
| `EV-099` | DRP en `moodle_restore_test`: importación de volcado, 494 tablas coincidentes (100%), cursos/usuarios y DROP | 10-06 | WebP (148 KB) | `2537144b71f42088610040d3642b2cd17edb761c983103515db9a92b3995e536` |

---

## 3. Incidentes y Hallazgos Técnicos

- **INC-012:** *Fallo de expansión de comodines en carpetas con permisos 0700 bajo sudo*.
  - Bash evalúa `*` en el contexto no privilegiado antes de ejecutar `sudo`. Al no tener permisos de lectura en `/var/backups/moodle`, pasa la cadena literal con asterisco a `gzip -t`, resultando en `No such file or directory`.
  - Solución adoptada: ejecutar mediante subshell de root `sudo sh -c 'gzip -t /var/backups/moodle/ctcr_moodle_*.sql.gz'` o utilizar rutas absolutas resueltas por variable.

---

## 4. Estado de Requisitos y Cierre de Fase

- **RC-05 (Respaldo Cron y Restauración):** Actualizado de `Pendiente` a **`CUMPLE (verificado local EV-096..EV-099)`** en `matriz-requisitos.md` y `ESTADO.md`.
- El bloque `10-respaldos` queda completamente ejecutado, verificado y documentado con base en las directrices institucionales del repositorio.
