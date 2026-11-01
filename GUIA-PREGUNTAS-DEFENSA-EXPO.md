# Guía de Preguntas Técnicas y Defensa Oral para la Exposición Final

**Proyecto:** Colegio Técnico de Costa Rica — Escenario 3: Moodle LMS con Departamentos Separados  
**Curso:** EIF431O — Administración de Servidores (UNA — Campus Nicoya)  
**Fecha de Presentación:** Sábado 07 de noviembre de 2026 (Sesión 16)  
**Audiencia y Propósito:** Guía de estudio y banco de simulación para los cinco integrantes del grupo. Contiene las preguntas que formula la cátedra docente durante la demostración en vivo, los comandos exactos de terminal, la interpretación de las salidas, el guion de respuesta verbal y cómo sortear preguntas trampa.

---

## 1. Reglas de Juego y Metodología de la Evaluación

> [!IMPORTANT]
> **Duración Estricta:** 25 minutos exactos por grupo cronometrados al segundo:
> * **3 minutos:** Contexto del problema institucional, decisiones clave y arquitectura (máximo 4 diapositivas).
> * **11 minutos:** Demostración técnica en vivo en la máquina virtual (guion común para todos los grupos).
> * **5 minutos:** Preguntas técnicas individuales de la cátedra (**el profesor elige a dedo quién responde cada pregunta; no se permite que otro compañero intervenga**).
> * **4 minutos:** Preguntas del plenario (otros grupos y docentes).
> * **2 minutos:** Desconexión y cambio de equipo.

### Principio Rector: «Lo que se evalúa es lo que se entrega»
Durante la demostración técnica, el profesor comprobará que **lo que corre en el servidor coincide byte a byte con los archivos entregados** en el aula virtual mediante el archivo [`hashes.txt`](scripts/armar-entrega.sh).

### Protocolo de Respuesta Verbal (Menos de 45 Segundos)
1. **Acción inmediata:** Escribir y ejecutar el comando solicitado con serenidad y banderas de lectura (`-h`, `--tail`, `-s`).
2. **Interpretación puntual:** Señalar en pantalla la columna o línea exacta que responde a la pregunta (ej. `STATUS: Up (healthy)`, `HTTP 301`, `serial 2026102401`).
3. **Fundamentación técnica:** Justificar *por qué* está configurado así y qué riesgo previene.
4. **Si no se sabe la respuesta:** Nunca inventar. Decir con seguridad:  
   *«No tengo el dato exacto de memoria, pero el comando para auditarlo en este servicio es `[comando]` y deberíamos observar `[concepto esperado]`»*. La rúbrica premia la honestidad profesional y el criterio diagnóstico.

---

## 2. Las 3 Preguntas Base del Docente (Desglose Exhaustivo)

Estas tres preguntas fueron señaladas explícitamente por el docente como ejemplos directos de evaluación:

### Pregunta Base 1: «Mostrar todas las máquinas/contenedores que están corriendo»
* **Comando que pide el profesor:**
  ```bash
  cd ~/proyecto-moodle
  sudo docker compose ps
  ```
* **Salida real observada:**
  ```text
  NAME                       IMAGE                     COMMAND                  SERVICE   CREATED       STATUS                    PORTS
  proyecto-moodle-db-1       mariadb:11.4.13           "docker-entrypoint.s…"   db        10 days ago   Up 45 minutes (healthy)   3306/tcp
  proyecto-moodle-moodle-1   oksigenia/moodle:4.5.15   "/usr/bin/tini -g --…"   moodle    3 days ago    Up 5 minutes (healthy)    80/tcp, 8443/tcp, 127.0.0.1:8080->8080/tcp
  ```
* **Cómo explicar la salida al docente:**
  * *«Profesor, aquí observamos los dos contenedores de la pila en ejecución bajo Docker Compose: el servicio `db` con MariaDB 11.4.13 y el servicio `moodle` con la versión 4.5.15. Ambos están en estado `Up (healthy)`, lo que confirma que superaron las pruebas de salud internas»*.
  * *«A nivel de red, el puerto 3306 de MariaDB está cerrado al exterior y solo es accesible dentro de la red privada de Docker. El contenedor de Moodle está enlazado de forma exclusiva a `127.0.0.1:8080`, por lo que nadie desde la red LAN puede acceder directamente al puerto 8080 sin pasar por el proxy inverso Nginx»*.
