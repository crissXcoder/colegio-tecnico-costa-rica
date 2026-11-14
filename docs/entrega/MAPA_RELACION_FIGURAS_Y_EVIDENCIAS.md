# Mapa Oficial de Evidencias, Figuras y Capturas — CTCR Moodle (EIF431O)

Este documento resuelve y aclara de forma definitiva la relación entre las **27 Figuras del Documento Técnico**, las **138 Evidencias de la Bitácora (EV-xxx)** y los archivos físicos de imagen del proyecto.

---

## 1. ¿Por qué en el texto se referencian códigos como (EV-001) a (EV-138) pero las imágenes se llaman Figuras 1 a 27?

1. **Origen de los códigos EV-xxx:**
   - Durante la ejecución del proyecto, el grupo documentó minuciosamente cada comando y prueba técnica en una bitácora exhaustiva que acumuló **138 evidencias numeradas de EV-001 a EV-138** (registradas en el repositorio en `docs/procedimientos/*/*/evidencias/` y catalogadas en `evidencias/manifiesto-detallado.csv`).
   - Cada evidencia `EV-xxx` tiene su captura individual, fecha, autor, límites de prueba y firma SHA-256 inmutable.

2. **Estructura del Documento Técnico Oficial (Word / PDF):**
   - Para no sobrecargar el informe formal de 36 páginas con 138 imágenes consecutivas, el equipo seleccionó las **27 capturas y diagramas más representativos y críticos**, diagramándolos bajo el estándar académico formal como **`Figura 1` a `Figura 27`**.
   - En el cuerpo del texto y en las tablas comparativas (como la Tabla 11), se mantuvieron las citas periciales `(EV-067)`, `(EV-102)`, `(EV-131 a EV-138)` como **referencias bibliográficas/cruzadas hacia la bitácora del repositorio**, indicando el número de prueba técnica que respalda cada afirmación.

3. **Disponibilidad Total:**
   - Tanto las **27 Figuras del Documento** como las **138 Evidencias de la Bitácora** están 100% disponibles, organizadas y convertidas para su visualización directa.

---

## 2. Índice de las 27 Figuras Oficiales del Documento

