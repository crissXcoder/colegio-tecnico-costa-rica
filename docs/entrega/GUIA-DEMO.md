# Guía de la presentación — 3 minutos de contexto y 11 de demostración

**Para quién:** los cinco integrantes, para ensayar el 06/11 y presentar el 07/11/2026.
**Regla de oro:** todo se muestra en el **servidor de la demostración** (ver [ADR-0004](../decisiones/ADR-0004-servidor-unico-de-demostracion.md)) y debe coincidir con el paquete entregado. Si algo falla, se dice qué falló, se explica por qué y se sigue: el reloj no se detiene.

## 0. Preparación (antes del turno, no en pantalla)

**Una hora antes**

1. Encender Ubuntu Server y Linux Mint. Esperar a que los contenedores estén `healthy` (el arranque de Moodle tarda alrededor de un minuto).
2. En Ubuntu, correr el chequeo y no presentarse con fallos sin entenderlos:
   ```bash
   cd ~/proyecto-moodle
   sudo ./verificar-servicios.sh "$PWD" ~/entrega-ctcr
   ```
3. Si el último respaldo es de días atrás (la VM estuvo apagada a las 02:00), correr `sudo ./respaldo.sh` para que la lista muestre uno de hoy.
4. En Mint, comprobar `getent hosts aulavirtual.ctcr` → `192.168.50.1`.

**Diez minutos antes**

- Terminal de Ubuntu con letra grande (Ctrl + Shift + +), ubicada en `~/proyecto-moodle`. Limpiar la pantalla con `clear`.
- Firefox en Mint con dos ventanas preparadas:
  - **Ventana normal:** administrador, en «Mis cursos». Tener copiadas en un archivo de texto las dos URL de prueba: el curso de Informática (`https://aulavirtual.ctcr/course/view.php?id=4`) y su PDF (`https://aulavirtual.ctcr/pluginfile.php/26/mod_resource/content/1/Curso_Informatica_Seguridad_Basica.pdf`). Confirmar que siguen siendo esas URL en el servidor de la demo.
  - **Ventana privada:** en la página de inicio de sesión, sin sesión iniciada.
  - Ojo: **todas las ventanas privadas de Firefox comparten la misma sesión**. Para el segundo usuario se cierra la sesión del primero; no se abre «otra» ventana privada.
- Cerrar WhatsApp, correo y cualquier pestaña personal. Cerrar el desplegable de historial de la barra de direcciones antes de compartir pantalla.
- Tener a mano la contraseña de laboratorio de las cuentas de prueba (no escribirla en pantalla visible ni en diapositivas).

## 1. Contexto y solución — 3 minutos

Máximo cuatro diapositivas.

| # | Diapositiva | Qué decir (resumen) |
|---|---|---|
| 1 | **Problema** | «El colegio tiene tres departamentos —Administración, Docencia e Informática— y cada uno necesita capacitación y materiales que los otros no deben poder ver.» Solución: un aula virtual Moodle en `https://aulavirtual.ctcr`, con un curso por departamento y acceso separado. |
| 2 | **Por qué software libre y por qué Moodle** | Moodle trae de fábrica cohortes, matrícula por cohorte y roles por curso, que es exactamente la separación que pide el escenario; licencia GPL sin costo por usuario; corre en Docker con MariaDB. Frente a Chamilo (también libre) y a plataformas propietarias: ver [comparativa](comparativa-software.md). Aclarar que «libre» no significa costo cero: el costo está en administrarlo. |
| 3 | **Diagrama** | Mint → DNS BIND9 (`192.168.50.1:53`) → Nginx HTTPS (`:443`) → Moodle en Docker (`127.0.0.1:8080`) → MariaDB en Docker (red interna, sin puerto publicado). FTPS en `:21` + pasivos `40000–40010`. Cron de root → `respaldo.sh` → `/var/backups/moodle`. |
| 4 | **Decisiones, contrapartidas y problemas reales** | Ver tabla de abajo. Elegir **dos** decisiones y **un** problema; no leer todo. |

**Decisiones con su contrapartida (elegir dos para decir en voz alta):**

| Decisión | Qué ganamos | Qué perdimos o aceptamos |
|---|---|---|
| HTTPS en Nginx, delante del contenedor ([ADR-0002](../decisiones/ADR-0002-proxy-https.md)) | Certificado y redirección 301 en un solo lugar del host; Moodle no queda expuesto (escucha solo en `127.0.0.1:8080`). | Un componente más; hubo que alinear `MOODLE_URL` y `MOODLE_SSL_PROXY`, y durante la transición apareció un 502 ([INC-015](../../bitacora/incidentes/INC-015-nginx-502-moodle-no-disponible.md)). |
| Separación por **cohorte + matrícula**, no por categoría | Es lo que realmente niega el acceso, incluso por URL directa. | Hay que revisar los métodos de matrícula de cada curso: un método de más rompe el aislamiento ([INC-011](../../bitacora/incidentes/INC-011-moodle-matricula-cohorte-incorrecta.md)). |
| Moodle y MariaDB en contenedores con volúmenes | Versiones fijas, se recrean sin perder datos. | La persistencia depende de no usar `down -v` y de respaldar. |
| Respaldo SQL diario con Cron + restauración de ensayo | Recuperable y comprobado (494 tablas, EV-099). | El SQL no incluye los archivos de `moodledata`; se documentó el procedimiento aparte (10-07). |
| Firewall con iptables, sin UFW ([ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md)) | No se rompen las cadenas de Docker ni el NAT de Mint. | Reglas menos legibles que UFW. |