* **Pregunta trampa del profesor:** *«¿Qué pasa si ejecuto `docker ps` a secas en lugar de `docker compose ps`?»*
  * **Respuesta:** *«`docker ps` es un comando de nivel de demonio que muestra todos los contenedores activos en el host, incluidos los de otros laboratorios previos (como `lab5-web-1` y `lab5-bd-1` del Laboratorio 5). En cambio, `docker compose ps` filtra estrictamente los servicios definidos en el archivo `compose.yaml` de este proyecto»*.

---

### Pregunta Base 2: «Mostrar todas las imágenes que tenemos»
* **Comando que pide el profesor:**
  ```bash
  cd ~/proyecto-moodle
  sudo docker compose images
  ```
  *(O a nivel global con digests inmutables):*
  ```bash
  sudo docker images --digests
  ```
* **Salida real observada:**
  ```text
  CONTAINER                  REPOSITORY          TAG                 IMAGE ID            SIZE
  proyecto-moodle-db-1       mariadb             11.4.13             250e1609e93c        451MB
  proyecto-moodle-moodle-1   oksigenia/moodle    4.5.15              e9efd6b4561c        1.49GB
  ```
* **Cómo explicar la salida al docente:**
  * *«Profesor, el proyecto utiliza dos imágenes oficiales y públicas: `mariadb:11.4.13` (451 MB) y `oksigenia/moodle:4.5.15` (1.49 GB). No construimos un `Dockerfile` propio porque las imágenes públicas de la comunidad cuentan con mantenimiento continuo, soporte para arquitecturas estándar y permiten reproducir la infraestructura en cualquier servidor sin compilar código»*.
* **Pregunta trampa del profesor:** *«¿Por qué en un entorno de producción no basta con confiar en la etiqueta `4.5.15`?»*
  * **Respuesta:** *«Porque una etiqueta flotante puede ser reconstruida en Docker Hub por su mantenedor. Para garantizar inmutabilidad criptográfica absoluta, en el archivo `versiones.txt` del paquete entregado registramos el digest SHA-256 de cada imagen, asegurando que se ejecute exactamente la misma compilación binaria»*.

---

### Pregunta Base 3: «Ver cómo tenemos configurado el Cron y saber explicarlo»
* **Comando que pide el profesor:**
  ```bash
  sudo crontab -l -u root
  ```
* **Salida real observada:**
  ```text
  0 2 * * * /home/criss/proyecto-moodle/respaldo.sh >> /var/log/moodle-backup.log 2>&1
  ```
* **Cómo explicar la salida al docente:**
  * *«Profesor, la tarea automatizada de respaldo está programada en el crontab del usuario root. Los cinco campos temporales `0 2 * * *` significan: minuto 0, hora 2 (es decir, todos los días a las 02:00 AM CST), sin restricción de día del mes, mes o día de la semana»*.
  * *«Ejecuta el script `/home/criss/proyecto-moodle/respaldo.sh`, redirigiendo tanto la salida estándar como los errores (`2>&1`) al archivo de bitácora rotativo `/var/log/moodle-backup.log`»*.
* **Preguntas trampa del profesor:**
  1. *«¿Por qué está en el crontab de `root` y no en el del usuario `criss`?»*
     * **Respuesta:** *«Porque el destino del respaldo es `/var/backups/moodle/`, un directorio restringido del sistema con permisos `0700` donde solo root tiene permisos de escritura, garantizando la confidencialidad de los volcados SQL ante otros usuarios locales»*.
  2. *«¿Qué ocurre si el servidor estuvo apagado durante la noche a las 02:00 AM?»*
     * **Respuesta:** *«El demonio Cron clásico no recupera tareas atrasadas; esa noche no se genera respaldo. Por esta razón, antes de cualquier mantenimiento o demostración ejecutamos el respaldo de forma preventiva y validamos la antigüedad del último archivo con `verificar-servicios.sh`»*.

