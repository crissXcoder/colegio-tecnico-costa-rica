# Despliegue Moodle + MariaDB — manual de operación

**Bloque:** `04-contenedores` · **Capturas históricas integradas:** 12 · **Estado:** evidencia local parcial o documentación proyectada, no validación cruzada del grupo.

## Por qué existe este bloque

El servicio `db` guarda la base de datos en un volumen, `moodle` expone temporalmente el HTTP del laboratorio y ambos se comunican en la red bridge. Aquí están los comandos originales con las capturas reales de edición, pull, arranque, logs, SQL y volúmenes.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** Preservar `.env`, nombre de proyecto Docker y volúmenes; un cambio de carpeta o `-p` puede aparentar pérdida de datos.

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [04-01: Entrar a la carpeta que ya creamos](04-01.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [04-02: Confirmar las versiones de las imágenes](04-02.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. | EV-004 |
| [04-03: Generar las contraseñas](04-03.md) | Confirmar secreto privado con permisos 600; no incluir valores en capturas. | EV-005, EV-006 |
| [04-04: Crear el archivo Compose](04-04.md) | Comparar Compose del disco con el repositorio, redes, puertos y tres volúmenes. | EV-007, EV-008 |
| [04-05: Validar Compose](04-05.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [04-06: Descargar las imágenes](04-06.md) | Verificar pull y las etiquetas concretas; anotar digest antes de futuras actualizaciones. | EV-009 |
| [04-07: Levantar los contenedores](04-07.md) | Mostrar estado de ambos contenedores y logs de arranque sin datos secretos. | EV-010, EV-011, EV-012 |
| [04-08: Confirmar la base de datos](04-08.md) | Confirmar acceso a la base e inspeccionar tablas mdl_ sin exponer contraseña. | EV-013, EV-014 |
| [04-09: Verificar los volúmenes](04-09.md) | Enumerar los tres volúmenes y relacionarlos con contenido de Moodle. | EV-015 |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

Compose válido, ambos servicios arriba, base con tablas, volúmenes, imagen/digest y prueba de persistencia. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
