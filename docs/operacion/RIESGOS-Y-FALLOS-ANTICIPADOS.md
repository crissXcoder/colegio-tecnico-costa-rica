# Riesgos y fallos anticipados

**Qué es este documento:** casos de error que **todavía no ocurrieron** en el proyecto, pero que pueden ocurrir al reiniciar las VMs, armar la entrega o presentar. Para cada uno: cómo se nota, cómo confirmarlo, qué hacer sin destruir datos y cómo prevenirlo.
**Qué no es:** los errores que sí ocurrieron están en [`bitacora/incidentes/`](../../bitacora/README.md) (INC-001 a INC-019). Si uno de estos riesgos llega a ocurrir, se abre un incidente nuevo con la [plantilla](../../plantillas/incidente.md) y se enlaza aquí.

**Regla general ante cualquier fallo:** primero diagnosticar con comandos de solo lectura. Nunca usar como primer intento `docker compose down -v`, `docker system prune`, `DROP DATABASE`, `lvextend`, `ufw enable` ni reinstalar paquetes.

Chequeo automático de la mayoría de estos riesgos: [`scripts/verificar-servicios.sh`](../../scripts/verificar-servicios.sh).

## 1. Arranque de las VMs y red

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-01 | Docker no arranca solo al encender la VM. | `docker compose ps` vacío; `systemctl is-enabled docker` dice `disabled`. | `sudo systemctl start docker` y luego `sudo docker compose up -d` en la carpeta del proyecto. | `sudo systemctl enable docker`. Los servicios tienen `restart: unless-stopped`. |
| R-02 | Los contenedores siguen en `health: starting` al empezar la demo. | `docker compose ps`; Nginx responde 502. | Esperar: Moodle tarda alrededor de un minuto. Revisar `docker compose logs --tail=30 moodle`. | Encender todo una hora antes y correr `verificar-servicios.sh`. |
| R-03 | VirtualBox cambia el nombre de la «Red interna» (por clonar la VM o importar en otra computadora) y Mint ya no ve al servidor. | `ping 192.168.50.1` falla desde Mint; ambas VMs tienen IP pero no se ven. | En VirtualBox, ambas VMs → Red → Adaptador de red interna → **mismo nombre de red**. | Anotar el nombre de la red interna en el inventario de cada integrante. |
| R-04 | Dos servidores con la misma IP `192.168.50.1` en la misma red interna (dos integrantes en una misma computadora anfitriona). | Respuestas intermitentes; `ip neigh` en Mint muestra MAC distinta a la esperada. | Encender solo el servidor de la demostración. | Una sola VM servidor encendida durante el ensayo y la demo. |
| R-05 | La hora de la VM está atrasada o adelantada (por ejemplo, tras restaurar un snapshot). | `timedatectl` muestra `System clock synchronized: no`; el certificado puede aparecer como «aún no válido»; Cron corre a otra hora. | `sudo timedatectl set-ntp true` (requiere salida NAT). | Revisar `timedatectl` en el chequeo previo. |
| R-06 | Se restaura un snapshot viejo de VirtualBox «para arreglar algo». | Desaparecen cursos, usuarios, respaldos o configuraciones recientes; los hashes no coinciden. | No hay vuelta atrás desde la VM: tomar el último respaldo SQL y la configuración del paquete. | No restaurar snapshots la semana de la entrega sin acuerdo del grupo. Tomar uno **después** de armar el paquete. |

## 2. Docker, Compose y datos

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-07 | Alguien ejecuta `docker compose up -d` desde **otra carpeta** (por ejemplo, la del paquete con `docker-compose.yml`). | Moodle aparece como recién instalado, sin cursos; `docker volume ls` muestra volúmenes con otro prefijo (`entrega-ctcr_…`). | No borrar nada. `docker compose down` **en esa carpeta** (sin `-v`) y volver a `~/proyecto-moodle` con `docker compose up -d`. Los volúmenes originales siguen intactos. | Levantar siempre desde la carpeta del proyecto o con `-p proyecto-moodle`. |
| R-08 | Conviven `compose.yaml` y `docker-compose.yml` distintos en la carpeta del proyecto. | Aviso «Found multiple config files»; Compose usa `compose.yaml`. | Dejar un solo archivo. | `verificar-servicios.sh` lo detecta. |
| R-09 | Se corre `docker compose pull` o `up -d` con una etiqueta que el autor de la imagen reconstruyó. | `docker images --digests` muestra un digest distinto al de `versiones.txt`. | Volver a la imagen anterior por digest (`image: oksigenia/moodle@sha256:…`) si la nueva falla. | No hacer `pull` antes de la demo. Registrar los digests en el paquete. |
| R-10 | Se «corrige» el compose antes de la demo (por ejemplo, la variable mal escrita `MOODLE_BD_TYPE` que se ve en las capturas). | `up -d` recrea el contenedor; si algo falla, Moodle no arranca justo antes de presentar. | Revertir al compose del paquete y `up -d`. | No cambiar el compose después de armar el paquete. Si se corrige, que sea con tiempo, probado, y volver a armar el paquete. |
| R-11 | Disco lleno otra vez (imágenes, logs o respaldos). | `df -h /` cerca de 100 %; Moodle o MariaDB fallan al escribir; `nano` no guarda (INC-001). | Ver qué ocupa con `sudo du -xh --max-depth=1 / \| sort -h` y `sudo docker system df`. Liberar solo lo que se identifique como ajeno. | Chequeo de `df -h` antes de la demo; retención de 7 días en respaldos. |