---

## 3. Banco de Preguntas Técnicas Avanzadas por Bloque

---

### Bloque A: Docker, Compose y Volúmenes Persistentes

#### P-A1: «¿Dónde se guardan realmente los datos y cómo demuestran que no se pierden al reiniciar?»
* **Comando:**
  ```bash
  sudo docker volume ls | grep moodle
  sudo docker compose restart
  sudo docker compose ps
  ```
* **Respuesta:**
  * *«Los datos se almacenan en tres volúmenes administrados por Docker en `/var/lib/docker/volumes/`: `mariadb_data` (la base de datos relacional), `moodle_data` (los archivos binarios y PDFs subidos) y `moodle_code` (el código PHP). Al reiniciar los contenedores con `docker compose restart`, los procesos se detienen y arrancan de nuevo, pero los volúmenes permanecen intactos montados en el sistema de archivos del host»*.

#### P-A2: «¿Cuál es la diferencia crítica entre `docker compose down` y `docker compose down -v`?»
* **Respuesta (¡No ejecutar `down -v` en vivo!):**
  * *«`docker compose down` detiene y remueve los contenedores y la red virtual, pero **conserva todos los volúmenes intactos**; al ejecutar `up -d` el LMS vuelve a operar con todos sus cursos. Por el contrario, la bandera `-v` (`--volumes`) instruye a Docker a **eliminar permanentemente los volúmenes de datos**, borrando toda la base de datos y los archivos del colegio»*.

#### P-A3: «¿Por qué en el `compose.yaml` Moodle tiene `depends_on` con `condition: service_healthy`?»
* **Comando para mostrarlo:**
  ```bash
  grep -A 4 "depends_on" ~/proyecto-moodle/compose.yaml
  ```
* **Respuesta:**
  * *«Un `depends_on` simple solo espera a que el contenedor de MariaDB arranque su proceso, pero MariaDB tarda varios segundos en inicializar el motor de almacenamiento InnoDB. Si Moodle intenta conectarse antes de que MariaDB esté lista, la aplicación falla con error 500 de conexión de base de datos. La directiva `condition: service_healthy` obliga a Compose a esperar que el healthcheck de MariaDB retorne código 0 antes de iniciar Moodle»*.

#### P-A4: «¿Dónde están las contraseñas y cómo están protegidas?»
* **Comando:**
  ```bash
  ls -l ~/proyecto-moodle/.env
  ```
* **Respuesta:**
  * *«Están almacenadas en el archivo `.env` del proyecto. Como se aprecia en los permisos `-rw-------` (modo `0600`), únicamente el usuario propietario puede leerlo. En el paquete de entrega no incluimos este archivo, sino un `.env.example` sanitizado sin valores»*. *(Nota: Nunca hacer `cat .env` en pantalla ante el docente)*.

---

### Bloque B: Moodle, Cursos y Aislamiento Departamental

#### P-B1: «¿Qué mecanismo técnico impide que un estudiante de Administración entre al curso de Informática?»
* **Comando / Demostración:**
  Mostrar desde la interfaz web o base de datos los métodos de matriculación:
  ```bash
  sudo docker compose exec -T db mariadb -u root moodle -e \
    "SELECT c.shortname, e.enrol FROM mdl_course c JOIN mdl_enrol e ON c.id=e.courseid WHERE c.id > 1;"
  ```
* **Respuesta:**
  * *«El aislamiento se basa en tres capas:*
    1. *Cada curso utiliza exclusivamente el método nativo `enrol_cohort` (Sincronizar cohorte) asociado a la cohorte de su propio departamento (`CTCR-COH-ADM`, `CTCR-DOC`, `CTCR-INF`).*
    2. *La auto-matriculación (`enrol_self`) y el acceso de invitados (`enrol_guest`) están deshabilitados en todo el sitio.*
    3. *Si Marta Jiménez (Administración) intenta ingresar a la URL del curso de Informática (`id=4`), Moodle valida sus capacidades contra la tabla de contexto y emite una redirección `HTTP 303` denegando el acceso»*.