**Problemas reales (elegir uno):** la raíz del disco se llenó y hubo que ampliar LVM en caliente ([INC-001](../../bitacora/incidentes/INC-001-almacenamiento-lvm.md)); dos estudiantes de Docencia aparecieron dentro del curso de Administración ([INC-011](../../bitacora/incidentes/INC-011-moodle-matricula-cohorte-incorrecta.md)).

## 2. Demostración en vivo — 11 minutos

Orden pensado para que el reinicio de los contenedores (que tarda) ocurra **mientras** se muestra otra cosa.

| Min | Qué se muestra | Comandos o acciones | Qué debe verse | Si falla |
|---|---|---|---|---|
| 0:00–1:30 | **Lo que corre es lo entregado** | `cat docker-compose.yml` (o `compose.yaml`)<br>`sha256sum compose.yaml`<br>`grep docker-compose.yml ~/entrega-ctcr/hashes.txt` | Dos servicios (`db`, `moodle`), imágenes con etiqueta fija, puerto `127.0.0.1:8080`, volúmenes. **El mismo hash** en ambas líneas. | Si el hash difiere: decirlo con honestidad («se editó después de armar el paquete») y mostrar `diff`. |
| 1:30–2:30 | **Contenedores y versiones** | `sudo docker compose ps`<br>`sudo docker images` | `db` y `moodle` en `Up (healthy)`; `oksigenia/moodle 4.5.15` y `mariadb 11.4.13`. | Si dice `starting`: explicar el healthcheck y volver al final. |
| 2:30–4:00 | **Persistencia (parte 1)** | `sudo docker volume ls`<br>En el navegador, mostrar los 3 cursos en «Mis cursos».<br>`sudo docker compose restart` | Tres volúmenes `proyecto-moodle_*`. El reinicio arranca. | **Nunca** `down -v`. Si alguien lo sugiere, explicar que borra los volúmenes. |
| 4:00–5:30 | **Respaldo y restauración** (mientras reinicia) | `sudo crontab -l`<br>`sudo ls -lh /var/backups/moodle`<br>Mostrar el log de `restauracion-prueba.sh` con fecha (o EV-099). | Línea `0 2 * * * .../respaldo.sh`; archivos `ctcr_moodle_*.sql.gz`; restauración en `moodle_restore_test` con el mismo número de tablas que `moodle`. | Si la lista está vacía: correr `sudo ./respaldo.sh` (tarda segundos) y volver a listar. |
| 5:30–6:00 | **Persistencia (parte 2)** | `sudo docker compose ps`; recargar «Mis cursos». | De nuevo `healthy`; los 3 cursos siguen ahí. | Si Nginx muestra **502**, Moodle aún no terminó de arrancar: esperar 30 s y recargar (INC-015). |
| 6:00–7:30 | **HTTPS con certificado propio** | En Firefox: candado → ver certificado (`CN=aulavirtual.ctcr`).<br>En Mint: `curl -vk https://aulavirtual.ctcr 2>&1 \| grep -E "subject:\|issuer:\|SSL connection\|HTTP/"`<br>`curl -I http://aulavirtual.ctcr` | `subject: ... CN=aulavirtual.ctcr`, conexión TLSv1.3 o 1.2, `HTTP/1.1 200` (o `303` hacia el login si está activo el inicio de sesión obligatorio) y `301` desde HTTP. | Si Mint no resuelve el nombre: `getent hosts aulavirtual.ctcr` y revisar DNS (ver riesgos R-12). Plan B: `--resolve aulavirtual.ctcr:443:192.168.50.1`. |
| 7:30–10:30 | **Escenario 3: acceso denegado entre departamentos** | Ventana privada → iniciar sesión como `marta.jimenez` (Administración).<br>1. «Mis cursos»: solo ve Gestión Documental.<br>2. Pegar la URL del curso de Informática.<br>3. Pegar la URL del PDF de Informática.<br>Cerrar sesión → iniciar como `valeria.sanchez` (Informática): ve solo Seguridad Digital y abre el PDF. | 1. Un solo curso.<br>2. «No se puede matricular en este curso», sin botón para matricularse.<br>3. «Lo sentimos, el archivo solicitado no se encuentra».<br>Valeria sí entra a su curso y al PDF. | Si aparece un botón «Matricularme» o el PDF se abre: hay un método de matrícula abierto. Decirlo, explicar la causa (INC-011) y mostrar Participantes → Métodos de matriculación. |
| 10:30–11:00 | **Cierre** | Una frase: qué se demostró y qué quedó fuera (por ejemplo, `moodledata` no está en el respaldo diario). | | |

**Si el tiempo se acaba antes:** el escenario 3 es lo único que **no** puede faltar. Si a los 7:00 todavía no empezó, saltar directo a la sección de denegación y mencionar en una frase lo que se omitió.

## 3. Después del turno

- Cerrar las sesiones de Moodle de las cuentas de prueba.
- No apagar el servidor hasta terminar la sesión: el profesor puede pedir revisar algo después.

Preguntas que puede hacer el profesor: [PREGUNTAS-TECNICAS.md](PREGUNTAS-TECNICAS.md). Problemas que pueden aparecer y cómo resolverlos: [RIESGOS-Y-FALLOS-ANTICIPADOS.md](../operacion/RIESGOS-Y-FALLOS-ANTICIPADOS.md).
