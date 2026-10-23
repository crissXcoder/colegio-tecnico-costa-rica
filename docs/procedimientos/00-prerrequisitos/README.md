# Preparación del laboratorio — manual de operación

**Bloque:** `00-prerrequisitos` · **Capturas históricas integradas:** 0 · **Estado:** evidencia local parcial o documentación proyectada, no validación cruzada del grupo.

## Por qué existe este bloque

Identificar recursos y precondiciones antes de ejecutar instalaciones. El guion inicial empieza en Docker porque el chat daba las VMs por creadas; esta sección recupera el contexto que faltaba.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** No avanzar sin constatar espacio libre, interfaces y versiones; un servidor ya instalado no debe tratarse como recién creado.

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [00-01: Preparación y comprobaciones antes de tocar una VM](00-01.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

Inventario de SO, CPU, RAM, discos, nombre del adaptador y topología individual. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
