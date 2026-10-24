# Inventario comentado de artefactos — documentación, ejecución, pruebas y evidencia

Este inventario es para **incorporar lectores ajenos al grupo**: cada archivo tiene una responsabilidad, se indica qué contiene y su contexto. A diferencia de un `tree`, permite entender por qué abrir o modificar una ruta. Las 50 capturas y sus 50 fichas están explicadas con precisión en sus propios pasos y en el [catálogo EV](../../evidencias/CATALOGO-CAPTURAS.md).

## Archivos de gobierno, fuente y operación

- **[`.editorconfig`](../../.editorconfig)** — Preferencias editoriales para no introducir inconsistencias de formato o finales de línea.
- **[`.gitattributes`](../../.gitattributes)** — Reglas de atributos y tratamiento de archivos en Git.
- **[`.github/ISSUE_TEMPLATE/incidencia.md`](../../.github/ISSUE_TEMPLATE/incidencia.md)** — Modelo de issue de error reproducible con VM, síntoma, prueba y vínculo a INC.
- **[`.github/PULL_REQUEST_TEMPLATE.md`](../../.github/PULL_REQUEST_TEMPLATE.md)** — Checklist de revisión de cambios con capturas y documentación antes de merge.
- **[`.github/workflows/validar-documentacion.yml`](../../.github/workflows/validar-documentacion.yml)** — GitHub Actions para revisar enlaces, Bash e inclusión accidental de archivos .env.
- **[`.gitignore`](../../.gitignore)** — Política de exclusión de .env, claves, backups y archivos locales no versionables.
- **[`AGENTS.md`](../../AGENTS.md)** — Reglas de actuación para agentes y colaboradores: leer fuente, contrastar con VM real, documentar y no declarar éxitos no probados.
- **[`ANALISIS-FUENTES.md`](../../ANALISIS-FUENTES.md)** — Auditoría inicial de documentos, repo externo y riesgos técnicos detectados; conserva el análisis base heredado.
- **[`CAMBIOS-V2.md`](../../CAMBIOS-V2.md)** — Registro del salto de v1 a v2, necesario para explicar por qué había subpasos y evidencia histórica.
- **[`CAMBIOS-V3.md`](../../CAMBIOS-V3.md)** — Registro detallado de la reorganización física de capturas y el refuerzo de README.
- **[`CONTRIBUTING.md`](../../CONTRIBUTING.md)** — Contrato de colaboración con revisión cruzada y ejecución de sesiones simultáneas para los cinco miembros.
- **[`README.md`](../../README.md)** — Puerta principal para audiencia nueva: negocio, arquitectura, estado, rutas y procedimiento de trabajo.
- **[`bitacora/incidentes/INC-001-almacenamiento-lvm.md`](../../bitacora/incidentes/INC-001-almacenamiento-lvm.md)** — Registro del error disco lleno/LVM, su diagnóstico y límites para repetir la solución en otros hosts.
- **[`bitacora/sesiones/2026-10-22-reconstruccion-bitacora-v2.md`](../../bitacora/sesiones/2026-10-22-reconstruccion-bitacora-v2.md)** — Reconstrucción histórica de actividades que aparecen fotografiadas en la bitácora de 26 páginas; no atribuye horas no conocidas.
- **[`bitacora/sesiones/2026-10-23-estado-heredado.md`](../../bitacora/sesiones/2026-10-23-estado-heredado.md)** — Corte inicial del estado recibido, sin suponer que todos los servicios estaban terminados.
- **[`docs/00-proyecto/COBERTURA-Y-TRAZABILIDAD.md`](COBERTURA-Y-TRAZABILIDAD.md)** — Mapa de requisitos y tramos históricos EV que conectan un procedimiento con una prueba por completar.
- **[`docs/00-proyecto/ESTADO.md`](ESTADO.md)** — Estado de progreso que distingue propuesta, evidencia parcial y aceptación reproducida por máquina.
- **[`docs/00-proyecto/README.md`](README.md)** — Contrato funcional y de infraestructura del Colegio Técnico: alcance, topología y lectoría de archivos.
- **[`docs/00-proyecto/matriz-requisitos.md`](matriz-requisitos.md)** — Matriz RC/RE/RA de la rúbrica con criterio de aceptación y pendientes.
- **[`docs/00-proyecto/responsabilidades.md`](responsabilidades.md)** — RACI simplificada de preparación/autoría/revisión por integrante, diferenciada del trabajo presencial conjunto.
- **[`docs/00-proyecto/versiones.md`](versiones.md)** — Versiones objetivo frente a evidencia efectiva; previene suposiciones sobre tag/digest por equipo.
- **[`docs/entrega/comparativa-software.md`](../entrega/comparativa-software.md)** — Material para justificar tecnologías libres versus alternativas, en vez de limitarse a costo de licencia.
- **[`docs/fuentes/GUIA-HISTORICA-INTEGRA.md`](../fuentes/GUIA-HISTORICA-INTEGRA.md)** — Transcripción completa del texto pegado con comandos originales del chat; referencia congelada, no guía de VM aprobada.
- **[`docs/fuentes/auditoria-dockerlabs.md`](../fuentes/auditoria-dockerlabs.md)** — Evaluación del repositorio Dockerlabs de uso docente; separa ideas aplicables de contraseñas/versiones antiguas.
- **[`docs/operacion/COPIAR-PEGAR.md`](../operacion/COPIAR-PEGAR.md)** — Recetario acotado para VM existente y VM nueva, con diferencias entre HTTP inicial y HTTPS final.
- **[`docs/operacion/INVENTARIO-POR-INTEGRANTE.md`](../operacion/INVENTARIO-POR-INTEGRANTE.md)** — Campos para levantar configuración real de cada VM y detectar divergencias entre los cinco.
- **[`docs/operacion/REINICIO-Y-RECUPERACION.md`](../operacion/REINICIO-Y-RECUPERACION.md)** — Orden para retomar Compose y cliente Mint tras apagar equipos, sin eliminar volúmenes.
- **[`docs/operacion/RESTAURACION-ENSAYO.md`](../operacion/RESTAURACION-ENSAYO.md)** — Importación de dump SQL a base aislada moodle_restore_test, preservando base Moodle real.
- **[`evidencias/CATALOGO-CAPTURAS.md`](../../evidencias/CATALOGO-CAPTURAS.md)** — Índice narrativo agrupado por paso con enlaces a fichas EV, nunca almacén único de imágenes.
- **[`evidencias/manifiesto-detallado.csv`](../../evidencias/manifiesto-detallado.csv)** — Índice estructurado con ID/archivo/paso/fuente/página/estado/hash de las 50 imágenes.
- **[`evidencias/manifiesto.csv`](../../evidencias/manifiesto.csv)** — Manifiesto compatible con los consumidores de v2; mantiene campos sincronizados.
- **[`infra/bind9/db.ctcr.test`](../../infra/bind9/db.ctcr.test)** — Archivo autoritativo de zona ctcr.test con registro NS, SOA y A hacia Ubuntu interno.
- **[`infra/bind9/named.conf.local.fragment`](../../infra/bind9/named.conf.local.fragment)** — Fragmento de declaración de zona para integrar en el named.conf.local existente.
- **[`infra/bind9/named.conf.options.fragment`](../../infra/bind9/named.conf.options.fragment)** — Fragmento de escucha, DNS de reenvío y restricción de recursión/consulta a la red interna.
- **[`infra/compose/.env.example`](../../infra/compose/.env.example)** — Esquema público de variables de instalación HTTP inicial; debe contener nombres y ejemplos, jamás secretos reales.
- **[`infra/compose/.env.https.example`](../../infra/compose/.env.https.example)** — Ejemplo de transición a URL segura y backend local sin sustituir archivo privado existente.
- **[`infra/compose/compose.yaml`](../../infra/compose/compose.yaml)** — Modelo de servicio Docker: Moodle y MariaDB, dependencias, red privada, imágenes parametrizadas y tres volúmenes persistentes.
- **[`infra/cron/moodle-backup.cron.example`](../../infra/cron/moodle-backup.cron.example)** — Línea de Cron de root para programar backups diarios y guardar log; ruta debe adaptarse por VM.
- **[`infra/nginx/moodle.conf.example`](../../infra/nginx/moodle.conf.example)** — VirtualHost con redirección HTTP, TLS autofirmado de laboratorio y proxy local para Moodle.
- **[`infra/vsftpd/vsftpd.conf.example`](../../infra/vsftpd/vsftpd.conf.example)** — Plantilla FTPS explícito, autenticación local, chroot, sustitución user_sub_token y puertos pasivos.
- **[`plantillas/adr.md`](../../plantillas/adr.md)** — Plantilla de decisión de arquitectura con alternativas, riesgos y consecuencias.
- **[`plantillas/incidente.md`](../../plantillas/incidente.md)** — Datos de diagnóstico, causa, arreglo, resultado, rollback y evidencia de un fallo.
- **[`plantillas/paso.md`](../../plantillas/paso.md)** — Modelo para documentar procedimiento nuevo con seguridad, resultado y evidencia local.
- **[`plantillas/prueba.md`](../../plantillas/prueba.md)** — Ficha para una prueba de aceptación con esperado y obtenido y evidencia verificable.
- **[`plantillas/sesion.md`](../../plantillas/sesion.md)** — Estructura de una reunión compartida de implementación, tareas, errores y decisiones.
- **[`scripts/backup-db.sh`](../../scripts/backup-db.sh)** — Dump SQL protegido con compresión/retención, sin restaurar ni respaldar automáticamente moodledata.
- **[`scripts/generate-env.sh`](../../scripts/generate-env.sh)** — Generador de contraseñas aleatorias para VM nueva con defensa contra sobrescribir .env.
- **[`scripts/inventory.sh`](../../scripts/inventory.sh)** — Lectura no destructiva del inventario Docker/Ubuntu para anexar a una sesión por VM.
- **[`scripts/validate-repository.py`](../../scripts/validate-repository.py)** — Revisión estática de enlaces, artefactos esperados y coherencia de las fichas e imágenes EV.

