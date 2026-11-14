# Guion y Reparto de la Demostración — Proyecto CTCR (Escenario 3: Moodle)
## EIF431O — Administración de Servidores Basados en Software Libre (25 Minutos Exactos)

**Servidor de demostración:** VM #1 (`criss@server`, IP `192.168.50.1` / `192.168.56.103`)  
**Servidor de base de datos y réplica:** VM #2 (`criss@server`, IP `192.168.56.104`)  
**Cliente de red interna:** Linux Mint (`criss-VirtualBox`, IP `192.168.50.101`)  
**Regla de oro:** Lo que corre en el servidor coincide al 100% con lo entregado según `hashes.txt`. Si algo falla, se indica la causa técnica, se cita la figura del documento y se continúa; el reloj no se detiene.

---

## 1. Reparto Minuto a Minuto

De los 25 minutos, **solo 14 dependen del grupo**: 3 de contexto y 11 de demostración (2:45 cada persona). Las preguntas no se pueden preasignar porque el profesor elige al azar quién responde.

| Tiempo | Segmento | Quién | Rúbrica |
| --- | --- | --- | --- |
| **0:00 – 3:00** | Contexto y solución (máx. 4 diapositivas) | **Persona 1** | Claridad de decisiones (3%) |
| **3:00 – 5:45** | Lo entregado = lo que corre, DNS y HTTPS | **Persona 2** | Demostración en vivo (5%) |
| **5:45 – 8:30** | Contenedores, versiones y persistencia | **Persona 3** |  |
| **8:30 – 11:15** | Respaldo y restauración | **Persona 4** |  |
| **11:15 – 14:00** | Control de acceso entre departamentos (Escenario 3) | **Persona 5** |  |
| **14:00 – 19:00** | Preguntas de conocimiento con comandos | **Quien elija el profesor** | Manejo de preguntas (2%) |
| **19:00 – 23:00** | Preguntas de los demás grupos y del profesor | **Responsable del tema** |  |
| **23:00 – 25:00** | Conclusiones y cambio de grupo | **Equipo completo** |  |

---

## 2. Asignación Detallada por Persona

### Persona 1. Contexto y Solución [0:00 – 3:00 · 3:00 min]
Cuatro diapositivas (~45 segundos por diapositiva):
1. **El problema en una frase:** Tres departamentos (Administración, Docencia e Informática) en la misma red sin control de acceso; un profesor dejó su sesión abierta y un estudiante alteró notas.
2. **Por qué Moodle y software libre:** Cohortes nativas que resuelven el requisito curricular, soberanía de datos dentro del colegio y **USD 0 en licencias** frente a más de USD 9 000 en la opción propietaria. Presentar a Canvas como *«servicio en la nube de Instructure»* (no como software propietario, ya que Canvas LMS es de código abierto).
3. **Diagrama de infraestructura (Fig. 1):** BIND9 DNS autoritativo, Nginx como proxy TLS y balanceador HA, contenedores Moodle y MariaDB divididos en dos VMs por red privada Host-only, FTPS con aislamiento y Cron de respaldo.
4. **Decisiones y trade-offs:** Nginx reverse proxy frente a HTTPS dentro del contenedor; cohortes frente a grupos simples. Problema real resuelto: ampliación de LVM en caliente al 100% de disco y optimización de restauración.
*Al terminar su turno, Persona 1 actúa como cronometrador oficial de la demo levantando la mano a los 2:00 y a los 2:30 de cada turno.*

---

### Persona 2. Lo Entregado es lo que Corre, DNS y HTTPS [3:00 – 5:45 · 2:45 min]

```bash
cd ~/proyecto-moodle
sha256sum -c hashes.txt                    # todos OK: lo que corre es lo entregado
cat docker-compose.yml                     # señalar versiones fijas, 127.0.0.1:8080 y volúmenes
dig @192.168.50.1 aulavirtual.ctcr +short
curl -vk https://aulavirtual.ctcr -o /dev/null 2>&1 | grep -E "subject|issuer|expire|HTTP/"
```

**Acción posterior en navegador:**  
Abrir Firefox en Linux Mint en `https://aulavirtual.ctcr`, hacer clic en el candado de la barra de direcciones y seleccionar **Ver certificado** para demostrar que es un certificado institucional propio emitido para `CN=aulavirtual.ctcr` por el Colegio Técnico de Costa Rica.

---

### Persona 3. Contenedores, Versiones y Persistencia [5:45 – 8:30 · 2:45 min]

```bash
sudo docker compose ps
sudo docker images
sudo docker volume ls
sudo docker compose restart               # lanzarlo apenas empieza el turno (tarda ~1.5 s)
```

**Explicación en vivo:**  
Mientras Moodle vuelve a estado `healthy` (tarda 2 segundos en el healthcheck), explicar los tres volúmenes (`mariadb_data`, `moodle_code`, `moodle_data`) y enfatizar por qué **nunca** se ejecuta `down -v`. Al finalizar, recargar el curso en el navegador para evidenciar que todo el contenido y las configuraciones persisten intactas.

---

### Persona 4. Respaldo y Restauración [8:30 – 11:15 · 2:45 min]

En terminal conectada a VM 2 (`ssh criss@192.168.56.104`):

```bash
sudo crontab -l
cd ~/proyecto-moodle
sudo ./respaldo.sh                         # en vivo, tarda unos 8-15 segundos
sudo ls -lh /var/backups/moodle            # aparece el archivo nuevo con la hora actual
cat evidencias/restauracion_2026-11-13_21-40.log
```