#### P-B2: «¿Por qué no bastaba con crear tres categorías separadas en Moodle?»
* **Respuesta:**
  * *«Las categorías en Moodle son únicamente un criterio organizativo visual en el catálogo de cursos. Si un curso dentro de una categoría permite auto-matrícula o acceso de invitados, cualquier usuario autenticado podría entrar. La seguridad y el control de acceso residen en los métodos de matriculación y en los permisos de rol asignados a los contextos»*.

#### P-B3: «¿Por qué los profesores NO pertenecen a las cohortes departamentales?»
* **Respuesta:**
  * *«Porque el plugin de sincronización de cohortes (`enrol_cohort`) matricula a todos sus miembros con el rol por defecto de **Estudiante**. Si matriculáramos al profesor dentro de la cohorte, el sistema lo convertiría en alumno de su propio curso. Por ende, los estudiantes se gestionan de forma masiva y automatizada mediante cohortes, mientras los tres profesores se matriculan manualmente con el rol `editingteacher`»*.

#### P-B4: «¿Cómo demuestran que un profesor no tiene privilegios de administrador del sistema?»
* **Comando / Demostración en Mint:**
  Iniciar sesión en Firefox como el profesor `daniel.vargas` y navegar manualmente a:
  `https://aulavirtual.ctcr/admin/`
* **Salida esperada:**
  Moodle muestra un mensaje de acceso denegado: *«No tiene permisos para acceder a esta página»*, y la barra lateral de navegación no incluye el botón *«Administración del sitio»*.

---

### Bloque C: DNS BIND9 Local

#### P-C1: «¿Quién resuelve `aulavirtual.ctcr` y cómo comprueban que la respuesta es autoritativa?»
* **Comando:**
  ```bash
  dig @192.168.50.1 aulavirtual.ctcr
  ```
* **Cómo explicar la salida:**
  * Señalar en la cabecera: `flags: qr aa rd ra; QUERY: 1, ANSWER: 1`.
  * *«Profesor, observamos la bandera **`aa` (Authoritative Answer)**, lo cual demuestra que nuestro BIND9 en `192.168.50.1` es el servidor maestro autoritativo de la zona `ctcr` y no un simple reenviador en caché. La sección ANSWER resuelve directamente a nuestra IP `192.168.50.1`»*.

#### P-C2: «¿Cómo validan que la configuración de BIND9 no tenga errores sintácticos?»
* **Comando:**
  ```bash
  sudo named-checkconf
  sudo named-checkzone ctcr /etc/bind/db.ctcr
  ```
* **Salida esperada:**
  `named-checkconf` no emite salida (código de salida 0 significa sintaxis perfecta). `named-checkzone` responde:
  `zone ctcr/IN: loaded serial 2026102401 OK`.

#### P-C3: «¿Por qué usamos un dominio `.ctcr` y no un dominio comercial público como `.com`?»
* **Respuesta:**
  * *«Porque se trata de una infraestructura de red interna aislada del Colegio Técnico. La extensión `.ctcr` es un TLD privado definido en nuestra zona autoritativa interna. BIND9 está configurado con reenviadores (`forwarders`) hacia `8.8.8.8` y `1.1.1.1` para que las peticiones a Internet sigan resolviendo, pero las consultas institucionales se resuelven localmente sin depender de internet»*.

---

### Bloque D: Nginx, Proxy Inverso y Certificados TLS

#### P-D1: «¿En qué puertos escucha Nginx y cómo comprueban su sintaxis?»
* **Comando:**
  ```bash
  sudo nginx -t
  sudo ss -lntup | grep nginx
  ```
* **Salida esperada:**
  `nginx -t` responde `syntax is ok` y `test is successful`. `ss` muestra que Nginx escucha en:
  * `192.168.50.1:80` (HTTP)
  * `192.168.50.1:443` (HTTPS)

