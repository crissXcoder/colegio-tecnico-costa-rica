# Copias verificables y restauración de ensayo — manual de operación

**Bloque:** `10-respaldos` · **Capturas e integradas:** 4 (EV-096, EV-097, EV-098, EV-099) · **Estado:** Verificado y reproducido en VM #1 (Ubuntu Server).

## Por qué existe este bloque

La restauración de MariaDB sobre una base diferente demuestra recuperabilidad SQL. Para respaldar contenido Moodle hace falta también preservar moodledata con consistencia; Git no guarda las bases.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** Nunca ejecutar DROP sobre la base real; no suponer que gzip -t equivale a una restauración funcional.

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [10-01: Crear el directorio de respaldos](10-01.md) | Creación y protección con permisos estrictos (`chmod 700 /var/backups/moodle`). | Procedimiento preparatorio |
| [10-02: Crear el script de respaldo](10-02.md) | Creación de `respaldo.sh` con `mariadb-dump`, tubería gzip y retención de 7 días. | [EV-096](10-02/evidencias/EV-096.md) |
| [10-03: Dar permisos de ejecución](10-03.md) | Permisos `chmod 700` y validación sintáctica estricta con `bash -n`. | Verificado en flujo |
| [10-04: Ejecutar un respaldo manual](10-04.md) | Ejecución manual exitosa, archivo `ctcr_moodle_*.sql.gz` y prueba de integridad con `gzip -t`. | [EV-097](10-04/evidencias/EV-097.md) |
| [10-05: Programar Cron](10-05.md) | Zona horaria `America/Costa_Rica`, cron activo y programación diaria a las 02:00 AM. | [EV-098](10-05/evidencias/EV-098.md) |
| [10-06: Probar una restauración sin dañar Moodle](10-06.md) | Base de ensayo restaurada y consultada (494 tablas, 100% de coincidencia), base real intacta. | [EV-099](10-06/evidencias/EV-099.md) |
| [10-07: ¿Qué respaldamos y qué no?](10-07.md) | Documentación de delimitación de alcance entre esquema relacional SQL y volumen moodledata. | Política y estrategia |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

Cron instalado y ejecutado, archivo SQL válido, restauración comprobada por tablas y cobertura de datos. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