## Procedimientos: cada archivo significa una acción verificable

Los README de capítulo indican dependencias, los `.md` numerados conservan el comando/clic literal y el contexto, y la carpeta `<paso>/evidencias` guarda fotos y fichas relacionadas. Los capítulos completos están navegables desde el [manual](../procedimientos/README.md).

### [00-prerrequisitos](../procedimientos/00-prerrequisitos/README.md)

 **[00-01](../procedimientos/00-prerrequisitos/00-01.md)** (Preparación y comprobaciones antes de tocar una VM): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [01-servidor-red](../procedimientos/01-servidor-red/README.md)

 **[01-01](../procedimientos/01-servidor-red/01-01.md)** (Topología NAT e interna y verificación entre Ubuntu y Mint): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[01-02](../procedimientos/01-servidor-red/01-02.md)** (Estado de discos, LVM y recuperación del incidente histórico): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [02-ubuntu](../procedimientos/02-ubuntu/README.md)

 **[02-01](../procedimientos/02-ubuntu/02-01.md)** (Ubuntu Server, paquetes, SSH y conectividad): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [03-docker](../procedimientos/03-docker/README.md)

 **[03-01](../procedimientos/03-docker/03-01.md)** (Docker y Compose instalados; comprobación en frío): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [04-contenedores](../procedimientos/04-contenedores/README.md)

 **[04-01](../procedimientos/04-contenedores/04-01.md)** (Entrar a la carpeta que ya creamos): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-02](../procedimientos/04-contenedores/04-02.md)** (Confirmar las versiones de las imágenes): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-03](../procedimientos/04-contenedores/04-03.md)** (Generar las contraseñas): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-04](../procedimientos/04-contenedores/04-04.md)** (Crear el archivo Compose): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-05](../procedimientos/04-contenedores/04-05.md)** (Validar Compose): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-06](../procedimientos/04-contenedores/04-06.md)** (Descargar las imágenes): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-07](../procedimientos/04-contenedores/04-07.md)** (Levantar los contenedores): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-08](../procedimientos/04-contenedores/04-08.md)** (Confirmar la base de datos): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[04-09](../procedimientos/04-contenedores/04-09.md)** (Verificar los volúmenes): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [05-cliente-mint](../procedimientos/05-cliente-mint/README.md)

 **[05-01](../procedimientos/05-cliente-mint/05-01.md)** (Comprobar el servicio desde Ubuntu): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[05-02](../procedimientos/05-cliente-mint/05-02.md)** (Abrir Moodle desde Mint): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[05-03](../procedimientos/05-cliente-mint/05-03.md)** (Probar la persistencia): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [06-moodle](../procedimientos/06-moodle/README.md)

 **[06-01](../procedimientos/06-moodle/06-01.md)** (Personalizar la plataforma): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-02](../procedimientos/06-moodle/06-02.md)** (Crear las categorías de cursos): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-03](../procedimientos/06-moodle/06-03.md)** (Crear los tres cursos): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-04-cuestionarios](../procedimientos/06-moodle/06-04-cuestionarios.md)** (cuestionario evaluable y banco de preguntas (fase 06.04)): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-04](../procedimientos/06-moodle/06-04.md)** (Agregar los recursos y actividades): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-05](../procedimientos/06-moodle/06-05.md)** (Crear los usuarios de prueba): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-06](../procedimientos/06-moodle/06-06.md)** (Crear las cohortes departamentales): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-07](../procedimientos/06-moodle/06-07.md)** (Configurar la matrícula por cohorte): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[06-08](../procedimientos/06-moodle/06-08.md)** (Comprobar el aislamiento): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [07-dns-bind9](../procedimientos/07-dns-bind9/README.md)

 **[07-01](../procedimientos/07-dns-bind9/07-01.md)** (Instalar BIND9 en Ubuntu): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[07-02](../procedimientos/07-dns-bind9/07-02.md)** (Configurar las opciones DNS): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[07-03](../procedimientos/07-dns-bind9/07-03.md)** (Registrar la zona del proyecto): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[07-04](../procedimientos/07-dns-bind9/07-04.md)** (Crear el archivo de zona): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[07-05](../procedimientos/07-dns-bind9/07-05.md)** (Validar BIND9): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[07-06](../procedimientos/07-dns-bind9/07-06.md)** (Probar el DNS desde Ubuntu): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[07-07](../procedimientos/07-dns-bind9/07-07.md)** (Configurar Linux Mint para utilizar BIND9): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [08-https-nginx](../procedimientos/08-https-nginx/README.md)

 **[08-01](../procedimientos/08-https-nginx/08-01.md)** (Instalar Nginx): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[08-02](../procedimientos/08-https-nginx/08-02.md)** (Crear el certificado): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[08-03](../procedimientos/08-https-nginx/08-03.md)** (Crear el VirtualHost): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[08-04](../procedimientos/08-https-nginx/08-04.md)** (Habilitar el sitio): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[08-05](../procedimientos/08-https-nginx/08-05.md)** (Cambiar la URL de Moodle): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[08-06](../procedimientos/08-https-nginx/08-06.md)** (Probar HTTPS desde Ubuntu): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[08-07](../procedimientos/08-https-nginx/08-07.md)** (Abrir Moodle desde Linux Mint): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [09-ftps-vsftpd](../procedimientos/09-ftps-vsftpd/README.md)

 **[09-01](../procedimientos/09-ftps-vsftpd/09-01.md)** (Instalar el servicio): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[09-02](../procedimientos/09-ftps-vsftpd/09-02.md)** (Crear usuarios FTP): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[09-03](../procedimientos/09-ftps-vsftpd/09-03.md)** (Crear los directorios separados): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[09-04](../procedimientos/09-ftps-vsftpd/09-04.md)** (Crear una lista de usuarios permitidos): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[09-05](../procedimientos/09-ftps-vsftpd/09-05.md)** (Configurar vsftpd): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[09-06](../procedimientos/09-ftps-vsftpd/09-06.md)** (Reiniciar FTP): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[09-07](../procedimientos/09-ftps-vsftpd/09-07.md)** (Probar un usuario FTP): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[09-08](../procedimientos/09-ftps-vsftpd/09-08.md)** (Comprobar que los permisos funcionan): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [10-respaldos](../procedimientos/10-respaldos/README.md)

 **[10-01](../procedimientos/10-respaldos/10-01.md)** (Crear el directorio de respaldos): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[10-02](../procedimientos/10-respaldos/10-02.md)** (Crear el script de respaldo): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[10-03](../procedimientos/10-respaldos/10-03.md)** (Dar permisos de ejecución): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[10-04](../procedimientos/10-respaldos/10-04.md)** (Ejecutar un respaldo manual): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[10-05](../procedimientos/10-respaldos/10-05.md)** (Programar Cron): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[10-06](../procedimientos/10-respaldos/10-06.md)** (Probar una restauración sin dañar Moodle): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[10-07](../procedimientos/10-respaldos/10-07.md)** (¿Qué respaldamos y qué no?): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [11-verificacion](../procedimientos/11-verificacion/README.md)

 **[11-01](../procedimientos/11-verificacion/11-01.md)** (Comprobar los contenedores): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[11-02](../procedimientos/11-verificacion/11-02.md)** (Comprobar los servicios de Ubuntu): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[11-03](../procedimientos/11-verificacion/11-03.md)** (Comprobar los puertos): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[11-04](../procedimientos/11-verificacion/11-04.md)** (Comprobar los accesos desde Mint): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

 **[11-05](../procedimientos/11-verificacion/11-05.md)** (Verificar el firewall): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

