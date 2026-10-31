# Comparativa y justificación de software libre

**Para qué sirve:** sustenta el criterio «Justificación de la elección de software libre» (3 %): comparar con al menos una alternativa, propietaria o libre distinta, con **criterios técnicos y de costo**, y explicar por qué se eligió esta.
**Estado:** 31/10/2026, con fuentes citadas en la sección 4 para licencias y cohortes. Falta citar la alternativa propietaria si se usa en el documento técnico. No se incluyen precios porque no se consultaron cotizaciones; donde se habla de costo, se describe el **modelo** de costo.

## 1. Plataforma de aprendizaje (la decisión principal)

**Necesidad del escenario:** tres departamentos separados; cada grupo de personas entra solo a su curso, y el acceso ajeno debe ser **denegado**, no solo ocultado. Además: cursos con recursos y evaluación calificada, instalación propia en un servidor del colegio.

| Criterio | **Moodle 4.5 (elegido)** | Chamilo (libre) | Canvas LMS (libre, versión comunitaria) | Plataformas propietarias en la nube (p. ej. Blackboard, Google Classroom) |
|---|---|---|---|---|
| Licencia | GPL v3 o posterior | GPL v3 o posterior | AGPL v3, con licencia dual comercial de Instructure | Propietaria |
| Modelo de costo de licencia | Sin pago de licencia | Sin pago de licencia | Sin pago para la versión comunitaria | Suscripción o licenciamiento institucional; algunas tienen nivel gratuito con condiciones |
| Costo real de operación | Servidor, respaldo y tiempo de administración (lo que demostramos en el proyecto) | Similar a Moodle | Más alto: pila más pesada | Bajo en servidores (los opera el proveedor); el costo pasa a la suscripción |
| Instalación en servidor propio | Sí; imagen Docker mantenida (`oksigenia/moodle`) | Sí | Sí, pero con más componentes | No: el servicio y los datos están en la nube del proveedor |
| Separar departamentos | **Cohortes + método «Sincronizar cohorte» + roles por curso**, de fábrica | Clases y sesiones; separación posible con más trabajo manual | Cuentas, secciones y subcuentas | Depende del producto; configuración ligada al proveedor |
| Requisitos técnicos | PHP + MariaDB/MySQL/PostgreSQL | PHP + MariaDB/MySQL | Ruby on Rails + PostgreSQL + Redis, entre otros | Navegador |
| Comunidad y documentación | Muy amplia; versión 4.5 con soporte extendido (LTS) | Menor | Amplia, más orientada a la versión comercial | Soporte del proveedor |
| Control de los datos | Total: datos en nuestro servidor y en nuestros respaldos | Total | Total | El proveedor custodia los datos |

**Por qué Moodle:** es la opción que resuelve el requisito central **con funciones nativas** (cohortes, sincronización y roles por curso), corre en contenedores con una base libre y deja los datos y respaldos en el servidor del colegio. Chamilo también es libre y más liviano, pero la separación por departamento exigía más trabajo manual. Canvas es libre pero su instalación es bastante más pesada para un laboratorio. Las plataformas propietarias quitan trabajo de servidor, pero no permiten instalar en un servidor propio, que es justamente lo que evalúa el curso, y dejan los datos fuera del colegio.

**Lo que se acepta al elegir Moodle:** la administración (actualizaciones de seguridad, respaldos, monitoreo) es responsabilidad del colegio. «Libre» no significa costo cero: el costo está en el tiempo de administración y en el hardware.

## 2. Componentes de infraestructura

