# Sesión 2026-11-07 — Implementación y Verificación Integral de la Fase Opcional Multi-VM (Separación de Moodle y MariaDB)

- **Tipo:** Sesión operativa, arquitectónica y de verificación integral de alta disponibilidad en clúster multi-VM.
- **Responsable:** Cristhian Altamirano Montes con soporte de agente.
- **Máquinas:** VM 1 (Ubuntu Server Moodle `192.168.56.103` / `192.168.50.1`) y VM 2 (Ubuntu Server MariaDB `192.168.56.104`).
- **Objetivo:** Ejecutar y documentar exhaustivamente la Fase Opcional del proyecto final CTCR: configurar la red Host-Only punto a punto, aislar el servicio MariaDB en VM 2 vinculando el puerto 3306 a la interfaz privada, conectar Moodle en VM 1 a la base remota, verificar la matriz de aceptación de 8 puntos, ejecutar la prueba de corte controlado y tolerancia a fallos, transferir y ensayar la rutina DRP y tareas periódicas Cron en VM 2, y generar el paquete probatorio completo (EV-131 a EV-138).

---

## 1. Topología y Asignación de Interfaces (Paso 2.2, 2.3 y 3)

### 1.1. Configuración de Adaptadores VirtualBox y Netplan
- **VM 1 (Moodle):**
  - Adaptador 1: NAT (`enp0s3`, `10.0.2.15/24`) para salida a Internet.
  - Adaptador 2: Red interna LAN `intnet` (`enp0s8`, `192.168.50.1/24`) para atención de clientes (Mint).
  - Adaptador 3: Red solo-anfitrión / Host-Only (`enp0s9`). Se aplicó `/etc/netplan/99-ctcr-hostonly.yaml` con dirección fija `192.168.56.103/24`.
- **VM 2 (MariaDB):**
  - Adaptador 1: NAT (`enp0s3`, `10.0.2.15/24`).
  - Adaptador 2: Desactivado en VirtualBox para erradicar cualquier conflicto de colisión ARP con la IP `192.168.50.1`.
  - Adaptador 3: Red Host-Only (`enp0s9`). Se aplicó `/etc/netplan/99-ctcr-hostonly.yaml` con dirección fija `192.168.56.104/24`.

### 1.2. Comprobación de Red (EV-131)
- `ping -c 4 192.168.56.104` desde VM 1: 4 paquetes enviados, 4 recibidos, 0% packet loss, RTT 0.930 ms.
- `ping -c 4 192.168.56.103` desde VM 2: 4 paquetes enviados, 4 recibidos, 0% packet loss, RTT 1.060 ms.
- Acceso SSH automatizado sin contraseña configurado desde VM 1 hacia VM 2 (`ssh criss@192.168.56.104`) con llave `id_ed25519`.

---

## 2. Aislamiento y Configuración de MariaDB en VM 2 (Paso 4)

### 2.1. Desactivación de Servicios Innecesarios
- Contenedor Moodle detenido con `sudo docker compose stop moodle`.
- Servicios del host desactivados con `sudo systemctl disable --now nginx named vsftpd`.
- Servicio `cron` verificado como `active` para los respaldos programados.

### 2.2. Modificación de Compose y Publicación de Puerto (EV-132)
- Respaldo de seguridad creado: `cp -p compose.yaml compose.antes-red.yaml`.
- En `compose.yaml` se eliminó el servicio `moodle` y se agregó en `db`:
  ```yaml
  ports:
    - "192.168.56.104:3306:3306"
  ```
- Comprobación: `sudo docker compose port db 3306` devolvió `192.168.56.104:3306`.
- El puerto permanece cerrado a la interfaz LAN y a Internet.

### 2.3. Auditoría de Integridad de Datos (EV-133)
- Consultas SQL ejecutadas en el contenedor `db`:
  - Esquemas presentes: `information_schema`, `moodle`, `mysql`, `performance_schema`, `sys`.
  - Conteo de tablas en `moodle`: **494 tablas**.
  - Conteo de usuarios activos: **12 usuarios**.
  - Conteo de cursos departamentales: **3 cursos** (`CTCR-ADM-101`, `CTCR-DOC-101`, `CTCR-INF-101`).
- Estado de salud: `proyecto-moodle-db-1` en estado `healthy`.

---

## 3. Conexión de Moodle en VM 1 a MariaDB Remota (Paso 5)

### 3.1. Validación de Socket TCP
- Comprobación desde VM 1: `timeout 5 bash -c 'echo > /dev/tcp/192.168.56.104/3306' && echo "Conexion MariaDB: OK"` → `Conexion MariaDB: OK`.

### 3.2. Modificación de Compose y Arranque (EV-134)
- En VM 1: `cp -p compose.yaml compose.antes-red.yaml` y `sudo docker compose stop moodle db`.
- Se eliminó el bloque de servicio `db` y la directiva `depends_on: db`.
- Se configuraron las variables de conexión remota:
  ```yaml
  MOODLE_DB_HOST: 192.168.56.104
  MOODLE_DB_PORT: "3306"
  ```
- Puesta en marcha: `sudo docker compose up -d --no-deps moodle`.
- Verificación en `/var/www/moodle/config.php`:
  ```php
  $CFG->dbhost = '192.168.56.104';
  $CFG->dboptions = array ( ... 'dbport' => 3306 ... );
  ```