### [12-entrega](../procedimientos/12-entrega/README.md)

 **[12-01](../procedimientos/12-entrega/12-01.md)** (Documentación académica y demostración en vivo): corresponde a una operación individual. Detalla dónde ejecutarla, comandos/GUI, archivos relacionados, comprobación y fotografías si existen.

## Documentos de fase y decisiones heredadas

Los documentos `docs/fases/<fase>/README.md` explican **qué entrega** cada fase, mientras los procedimientos explican **cómo**. Los ficheros `docs/fases/<fase>/pasos/STEP-...md` quedan conservados como planificación/gestión histórica, ahora enlazando el manual ampliado. Nunca editar una ficha STEP como sustituto del comando correcto.

- [01-servidor-red](../fases/01-servidor-red/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 2 fichas STEP históricas (si aplica).
- [02-contenedores](../fases/02-contenedores/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 6 fichas STEP históricas (si aplica).
- [03-moodle-contenidos](../fases/03-moodle-contenidos/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 5 fichas STEP históricas (si aplica).
- [04-autorizacion](../fases/04-autorizacion/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 3 fichas STEP históricas (si aplica).
- [05-dns](../fases/05-dns/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 3 fichas STEP históricas (si aplica).
- [06-https](../fases/06-https/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 4 fichas STEP históricas (si aplica).
- [07-ftps](../fases/07-ftps/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 3 fichas STEP históricas (si aplica).
- [08-respaldos](../fases/08-respaldos/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 4 fichas STEP históricas (si aplica).
- [09-presentacion](../fases/09-presentacion/README.md): descripción de alcance, dependencias, criterio de aceptación, responsable/revisor y 2 fichas STEP históricas (si aplica).

## Fichas STEP heredadas: para gestión, no para copiar comandos sin contexto

Estas fichas de versiones anteriores siguen presentes para que la estructura y las referencias del trabajo no se pierdan. Cada una indica un resultado previsto y ahora enlaza el manual detallado donde están los comandos completos. Se diferencian de las fichas `EV-XXX`, que documentan una observación fotográfica concreta.

- **[`docs/fases/01-servidor-red/pasos/STEP-01-01.md`](../fases/01-servidor-red/pasos/STEP-01-01.md)** — STEP-01-01 — Red interna de VirtualBox y direcciones; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/01-servidor-red/pasos/STEP-01-02.md`](../fases/01-servidor-red/pasos/STEP-01-02.md)** — STEP-01-02 — Diagnóstico de recursos y almacenamiento; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/02-contenedores/pasos/STEP-04-01.md`](../fases/02-contenedores/pasos/STEP-04-01.md)** — STEP-04-01 — Versiones y manifiestos; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/02-contenedores/pasos/STEP-04-02.md`](../fases/02-contenedores/pasos/STEP-04-02.md)** — STEP-04-02 — Variables privadas y credenciales; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/02-contenedores/pasos/STEP-04-03.md`](../fases/02-contenedores/pasos/STEP-04-03.md)** — STEP-04-03 — Crear y validar Compose; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/02-contenedores/pasos/STEP-04-04.md`](../fases/02-contenedores/pasos/STEP-04-04.md)** — STEP-04-04 — Descargar e iniciar los dos servicios; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/02-contenedores/pasos/STEP-04-05.md`](../fases/02-contenedores/pasos/STEP-04-05.md)** — STEP-04-05 — Verificar base y volúmenes; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/02-contenedores/pasos/STEP-05-01.md`](../fases/02-contenedores/pasos/STEP-05-01.md)** — STEP-05-01 — Acceso web y persistencia; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/03-moodle-contenidos/pasos/STEP-06-01.md`](../fases/03-moodle-contenidos/pasos/STEP-06-01.md)** — STEP-06-01 — Personalizar plataforma; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/03-moodle-contenidos/pasos/STEP-06-02.md`](../fases/03-moodle-contenidos/pasos/STEP-06-02.md)** — STEP-06-02 — Crear departamentos/categorías; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/03-moodle-contenidos/pasos/STEP-06-03.md`](../fases/03-moodle-contenidos/pasos/STEP-06-03.md)** — STEP-06-03 — Crear tres cursos; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/03-moodle-contenidos/pasos/STEP-06-04.md`](../fases/03-moodle-contenidos/pasos/STEP-06-04.md)** — STEP-06-04 — Cargar dos recursos genuinos por curso; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/03-moodle-contenidos/pasos/STEP-06-05.md`](../fases/03-moodle-contenidos/pasos/STEP-06-05.md)** — STEP-06-05 — Actividad evaluable y cuestionario; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/04-autorizacion/pasos/STEP-06-06.md`](../fases/04-autorizacion/pasos/STEP-06-06.md)** — STEP-06-06 — Usuarios y roles; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/04-autorizacion/pasos/STEP-06-07.md`](../fases/04-autorizacion/pasos/STEP-06-07.md)** — STEP-06-07 — Cohortes y matrícula; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/04-autorizacion/pasos/STEP-06-08.md`](../fases/04-autorizacion/pasos/STEP-06-08.md)** — STEP-06-08 — Denegación de acceso directo; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/05-dns/pasos/STEP-07-01.md`](../fases/05-dns/pasos/STEP-07-01.md)** — STEP-07-01 — Revisar puerto 53 y BIND9; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/05-dns/pasos/STEP-07-02.md`](../fases/05-dns/pasos/STEP-07-02.md)** — STEP-07-02 — Crear zona y registros; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/05-dns/pasos/STEP-07-03.md`](../fases/05-dns/pasos/STEP-07-03.md)** — STEP-07-03 — Resolver desde Linux Mint; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/06-https/pasos/STEP-08-01.md`](../fases/06-https/pasos/STEP-08-01.md)** — STEP-08-01 — Revisar Nginx y certificados; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/06-https/pasos/STEP-08-02.md`](../fases/06-https/pasos/STEP-08-02.md)** — STEP-08-02 — Configurar VirtualHost proxy; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/06-https/pasos/STEP-08-03.md`](../fases/06-https/pasos/STEP-08-03.md)** — STEP-08-03 — Migrar wwwroot a HTTPS; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/06-https/pasos/STEP-08-04.md`](../fases/06-https/pasos/STEP-08-04.md)** — STEP-08-04 — Verificación TLS y navegador; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/07-ftps/pasos/STEP-09-01.md`](../fases/07-ftps/pasos/STEP-09-01.md)** — STEP-09-01 — Decidir cuentas, rutas y PAM; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/07-ftps/pasos/STEP-09-02.md`](../fases/07-ftps/pasos/STEP-09-02.md)** — STEP-09-02 — Configurar vsftpd y certificados; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/07-ftps/pasos/STEP-09-03.md`](../fases/07-ftps/pasos/STEP-09-03.md)** — STEP-09-03 — Probar aislamiento de cuentas; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/08-respaldos/pasos/STEP-10-01.md`](../fases/08-respaldos/pasos/STEP-10-01.md)** — STEP-10-01 — Estrategia de respaldo completo; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/08-respaldos/pasos/STEP-10-02.md`](../fases/08-respaldos/pasos/STEP-10-02.md)** — STEP-10-02 — Ejecutar respaldo SQL validado; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/08-respaldos/pasos/STEP-10-03.md`](../fases/08-respaldos/pasos/STEP-10-03.md)** — STEP-10-03 — Cron automático; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/08-respaldos/pasos/STEP-10-04.md`](../fases/08-respaldos/pasos/STEP-10-04.md)** — STEP-10-04 — Restauración segura en entorno aparte; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/09-presentacion/pasos/STEP-11-01.md`](../fases/09-presentacion/pasos/STEP-11-01.md)** — STEP-11-01 — Pruebas integrales en frío; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.
- **[`docs/fases/09-presentacion/pasos/STEP-12-01.md`](../fases/09-presentacion/pasos/STEP-12-01.md)** — STEP-12-01 — Construir informe y exposición; conserva alcance y criterio de gestión, remite al paso completo para ejecutar.

## Imágenes de la bitácora: un archivo por captura y una ficha por interpretación

El patrón es `docs/procedimientos/06-moodle/06-04/evidencias/EV-025.webp` + `EV-025.md`. La imagen documenta una pantalla histórica y la ficha explica lo que efectivamente muestra, sus límites, origen (página del Word), privacidad, integridad y vínculo de regreso al paso. La lista completa de IDs, ubicación y resumen está en el [catálogo](../../evidencias/CATALOGO-CAPTURAS.md); las pruebas futuras se añaden al paso pertinente, no a una galería común.

## Políticas de edición y revisión

Al cambiar un archivo `infra/`, se debe actualizar el procedimiento que lo instala/verifica y, si cambia diseño, ADR y diagrama. Al agregar captura, añadir ficha EV y manifest/hashes. Una bitácora describe lo sucedido (no lo que se pretendía hacer). Un resultado fallido queda preservado y conectado con una incidencia; el estado global solo cambia con prueba real en máquinas identificadas.