**Explicación en vivo:**  
Explicar la frecuencia diaria a las 02:00 AM y la política de retención automática de 7 días. No se ejecuta la restauración en vivo para no consumir tiempo de la demo; se muestra el log real fechado que certifica la recuperación de las **494 tablas**, **3 cursos** y **12 usuarios activos** en la base temporal `moodle_restore_test` sin tocar la base de producción.

---

### Persona 5. Control de Acceso entre Departamentos [11:15 – 14:00 · 2:45 min]

Demostración práctica del aislamiento departamental con 3 navegadores o perfiles independientes:
1. **Marta Jiménez (Administración):** En *«Mis cursos»* solo aparece Gestión Documental (`CTCR-ADM-101`).
2. **Marta intenta entrar al curso de Docencia:** Pega `https://aulavirtual.ctcr/course/view.php?id=3` y Moodle rechaza: *«No se puede auto matricular en este curso»*.
3. **Marta abre la URL directa del PDF de Informática:** Pega `https://aulavirtual.ctcr/mod/resource/view.php?id=18` y Moodle niega la entrega del archivo (*«Error: Lo sentimos, el archivo solicitado no se encuentra»*).
4. **Prueba de control con Valeria Sánchez (Informática):** En su navegador abre exactamente esa misma URL (`https://aulavirtual.ctcr/mod/resource/view.php?id=18`) y el PDF **sí abre de inmediato**. Esto demuestra de forma irrefutable que lo anterior fue una denegación de permisos y no un enlace roto.
5. **Daniel Vargas (Profesor de Informática):** En su sesión privada abre *Calificaciones → Informe del calificador* de su curso, pero al intentar abrir `https://aulavirtual.ctcr/admin/`, Moodle le niega el acceso administrativo (*«No se han encontrado resultados»*).

*Credencial unificada de prueba para todos los usuarios:* `Ctcr2026!Segura#`

---

## 3. Preguntas de Conocimiento con Comandos (9 Minutos)

El profesor elige a cualquier persona para ejecutar e interpretar los comandos de diagnóstico:

| Comando a Ejecutar | Qué se evalúa y qué responder |
|---|---|
| `sudo named-checkconf && sudo named-checkzone ctcr /etc/bind/db.ctcr` | Sintaxis BIND9 y serial de la zona `ctcr` cargada con respuesta autoritativa. |
| `sudo nginx -t && systemctl is-active named nginx vsftpd cron` | Integridad de Nginx y verificación de que los cuatro servicios del host están `active`. |
| `sudo iptables-save` (o `sudo ufw status verbose`) | **Pregunta trampa:** UFW no está instalado en VM 1 (`command not found`). Se responde: *«El lineamiento pide ufw.txt solo si se usa; en este servidor el filtrado y el NAT se gestionan con iptables persistente para no colisionar con las cadenas de Docker»*. |
| `ls -ld /srv/ftp/*/archivos` | Permisos `0700` por usuario; raíz del chroot en `root:root 755` para evitar el error 500 de vsftpd por raíz escribible. |
| `curl -k --ssl-reqd -u marta.jimenez:Ctcr2026!Segura# ftp://192.168.50.1/` | Conexión FTPS explícita con TLSv1.3 obligatoria y listado de su carpeta `archivos`. |
| `./scripts/verificar-alta-disponibilidad.sh` | Demostración del Bonus HA: caída forzada de una instancia Moodle y respuesta inmediata en 0.165 s de la segunda instancia manteniendo HTTP 200 continuo. |

---

## 4. Preguntas Difíciles del Escenario

| Pregunta probable | Respuesta técnica exacta |
|---|---|
| **¿Corrió alguna vez el respaldo de las 02:00?** | Sí, en VM 2 existe el archivo `ctcr_moodle_2026-11-07_02-00-01.sql.gz` en `/var/backups/moodle/`. Si la máquina estuvo apagada de madrugada, se reconoce con honestidad y se explica la alternativa de usar `anacron`. |
| **Si Docker solo publica 127.0.0.1, ¿qué riesgo había en activar UFW?** | El riesgo hacia Moodle era bajo, pero UFW podía alterar la cadena `FORWARD` y las reglas de `MASQUERADE` que dan salida a Internet a Linux Mint, además de bloquear los puertos pasivos dinámicos de FTPS. |
| **Si el código está en el volumen `moodle_code`, ¿qué pasa al cambiar la imagen a 4.5.16?** | El volumen conserva el código anterior: cambiar el tag de la imagen no actualiza Moodle automáticamente. Se requiere ejecutar el asistente de actualización (`admin/cli/upgrade.php`). |
| **¿Por qué se usa `oksigenia/moodle`?** | Imagen mantenida de software libre elegida tras el fin de soporte de Bitnami. En el entregable se fija por tag y por digest SHA-256 en `versiones.txt`. |

---

## 5. Lista de Verificación Inmediata antes de Presentar

- [x] VM 1 y VM 2 encendidas; `docker compose ps` muestra todos los contenedores en estado `healthy`.
- [x] `sha256sum -c hashes.txt` devuelve `OK` en todos los archivos.
- [x] Cliente Linux Mint con DNS apuntando a `192.168.50.1`; `https://aulavirtual.ctcr` carga con candado válido.
- [x] Marta Jiménez (Firefox), Valeria Sánchez (Chromium) y Daniel Vargas (ventana privada) con sesiones ya iniciadas.
- [x] URL directa del PDF de Informática copiada en el portapapeles: `https://aulavirtual.ctcr/mod/resource/view.php?id=18`.
- [x] Terminales abiertas y ordenadas por pestaña para cada expositor.
- [x] Documento técnico en PDF abierto como respaldo ante cualquier contingencia.
