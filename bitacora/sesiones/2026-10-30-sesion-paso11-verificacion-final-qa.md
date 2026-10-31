# Minuta de Sesión de Bitácora — Despliegue, Validación Cruzada y QA Final del Paso 11

- **Fecha:** 2026-10-30 (17:15 a 18:30 CST)
- **Bloque:** `11-verificacion` (Fase 9: Verificación final del proyecto / QA transversal e integral)
- **Integrantes / Operador:** criss (Estudiante EIF431O)
- **Revisor Técnico:** Antigravity AI Pair Programmer
- **Máquinas involucradas:**
  - VM #1 Ubuntu Server (`192.168.50.1`) — Hostname: `server`
  - VM #2 Linux Mint (`192.168.50.101`) — Hostname: `criss-VirtualBox`
- **Objetivo:** Ejecutar la batería integral y transversal de pruebas de aceptación del Paso 11 sobre los servicios acumulados de la infraestructura del Colegio Técnico de Costa Rica (Moodle LMS, MariaDB en Docker, BIND9, Nginx HTTPS Reverse Proxy, vsftpd con FTPS y Cron de respaldos), demostrando el correcto funcionamiento interconectado, la respuesta a pruebas negativas (aislamiento departamental estricto, rechazo de accesos cruzados a recursos educativos, confinamiento enjaulado de FTPS) y la resiliencia operativa tras reinicio de contenedores y prueba de recuperación ante desastres (DRP).

---

## 1. Comandos Ejecutados, Diagnósticos y Resultados por Subpaso

### 11.1. Comprobación de Docker y URL Canónica de Moodle
- **Comandos ejecutados:**
  ```bash
  cd ~/proyecto-moodle
  sudo docker compose ps
  sudo docker compose exec moodle php -r 'define("CLI_SCRIPT", true); require "/var/www/moodle/config.php"; echo $CFG->wwwroot, PHP_EOL;'
  ```
- **Resultados observados:**
  - Contenedores activos y saludables: `proyecto-moodle-moodle-1` (`oksigenia/moodle:4.5.15`, status: `Up ... (healthy)`) y `proyecto-moodle-db-1` (`mariadb:11.4.13`, status: `Up ... (healthy)`).
  - La URL canónica devuelta por `$CFG->wwwroot` es exactamente: `https://aulavirtual.ctcr`.
  - Nota de seguridad: Se aplicó `define("CLI_SCRIPT", true);` para satisfacer la protección de `config.php` (antecedente en `INC-005`).
- **Evidencia generada:** [`EV-100.webp`](../../docs/procedimientos/11-verificacion/11-01/evidencias/EV-100.webp) (Ficha [`EV-100.md`](../../docs/procedimientos/11-verificacion/11-01/evidencias/EV-100.md)).

### 11.2. Comprobación de Servicios del Sistema (Systemd)
- **Comandos ejecutados:**
  ```bash
  sudo systemctl is-active named
  sudo systemctl is-active nginx
  sudo systemctl is-active vsftpd
  sudo systemctl is-active cron
  ```
- **Resultados observados:**
  - Los cuatro servicios retornaron unánimemente el estado `active`.
  - Adicionalmente, `systemctl is-enabled` confirmó que todos están habilitados para iniciar automáticamente con el sistema.

### 11.3. Verificación de Sockets y Puertos Escuchando (ss)
- **Comando ejecutado:**
  ```bash
  sudo ss -lntup | grep -E ':(21|53|80|443|8080|3306)\b'
  ```
- **Resultados observados:**
  - Puerto `21/TCP`: `vsftpd` en `0.0.0.0:21` (FTPS explícito con rango pasivo `40000:40010`).
  - Puerto `53/TCP y UDP`: `named` (BIND9 9.20.24) en `192.168.50.1:53` (LAN) y `127.0.0.1:53`.
  - Puerto `80/TCP`: `nginx` (1.28.3) en `0.0.0.0:80` (redirección 301 obligatoria hacia HTTPS).
  - Puerto `443/TCP`: `nginx` en `0.0.0.0:443` (terminación TLS con certificado `aulavirtual.ctcr`).
  - Puerto `8080/TCP`: `docker-proxy` enlazado estrictamente en `127.0.0.1:8080` (cerrado a la red LAN).
  - Puerto `3306/TCP`: No expuesto en interfaces del host por Docker; MariaDB se comunica exclusivamente con Moodle a través de la red interna de puente `proyecto-moodle_backend`.
- **Evidencia generada:** [`EV-101.webp`](../../docs/procedimientos/11-verificacion/11-03/evidencias/EV-101.webp) (Ficha [`EV-101.md`](../../docs/procedimientos/11-verificacion/11-03/evidencias/EV-101.md)).

### 11.4. Auditoría de Firewall (iptables / UFW)
- **Comandos ejecutados:**
  ```bash
  sudo ufw status verbose
  sudo iptables -S FORWARD
  sudo iptables -t nat -S POSTROUTING
  ```