| Figura | Archivo de Imagen | Sección / Paso | Descripción Técnica |
|---|---|---|---|
| **Figura 1** | `Figura_01_Arquitectura_Final_HA_Dos_VM.png` | Sec. 4.1 / HA | Arquitectura final de dos VM con alta disponibilidad (Nginx + Moodle 1 y 2 + MariaDB Host-only). |
| **Figura 2** | `Figura_02_Compose_Original_Imagenes_Fijas.png` | Sec. 5.1 / Paso 04 | Evidencia de imágenes Docker fijas y Compose previo a la separación en dos VM. |
| **Figura 3** | `Figura_03_Reinicio_Local_Persistencia.png` | Sec. 5.4 / Paso 04 | Comprobación de reinicio y persistencia de contenedores. |
| **Figura 4** | `Figura_04_Volumenes_Docker_ls.png` | Sec. 5.4 / Paso 04 | Listado de volúmenes persistentes del proyecto (`docker volume ls`). |
| **Figura 5** | `Figura_05_Portada_Moodle_Personalizada.png` | Sec. 6.1 / Paso 06 | Portada principal de Moodle personalizada con logotipo institucional CTCR. |
| **Figura 6** | `Figura_06_Tres_Cursos_Administrador.png` | Sec. 6.2 / Paso 06 | Los 3 cursos creados vistos por el administrador (Administración, Docencia, Informática). |
| **Figura 7** | `Figura_07_Cohortes_Institucionales.png` | Sec. 6.3 / Paso 06 | Configuración de las 3 cohortes del sistema (Personal de Administración, Docencia, Informática). |
| **Figura 8** | `Figura_08_Metodos_Matriculacion_Administracion.png` | Sec. 6.3 / Paso 06 | Métodos de matriculación: sincronización por cohorte activa; auto-matriculación deshabilitada. |
| **Figura 9** | `Figura_09_Participantes_Curso_Administracion.png` | Sec. 6.4 / Paso 06 | Participantes del curso de Administración (funcionarios asignados vía cohorte). |
| **Figura 10** | `Figura_10_Contenido_Curso_Administracion.jpg` | Sec. 6.4 / Paso 06 | Contenido curricular del curso CTCR-ADM-101 (Manuales y Guías). |
| **Figura 11** | `Figura_11_Contenido_Curso_Docencia.png` | Sec. 6.4 / Paso 06 | Contenido curricular del curso CTCR-DOC-101 (Diseño de instrumentos y cuestionario). |
| **Figura 12** | `Figura_12_Contenido_Curso_Informatica.jpg` | Sec. 6.4 / Paso 06 | Contenido curricular del curso CTCR-INF-101 (Manuales y cuestionario). |
| **Figura 13** | `Figura_13_Consulta_DNS_BIND9_Autoritativo.png` | Sec. 7.1 / Paso 07 | Consulta a BIND9 con `dig`: respuesta autoritativa (`flags: aa`) para `aulavirtual.ctcr`. |
| **Figura 14** | `Figura_14_Cliente_Mint_Ping_DNS_HTTPS_Curl.png` | Sec. 7.2 / Paso 07 | Cliente Linux Mint: resolución DNS y handshake HTTPS exitoso vía `curl -k`. |
| **Figura 15** | `Figura_15_Sitio_Moodle_Firefox_HTTPS.png` | Sec. 7.3 / Paso 08 | Aula Virtual cargada en navegador Firefox bajo HTTPS seguro (`https://aulavirtual.ctcr`). |
| **Figura 16** | `Figura_16_Prueba_FTPS_Permisos_700_Denegado.png` | Sec. 8.1 / Paso 09 | Permisos 700 en carpetas FTPS y denegación de acceso cruzado entre departamentos. |
| **Figura 17** | `Figura_17_Configuracion_Cron_Respaldo.png` | Sec. 9.1 / Paso 10 | Configuración de tarea Cron diaria a las 02:00 AM para respaldo automatizado. |
| **Figura 18** | `Figura_18_Sesion_Marta_Jimenez_Administracion.png` | Sec. 11.1 / Paso 11 | Sesión de Marta Jiménez (Administración): únicamente ve su curso asignado. |
| **Figura 19** | `Figura_19_Prueba1_Denegacion_Matricula_Docencia.png` | Sec. 11.2 / Paso 11 | Prueba 1: intento de auto-matriculación en curso de Docencia denegado. |
| **Figura 20** | `Figura_20_Prueba2_Denegacion_PDF_Informatica.png` | Sec. 11.3 / Paso 11 | Prueba 2: intento de acceso por URL directa al PDF de Informática bloqueado. |
| **Figura 21** | `Figura_21_Calificador_Profesor_Daniel_Informatica.png` | Sec. 11.4 / Paso 11 | Profesor Daniel consulta el informe del calificador exclusivo de su asignatura. |
| **Figura 22** | `Figura_22_Prueba4_Profesor_Admin_Denegado.png` | Sec. 11.5 / Paso 11 | Prueba 4: profesor intenta acceder a `/admin` y Moodle no entrega opciones. |
| **Figura 23** | `Figura_23_Validacion_Entorno_Inicial_02Nov.png` | Sec. 11.6 / Paso 11 | Resumen de validación del entorno inicial previo a la fase de alta disponibilidad. |
| **Figura 24** | `Figura_24_Conmutacion_HA_Failover_Log_Nginx.png` | Sec. 13.2 / HA | Secuencia de conmutación transparente en logs de Nginx al detener Moodle 1. |
| **Figura 25** | `Figura_25_Interfaces_Red_VM1_y_VM2_ip_addr.png` | Sec. 13.4 / HA | Interfaces IP en ambas VMs (`ip -br addr`) demostrando el segmento Host-only. |
| **Figura 26** | `Figura_26_Zona_Horaria_Sincronizacion_timedatectl.png` | Sec. 13.4 / HA | Sincronización horaria NTP idéntica en VM 1 y VM 2 con `timedatectl`. |
| **Figura 27** | `Figura_27_Contenedores_Compose_ps_VM1_VM2.png` | Sec. 13.4 / HA | Estado `healthy` simultáneo de contenedores en VM 1 y VM 2 con `docker compose ps`. |