#### P-D2: «¿Qué ocurre si un usuario escribe la dirección sin `https://` en el navegador?»
* **Comando:**
  ```bash
  curl -s -I http://aulavirtual.ctcr
  ```
* **Salida observada:**
  ```text
  HTTP/1.1 301 Moved Permanently
  Server: nginx/1.28.3 (Ubuntu)
  Location: https://aulavirtual.ctcr/
  ```
* **Explicación:**
  * *«Nginx intercepta la petición en el puerto 80 y responde con un código de redirección permanente `301 Moved Permanently`, forzando al navegador a elevar la conexión hacia el puerto 443 bajo cifrado TLS»*.

#### P-D3: «¿Qué certificado digital están usando y qué nombres cubre?»
* **Comando:**
  ```bash
  sudo openssl x509 -in /etc/nginx/certs/aulavirtual.ctcr.crt -noout -subject -dates -ext subjectAltName
  ```
* **Salida esperada:**
  * `subject=C=CR, O=Colegio Tecnico de Costa Rica, CN=aulavirtual.ctcr`
  * `notBefore=... notAfter=...` (vigente hasta octubre de 2027).
  * `X509v3 Subject Alternative Name: DNS:aulavirtual.ctcr, DNS:moodle.ctcr.test`
* **Explicación:**
  * *«Es un certificado X.509 de 3072 bits generado institucionalmente con OpenSSL. Incluye la extensión Subject Alternative Name (SAN) para validar tanto el FQDN principal `aulavirtual.ctcr` como el alias alternativo `moodle.ctcr.test`»*.

#### P-D4: «¿Cómo sabe Moodle que está navegando bajo HTTPS si Nginx le reenvía en HTTP a `127.0.0.1:8080`?»
* **Respuesta:**
  * *«A través de dos configuraciones coordinadas:*
    1. *En Nginx enviamos la cabecera `proxy_set_header X-Forwarded-Proto https;`.*
    2. *En el archivo `compose.yaml` de Moodle definimos las variables de entorno `MOODLE_URL=https://aulavirtual.ctcr` y `MOODLE_SSL_PROXY=yes`.*
    *Esto le indica a Moodle que confíe en la terminación TLS del proxy inverso y genere todos los hipervínculos internos con esquema `https://`»*.

---

### Bloque E: FTPS Seguro y Confinamiento Chroot (vsftpd)

#### P-E1: «¿Cómo se garantiza que un funcionario de un departamento no pueda espiar archivos de otro?»
* **Comando para mostrar la configuración:**
  ```bash
  grep -E "chroot_local_user|local_root|user_sub_token|allow_writeable_chroot" /etc/vsftpd.conf
  ```
* **Salida esperada:**
  ```text
  chroot_local_user=YES
  allow_writeable_chroot=NO
  user_sub_token=$USER
  local_root=/srv/ftp/$USER
  ```
* **Explicación:**
  * *«`chroot_local_user=YES` enjaula al usuario en su propio directorio raíz. La combinación de `user_sub_token=$USER` y `local_root=/srv/ftp/$USER` expande dinámicamente la ruta a su carpeta personal. `allow_writeable_chroot=NO` protege la seguridad del enjaulamiento impidiendo que la raíz sea escribible»*.

#### P-E2: «¿Por qué la raíz `/srv/ftp/<usuario>` pertenece a `root:root` con permisos 755?»
* **Comando:**
  ```bash
  sudo ls -ld /srv/ftp/marta.jimenez /srv/ftp/marta.jimenez/archivos
  ```
* **Respuesta:**
  * *«Es un diseño estricto de seguridad de vsftpd para mitigar ataques de elevación de privilegios en entornos chroot. Si la raíz de la jaula tuviera permisos de escritura para el usuario, vsftpd aborta la conexión con el error `500 OOPS: vsftpd: refusing to run with writable root inside chroot()` (INC-010). Por eso la raíz pertenece a `root:root` (`0755`) y el funcionario solo tiene permisos de escritura dentro del subdirectorio `/archivos` (`0700`)»*.