## 3. DNS y HTTPS

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-12 | Mint pierde el DNS `192.168.50.1` al reiniciar, o el adaptador NAT agregado a Mint pone otro DNS primero. | `getent hosts aulavirtual.ctcr` vacío; `resolvectl status` en Mint muestra otro servidor. | En Mint: `nmcli connection modify "<conexión interna>" ipv4.dns 192.168.50.1 ipv4.ignore-auto-dns yes` y reconectar. Plan B en la demo: `curl --resolve`. | Configurar el DNS en la conexión de la red interna y deshabilitar el DNS automático del adaptador NAT. |
| R-13 | Se edita `db.ctcr` y no se recarga BIND, o hay un error de sintaxis. | `dig` responde lo viejo o `SERVFAIL`. | `sudo named-checkzone ctcr /etc/bind/db.ctcr` y luego `sudo rndc reload ctcr`. | Subir el serial en cada cambio y validar antes de recargar. |
| R-14 | El profesor abre el sitio por IP (`https://192.168.50.1`). | Advertencia de nombre no coincidente: el certificado es para `aulavirtual.ctcr`. | Explicar que el certificado se emitió para el nombre (SAN `DNS:aulavirtual.ctcr`). | Usar siempre el nombre en la demo. |
| R-15 | El certificado vence o se regenera sin actualizar el paquete. | `openssl x509 -enddate` muestra la fecha; navegador avisa «caducado». | Regenerar con el mismo comando del paso 08-02 y volver a armar el paquete. | Vence un año después de creado; `verificar-servicios.sh` avisa si faltan menos de 30 días. |
| R-16 | Nginx no arranca porque otro servicio ocupa el 80 o el 443 (Apache se reactivó por una actualización). | `systemctl status nginx` muestra «Address already in use». | `sudo ss -lntp \| grep -E ':80 \|:443 '` para ver quién lo usa (ya pasó con Apache2, INC-004). | Mantener `apache2` deshabilitado. |
| R-17 | El sitio por defecto de Nginx vuelve a quedar habilitado. | Al abrir el dominio aparece la página de bienvenida de Nginx. | `ls -l /etc/nginx/sites-enabled/`; quitar el enlace `default`, `nginx -t`, recargar. | `sites-enabled.txt` del paquete documenta lo que debe estar habilitado. |

## 4. Moodle y la prueba de aislamiento

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-18 | La prueba de denegación «falla» porque el navegador sigue con la sesión del administrador. | Marta parece ver todo. | Cerrar sesión. Todas las ventanas privadas de Firefox comparten **una** sesión: usar ventana normal para el admin y privada para la cuenta de prueba. | Guion de la demo (sección 0). |
| R-19 | Alguien reactiva invitados o auto-matriculación, o agrega una cohorte de más (repite INC-011). | Aparece un botón «Matricularme» o el PDF ajeno se abre. | Participantes → Métodos de matriculación: dejar solo la cohorte del departamento y la matrícula manual. | Revisar los tres cursos el día del ensayo. |
| R-20 | Cambiaron las URL del PDF o del curso (por ejemplo, al reemplazar materiales por los documentos reales del Drive). | La URL preparada da error también para el usuario autorizado. | Copiar de nuevo la URL como administrador. | Probar las URL con el usuario autorizado durante el ensayo. |
| R-21 | Una cuenta de prueba queda bloqueada o se olvidó la contraseña. | «Datos erróneos» repetidos. | Como administrador: Usuarios → editar → nueva contraseña, o desbloquear la cuenta. | Probar el inicio de sesión de cada cuenta en el ensayo. |
| R-22 | Cambios en la apariencia o en cursos no se ven. | Se ve la versión anterior. | Administración del sitio → Desarrollo → Purgar cachés. | — |