- Logs de Moodle:
  `[moodle] Connecting to the mariadb database at 192.168.56.104:3306`
  `[moodle] Moodle is ready at https://aulavirtual.ctcr`

---

## 4. Pruebas Funcionales, Tolerancia a Fallos y Servicios del Host (Paso 6)

### 4.1. Verificación HTTPS y Cursos (EV-135)
- `curl -kI https://aulavirtual.ctcr/`: código `200 OK`, emitido por Nginx con cookie segura `MoodleSession`.
- `curl -I http://aulavirtual.ctcr/`: redirección permanente `301 Moved Permanently` a HTTPS.
- Moodle CLI en PHP confirmó la lectura remota de los 3 cursos y el aislamiento por cohortes departamentales.

### 4.2. Prueba de Corte Controlado y Tolerancia a Fallos (EV-136)
- **Estado 1:** Moodle responde `200 OK`.
- **Estado 2:** Se detiene MariaDB en VM 2 (`sudo docker compose stop db`). Moodle en VM 1 responde HTTP `500` con `<div class='alert-danger'><p>Error: Database connection failed</p>`. Esto comprueba que Moodle no utiliza ninguna base de datos local residual.
- **Estado 3:** Se inicia MariaDB en VM 2 (`sudo docker compose up -d db`). Moodle en VM 1 recupera la conexión y responde `200 OK` de forma autónoma sin reiniciar el contenedor web.

### 4.3. Persistencia y FTPS (EV-137)
- `sudo docker compose restart moodle` reinició en 0.6s y devolvió `200 OK`.
- Servicios del host en VM 1: `vsftpd`, `nginx`, `named`, `cron` reportan estado `active`.
- `curl -k --ssl-reqd` hacia `192.168.50.1:21` autenticó con éxito a `marta.jimenez` y confirmó su enjaulamiento chroot con permisos `0700`.

---

## 5. Automatización de Respaldos, DRP y Cron (Paso 7, 8 y 9)

### 5.1. Ejecución de Respaldo y Ensayo DRP (EV-138)
- `sudo ./respaldo.sh` en VM 2 generó `/var/backups/moodle/ctcr_moodle_2026-11-07_00-01-09.sql.gz` (748 KB).
- `sudo ./restauracion-prueba.sh` en VM 2 importó el respaldo a `moodle_restore_test`, validando que:
  - 494 tablas coinciden exactamente.
  - 3 cursos coinciden exactamente.
  - 12 usuarios activos coinciden exactamente.
  - La base real `moodle` no sufrió modificaciones.
  - La base de ensayo fue purgada con éxito.

### 5.2. Reubicación de Cron
- En VM 1: se comentó la tarea de respaldo en el crontab de `root`.
- En VM 2: se validó activa la tarea `0 2 * * * /home/criss/proyecto-moodle/respaldo.sh >> /var/log/moodle-backup.log 2>&1`.

---

## 6. Inventario de Evidencias Incorporadas

| ID | Archivo WebP | Paso | Resumen Técnico | SHA-256 |
|---|---|:---:|---|---|
| **EV-131** | `13-01/evidencias/EV-131.webp` | `13-01` | Asignación IP Host-Only (`192.168.56.103` y `.104`) y ping bidireccional (0% pérdida). | `bb3477cf620f5da40ffc32853365420b9b2ed266221bf4e5f00de98e5d9a95d6` |
| **EV-132** | `13-02/evidencias/EV-132.webp` | `13-02` | Detención de Moodle/host en VM 2 y exposición de MariaDB en `192.168.56.104:3306`. | `f47dfa398e3073f8bf1a51c9e9d506aa95c51cfff6654fece355e845f1c703a0` |
| **EV-133** | `13-02/evidencias/EV-133.webp` | `13-02` | Auditoría de integridad de base de datos en VM 2 (494 tablas, 12 usuarios, 3 cursos). | `97e5bda1bfb1f55bfe6ab51220c9fe07e18cbfb8b9c831879721a60250079474` |
| **EV-134** | `13-03/evidencias/EV-134.webp` | `13-03` | Conexión remota TCP a MariaDB, Compose de Moodle y verificación de `$CFG->dbhost` en `config.php`. | `fc51d7a8f3867a8d79c7bf9b590f8dc0886b3db6721a0f9b1b616b47268c6c93` |
| **EV-135** | `13-04/evidencias/EV-135.webp` | `13-04` | Verificación web HTTPS 200 OK por Nginx, redirección 301 y lectura de cursos vía PHP CLI. | `c428abc1596b7a96f2091f3a8164461931da401840c85412bbfb4e5112ee4f58` |
| **EV-136** | `13-04/evidencias/EV-136.webp` | `13-04` | Prueba controlada de corte: fallo 500 al detener MariaDB en VM 2 y recuperación 200 OK inmediata. | `fb5d59b47a06c80d5a1a877081189c5c8cb0ba27b5a22a78103166860859ffa7` |
| **EV-137** | `13-04/evidencias/EV-137.webp` | `13-04` | Persistencia tras reinicio de Moodle, servicios host activos y conexión FTPS enjaulada 700. | `6da20f08a31b836a08905ab3f0ec791bdd817516d79caee36b3d19b7c5cf76a0` |
| **EV-138** | `13-05/evidencias/EV-138.webp` | `13-05` | Respaldo ACID en VM 2, ensayo DRP en `moodle_restore_test` coincidente 100% y Cron programado. | `e6e970273a8b3a885aaa64ecb24939bbf333776429ea9596036a9885cf432678` |
