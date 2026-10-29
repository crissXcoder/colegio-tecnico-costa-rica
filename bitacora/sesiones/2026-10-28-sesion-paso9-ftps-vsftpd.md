# Minuta de Sesión de Bitácora — Despliegue y Validación del Paso 9 (FTPS con Usuarios Institucionales y Enjaulamiento)

- **Fecha:** 2026-10-28 (20:25 a 20:35 CST)
- **Bloque:** `09-ftps-vsftpd` (Fase 7: FTPS Institucional y Enjaulamiento)
- **Integrantes / Operador:** criss (Estudiante EIF431O)
- **Revisor Técnico:** Antigravity AI Pair Programmer
- **Máquinas involucradas:** 
  - VM #1 Ubuntu Server (`192.168.50.1`) — Hostname: `server`
  - VM #2 Linux Mint (`192.168.50.101`) — Hostname: `criss-VirtualBox`
- **Objetivo:** Implementar el servicio FTPS seguro con `vsftpd 3.0.5`, habilitar 6 cuentas departamentales del Colegio Técnico de Costa Rica con shell restrictiva `/usr/sbin/nologin`, enjaulamiento chroot por usuario en `/srv/ftp/$USER/archivos` con permisos estrictos `0700`, forzar TLSv1.3 con certificados institucionales, verificar transferencias seguras, y validar rigurosamente el bloqueo de accesos cruzados tanto a nivel de sistema de archivos local como por protocolo FTP remoto desde Linux Mint.

---

## 1. Comandos Ejecutados y Resultados

1. **Instalación y Verificación de vsftpd (Paso 9.2):**
   - Comando: `sudo apt install -y vsftpd`
   - Versión verificada: `vsftpd: version 3.0.5`
   - Estado: `active` en systemd.
2. **Creación de Cuentas Institucionales y Shell Restrictiva (Paso 9.3):**
   - Habilitación de shell en `/etc/shells`: `grep -Fxq /usr/sbin/nologin /etc/shells || echo /usr/sbin/nologin | sudo tee -a /etc/shells`.
   - Creación de 6 cuentas mediante `useradd`:
     - Administración: `marta.jimenez` (UID 1006), `carlos.mendez` (UID 1007)
     - Docencia: `sofia.hernandez` (UID 1008), `jose.ramirez` (UID 1009)
     - Informática: `valeria.sanchez` (UID 1010), `diego.fernandez` (UID 1011)
   - Contraseña asignada: clave segura institucional mediante `chpasswd`.
   - Shell asignada: `/usr/sbin/nologin` (bloqueo total de sesiones de consola/SSH).
3. **Estructura de Directorios y Permisos de Enjaulamiento (Paso 9.4):**
   - Raíz institucional: `/srv/ftp/`
   - Directorios chroot de usuarios: `/srv/ftp/<usuario>/` (permisos `0755`, propietario `root:root`, obligatorio para chroot vsftpd).
   - Carpetas de trabajo privadas: `/srv/ftp/<usuario>/archivos/` (permisos `0700` `drwx------`, propietario `<usuario>:<usuario>`).
   - Directorio home del sistema actualizado con `usermod -d /srv/ftp/<usuario> <usuario>`.
4. **Lista Blanca de Usuarios Autorizados (Paso 9.5):**
   - Archivo: `/etc/vsftpd.user_list`.
   - Usuarios incluidos: los 6 usuarios institucionales (`marta.jimenez`, `carlos.mendez`, `sofia.hernandez`, `jose.ramirez`, `valeria.sanchez`, `diego.fernandez`), preservando adicionalmente las cuentas históricas del laboratorio (`wp_criss`, `coop_editor`, `coop_acopio`, `ftp_altamirano`).
