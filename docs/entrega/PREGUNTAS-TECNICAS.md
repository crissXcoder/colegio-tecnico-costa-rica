# Banco de preguntas técnicas para practicar

**Para quién:** los cinco integrantes. El profesor elige en el momento quién responde, así que **todos** deben poder contestar cualquier bloque.
**Cómo practicar:** cada integrante saca una pregunta al azar, la responde en la VM con el comando y explica la salida en voz alta en menos de un minuto. Rotar hasta que cada persona haya pasado por todos los bloques.

**Si no se sabe algo:** decirlo («no lo sé con certeza; lo verificaría con …») vale más que inventar. La rúbrica evalúa reconocer lo que no se sabe.

Todos los comandos son de **solo lectura**, salvo que se indique.

## A. Docker y Compose

| Pregunta | Comando | Cómo leer la salida | Trampa |
|---|---|---|---|
| ¿Qué contenedores corren y están sanos? | `sudo docker compose ps` | `STATUS` debe decir `Up … (healthy)`. `PORTS` de moodle: `127.0.0.1:8080->8080/tcp`; db no publica puertos. | Correrlo fuera de `~/proyecto-moodle` da «no configuration file provided». |
| ¿Qué versión exacta de cada imagen usan? | `sudo docker images --digests` | Etiquetas `4.5.15` y `11.4.13` y su digest `sha256:…`. | La etiqueta puede reconstruirse; el digest identifica la imagen exacta. |
| ¿Dónde se guardan los datos? | `sudo docker volume ls`<br>`sudo docker volume inspect proyecto-moodle_mariadb_data` | Tres volúmenes; `Mountpoint` bajo `/var/lib/docker/volumes/`. | — |
| ¿Qué pasa si hago `docker compose down`? ¿Y `down -v`? | (explicar, no ejecutar) | `down` borra contenedores y red, **no** los volúmenes: al hacer `up -d` vuelven los datos. `down -v` **borra los volúmenes**: Moodle queda vacío. | — |
| ¿Por qué Moodle espera a la base de datos? | `grep -A3 depends_on compose.yaml` | `condition: service_healthy`: Moodle arranca cuando el healthcheck de MariaDB pasa. | — |
| ¿Cómo ve los registros de Moodle? | `sudo docker compose logs --tail=50 moodle` | Últimas líneas; buscar errores de conexión a `db`. | Sin `--tail` llena la pantalla. |
| ¿Dónde están las contraseñas? | `ls -l .env` | Permisos `-rw-------` (600). | **No** mostrar el contenido con `cat .env`. |

## B. Moodle: roles, cohortes y aislamiento

| Pregunta | Dónde o comando | Respuesta esperada |
|---|---|---|
| ¿Qué impide que Marta entre al curso de Informática? | Curso → Participantes → Métodos de matriculación | En Informática solo hay «Sincronizar cohorte (Personal de Informática)» y la matrícula manual del profesor. Marta no está en esa cohorte ni matriculada manualmente, e invitados y auto-matriculación están desactivados. |
| ¿Por qué no basta con categorías? | (explicar) | Las categorías solo ordenan cursos. El acceso lo decide la matrícula. |
| ¿Cohorte o grupo? | (explicar) | La cohorte es de sitio y decide quién entra al curso; el grupo vive dentro de un curso y solo organiza. |
| ¿Por qué los profesores no están en la cohorte? | (explicar) | La cohorte matricula con rol Estudiante; los profesores van por matrícula manual con rol Profesor. Si estuvieran en la cohorte, serían también estudiantes. |
| ¿Por qué el PDF da «archivo no encontrado» y no «acceso denegado»? | (explicar, EV-095) | Moodle no entrega archivos de cursos donde la persona no está matriculada. Lo que importa es que el contenido no se entrega. |
| ¿Cómo comprueban que un profesor no administra el sitio? | Iniciar como `daniel.vargas` y abrir `https://aulavirtual.ctcr/admin/` | Moodle niega el acceso; en su menú no aparece «Administración del sitio». |
| ¿Por qué no probar con `admin`? | (explicar) | El administrador del sitio ve todo: daría siempre «permitido». |

## C. DNS (BIND9)

| Pregunta | Comando | Cómo leer la salida |
|---|---|---|
| ¿Quién resuelve `aulavirtual.ctcr`? | `dig @192.168.50.1 aulavirtual.ctcr` | `status: NOERROR`, bandera `aa` (respuesta autoritativa) y `ANSWER: aulavirtual.ctcr. … A 192.168.50.1`. |
| ¿La configuración es válida? | `sudo named-checkconf && sudo named-checkzone ctcr /etc/bind/db.ctcr` | Sin salida el primero; el segundo `loaded serial 2026102401` y `OK`. |
| ¿Por qué `.ctcr` y no un dominio real? | (explicar) | Es una zona privada del laboratorio; solo la resuelve nuestro BIND9 en la red interna. |
| ¿Qué es el número de serie del SOA? | `grep -A2 SOA /etc/bind/db.ctcr` | Versión de la zona; se incrementa en cada cambio (formato fecha + número). |
| ¿Mint usa nuestro DNS? | En Mint: `resolvectl status` o `nmcli device show enp0s3 \| grep DNS` | Debe aparecer `192.168.50.1`. `getent hosts` solo prueba que resolvió, no quién respondió. |
| ¿Por qué Ubuntu no resolvía su propio dominio? | (explicar, INC-013) | `systemd-resolved` en Ubuntu no consultaba a BIND9; se resolvió con `/etc/hosts`. |

## D. Nginx y HTTPS