## 5. FTPS

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-23 | El inicio de sesión FTPS funciona pero el listado se cuelga. | `ls` sin respuesta; el cliente informa tiempo agotado. | Revisar que el rango `40000–40010` y `pasv_address=192.168.50.1` estén en `vsftpd.conf` y que ningún firewall los bloquee. | Si se activa un firewall, incluir el rango pasivo. |
| R-24 | Un cliente intenta FTP sin cifrar. | «530 Non-anonymous sessions must use encryption» o `curl: (64)`. | Usar `--ssl-reqd` (curl) o «Requerir FTP explícito sobre TLS» (FileZilla). | — |
| R-25 | Se edita `vsftpd.conf` y el servicio no reinicia. | `systemctl status vsftpd` con «500 OOPS». | `sudo journalctl -u vsftpd -n 20`; revisar valores YES/NO y directivas duplicadas (INC-016). | Copia de respaldo del archivo antes de editar y `grep -nE '^[a-z_]+=' /etc/vsftpd.conf \| sort` para ver duplicados. |

## 6. Respaldos y restauración

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-26 | La VM está apagada a las 02:00 y no hay respaldo reciente. | `ls -lh /var/backups/moodle` sin archivo del día. | `sudo ./respaldo.sh` a mano. | Ejecutar uno la mañana de la demo. |
| R-27 | El respaldo se ejecuta pero queda vacío o dañado (db caída). | Archivo muy pequeño; `gzip -t` falla; el log `/var/log/moodle-backup.log` muestra error. | `respaldo.sh` usa `set -euo pipefail` y `test -s`: revisar el log y el estado de `db`. | Revisar el log una vez por semana. |
| R-28 | Quedó `moodle_restore_test` de una prueba anterior. | `restauracion-prueba.sh` se detiene avisándolo. | Revisarla y borrarla: `DROP DATABASE moodle_restore_test;` (nunca `moodle`). | El script la borra al terminar salvo `--conservar`. |
| R-29 | Se restaura por error sobre la base real `moodle`. | Se pierden los cambios posteriores al respaldo. | Restaurar el respaldo más reciente disponible; avisar al grupo. | Usar solo `restauracion-prueba.sh`, que no puede escribir en `moodle`. |
| R-30 | Se necesita recuperar archivos subidos (PDF) y solo hay SQL. | Cursos con recursos que dan «archivo no encontrado» también al admin. | Restaurar la copia del volumen `moodle_data` (10-07), si existe. | Hacer una copia del volumen antes de la entrega. |
| R-31 | `crontab -l` sin `sudo` dice «no crontab». | Parece que no hay Cron. | Usar `sudo crontab -l`: la tarea está en el crontab de root. | — |

## 7. Firewall y servicios ajenos

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-32 | Se ejecuta `ufw enable` sin preparar reglas. | Se corta SSH; Mint pierde salida a Internet o el acceso al sitio. | Desde la consola de VirtualBox (no SSH): `sudo ufw disable`. | Ver [ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md): no activar UFW antes de la entrega. |
| R-33 | El profesor ve en `ss -lntup` bases de datos del host abiertas (`0.0.0.0:3306`, `0.0.0.0:5432`) o contenedores de otras prácticas (`lab5`). | Pregunta: «¿esa base es la de Moodle?». | Explicar que son de otras prácticas; Moodle usa su propia MariaDB en Docker sin puerto publicado. | Documentado en [ADR-0004](../decisiones/ADR-0004-servidor-unico-de-demostracion.md). Decidir antes si se detienen (no borrar sin saber a qué práctica pertenecen). |
| R-34 | Un contenedor ajeno ocupa un puerto que necesita Moodle (8080). | `up -d` falla con «port is already allocated». | `sudo docker ps --format "table {{.Names}}\t{{.Ports}}"` para ver quién lo usa. | Hoy `lab5-web` usa 8081, no 8080 (anexo técnico 31/10). |

