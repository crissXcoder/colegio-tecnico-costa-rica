# Análisis de las fuentes y decisión de estructura

Fecha de consolidación: 2026-10-23. **Fuente, evidencia e inferencia se distinguen expresamente**.

## Fuente 1: Plantilla.docx (11 páginas)

La plantilla describe el índice del documento final y cinco líneas de responsabilidad: (1) Ubuntu/Docker/Moodle, (2) organización del colegio, (3) DNS/HTTPS, (4) FTP/respaldos, (5) justificación, arquitectura, pruebas e integración. Sugiere reproducción cruzada el 4/11 y ensayo de demostración el 6/11. Es una **plantilla con campos pendientes**, no evidencia de que el proyecto haya implementado cada fase.

### Inconsistencias a resolver

- Ejemplo de cliente Windows en el diagrama, mientras las evidencias del grupo utilizan Linux Mint.
- Ejemplo `colegio.internal`, mientras la guía conversacional utiliza `moodle.colegio.test`.
- Menciona Dockerfile como anexo posible, pero el despliegue observado usa una imagen ya construida. **No fingir un Dockerfile inexistente**.
- Integrantes y responsable académico aparecen como marcadores genéricos en la plantilla.
- La asignación de contenidos no describe sesiones simultáneas: esta aclaración procede del propio grupo y se incorpora en CONTRIBUTING.md.

## Fuente 2: Proyecto_Colegio_Técnico_con_departamentos_separados.docx (24 páginas, 46 imágenes)

- Portada con identidad del grupo y tres personas rellenadas; otros dos espacios por completar. **No trasladar números de cédula a un repositorio público.**
- Pág. 2-3: pruebas de conectividad desde Linux Mint/Ubuntu, comprobación de versiones, OpenSSL y creación/protección de `.env`.
- Pág. 4-8: compose, pull, contenedores, logs, tablas `mdl_*`, tres volúmenes, acceso web y prueba `down`/`up -d`.
- Pág. 9-21: pantallas de personalización, categorías, cursos, recursos, cuestionarios y comienzo de gestión de usuarios/roles. **No alcanza para asegurar tres cursos completos ni aislamiento por cohorte validado.**
- Pág. 23-24: incidente real de espacio (`/` al 100% con 12 GB), LVM con espacio libre, ampliación a ~23 GB y limpieza de imágenes. Se rescata como [INC-001](bitacora/incidentes/INC-001-almacenamiento-lvm.md), con advertencias de operaciones destructivas.
- Hay capturas que pueden contener contraseñas o detalles de credenciales. **No se importan automáticamente al repositorio público**.

## Fuente 3: Chat compartido «Explicación proyecto Moodle»

Estableció: Ubuntu 26.04, Mint 22.3, Docker 29.9.0, Compose 5.6.0, Moodle 4.5.15, MariaDB 11.4.13, PHP 8.3 y guía de pasos 4-12. La conversación confirmaba la etapa previa a `up -d`; la **bitácora más reciente contiene evidencia de avance posterior**. En ningún caso se debe retroceder el estado por depender solo del chat.

## Fuente 4: enunciado oficial «Proyecto_Curso_EIF431O.pdf»

Seis obligatorios generales: BIND9; VirtualHost HTTPS; Moodle+BD en contenedores con volúmenes e imágenes versionadas; FTP por persona o rol con aislamiento; backup Cron y restauración probada; documentación reproducible. Específicos: tres cursos con recursos/actividad evaluable, tres grupos con acceso exclusivo, prueba denegación. Entrega el 7/11/2026, equipo de cinco, demostración viva.

## Fuente 5: cachac/dockerlabs (https://github.com/cachac/dockerlabs)

Laboratorios pedagógicos de Docker con notas de instalación, ciclo de vida, redes, storage, Compose, logs, monitoreo, proxy/balanceo. Su README declara actualización en marzo de 2022. **Referenciar conceptos y adaptar, no copiar su infraestructura demo como producción**.

Aprovechar: `07 Networking.md` (bridge/DNS interno), `09 Storage.md` (volúmenes), `11 Compose.md` (`docker compose config`, `ps`, logs), `20.Logs.md` (rotación), ejemplos de Nginx/balanceo solo como investigación. No trasladar: comandos de limpieza global, `latest`, imágenes antiguas, contraseñas de demostración `12345`, usuario root de base de datos, despliegues de monitoreo pesados para una VM pequeña, bind de socket Docker o proxies públicos sin análisis.

[Revisión de los 21 capítulos y ejemplos relevantes](docs/fuentes/auditoria-dockerlabs.md).

## Decisión

Un monorepositorio privado con **infraestructura versionada** (propuesta + versión efectiva), **fases autocontenidas**, **bitácoras cronológicas**, **evidencia etiquetada**, **pruebas de aceptación**, **documento final derivado**. Todo cambio debe registrar fuente, responsable, revisor y resultado observado; no hay obligación de convertirlo en un software más grande.