5. **Configuración de vsftpd con FTPS y Enjaulamiento (Paso 9.6):**
   - Respaldo previo: `cp /etc/vsftpd.conf /etc/vsftpd.conf.bak`.
   - Directivas clave aplicadas en `/etc/vsftpd.conf`:
     - `listen_address=192.168.50.1` y `listen_port=21`.
     - `anonymous_enable=NO`, `local_enable=YES`, `write_enable=YES`, `local_umask=077`.
     - `chroot_local_user=YES`, `allow_writeable_chroot=NO`.
     - `user_sub_token=$USER`, `local_root=/srv/ftp/$USER`.
     - `ssl_enable=YES`, `rsa_cert_file=/etc/nginx/certs/aulavirtual.ctcr.crt`, `rsa_private_key_file=/etc/nginx/certs/aulavirtual.ctcr.key`.
     - `ssl_tlsv1=NO`, `ssl_sslv2=NO`, `ssl_sslv3=NO`, `ssl_tlsv1_2=NO`, `ssl_tlsv1_3=YES`.
     - `allow_anon_ssl=NO`, `force_local_data_ssl=YES`, `force_local_logins_ssl=YES`.
     - `pasv_enable=YES`, `pasv_min_port=40000`, `pasv_max_port=40010`.
     - `userlist_enable=YES`, `userlist_file=/etc/vsftpd.user_list`, `userlist_deny=NO`.
   - Reinicio del servicio: `sudo systemctl restart vsftpd` -> Estado `active (running)`.
   - Sockets verificados: `192.168.50.1:21` (vsftpd).
6. **Pruebas de Carga Departamental en Ubuntu Server (Paso 9.8):**
   - Se crearon documentos muestra en `/tmp`:
     - `expediente-administrativo.txt` ("CTCR - Expediente administrativo de prueba")
     - `planificacion-docente.txt` ("CTCR - Planificacion docente de prueba")
     - `informe-soporte.txt` ("CTCR - Informe de soporte tecnico de prueba")
   - Transferencia FTPS con `curl --ssl-reqd --insecure`:
     - Subida de Marta (`marta.jimenez`): `226 Transfer complete` bajo TLSv1.3 (`TLS_AES_256_GCM_SHA384`).
     - Subida de Sofía (`sofia.hernandez`): `226 Transfer complete` bajo TLSv1.3.
     - Subida de Valeria (`valeria.sanchez`): `226 Transfer complete` bajo TLSv1.3.
   - Verificación física: Cada archivo guardado con permisos `-rw-------` (600) en su respectivo directorio `/archivos/`.
7. **Pruebas de Aislamiento y Acceso Cruzado Denegado (Paso 9.9 y 9.10):**
   - **En el sistema de archivos local (Ubuntu Server):**
     - Intento de listado como Marta en la carpeta de Sofía: `sudo -u marta.jimenez ls -la /srv/ftp/sofia.hernandez/archivos` -> `ls: no se puede abrir el directorio: Permiso denegado`.
     - Intento de lectura de archivo ajeno: `sudo -u marta.jimenez cat /srv/ftp/sofia.hernandez/archivos/planificacion-docente.txt` -> `cat: Permiso denegado`.
   - **En conexión remota desde Linux Mint (`192.168.50.101`):**
     - Marta descarga su propio archivo: `curl --ssl-reqd --insecure -u marta.jimenez:*** ftp://192.168.50.1/archivos/expediente-administrativo.txt` -> 100% exitoso.
     - Marta intenta escape chroot hacia Sofía: `curl -v --ssl-reqd --insecure -u marta.jimenez:*** "ftp://192.168.50.1/../sofia.hernandez/archivos/"` -> Código `550 Failed to change directory`, error curl 9. Aislamiento total confirmado.

---

## 2. Evidencias Generadas (Paso 9.11)
- `EV-071` (`EV09_01_ubuntu_cuentas_y_carpetas_privadas.webp`) (SHA-256: `14a1caab133213e603ec1b85f6769a94d4391b98f10ea418ce2b46a9b6ed1df5`)
- `EV-072` (`EV09_02_ubuntu_ftps_upload_y_permisos_denegados.webp`) (SHA-256: `aa7927bfc405bc6884398d76239d8e0d8cfb070766b573d5ba414a11098e7dd6`)
- `EV-073` (`EV09_03_mint_ftps_remote_tests.webp`) (SHA-256: `62953761c3295e5ede907a09710e2ffe4d5b922fe4f024c89b48dbab5ba5c30c`)
- `EV-074` (`EV09_04_mint_ftps_desktop.webp`) (SHA-256: `a1481768e5cf52f5c6097590f38564fdb636dbcc1177d6353c83bc8febeae137`)

---

## 3. Estado de Repositorio y Criterios de Aceptación
- Evidencias y documentación integradas en el repositorio institucional (`docs/procedimientos/09-ftps-vsftpd/`, `evidencias/`).
- Criterio de aceptación RC-04: **CUMPLE (PASS)** al 100%.