## 8. Entrega y presentación

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-35 | Los hashes del paquete no coinciden con el servidor en la demo. | `verificar-servicios.sh … ~/entrega-ctcr` marca DIFIERE. | Decirlo con honestidad y mostrar el `diff`. | Congelar cambios; armar el paquete el 06/11 ([PAQUETE-ENTREGA](../entrega/PAQUETE-ENTREGA.md)). |
| R-36 | Los archivos pasaron por Windows y cambiaron los finales de línea. | Hashes distintos sin cambios visibles; scripts con `^M`. | Usar el `.tar.gz` armado en el servidor; `sed -i 's/\r$//'` en scripts copiados desde Windows. | No reempaquetar en Windows. |
| R-37 | Se filtran secretos o datos personales (`.env`, clave del certificado, correos personales, historial del navegador). | Revisión manual o `armar-entrega.sh`. | Quitar el archivo, volver a armar. Si ya se subió a Git: cambiar la contraseña expuesta. | Revisar capturas y archivos antes de subir; `docker compose config --quiet`. |
| R-38 | La persona elegida por el profesor no conoce la contraseña `sudo` o la ruta del proyecto. | Silencio frente a la terminal. | Otra persona no puede responder por ella: decir qué comando usaría. | Todos practican con [PREGUNTAS-TECNICAS](../entrega/PREGUNTAS-TECNICAS.md) en la VM real. |
| R-39 | La distribución de teclado de la VM no coincide (no salen `\|`, `~` o `@`). | Comandos mal escritos. | Cambiar la distribución en la VM o pegar desde un archivo de comandos preparado. | Probar el teclado en el ensayo con la misma computadora. |
| R-40 | La computadora anfitriona entra en suspensión o se queda sin batería. | VMs pausadas o apagadas. | Reanudar; esperar a `healthy`. | Conectar el cargador; desactivar la suspensión ese día. |

## 9. Riesgos que aparecen al comparar las dos VMs del grupo

Detectados el 31/10 al incorporar el documento del grupo de 54 páginas (VM `server@server`, EV-107 a EV-130) y compararlo con la VM de Criss (`criss@server`).

| ID | Qué puede pasar | Cómo se nota / cómo confirmarlo | Qué hacer | Prevención |
|---|---|---|---|---|
| R-41 | En la VM `server@server` hay **dos carpetas de proyecto**: `/root/proyecto-moodle` (capturas con `root@server`) y `/home/server/proyecto-moodle` (capturas con `server@server`). Las dos se llaman `proyecto-moodle`, así que Compose les da el **mismo nombre de proyecto** y comparten contenedores y volúmenes: un `up -d` desde la carpeta equivocada recrea Moodle con **otro** compose. | `sudo docker inspect proyecto-moodle-moodle-1 --format '{{ index .Config.Labels "com.docker.compose.project.working_dir" }}'` muestra desde qué carpeta se creó. `diff /root/proyecto-moodle/compose.yaml /home/server/proyecto-moodle/compose.yaml`. | Usar siempre la carpeta que dé el comando anterior; si los compose difieren, decidir cuál vale y renombrar el otro (`compose.yaml.viejo`). | Anotar la carpeta real en [ADR-0004](../decisiones/ADR-0004-servidor-unico-de-demostracion.md) y en `LEEME.txt` del paquete. |
| R-42 | El `named.conf.local` entregado incluye zonas de otras prácticas (`hobbier.internal`, `salazarchavarria.internal`, `examenkrystel.internal`, EV-110). | El profesor pregunta qué son. | Explicar que el BIND9 de la VM se comparte con otros laboratorios y que la zona del proyecto es `ctcr`. | Lo que se entrega es lo que corre (no editar el archivo para «limpiarlo»); preparar la respuesta. |
| R-43 | Las dos VMs se llaman `server`; una captura o un comando se atribuye a la VM equivocada. | El prompt dice `criss@server` o `server@server`; el hostname es el mismo. | Mirar el **usuario** del prompt o `ls /home`. | En las fichas EV indicar siempre el usuario de la VM. |
| R-44 | Los usuarios FTP no se llaman igual: `marta.jimenez` en la VM de Criss y `marta_jimenez` en la VM `server@server` (INC-007). | «530 Login incorrect» al usar el nombre de la otra VM. | `getent passwd \| grep -E 'marta[._]jimenez'` para ver el nombre real. | Usar en la demo los nombres de la VM elegida; ajustar la guía si es la `server@server` (P-17). |
| R-45 | Quedó `compose-http.backup.yaml` (versión HTTP) en la carpeta del proyecto (EV-119) y alguien lo usa con `-f`. | Moodle vuelve a publicarse en `192.168.50.1:8080` con URL HTTP; HTTPS da 502 o redirige mal. | `docker compose up -d` sin `-f`, con el `compose.yaml` actual. | No usar `-f` con archivos de respaldo; no incluirlo en el paquete. |
| R-46 | Las actualizaciones automáticas cambian la versión de un paquete entre la entrega y la demo (por ejemplo, Nginx `…1.11` instalado desde `.deb` sube a `…1.12`). | `dpkg-query -W nginx` distinto a `versiones.txt` del paquete; `/var/log/apt/history.log`. | Explicarlo; no hace falta revertir si funciona. | `sudo apt-mark hold nginx nginx-common` (o los paquetes que se quieran congelar) la semana de la entrega y no instalar nada justo después de encender (INC-019). |
