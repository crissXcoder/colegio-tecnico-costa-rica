# INC-014 — Excepción por Métodos Desactualizados en la API de Question Engine de Moodle 4.5

- INC-ID: INC-014
- Fecha / VM / paso: 2026-10-30 17:42 CST / VM #1 Ubuntu Server / Paso 11 (Verificación final del proyecto / QA)
- Estado: resuelto y verificado

## Síntoma y contexto
Durante la automatización de las evaluaciones departamentales del Paso 11.6 para generar los intentos de cuestionarios resueltos y las calificaciones de los estudiantes (Sofía Hernández en Docencia y Valeria Sánchez en Informática), se ejecutó un script PHP CLI dentro del contenedor Moodle para cerrar y calificar los intentos en curso.

El intérprete de PHP abortó arrojando el siguiente error fatal:
```text
Fatal error: Uncaught Error: Call to undefined method mod_quiz\quiz_settings::get_slots() in /tmp/submit_quiz.php:42
```
Tras un primer ajuste manual, un segundo error fue arrojado:
```text
Fatal error: Uncaught Error: Call to undefined method question_engine::save_usage_by_activity() in /tmp/submit_quiz.php:58
```

## Impacto, severidad y riesgo
- **Severidad:** Media (impide la finalización y persistencia de intentos de cuestionario mediante scripts CLI directos de automatización administrativa).
- **Riesgo:** Bloqueo en la generación de evidencias de estudiantes evaluados y libros de calificaciones para los profesores antes de la demostración final.

## Diagnóstico con comandos y salida saneada
Moodle 4.5 (`oksigenia/moodle:4.5.15`) introdujo cambios estructurales en el subsistema de Question Engine y en el módulo de actividades `mod_quiz`:
1. El objeto `quiz_settings` ya no expone directamente el método `get_slots()`. En su lugar, la colección de preguntas y ranuras se obtiene mediante el objeto de estructura:
   ```php
   $slots = $quizobj->get_structure()->get_slots();
   ```
2. La API estática `question_engine` deprecó o renombró el método genérico `save_usage_by_activity()`. El método oficial y persistente en la versión 4.5 es:
   ```php
   question_engine::save_questions_usage_by_activity($quba);
   ```

## Solución y por qué
Se refactorizó el script de procesamiento de intentos PHP CLI aplicando las firmas de métodos vigentes en Moodle 4.5:

```php
define('CLI_SCRIPT', true);
require('/var/www/moodle/config.php');
require_once($CFG->dirroot . '/mod/quiz/locallib.php');

$quizobj = quiz_settings::create($quiz->id);
$structure = $quizobj->get_structure();
$slots = $structure->get_slots();

foreach ($slots as $slot) {
    // Procesa y responde cada pregunta con respuesta correcta
    $qa = $quba->get_question_attempt($slot);
    // ...
}

$quba->finish_all_questions(time());
question_engine::save_questions_usage_by_activity($quba);

$attemptobj = new quiz_attempt($attempt, $quiz, $cm, $course, false);
$attemptobj->process_finish(time(), false);
quiz_save_best_grade($quiz, $user->id);
```

## Verificación y recuperación
1. El script procesó las 5 preguntas de opción múltiple del cuestionario de Docencia para Sofía Hernández:
   - Estado del intento: `finished`.
   - Suma de calificaciones: `100.00 / 100.00` (5/5 respuestas correctas, ponderación 20 pts cada una).
2. El script procesó las 5 preguntas del cuestionario de Informática para Valeria Sánchez:
   - Estado del intento: `finished`.
   - Suma de calificaciones: `100.00 / 100.00`.
3. Verificación de notas persistidas en la tabla de calificaciones de Moodle (`mdl_quiz_grades`):
   ```sql
   SELECT u.username, q.name, g.grade 
   FROM mdl_quiz_grades g 
   JOIN mdl_quiz q ON q.id = g.quiz 
   JOIN mdl_user u ON u.id = g.userid;
   ```
   Salida:
   - `sofia.hernandez` | Cuestionario: Evaluación de Estrategias Didácticas | `100.00000`
   - `valeria.sanchez` | Cuestionario: Fundamentos de Ciberseguridad | `100.00000`
4. Confirmación visual en la vista de libro de calificaciones del profesor Daniel Vargas (`EV-105`).

## Evidencia de resolución
- **Subpaso asociado:** [`docs/procedimientos/11-verificacion/11-06.md`](../../docs/procedimientos/11-verificacion/11-06.md)
- **Captura relacionada:** [`EV-105.webp`](../../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.webp) y ficha [`EV-105.md`](../../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.md).

## Prevención y documentación asociada
- Documentado en la minuta de sesión [`bitacora/sesiones/2026-10-30-sesion-paso11-verificacion-final-qa.md`](../sesiones/2026-10-30-sesion-paso11-verificacion-final-qa.md).
- Guardrail añadido a `eif431o-lab-ops/SKILL.md` y `GEMINI.md`.
