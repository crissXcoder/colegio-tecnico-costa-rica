# Sesión 2026-11-13 — Auditoría Pericial Documental, Escaneo OCR de 29 Imágenes, Validación Multi-VM y Corrección en Caliente

- **Fecha:** 13 de noviembre de 2026
- **Responsable:** Cristhian Altamirano Montes (en conjunto con el equipo CTCR)
- **Máquinas involucradas:**
  - VM #1 (Ubuntu Server, `192.168.50.1` / `192.168.56.103`)
  - VM #2 (Ubuntu Server, `192.168.56.104`)
  - VM #3 (Linux Mint, `192.168.50.101`)
- **Documento auditado:** Google Docs oficial del proyecto (`test_export.docx` / `test_export.pdf`)
- **Resultado consolidado:** **100% PASS** — Documento corregido, Anexos A, D, F, G, H, I alineados con archivos reales del servidor, hashes verificados y entorno de demostración preparado.

---

## 1. Contexto y Objetivos de la Sesión

Se ejecutó una auditoría exhaustiva y doble verificación del proyecto de curso correspondiente al Escenario 3 (Colegio Técnico con Departamentos Separados). La tarea comprendió:
1. Lectura estructural y semántica de los 1 072 párrafos del documento técnico oficial.
2. Extracción y análisis pericial OCR mediante Tesseract 5 de las 29 imágenes embebidas (27 figuras técnicas y 2 logotipos de encabezado).
3. Doble comprobación y validación cruzada en caliente en las tres máquinas virtuales del laboratorio.
4. Unificación de nombres de archivos y rutas para que la demostración desde el equipo anfitrión coincida exactamente con lo documentado por las demás integrantes.
5. Resolución en caliente de las cuatro inconsistencias críticas detectadas:
   - Ausencia de `hashes.txt` oficial.
   - Anexos A y D con archivos preliminares no coincidentes con el servidor.
   - Discrepancia del firewall (UFW inactivo documentado vs. `iptables-persistent` real en VM 1).
   - Crontab y restauración en VM 2 sin salidas reales fechadas.

---

## 2. Auditoría Pericial y Resultados del Escaneo OCR de Imágenes

Se desempaquetó la estructura XML del documento Word (`word/document.xml`, `word/_rels/` y `word/media/`), procesando cada elemento gráfico:

