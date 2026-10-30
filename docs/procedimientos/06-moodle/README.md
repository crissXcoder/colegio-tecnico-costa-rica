# Cursos, actividades, cuentas y controles de acceso — manual de operación

**Bloque:** `06-moodle` · **Capturas integradas:** 64 (EV-019 a EV-062, salvo EV-050, y EV-075 a EV-095) · **Estado:** verificado local en una VM (EV-056 a EV-062) y recorrido histórico del grupo; matriz 3×3 completa pendiente.

## Por qué existe este bloque

Moodle da solución al problema de separación del colegio. Cada pieza cumple un papel distinto y conviene no confundirlas:

| Pieza | Para qué sirve | ¿Protege? | Subpaso |
|---|---|---|---|
| Categoría | Ordenar los cursos por departamento | No | 06-02 |
| Curso | Contener recursos y evaluación de un departamento | Es lo que se protege | 06-03, 06-04 |
| Cuenta | Identificar a cada persona | No, por sí sola no da acceso | 06-05 |
| Cohorte | Agrupar a los estudiantes de un departamento | No, hasta sincronizarla | 06-06 |
| Método de matrícula | Decidir quién entra al curso y con qué rol | **Sí** | 06-07 |
| Prueba por URL directa | Demostrar que nadie de otro departamento entra | Es la verificación | 06-08 |

Las capturas de 06-01 a 06-06 demuestran trabajo en la interfaz; la autorización efectiva se demuestra en 06-07 y 06-08.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** No confundir cohortes creadas con matrícula efectiva ni pantalla de cuestionario con una evaluación completada. Tampoco confundir «eliminado de la selección» en Participantes con desmatricular a alguien (ver [INC-011](../../../bitacora/incidentes/INC-011-moodle-matricula-cohorte-incorrecta.md)).

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [06-01: Personalizar la plataforma](06-01.md) | Sitio con nombre «Colegio Técnico de Costa Rica», nombre corto «CTCR», resumen y logo. | EV-019, EV-045 a EV-049, EV-051 |
| [06-02: Crear las categorías de cursos](06-02.md) | Tres categorías `DEP-ADM`, `DEP-DOC`, `DEP-INF`, sin asumir aislamiento. | EV-020, EV-052 |
| [06-03: Crear los tres cursos](06-03.md) | Tres cursos `CTCR-*-101`, cada uno en su categoría. | EV-021, EV-022, EV-053, EV-075 |
| [06-04: Agregar los recursos y actividades](06-04.md) | Dos recursos reales y un cuestionario calificable por curso. | EV-023 a EV-037, EV-054, EV-055 |
| [06-04-cuestionarios: cuestionario evaluable y banco de preguntas](06-04-cuestionarios.md) | Recorrido detallado para crear el cuestionario y sus preguntas. | Usa EV-027 a EV-037 de 06-04 |
| [06-05: Crear los usuarios de prueba](06-05.md) | Las 9 cuentas `@ctcr.example`, sin roles de sistema. | EV-076, EV-038, EV-039, EV-040, EV-056 |
| [06-06: Crear las cohortes departamentales](06-06.md) | Tres cohortes con 2 estudiantes cada una; todavía sin acceso a cursos. | EV-041 a EV-044, EV-077, EV-057 |
| [06-07: Configurar la matrícula por cohorte](06-07.md) | Cada curso con su cohorte (Estudiante) y su profesor manual; sin invitados ni auto-matrícula. Incluye INC-011. | EV-078 a EV-091, EV-058 |
| [06-08: Comprobar el aislamiento](06-08.md) | Curso y PDF de otro departamento denegados por URL directa; intento calificado visible al profesor. | EV-059 a EV-062, EV-092 a EV-095 |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

Tres cursos × dos recursos auténticos + una actividad evaluable; al final prueba 3×3 de accesos denegados. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