#### P-E3: «¿Pueden las cuentas de FTP iniciar sesión por SSH en la consola del servidor?»
* **Comando:**
  ```bash
  getent passwd marta.jimenez
  ```
* **Salida esperada:**
  `marta.jimenez:x:1006:1006:...:/srv/ftp/marta.jimenez:/usr/sbin/nologin`
* **Respuesta:**
  * *«No. Tienen asignada la shell restrictiva `/usr/sbin/nologin`. Si intentan conectarse por SSH, el sistema rechaza la sesión. Asimismo, `/usr/sbin/nologin` está registrada en `/etc/shells` para permitir que el módulo PAM de vsftpd autorice la sesión FTP legítima»*.

#### P-E4: «¿Para qué sirve el rango de puertos 40000–40010 en vsftpd?»
* **Respuesta:**
  * *«En el protocolo FTP en modo pasivo (`PASV`), el cliente establece la conexión de control en el puerto 21, pero para listar archivos o transferir datos el servidor le indica un puerto efímero. Fijamos `pasv_min_port=40000` y `pasv_max_port=40010` para acotar el rango de puertos a un intervalo predecible y poder abrirlo de forma controlada en el cortafuegos»*.

---

### Bloque F: Respaldos, Restauración DRP y Copia de Volúmenes

#### P-F1: «¿Cómo demuestran que un respaldo de Moodle realmente funciona sin alterar el servidor en producción?»
* **Comando:**
  ```bash
  cd ~/proyecto-moodle
  sudo ./restauracion-prueba.sh
  ```
* **Explicación del procedimiento:**
  * *«Profesor, desarrollamos el script automatizado `restauracion-prueba.sh`. El script toma el respaldo más reciente de `/var/backups/moodle/`, valida su integridad con `gzip -t`, crea una base de datos de prueba independiente llamada `moodle_restore_test`, inyecta el dump SQL, y compara el conteo de tablas y registros contra la base activa.*
  * *En nuestra última verificación comprobamos que se restauraron exactamente las **494 tablas** de Moodle, 3 cursos y 12 usuarios institucionales, y mediante una trampa `trap` en bash se destruye la base temporal al finalizar, sin tocar jamás la base de producción `moodle`»*.

#### P-F2: «¿Qué diferencia hay entre el respaldo SQL diario y el respaldo del volumen `moodledata`?»
* **Respuesta (Paso 10-07):**
  * *«El respaldo diario por Cron es un volcado lógico relacional generado con `mariadb-dump`. Respalda usuarios, matrículas, calificaciones, cuestionarios y estructura. Sin embargo, los archivos físicos (como los documentos PDF cargados por los profesores) no se guardan en MariaDB, sino en el volumen de Docker `moodledata`.*
  * *Para una contingencia total (Bare-Metal DRP), implementamos el procedimiento del Paso 10-07: detenemos momentáneamente el contenedor Moodle y comprimimos el volumen como solo lectura (`:ro`) usando un contenedor auxiliar de Alpine, generando `moodledata_manual_2026-10-31.tar.gz` (11 MB)»*.

---

### Bloque G: Red, Cortafuegos y Correspondencia del Paquete

#### P-G1: «¿Usan firewall en el servidor y por qué UFW no está activo?»
* **Comando:**
  ```bash
  sudo iptables -S | head -n 15
  command -v ufw || echo "UFW no instalado"
  ```
* **Respuesta oficial del grupo ([ADR-0003](docs/decisiones/ADR-0003-firewall-iptables-sin-ufw.md)):**
  * *«Profesor, el filtrado perimetral, la seguridad de red y el enmascaramiento NAT de Linux Mint se administran a nivel de kernel directamente con **`iptables` y `iptables-persistent`**.*
  * *UFW no está activo porque su activación genera conflictos graves con Docker: UFW impone una política de `FORWARD DROP` que aísla los contenedores, rompe las cadenas `DOCKER-USER` y corta el acceso a Internet del cliente Linux Mint.*
  * *Moodle no queda expuesto porque su puerto 8080 está atado exclusivamente al loopback `127.0.0.1` y MariaDB no publica puertos en el host. En el paquete entregamos `firewall-iptables.txt` con todas las reglas reales y `ufw.txt` explicando técnicamente esta decisión»*.