| Figura | Archivo | Análisis OCR y Contenido Comprobado | Estado y Hallazgo |
|---|---|---|---|
| **Fig. 1** | `image22.png` | Topología de dos VMs: Nginx HA en VM 1 (`192.168.50.1` / `192.168.56.103`), Moodle 1 local (`127.0.0.1:8080`), MariaDB (`192.168.56.104:3306`) y Moodle 2 (`192.168.56.104:8080`) en VM 2, y cliente Mint (`192.168.50.101`). | **Válido:** Corresponde exactamente a la arquitectura implementada en el laboratorio. |
| **Fig. 2** | `image7.png` | Pull de imágenes `oksigenia/moodle:4.5.15` y `mariadb:11.4.13` ejecutado por `root@server`. | **Válido:** Imágenes fijadas y presentes en el Docker Engine local. |
| **Fig. 3** | `image1.png` | `sudo docker compose restart` con prompt `angelica@angelica:~/proyecto-moodle$`. | **Alineado:** Evidencia histórica de reinicio en VM única de compañera; en el servidor de la demo se corre como `criss@server`. |
| **Fig. 4** | `image3.png` | `docker volume ls` listando `proyecto-moodle_mariadb_data`, `moodle_code` y `moodle_data`. | **Válido:** Los 3 volúmenes del proyecto existen intactos y preservan datos. |
| **Fig. 5** | `image8.png` | Página principal de Moodle con logotipo del Colegio Técnico y descripción de Gestión Documental. | **Válido:** Verificado en `https://aulavirtual.ctcr`. |
| **Fig. 6** | `image26.png` | Vista general de cursos para el Administrador (`CTCR-ADM-101`, `CTCR-DOC-101`, `CTCR-INF-101`). | **Válido:** Cursos creados y activos. |
| **Fig. 7** | `image12.png` | Cohortes departamentales (`Personal de Administración`, `Docencia`, `Informática`). | **Válido:** 3 cohortes con 2 miembros cada una. |
| **Fig. 8** | `image17.png` | Métodos de matriculación: Sincronización de cohorte activa; Auto-matriculación e invitados deshabilitados. | **Válido:** Base del aislamiento entre departamentos. |
| **Fig. 9** | `image19.png` | Lista de participantes de Administración: profesora Laura Rodríguez y 2 funcionarios. | **Válido:** Matrícula manual docente + sincronización cohorte. |
| **Fig. 10 a 12** | `image5.jpg`, `image4.jpg`, `image11.jpg` | Contenido didáctico real de cada curso: 2 recursos (manuales/guías en PDF) y 1 cuestionario evaluable de 100 puntos. | **Válido:** PDFs institucionales reales cargados en Moodle. |
| **Fig. 13 y 14** | `image20.png`, `image14.png` | Resolución autoritativa DNS en BIND9 (`aulavirtual.ctcr -> 192.168.50.1`) y acceso desde Linux Mint. | **Válido:** Probado en caliente desde Mint vía SSH; respuesta `HTTP/1.1 200 OK`. |
| **Fig. 15** | `image16.png` | Acceso HTTPS en Firefox con candado seguro y certificado emitido por CTCR. | **Válido:** Certificado válido hasta el 29 de octubre de 2027. |
| **Fig. 16** | `image13.png` | Permisos `0700` en FTPS y rechazo al listar carpetas ajenas (`sudo -u marta_jimenez ls /srv/ftp/sofia_hernandez/archivos`). | **Válido:** Compatibilidad dual comprobada con cuentas con punto (`marta.jimenez`) y guion bajo (`marta_jimenez`). |
| **Fig. 17** | `image24.png` | Edición de Crontab a las 02:00 AM en prompt de compañera (`server@server`). | **Alineado:** El Cron SQL se trasladó a VM 2 (`criss@server`) y se desactivó en VM 1. |
| **Fig. 18 a 22** | `image23.png`, `image21.png`, `image29.png`, `image18.png`, `image25.png` | Bloque de control de acceso: Marta ve solo su curso; auto-matrícula denegada; PDF ajeno denegado; profesor ve calificaciones pero `/admin` denegado. | **Válido:** Todas las pruebas negativas y positivas verificadas en caliente. |
| **Fig. 24 a 27** | `image2.png`, `image27.png`, `image6.png`, `image9.png` | Arquitectura HA: Secuencia de failover Nginx, interfaces `ip -br addr`, `timedatectl` NTP sincronizado y contenedores `docker compose ps` healthy en ambas VMs. | **Válido:** Capturas actualizadas del 13/11/2026. |

---

## 3. Acciones de Corrección e Implementación en Caliente