| Pregunta | Comando | Cómo leer la salida |
|---|---|---|
| ¿La configuración de Nginx es válida? | `sudo nginx -t` | `syntax is ok` y `test is successful`. |
| ¿En qué puertos escucha? | `sudo ss -lntp \| grep nginx` | `192.168.50.1:80` y `192.168.50.1:443`. |
| ¿Qué hace el puerto 80? | `curl -I http://aulavirtual.ctcr` | `301 Moved Permanently` con `Location: https://aulavirtual.ctcr/`. |
| ¿A quién reenvía Nginx? | `sudo grep proxy_pass /etc/nginx/sites-available/aulavirtual.ctcr` | `http://127.0.0.1:8080`, el contenedor de Moodle. |
| ¿Qué certificado usan y hasta cuándo vale? | `sudo openssl x509 -in /etc/nginx/certs/aulavirtual.ctcr.crt -noout -subject -enddate -ext subjectAltName` | `CN=aulavirtual.ctcr`, `DNS:aulavirtual.ctcr`, vence un año después de crearlo. |
| ¿Por qué el navegador advierte? | (explicar) | Es autofirmado: ninguna autoridad de confianza lo firmó. Cifra igual; para producción se usaría una CA. |
| ¿Por qué Moodle sabe que está en HTTPS si Nginx le habla en HTTP? | `grep -E "MOODLE_URL\|SSL_PROXY" compose.yaml` | `MOODLE_URL=https://aulavirtual.ctcr` y `MOODLE_SSL_PROXY=yes`. |
| ¿Qué significa un 502? | (explicar, INC-015) | Nginx no pudo hablar con `127.0.0.1:8080`: Moodle caído o arrancando. |

## E. FTPS (vsftpd)

| Pregunta | Comando | Cómo leer la salida |
|---|---|---|
| ¿Está activo y qué versión? | `systemctl is-active vsftpd; vsftpd -v` | `active`; `version 3.0.5`. |
| ¿Cómo se encierra a cada usuario? | `grep -E "chroot_local_user\|local_root\|user_sub_token\|allow_writeable_chroot" /etc/vsftpd.conf` | `chroot_local_user=YES`, `local_root=/srv/ftp/$USER`, `user_sub_token=$USER`. |
| ¿Por qué la raíz del usuario es de root? | `sudo ls -ld /srv/ftp/marta.jimenez /srv/ftp/marta.jimenez/archivos` | Raíz `root:root 755`; `archivos/` del usuario con `700`. vsftpd rechaza una raíz escribible dentro del chroot (INC-010). |
| ¿Se exige cifrado? | `grep -E "ssl_enable\|force_local" /etc/vsftpd.conf` | `ssl_enable=YES` y `force_local_logins_ssl` / `force_local_data_ssl` en `YES`. |
| ¿Para qué son los puertos 40000–40010? | `grep pasv /etc/vsftpd.conf` | Modo pasivo: el cliente abre la conexión de datos hacia ese rango. Si un firewall lo bloquea, el login funciona pero `ls` se cuelga. |
| ¿Pueden entrar por SSH los usuarios FTP? | `getent passwd marta.jimenez` | Shell `/usr/sbin/nologin`. |

## F. Respaldos y restauración

| Pregunta | Comando | Cómo leer la salida |
|---|---|---|
| ¿Cuándo corre el respaldo? | `sudo crontab -l` | `0 2 * * *` = todos los días a las 02:00. Es el crontab de **root**. |
| ¿Dónde quedan y cuántos se guardan? | `sudo ls -lh /var/backups/moodle` | Archivos `ctcr_moodle_<fecha>.sql.gz`; se borran los de más de 7 días. |
| ¿Cómo sabe que el respaldo sirve? | `sudo gzip -t <archivo>` + `restauracion-prueba.sh` | `gzip -t` solo prueba que el archivo no está dañado. La prueba real es restaurarlo en `moodle_restore_test` y comparar tablas. |
| ¿Por qué no restaurar sobre `moodle`? | (explicar) | Se perderían los datos posteriores al respaldo y la plataforma quedaría inconsistente si algo falla. |
| ¿Qué no cubre el respaldo? | (explicar, 10-07) | Los archivos de `moodledata` (PDF subidos, etc.). Para eso está el procedimiento de copia del volumen. |
| ¿Qué pasa si la VM está apagada a las 02:00? | (explicar) | Cron no recupera ejecuciones perdidas; ese día no hay respaldo. |

## G. Red, sistema y firewall

| Pregunta | Comando | Cómo leer la salida |
|---|---|---|
| ¿Qué interfaces tiene el servidor? | `ip -br -4 addr` | `enp0s3` 10.0.2.15 (NAT, salida a Internet); `enp0s8` 192.168.50.1 (red interna con Mint); interfaces `br-…` y `docker0` de Docker. |
| ¿Qué servicios escuchan? | `sudo ss -lntup` | Identificar 53, 80, 443, 21, 127.0.0.1:8080 y explicar cualquier otro (por ejemplo, bases de datos del host de otras prácticas). |
| ¿Usan firewall? | `sudo iptables -S` / `sudo ufw status verbose` | Ver [ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md): en la VM #1 el filtrado es con iptables y UFW no está instalado. |
| ¿Por qué no activar UFW sin más? | (explicar) | Puede cortar la sesión SSH y entrar en conflicto con las reglas que Docker crea en iptables. |
| ¿Cuánto disco queda? | `df -h /` | Porcentaje de uso de la raíz; recordar INC-001 (LVM ampliado de 12 a 23 GB). |
| ¿Cuánto espacio ocupa Docker? | `sudo docker system df` | Imágenes, contenedores y volúmenes. |
