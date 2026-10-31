# Pendientes antes de la entrega del 07/11/2026

**Corte:** 31/10/2026. Esta lista cruza los «pendientes críticos» del anexo técnico (sección N) con la evidencia que ya existe en el repositorio. Algo pasa a «hecho» solo con evidencia (`EV-…`, salida con fecha o archivo exportado), no porque figure en una guía.

**Fechas del grupo:** 04/11 reproducción cruzada · 06/11 ensayo y armado del paquete · 07/11 entrega antes de las 7:59 a. m. y presentación.

## 1. Bloquean la entrega

| # | Pendiente | Por qué | Cómo se cierra | Meta |
|---|---|---|---|---|
| P-01 | **Elegir el servidor de la demostración.** | El profesor compara lo entregado con lo que corre; hoy hay al menos dos VMs distintas. | Confirmar [ADR-0004](../decisiones/ADR-0004-servidor-unico-de-demostracion.md) (propuesta: VM #1). | 02/11 |
| P-02 | Instalar `restauracion-prueba.sh` y `verificar-servicios.sh` en el servidor y ejecutarlos una vez. | El profesor pide el script de restauración; la restauración actual (EV-099) se hizo con comandos sueltos. | [PAQUETE-ENTREGA §3](../entrega/PAQUETE-ENTREGA.md); guardar los `.log` con fecha como evidencia. | 04/11 |
| P-03 | Armar el paquete desde el servidor: `docker-compose.yml`, configuraciones reales, `crontab.txt`, `ufw.txt`, `versiones.txt` con digests, `hashes.txt`. | Hoy el repositorio solo tiene **modelos** en `infra/`, no las copias del servidor. | `sudo ./armar-entrega.sh` ([PAQUETE-ENTREGA](../entrega/PAQUETE-ENTREGA.md)). | 06/11 |
| P-04 | Documento técnico final (plantilla del curso). | 2 % de documentación y 3 % de justificación dependen de él. | [docs/entrega/README.md](../entrega/README.md) indica qué archivo alimenta cada sección. | 05/11 |
| P-05 | Comparativa de software libre: **fuentes de licencias y cohortes citadas el 31/10**. Falta citar la alternativa propietaria si se usa. | Rúbrica: 3 % (RA-01). | [comparativa-software.md §4](../entrega/comparativa-software.md). | 04/11 |
| P-06 | Diapositivas del contexto (máximo 4). | Segmento de 3 minutos, 3 % de la rúbrica. | Contenido en [GUIA-DEMO §1](../entrega/GUIA-DEMO.md). | 05/11 |
| P-07 | Ensayo completo cronometrado (25 min, demo en 11). | RA-02; el tiempo es estricto. | [GUIA-DEMO](../entrega/GUIA-DEMO.md) en la VM elegida, con alguien cronometrando. | 06/11 |
| P-08 | Subir el paquete al aula virtual. | Sin entrega no hay nota de implementación. | Subir el `.tar.gz` armado en el servidor la noche del 06/11. | 06/11 |

## 2. Importantes, no bloqueantes

| # | Pendiente | Por qué | Cómo se cierra |
|---|---|---|---|
| P-09 | Práctica de preguntas técnicas con los cinco integrantes. | Responde la persona elegida en el momento (2 % + 2 %). | [PREGUNTAS-TECNICAS](../entrega/PREGUNTAS-TECNICAS.md), rotando en la VM real. |
| P-10 | Contraseña de laboratorio publicada en el historial de Git. | Se quitó del texto actual, pero sigue en commits anteriores. | Cambiar la contraseña de las cuentas Moodle y FTP de prueba en el servidor de la demo; compartir la nueva fuera de Git. |
| P-11 | Copia del volumen `moodledata` antes de la entrega. | El respaldo diario es solo SQL; los PDF subidos no están en él (10-07, riesgo R-30). | Procedimiento de [10-07](../procedimientos/10-respaldos/10-07.md) una vez, con evidencia. |
| P-12 | Decidir qué hacer con los servicios ajenos de la VM del anexo (`lab5`, MariaDB y PostgreSQL del host). | Si esa VM presenta, el profesor los verá en `ss -lntup`. | Solo si P-01 elige esa VM. No borrar sin saber a qué práctica pertenecen. |
| P-13 | Reproducción cruzada por otra persona. | RC-06: un tercero debe poder reproducir. | Otra integrante sigue los pasos 7 a 10 en su VM y registra diferencias en la bitácora. |
| P-14 | Unificar el rol del administrador en los tres cursos. | Aparece como Estudiante en ADM y DOC y como Profesor en INF (EV-087..EV-089). | Participantes de cada curso; no afecta el aislamiento. |
| P-15 | Decidir qué hacer con `MOODLE_BD_TYPE` (con `BD`) en el compose real. | **Confirmado** en las capturas del compose (documento del grupo, págs. 4, 5 y 40; EV-119). La imagen la ignora y Moodle funciona con MariaDB, pero el profesor puede verla. | Opción recomendada: dejarla y saber explicarla. Si se corrige, que sea **antes** de armar el paquete y con prueba posterior (riesgo R-10). |
| P-16 | ~~Alinear `infra/compose/.env.example` con lo que corre.~~ | Hecho el 31/10: el modelo dice ahora `oksigenia/moodle:4.5.15`, como las dos VMs, y anota que existe `4.5.15-r17` con correcciones de seguridad. | Decidir en grupo si se actualiza la imagen **después** de la entrega. |
| P-17 | Unificar o documentar los nombres de las cuentas FTP. | VM de Criss: `marta.jimenez`; VM `server@server`: `marta_jimenez` (INC-007, EV-124). Las guías usan el punto. | Si presenta la VM `server@server`, cambiar los nombres en GUIA-DEMO y PREGUNTAS-TECNICAS o recrear las cuentas con `adduser --allow-bad-names`. |
| P-18 | Si presenta la VM `server@server`: paso 10 y prueba FTPS cruzada. | Esa VM no tiene evidencia de respaldo, Cron ni restauración (el «Paso 10» del documento está vacío) ni del aislamiento por FTPS. | Ejecutar 10-01 a 10-06 y 09-08 en esa VM con capturas; resolver R-41 (dos carpetas de proyecto). |

## 3. Del anexo que ya está resuelto en el repositorio

El anexo técnico se redactó con información anterior a las últimas sesiones. Estos puntos ya tienen evidencia en la VM #1:

| Punto del anexo (sección N) | Evidencia en el repositorio |
|---|---|
| Confirmar paso 10: Cron de root, respaldo comprimido, restauración en base aparte | EV-096..EV-099 (494 tablas restauradas en `moodle_restore_test`). Falta solo el **script** de restauración (P-02). |
| Probar FTPS con las seis cuentas y la denegación cruzada por el protocolo | EV-071..EV-074, EV-106 (error 550 al intentar salir de la jaula). |
| Validar Moodle con estudiantes de departamentos distintos, enlace directo denegado, calificación real y revisión del profesor | EV-060, EV-092..EV-095, EV-104, EV-105. |
| Confirmar que Moodle conserva datos al reiniciar contenedores | EV-106. |
| UFW: política, riesgos con Docker, activación | Decidido en [ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md): no se activa antes de la entrega. |
| Exportar configuraciones reales, digests y hashes | Pendiente: P-03. |
| Comparar Moodle con al menos una alternativa | Pendiente: P-05. |