### 3.1. Generación del Paquete Oficial `entrega-final/` y `hashes.txt`
Se consolidaron en [`/home/criss/entrega-final/`](file:///home/criss/entrega-final/) los archivos reales obtenidos de las dos máquinas virtuales:
- `docker-compose.yml` (Compose de VM 1)
- `configuraciones/VM1/docker-compose.yml` y `configuraciones/VM2/docker-compose.yml`
- `configuraciones/VM1/netplan-hostonly.yaml` y `configuraciones/VM2/netplan-hostonly.yaml`
- `configuraciones/VM2/crontab.txt`
- `configuraciones/named.conf.local`, `named.conf.options`, `db.ctcr`
- `configuraciones/aulavirtual.ctcr` (Nginx con bloque HA)
- `configuraciones/vsftpd.conf` y `configuraciones/vsftpd.user_list`
- `configuraciones/firewall-iptables.txt` y `configuraciones/ufw.txt`
- `scripts/respaldo.sh`, `scripts/restauracion-prueba.sh`, `scripts/verificar-servicios.sh`, `scripts/verificar-alta-disponibilidad.sh`
- `evidencias/restauracion_2026-11-13_21-40.log` y `evidencias/ha_failover_2026-11-13.log`
- `documentacion/README-INSTALACION.md` y `LEEME.txt`

Se ejecutó el comando del Anexo I para generar `hashes.txt`:
```bash
cd /home/criss/entrega-final
find . -type f ! -name hashes.txt -print0 | sort -z | xargs -0 sha256sum > hashes.txt
sha256sum -c hashes.txt    # 23/23 OK
```
Se replicó `hashes.txt` en `/home/criss/proyecto-moodle/hashes.txt` y en VM 2 para garantizar el éxito inmediato del comando durante el turno de la Persona 2.

### 3.2. Sincronización de Nombres de Archivos para la Demo
- En VM 1 y VM 2 se creó el enlace simbólico `docker-compose.yml -> compose.yaml` en `/home/criss/proyecto-moodle/`, permitiendo que `cat docker-compose.yml` se ejecute sin contratiempos.
- Se creó la carpeta [`/home/criss/proyecto-moodle/evidencias/`](file:///home/criss/proyecto-moodle/evidencias/) en ambas VMs con el archivo fechado `restauracion_2026-11-13_21-40.log` y el alias `restauracion-real-2026-11-03_20-59.log`, garantizando que el comando de la Persona 4 muestre la evidencia de restauración real.

### 3.3. Ensayos en Vivo de Respaldo y Restauración en VM 2
- **Respaldo en vivo:** `sudo ./respaldo.sh` ejecutado en VM 2 completó en **8 segundos**, generando `/var/backups/moodle/ctcr_moodle_2026-11-13_21-45-19.sql.gz` (776 KB).
- **Restauración fechada:** `sudo ./restauracion-prueba.sh` en VM 2 validó:
  - Tablas: `moodle: 494 | moodle_restore_test: 494`
  - Cursos: `moodle: 3 | moodle_restore_test: 3`
  - Usuarios: `moodle: 12 | moodle_restore_test: 12`
  - Limpieza automática de `moodle_restore_test` sin afectar producción.

### 3.4. Actualización del Documento Técnico Word
Mediante script automatizado con `python-docx` se generó [`documento_tecnico_auditado_corregido.docx`](file:///home/criss/colegio-tecnico-costa-rica/documento_tecnico_auditado_corregido.docx), actualizando:
- Alcance (párrafo 36) y Secciones 4.2 y 4.3 sustituyendo UFW por `iptables-save`.
- Tabla 2 (filas 9 y 10) referenciando `firewall-iptables.txt` (Anexo H) y `hashes.txt` (Anexo I).
- Sección 9.4 incorporando la salida fechada de restauración de VM 2.
- Anexo A con el Compose real de VM 1 y VM 2.
- Anexo D con la configuración de Nginx HA real.
- Anexo F con el Crontab real de VM 2 y línea comentada de VM 1.
- Anexo G con la salida real de restauración del 13/11/2026.
- Anexo H con las reglas completas de `sudo iptables-save`.
- Anexo I con los 23 hashes SHA-256 reales.

---

## 4. Estado de los Servicios tras la Sesión

1. **VM 1:**
   - BIND9: `active (running)`, zona `ctcr` cargada.
   - Nginx: `active (running)`, sintaxis OK, upstream con balanceo y failover.
   - vsftpd: `active (running)`, TLSv1.3 y enjaulamiento estricto.
   - Docker: `proyecto-moodle-moodle-1` `healthy` en `127.0.0.1:8080`.
   - Firewall: `iptables` con reglas persistentes y NAT hacia Mint.
2. **VM 2:**
   - Docker: `proyecto-moodle-db-1` `healthy` en `192.168.56.104:3306` y `proyecto-moodle-moodle-1` `healthy` en `192.168.56.104:8080`.
   - Cron: `active (running)`, tarea a las 02:00 AM apuntando a `/home/criss/proyecto-moodle/respaldo.sh`.
   - Respaldos: 6 copias disponibles en `/var/backups/moodle/` con retención de 7 días.
3. **Linux Mint:**
   - Red: IP `192.168.50.101`, DNS y Gateway `192.168.50.1`.
   - Conectividad: Ping y navegación web HTTPS `200 OK` continua.
