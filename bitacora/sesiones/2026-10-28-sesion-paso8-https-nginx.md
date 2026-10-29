# Minuta de Sesión de Bitácora — Despliegue y Validación del Paso 8 (Nginx HTTPS Reverse Proxy)

- **Fecha:** 2026-10-28 (20:10 a 20:25 CST)
- **Bloque:** `08-https-nginx` (Fase 6: Publicación Segura HTTPS)
- **Integrantes / Operador:** criss (Estudiante EIF431O)
- **Revisor Técnico:** Antigravity AI Pair Programmer
- **Máquinas involucradas:** 
  - VM #1 Ubuntu Server (`192.168.50.1`) — Hostname: `server`
  - VM #2 Linux Mint (`192.168.50.101`) — Hostname: `criss-VirtualBox`
- **Objetivo:** Desplegar Nginx 1.28.3 como reverse proxy con certificado SSL autofirmado (SAN: `aulavirtual.ctcr`, `moodle.ctcr.test`), configurar redirección 301 en puerto 80 y proxy SSL en puerto 443 hacia Moodle en `127.0.0.1:8080`, actualizar `compose.yaml` (URL `https://aulavirtual.ctcr` y `MOODLE_SSL_PROXY: "yes"`), validar sintaxis, purgar cachés y comprobar navegación real desde Linux Mint.

---

## 1. Comandos Ejecutados y Resultados

1. **Liberación de Puertos y Detención de Apache2:**
   - Comandos: `sudo systemctl stop apache2 && sudo systemctl disable apache2`
   - Resultado: Puertos 80 y 443 liberados por completo para evitar colisión de sockets.
2. **Instalación de Nginx 1.28.3 y OpenSSL (Paso 8.1):**
   - Comandos: `sudo apt update && sudo apt install -y nginx openssl`
   - Versión verificada: `nginx version: nginx/1.28.3 (Ubuntu)` (paquete `1.28.3-2ubuntu1.12`).
   - Estado: `active` en systemd.
3. **Generación del Certificado SSL (Paso 8.2):**
   - Directorio: `/etc/nginx/certs`
   - Comando: `sudo openssl req -x509 -nodes -days 365 -newkey rsa:3072 -keyout /etc/nginx/certs/aulavirtual.ctcr.key -out /etc/nginx/certs/aulavirtual.ctcr.crt -subj "/C=CR/O=Colegio Tecnico de Costa Rica/CN=aulavirtual.ctcr" -addext "subjectAltName=DNS:aulavirtual.ctcr,DNS:moodle.ctcr.test"`
   - Permisos: `chmod 600` en clave privada.
   - Verificación con `openssl x509`: Sujeto, vigencia y extensiones SAN verificadas exitosamente.
4. **Configuración de VirtualHost Nginx (Pasos 8.3 y 8.4):**
   - Archivo: `/etc/nginx/sites-available/aulavirtual.ctcr` habilitado en `sites-enabled/`.
   - Sitio por defecto deshabilitado (`rm /etc/nginx/sites-enabled/default`).
   - Sintaxis: `sudo nginx -t` -> `syntax is ok / test is successful`.
   - Reinicio: `sudo systemctl restart nginx` -> `active`.
   - Sockets verificados: `192.168.50.1:80` y `192.168.50.1:443`.
5. **Actualización de Docker Compose (Pasos 8.5 y 8.6):**
   - Respaldo: `cp compose.yaml compose-http.backup.yaml`.
   - Cambios: `ports: - "127.0.0.1:8080:8080"`, `MOODLE_URL: https://aulavirtual.ctcr`, `MOODLE_SSL_PROXY: "yes"`.
   - Recreación: `sudo docker compose up -d`.
   - Estado de contenedores: `proyecto-moodle-db-1` y `proyecto-moodle-moodle-1` ambos en estado `healthy`.
   - Verificación wwwroot: `CFG->wwwroot` devuelve `https://aulavirtual.ctcr` y `CFG->sslproxy: '1'`.
   - Purga de cachés: `moodle-cli purge_caches` ejecutado exitosamente.
6. **Pruebas de Conectividad HTTP/HTTPS en Ubuntu Server (Paso 8.7):**
   - `curl -k -I https://aulavirtual.ctcr` -> `HTTP/1.1 200 OK`, `Server: nginx/1.28.3 (Ubuntu)`, cookie `secure`.
   - `curl -I http://192.168.50.1 -H "Host: aulavirtual.ctcr"` -> `HTTP/1.1 301 Moved Permanently` a `https://aulavirtual.ctcr/`.
7. **Pruebas en Vivo desde Linux Mint (Paso 8.8):**
   - `curl -I http://aulavirtual.ctcr` -> 301 a HTTPS.
   - `curl -k -I https://aulavirtual.ctcr` -> 200 OK.
   - Navegación gráfica en Mozilla Firefox mediante Selenium: página `https://aulavirtual.ctcr/` cargada con título `Home | CTCR`, cursos y usuarios íntegros.

---

## 2. Evidencias Generadas (Paso 8.9)
- `EV-067` (`EV08_01_ubuntu_nginx_config_y_check.webp`) (SHA-256: `61f46ecd3aaebe70b091afb8a32cc0abe9e8440677d9b2199d2d51887ab1ddc0`)
- `EV-068` (`EV08_02_ubuntu_moodle_compose_wwwroot_curl.webp`) (SHA-256: `c20d300b101b07a9a43f5c59dc271f781508066d695839fd35bb439ba6006d03`)
- `EV-069` (`EV08_03_mint_firefox_https.webp`) (SHA-256: `0c3e7127306196de8560e7775eaf3d605dce083ad0e170e72b248ffd8db45e5a`)
- `EV-070` (`EV08_04_mint_https_desktop.webp`) (SHA-256: `f58e4ac03277e7124c58c9801dbe4642bcc4032dba143e4eeefcab75a8d54580`)

---

## 3. Estado de Repositorio y Criterios de Aceptación
- Evidencias y documentación integradas en el repositorio institucional (`docs/procedimientos/08-https-nginx/`, `evidencias/`).
- Criterio de aceptación RC-02: **CUMPLE (PASS)** al 100%.