#### P-G2: «¿Por qué en `ss -lntup` se ven puertos como 3306, 5432 u 8081 en el host?»
* **Comando:**
  ```bash
  sudo ss -lntup | grep -E ':(3306|5432|8081) '
  ```
* **Respuesta:**
  * *«Pertenecen a los Laboratorios #4 y #5 del curso EIF431O, desarrollados y calificados previamente en esta misma máquina virtual. MariaDB (3306) y PostgreSQL (5432) corresponden al Laboratorio 4 de bases de datos, y el puerto 8081 corresponde al contenedor PHP del Laboratorio 5 con proxy inverso en Apache. Están documentados en nuestro inventario y no interfieren con Moodle, que corre encapsulado en Docker»*.

#### P-G3: «¿Cómo demuestran que lo que corre en este servidor coincide con lo que subieron al aula virtual?»
* **Comando:**
  ```bash
  cd ~/proyecto-moodle
  sudo ./verificar-servicios.sh "$PWD" /home/criss/entrega-ctcr
  ```
* **Salida esperada:**
  El script recorre todos los archivos exportados (`docker-compose.yml`, `named.conf.local`, `db.ctcr`, `aulavirtual.ctcr.conf`, `vsftpd.conf`, `respaldo.sh`, `restauracion-prueba.sh`, etc.), calcula su hash SHA-256 en vivo y los compara contra `hashes.txt`:
  ```text
  == Correspondencia con el paquete entregado
    [OK] docker-compose.yml coincide con /home/criss/proyecto-moodle/compose.yaml
    [OK] configuraciones/bind/db.ctcr coincide con /etc/bind/db.ctcr
    [OK] configuraciones/nginx/aulavirtual.ctcr.conf coincide con /etc/nginx/sites-available/aulavirtual.ctcr
    ...
  Resultado: TODO OK
  ```
  *«Profesor, aquí se comprueba matemáticamente que ni una sola línea de configuración ni los scripts fueron alterados después de armar el paquete de entrega»*.

---

## 4. Matriz Rápida de Comandos de Supervivencia en Terminal

Imprimir o memorizar esta tabla rápida para ejecutar sin titubeos durante la ronda de preguntas:

| Lo que pide el profesor | Comando exacto a teclear |
|---|---|
| **Contenedores activos** | `cd ~/proyecto-moodle && sudo docker compose ps` |
| **Imágenes y versiones** | `cd ~/proyecto-moodle && sudo docker compose images` |
| **Crontab de respaldos** | `sudo crontab -l -u root` |
| **Lista de respaldos** | `sudo ls -lh /var/backups/moodle/` |
| **Sintaxis Nginx** | `sudo nginx -t` |
| **Puertos de Nginx** | `sudo ss -lntup \| grep nginx` |
| **Sintaxis DNS BIND9** | `sudo named-checkconf && sudo named-checkzone ctcr /etc/bind/db.ctcr` |
| **Resolución autoritativa** | `dig @192.168.50.1 aulavirtual.ctcr +noall +answer` |
| **Prueba HTTP 301** | `curl -s -I http://aulavirtual.ctcr \| grep -E "(HTTP\|Location)"` |
| **Certificado SSL y SAN** | `sudo openssl x509 -in /etc/nginx/certs/aulavirtual.ctcr.crt -noout -subject -dates -ext subjectAltName` |
| **Enjaulamiento FTPS** | `grep -E "(chroot_local_user\|local_root\|user_sub_token)" /etc/vsftpd.conf` |
| **Shell nologin de FTP** | `getent passwd marta.jimenez` |
| **Prueba DRP de ensayo** | `cd ~/proyecto-moodle && sudo ./restauracion-prueba.sh` |
| **Auditoría general pre-demo**| `cd ~/proyecto-moodle && sudo ./verificar-servicios.sh "$PWD"` |
| **Espacio libre en disco** | `df -h /` |
| **Uso de disco en Docker** | `sudo docker system df` |
