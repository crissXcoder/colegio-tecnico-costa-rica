# Cursos, actividades, cuentas y controles de acceso — manual de operación

**Bloque:** `06-moodle` · **Capturas históricas integradas:** 31 · **Estado:** evidencia local parcial o documentación proyectada, no validación cruzada del grupo.

## Por qué existe este bloque

Moodle da solución al problema de separación del colegio: categorías organizan, cohortes permiten matrícula, roles definen capacidades y los recursos deben poderse consultar solo desde la matrícula autorizada. Las fotografías 19–49 demuestran trabajo en la UI, no autorización efectiva.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** No confundir cohortes creadas con matrícula efectiva ni pantalla de cuestionario con una evaluación completada.

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [06-01: Personalizar la plataforma](06-01.md) | Página institucional con identificación y personalización real del colegio. | EV-019, EV-045, EV-046, EV-047, EV-048, EV-049 |
| [06-02: Crear las categorías de cursos](06-02.md) | Tres categorías presentes y ubicadas correctamente, sin asumir aislamiento. | EV-020 |
| [06-03: Crear los tres cursos](06-03.md) | Tres cursos reales con nombre, categoría y código corto consistentes. | EV-021, EV-022 |
| [06-04-cuestionarios: cuestionario evaluable y banco de preguntas (fase 06.04)](06-04-cuestionarios.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [06-04: Agregar los recursos y actividades](06-04.md) | Dos recursos genuinos y una actividad calificable en los tres cursos. | EV-023, EV-024, EV-025, EV-026, EV-027, EV-028, EV-029, EV-030, EV-031, EV-032, EV-033, EV-034, EV-035, EV-036, EV-037 |
| [06-05: Crear los usuarios de prueba](06-05.md) | Cuentas de prueba separadas, sin privilegios administrativos de más. | EV-038, EV-039, EV-040 |
| [06-06: Crear las cohortes departamentales](06-06.md) | Tres cohortes con usuarios asignados; matrícula real todavía requiere otro paso. | EV-041, EV-042, EV-043, EV-044 |
| [06-07: Configurar la matrícula por cohorte](06-07.md) | Sincronización y matrícula válida para cohorte específica; auto-matrícula desactivada. |  |
| [06-08: Comprobar el aislamiento](06-08.md) | Matriz 3×3 de acceso por URL directa; recurso de otro departamento denegado. |  |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

Tres cursos × dos recursos auténticos + una actividad evaluable; al final prueba 3×3 de accesos denegados. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