- **Resultados observados:**
  - `ufw` reporta `Status: inactive` (política institucional intencionada para no interferir con las cadenas dinámicas de Docker ni el filtrado NAT).
  - Reglas de reenvío en `iptables`:
    - `-A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT` (tráfico LAN hacia Internet autorizado).
    - `-A FORWARD -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT`.
  - Regla NAT de enmascaramiento:
    - `-A POSTROUTING -o enp0s3 -j MASQUERADE` (permite a Linux Mint navegar a Internet a través de Ubuntu Server).
- **Evidencia generada:** [`EV-102.webp`](../../docs/procedimientos/11-verificacion/11-04/evidencias/EV-102.webp) (Ficha [`EV-102.md`](../../docs/procedimientos/11-verificacion/11-04/evidencias/EV-102.md)).

### 11.5. Pruebas de Red y Navegación desde Linux Mint (VM #2)
- **Comandos ejecutados vía SSH en Linux Mint (`192.168.50.101`):**
  ```bash
  ping -c 4 192.168.50.1
  getent ahostsv4 aulavirtual.ctcr
  curl -k -I http://aulavirtual.ctcr
  curl -k -I https://aulavirtual.ctcr
  ```
- **Resultados observados:**
  - `ping`: 4 paquetes transmitidos, 4 recibidos, **0% de pérdida**, latencia promedio `< 0.5 ms`.
  - `getent`: Resolución DNS inmediata de `aulavirtual.ctcr` devolviendo la IP `192.168.50.1`.
  - `curl HTTP`: Código `HTTP/1.1 301 Moved Permanently` con cabecera `Location: https://aulavirtual.ctcr/`.
  - `curl HTTPS`: Código `HTTP/1.1 200 OK` con servidor Nginx y contenido Moodle.
  - Resolución local en Ubuntu Server saneada registrando `192.168.50.1 aulavirtual.ctcr` en `/etc/hosts` (documentado en `INC-013`).
- **Evidencia generada:** [`EV-103.webp`](../../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.webp) (Ficha [`EV-103.md`](../../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.md)).

### 11.6. Pruebas Funcionales y Negativas de Departamentos y Evaluaciones
- **Acciones y comprobaciones ejecutadas:**
  1. *Acceso legítimo de estudiante:* Marta Jiménez (`marta.jimenez`, Depto. Administración) ingresa a su curso legítimo `CTCR-ADM-101` y abre con éxito sus recursos didácticos (`HTTP 200 OK`).
  2. *Prueba negativa de aislamiento departamental:* Marta Jiménez intenta abrir directamente por URL el curso ajeno de Informática (`https://aulavirtual.ctcr/course/view.php?id=4`) y sus recursos protegidos (`mod/resource/view.php?id=...`). Moodle intercepta la petición, deniega el acceso y redirige con código `303 See Other` hacia el aviso de error por falta de matrícula.
  3. *Evaluaciones completadas con calificación perfecta (100/100):*
     - Sofía Hernández (`sofia.hernandez`, Docencia) resolvió el cuestionario `CTCR-DOC-101` (5/5 preguntas correctas, ponderación 20 pts cada una, calificación obtenida: **100.00 / 100.00**).
     - Valeria Sánchez (`valeria.sanchez`, Informática) resolvió el cuestionario `CTCR-INF-101` (5/5 preguntas correctas, calificación obtenida: **100.00 / 100.00**).
     - Se superó el error de métodos de API de Moodle 4.5 documentado en `INC-014`.
  4. *Revisión de calificaciones por el docente:* El profesor Daniel Vargas (`daniel.vargas`, Depto. Informática) accede a su curso y consulta el calificador general (`grade/report/grader/index.php?id=4`), verificando la calificación de 100.00 registrada para Valeria Sánchez.
- **Evidencias generadas:**
  - [`EV-104.webp`](../../docs/procedimientos/11-verificacion/11-06/evidencias/EV-104.webp) (Ficha [`EV-104.md`](../../docs/procedimientos/11-verificacion/11-06/evidencias/EV-104.md) — Acceso Marta ADM y rechazo estricto a recurso ajeno INF).
  - [`EV-105.webp`](../../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.webp) (Ficha [`EV-105.md`](../../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.md) — Cuestionarios resueltos 100/100 y vista de notas de Daniel Vargas).

### 11.7. Pruebas de Resiliencia de Infraestructura, Seguridad FTPS y DRP
- **Acciones y comprobaciones ejecutadas:**
  1. *Prueba de persistencia ante reinicio de contenedores:*
     - Se ejecutó `sudo docker compose restart` en `/home/criss/proyecto-moodle`.
     - Tras el reinicio, se confirmó que los 4 cursos y los 12 usuarios institucionales continúan intactos en la base de datos sin pérdida de configuración ni de calificaciones.
  2. *Prueba de seguridad FTPS (Enjaulamiento Chroot):*
     - Conexión con usuario departamental `carlos.mendez`.
     - Intento de escape hacia `/etc` o hacia el directorio personal de otro docente (`/srv/ftp/sofia.hernandez`).
     - El servidor `vsftpd` denegó terminantemente el acceso arrojando `550 Failed to change directory`.
  3. *Prueba de Recuperación ante Desastres (DRP) en esquema aislado:*
     - Se tomó el volcado de respaldo más reciente generado por Cron (`/var/backups/moodle/ctcr_moodle_*.sql.gz`).
     - Se importó desatendidamente en una base de datos temporal `moodle_restore_test`.
     - Se realizó el conteo de tablas: la base restaurada contiene exactamente **494 tablas**, logrando un **100% de coincidencia estructural** con la base en producción.
     - Se ejecutó la posterior limpieza de la base de prueba (`DROP DATABASE moodle_restore_test`).