| Rol | Elegido | Alternativa libre | Alternativa propietaria | Por qué el elegido |
|---|---|---|---|---|
| Sistema operativo | Ubuntu Server 26.04 LTS | Debian | Windows Server (licencia por núcleos y accesos) | Versión LTS, paquetes al día y la misma base que usa el curso. |
| Base de datos | MariaDB 11.4 (en contenedor) | PostgreSQL | Microsoft SQL Server | Soportada por Moodle, imagen oficial con healthcheck, misma familia que MySQL. |
| Contenedores | Docker Engine + Compose | Podman | — | Compose define los dos servicios, volúmenes y puertos en un archivo que se entrega y se reproduce. |
| DNS | BIND9 | dnsmasq, Unbound | Windows DNS | Servidor autoritativo completo para la zona privada `ctcr`, con validación (`named-checkzone`). |
| Proxy HTTPS | Nginx | Apache, Caddy | IIS | Proxy inverso liviano; TLS en el host, Moodle sin exponer (ver [ADR-0002](../decisiones/ADR-0002-proxy-https.md)). |
| Transferencia de archivos | vsftpd con FTPS | ProFTPD; SFTP de OpenSSH | Servidores FTP comerciales | Encierro por usuario (`chroot`) y TLS obligatorio con pocas directivas. SFTP sería más simple de filtrar (un solo puerto), pero el escenario pide FTP. |
| Respaldos | Cron + `mariadb-dump` + gzip | Bacula, restic | Soluciones de respaldo comerciales | Suficiente para una base en un solo servidor, y se demuestra con una restauración de ensayo. |

## 3. Cómo presentarlo en 30 segundos

«Elegimos Moodle porque la separación por departamentos que pide el escenario la resuelve con funciones que ya trae —cohortes y matrícula por cohorte— y porque lo podemos instalar en nuestro propio servidor con todos los datos bajo control. Lo comparamos con Chamilo, que es libre pero más manual para separar departamentos, y con plataformas en la nube, que quitan trabajo de servidor pero cobran suscripción y dejan los datos fuera del colegio. Lo que aceptamos es que la administración y los respaldos son responsabilidad nuestra.»

## 4. Fuentes consultadas (31/10/2026)

| Afirmación | Fuente |
|---|---|
| Moodle es software libre bajo la GNU GPL versión 3 o posterior (desde Moodle 2.x); el nombre «Moodle» es marca registrada aparte. | Moodle Docs, «Licencia»: <https://docs.moodle.org/es/Licencia>; «License» (developer docs, ahora solo lectura): <https://docs.moodle.org/dev/License> |
| La sincronización de cohortes matricula y da de baja automáticamente a quien entra o sale de la cohorte; el administrador debe habilitar el método y luego se agrega en cada curso. La matrícula manual de una cohorte, en cambio, es una acción única que no se actualiza. | Moodle Docs, «Cohort sync»: <https://docs.moodle.org/405/en/admin/setting/enrolsettingscohort>; «Cohorts enrolment»: <https://docs.moodle.org/404/en/Cohorts_enrolment> |
| Chamilo se distribuye bajo GNU GPLv3 o posterior. | Documentación del repositorio `chamilo-lms`: <https://forger.sitiv.fr/chamilo/chamilo-lms/src/branch/skala/documentation/readme.html> (espejo del repositorio oficial; contrastar con el `LICENSE` de GitHub) |
| Canvas LMS se publica bajo AGPLv3 con licencia dual comercial de Instructure; la imagen Docker oficial está desactualizada y la instalación propia se construye desde el código fuente. | Wiki de `instructure/canvas-lms` (FAQ): <https://github.com/instructure/canvas-lms/wiki/FAQ/4d387aa13aaba4b6136e44bacd1bfe38d11c8db8>; Docker Hub: <https://hub.docker.com/r/instructure/canvas-lms> |
| Imagen Moodle usada y su versión con correcciones de seguridad. | <https://hub.docker.com/r/oksigenia/moodle> y <https://github.com/OksigeniaSL/docker-moodle> (ver [versiones.md](../00-proyecto/versiones.md)) |

**Sin fuente todavía (no afirmarlo como dato en el documento técnico):** los requisitos de hardware de Canvas (solo hay cifras de una guía de terceros) y el modelo de licenciamiento concreto de la alternativa propietaria; si se usa Blackboard o Google Classroom como comparación, citar su página oficial de planes.

No afirmar que una alternativa «es peor» solo por ser propietaria: compararla por los criterios de la tabla.
