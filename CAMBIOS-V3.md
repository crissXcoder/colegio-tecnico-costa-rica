# Cambios v2 → v3: documentación operativa y evidencias en contexto

**Base:** ZIP `Elevaquitas_Monorepo_Completo_v2.zip`; no se creó un repositorio vacío. Se mantienen las guías históricas, fases, bitácoras, archivos de infraestructura, scripts, ADR, GitHub CI, plantillas y trazabilidad.

## Correcciones implementadas

1. **50 imágenes relocalizadas** desde `evidencias/capturas-saneadas/` a cada `docs/procedimientos/<bloque>/<paso>/evidencias/`. No quedan capturas sin ubicación documental.
2. **50 fichas EV individuales** junto a las imágenes: descripción, qué se observa, qué NO se prueba, fuente/página, hash de la imagen incorporada, enlace al procedimiento y revisión de privacidad.
3. **Corrección de asignaciones de evidencia:** EV-003 se interpreta como conectividad externa (no LVM); EV-028 a EV-037 se vinculan a creación de recursos/cuestionarios y no a creación de usuarios; EV-038 a EV-040 a usuarios; EV-041 a cohortes.
4. **Pasos Markdown con material fotográfico en contexto**, interpretación no especulativa, comandos y comprobación recomendada. El índice maestro queda como puerta de entrada, no como almacén.
5. **Tutorial especializado del cuestionario** [`06-04-cuestionarios.md`](docs/procedimientos/06-moodle/06-04-cuestionarios.md) para explicar el flujo de las fotografías 027–037.
6. **README enriquecidos** con propósito, dependencias, estados reales, descripción de archivos, orden, ejemplos, riesgos y criterios de aceptación. `docs/fases` es el mapa de requisitos y `docs/procedimientos` la referencia ejecutable.
7. **Plantilla de evidencia añadida** en `plantillas/evidencia.md` para conservar metadatos y privacidad de nuevas capturas.
8. **Integridad revisable**: validador comprueba enlaces, existencia de evidencias, paso correspondiente, SHA-256 y consistencia del manifiesto.

## Decisiones de alcance

- No reescribir el documento original de bitácora ni inventar resultados de ejecución faltantes.
- Conservar los comandos originales como referencia histórica y marcar diferencia entre una receta para VM nueva y los cambios autorizados en VMs ya instaladas.
- Las capturas muestran avances, pero **la matriz de accesos denegados, DNS, HTTPS, FTPS y restauración requieren evidencias futuras**.
- Mantener datos de estudiantes, contraseñas, `.env` y respaldos SQL fuera de Git.
