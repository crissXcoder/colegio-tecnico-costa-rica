# Tutorial — cuestionario evaluable y banco de preguntas (fase 06.04)

## Archivos relacionados y por qué importan

- **[`docs/00-proyecto/matriz-requisitos.md`](../../00-proyecto/matriz-requisitos.md)**: criterios de aceptación por curso, recurso y denegación de acceso.
- **[`docs/procedimientos/06-moodle/06-04-cuestionarios.md`](06-04-cuestionarios.md)**: pasos GUI detallados para crear y evaluar preguntas de cuestionarios.

**Lugar de ejecución:** navegador Firefox en Linux Mint con sesión Moodle y permisos de edición. Confirmar direcciones reales y el estado actual de la VM antes de copiar comandos.

## Propósito del paso y contexto operacional

Modelo académico del Colegio Técnico: tres categorías, tres cursos con recursos y cuestionarios, roles y cohortes.

Este archivo corresponde **exclusivamente al paso 06-04-cuestionarios**, con comandos históricos literales y mejoras razonadas. En una **VM ya configurada** se inspeccionan primero los servicios y datos; no se vuelven a crear credenciales ni volúmenes. Los resultados observados en las capturas pertenecen a la sesión que los originó, no al conjunto de cinco integrantes.

## Comprobación recomendada y salida a documentar

Realizar una matriz por curso y cuenta: 2 recursos genuinos, 1 actividad evaluable, 1 nota de prueba y bloqueo de URL ajena. Nunca probar aislamiento con el superusuario.

Registrar el resultado exacto, fecha, sistema y si la prueba pasó o falló. Para un cambio de configuración conservar el archivo anterior y ejecutar la validación sintáctica antes de reiniciar el servicio. La **ruta versionable recomendada** está explicada en [`infra/`](../../../infra/README.md), sin sustituir los comandos originales que aparecen abajo.

Este complemento convierte las pantallas 27–37 de la bitácora en un **recorrido reproducible**. El requisito pide una actividad evaluable por departamento, además de dos recursos por curso. Se documentan los clics realizados; la existencia de la pantalla de edición **no prueba** que las tres actividades estén terminadas ni calificadas.

## Prerrequisitos y contexto

Entrar en Moodle desde Mint con cuenta autorizada para editar el curso. Asegurarse de que el curso ya existe, pertenece a la categoría correcta y dispone de sus recursos. Los cursos son `CTCR-ADM-101`, `CTCR-DOC-101` y `CTCR-INF-101`, con preguntas y claves en [CONTENIDO-CURSOS](../../00-proyecto/CONTENIDO-CURSOS.md); comprobar los nombres reales antes de editar.

## Recorrido completo y puntos de control

1. Abrir el curso y activar **Modo de edición**. Usar **Añadir una actividad o un recurso**; el selector se documenta en la captura `EV-027` dentro de [06-04](06-04.md).
2. Seleccionar **Cuestionario**. En el formulario, escribir un nombre útil y específico (ej.: «Evaluación de Seguridad Digital Institucional»), establecer la calificación para aprobar y guardar. `EV-028` muestra el formulario. **Criterio:** el cuestionario existe y se puede abrir con rol docente.
3. Volver al curso y abrir el cuestionario guardado (`EV-029`). Entrar en la pestaña **Preguntas** (`EV-030`).
4. Pulsar **Agregar** → **Una nueva pregunta**, y seleccionar el tipo **Opción múltiple** o el formato que realmente corresponda a la evaluación (`EV-031` y `EV-032`).
5. Escribir **Nombre de la pregunta**, **Texto de la pregunta**, **Puntuación por defecto** y las opciones de respuesta (`EV-033` y `EV-034`). No usar preguntas de relleno: el contenido debe pertenecer al departamento.
6. Indicar la fracción de calificación correcta, típicamente **100 %** para una respuesta totalmente correcta si el tipo lo permite, y **ninguna puntuación** para distractores incorrectos; guardar (`EV-035`). No marcar varias respuestas correctas accidentalmente en preguntas de respuesta única.
7. Regresar a las preguntas y confirmar que el cuestionario incluye preguntas visibles y puntuación coherente. Abrir **Vista previa**, completar un intento y revisar la retroalimentación y la nota (`EV-036`/`EV-037` documentan una pantalla posterior, no necesariamente una calificación estudiantil válida).
8. Repetir en **cada curso departamental**, cerrar sesión de administrador, matricular la cuenta de prueba autorizada y realizar un intento como estudiante. Comprobar desde el rol docente que el intento y su calificación son visibles.

## Criterio de aceptación medible

| Curso | Recursos reales | Cuestionario | Intento de estudiante | Docente ve calificación |
|---|---:|---|---|---|
| CTCR-ADM-101 | 2 mínimo | Por verificar | Por verificar | Por verificar |
| CTCR-DOC-101 | 2 mínimo | Por verificar | Por verificar | Por verificar |
| CTCR-INF-101 | 2 mínimo | Por verificar | Por verificar | Por verificar |

Cada celda debe respaldarse con una captura nueva, identificada por curso y VM. Evitar información personal de estudiantes; utilizar cuentas ficticias del laboratorio.

## Evidencia del recorrido

Las once capturas están dentro de [`06-04/evidencias/`](06-04/evidencias/) con ficha `EV-027` a `EV-037` que explica qué pantalla muestran y cuáles son sus límites. El [paso 06-04](06-04.md) incluye todas las imágenes en el orden en que se tomaron.