---

## 3. Principales Evidencias Citadas en Texto y su Ubicación

| Código Citado | Prueba / Tema que Respalda | Archivo en Repositorio / Galería |
|---|---|---|
| **`EV-001`** | Conectividad cliente Mint -> VM 1 | `02_Evidencias_Completas_Bitacora_138/EV-001_Mint_ping_hacia_Ubuntu_Server.png` |
| **`EV-010`** | Despliegue compose y servicios | `02_Evidencias_Completas_Bitacora_138/EV-010_docker_compose_up_y_estado_de_los_serv.png` |
| **`EV-051`** | Pruebas cliente en red interna | `02_Evidencias_Completas_Bitacora_138/EV-051_DNS_Prueba_de_resolucion_directa.png` |
| **`EV-063`** | Versión de BIND9 en Ubuntu Server | `02_Evidencias_Completas_Bitacora_138/EV-063_named_v_Version_del_servicio_DNS.png` |
| **`EV-067`** | Versión de Nginx 1.28.3 en VM 1 | `02_Evidencias_Completas_Bitacora_138/EV-067_nginx_v_Version_del_servidor_web_pro.png` |
| **`EV-071`** | Versión de vsftpd en Ubuntu Server | `02_Evidencias_Completas_Bitacora_138/EV-071_vsftpd_v_Version_del_servicio_FTPS.png` |
| **`EV-102`** | Auditoría de firewall iptables / NAT | `02_Evidencias_Completas_Bitacora_138/EV-102_Auditoria_de_reglas_iptables_cadenas.png` |
| **`EV-130`** | Diagnóstico de comando UFW no encontrado | `02_Evidencias_Completas_Bitacora_138/EV-130_UFW_comando_no_encontrado.png` |
| **`EV-131`** | Configuración de red Host-only en 2 VMs | `02_Evidencias_Completas_Bitacora_138/EV-131_Red_Hostonly_ip_br_addr_y_ping_bidir.png` |
| **`EV-132`** | Base de datos MariaDB remota en VM 2 | `02_Evidencias_Completas_Bitacora_138/EV-132_MariaDB_remota_en_VM_2_puerto_3306_esc.png` |
| **`EV-133`** | Verificación de conexión TCP 3306 | `02_Evidencias_Completas_Bitacora_138/EV-133_Verificacion_de_conexion_TCP_3306_des.png` |
| **`EV-134`** | Moodle 1 conectado a MariaDB en VM 2 | `02_Evidencias_Completas_Bitacora_138/EV-134_Moodle_1_en_VM_1_apuntando_a_MariaDB.png` |
| **`EV-135`** | Checklist de 8 puntos de verificación | `02_Evidencias_Completas_Bitacora_138/EV-135_Verificacion_funcional_completa_8_pun.png` |
| **`EV-136`** | Conmutación por error y log Nginx | `02_Evidencias_Completas_Bitacora_138/EV-136_Conmutacion_por_error_con_Moodle_1_de.png` |
| **`EV-137`** | Alta disponibilidad balanceada M1 y M2 | `02_Evidencias_Completas_Bitacora_138/EV-137_Alta_disponibilidad_activa_con_dos_in.png` |
| **`EV-138`** | Cron en VM 2 y restauración probada | `02_Evidencias_Completas_Bitacora_138/EV-138_Cron_en_VM_2_y_restauracion_verificad.png` |

---

## 4. Cómo abrir y visualizar las capturas

1. **Vía Galería Web (Recomendado):**
   - Abrí el archivo `GALERIA_VISUAL_CAPTURAS.html` en Firefox o Chromium dentro de Linux Mint con un doble clic.
   - Navegá entre las 27 Figuras y las 138 Evidencias, filtrá con el buscador y hacé clic en cualquier imagen para verla en pantalla completa.
2. **Vía Explorador de Archivos:**
   - La carpeta `01_Figuras_Documento_Oficial_27` contiene las 27 figuras en alta resolución listas para proyectar.
   - La carpeta `02_Evidencias_Completas_Bitacora_138` contiene las 138 capturas individuales de la bitácora técnica.