- **Evidencia generada:** [`EV-106.webp`](../../docs/procedimientos/11-verificacion/11-07/evidencias/EV-106.webp) (Ficha [`EV-106.md`](../../docs/procedimientos/11-verificacion/11-07/evidencias/EV-106.md)).

---

## 2. Evidencias Integradas al Manifiesto y Catálogo Maestro

| Identificador | Descripción Técnica | Subpaso | Formato / Tamaño | SHA-256 |
|---|---|---|---|---|
| `EV-100` | Docker compose ps (moodle y db healthy) y verificación PHP CLI de wwwroot canónico `https://aulavirtual.ctcr` | 11-01 | WebP (119 KB) | `f599986bbcf28c04ec471cead83cc06f85d263a2aebda39ecf937d45bb41f237` |
| `EV-101` | Sockets escuchando con `ss -lntup`: puertos 21, 53, 80, 443; 8080 en loopback y MariaDB aislado | 11-03 | WebP (117 KB) | `bf22a27a4eecdeab562c5ebc00d4352dc0029b9f3fe2b45053229b9be5735e23` |
| `EV-102` | Auditoría de firewall: ufw inactivo, cadenas iptables FORWARD LAN->WAN y regla MASQUERADE | 11-04 | WebP (123 KB) | `bb1dff635b75fcfa1fc953b0060935105230ef1d48c90382379308ce7a69bc92` |
| `EV-103` | Verificación en Linux Mint: ping 0% pérdida, getent ahostsv4, curl HTTP 301 y HTTPS 200 OK | 11-05 | WebP (126 KB) | `8f8287e07664e43eb91fe69b59e37da48bb922dd81a953e54b67966f91d57540` |
| `EV-104` | Pruebas de departamento: acceso de Marta a ADM y rechazo directo (303) al intentar acceder a INF | 11-06 | WebP (148 KB) | `ff4624b6131c38cc0807b1b369da8a509aeec7d32c45e54d6fa0a38cc43063cb` |
| `EV-105` | Cuestionarios resueltos (100/100 para Valeria y Sofía) y vista de notas de Daniel Vargas | 11-06 | WebP (152 KB) | `797d5a574ec8b2ce3a0fe68194a2b97282b09a7b973e6a0d481f3b26c7150993` |
| `EV-106` | Pruebas de infraestructura: reinicio sin pérdida de datos, enjaulamiento FTPS y DRP con 494 tablas | 11-07 | WebP (147 KB) | `2ec27438259d0476e3dbe75924d5ba7b2cfca7b57b11634bda7b2355dd489a20` |

---

## 3. Incidentes y Hallazgos Técnicos de la Sesión

- **INC-013:** *Discrepancia de resolución DNS local en Ubuntu Server con systemd-resolved*.
  - Las consultas del propio host no consultaban BIND9 en `192.168.50.1:53` por colisión de loopback resuelta en `INC-002`.
  - Solución: Registro estático de `192.168.50.1 aulavirtual.ctcr moodle.ctcr.test` en `/etc/hosts` de Ubuntu Server.
- **INC-014:** *Excepción por métodos desactualizados en la API de Question Engine de Moodle 4.5*.
  - En Moodle 4.5, `$quizobj->get_slots()` fue refactorizado a `$quizobj->get_structure()->get_slots()` y `save_usage_by_activity()` fue reemplazado por `save_questions_usage_by_activity($quba)`.
  - Solución: Adaptación de la automatización CLI respetando las firmas de la API moderna de Moodle 4.5.

---

## 4. Estado de Requisitos y Cierre de Fase

Con la culminación de la batería de pruebas del Paso 11:
- **RC-03 (Moodle+DB Docker, volumen, persistencia):** Actualizado a **`CUMPLE (verificado local EV-100, EV-106)`**.
- **RE-02 (Tres grupos/cohortes con acceso exclusivo):** Actualizado a **`CUMPLE (verificado local EV-104, EV-105, EV-057, EV-085..EV-089)`**.
- **RE-03 (Prueba de denegación de recurso ajeno):** Actualizado a **`CUMPLE (verificado local EV-104)`**.
- **RX-01 (Rol profesor no superusuario funcional):** Actualizado a **`CUMPLE (verificado local EV-105)`**.
- **T-01 a T-10 (Criterios de Aceptación Críticos):** 10/10 evaluados y marcados como **PASS** en [`pruebas/MATRIZ-QA-FINAL.md`](../../pruebas/MATRIZ-QA-FINAL.md).
