# Matriz de pruebas de aceptación: del comando a la demostración

Este directorio registra **pruebas funcionales y negativas**, no impresiones de que “funciona”. Para cada caso hay que identificar VM, fecha, cuenta de prueba, estado previo, acción/comando, resultado esperado, resultado observado, criterio PASS/FAIL, captura y revisor. La plantilla reutilizable está en [`plantillas/prueba.md`](../plantillas/prueba.md).

## Criterios de aceptación críticos

| ID | Qué se está probando | Cómo ejecutarlo y qué evidencia prueba el resultado |
|---|---|---|
| T-01 | Dos contenedores y base operativa | `sudo docker compose ps`, logs y `SHOW TABLES` de Moodle; fotografías EV-010–015 son antecedentes locales, no garantía en cinco VMs. |
| T-02 | Persistencia real | Crear recurso de prueba, `docker compose down` **sin -v**, `up -d`, confirmar el recurso, archivo y usuario antes/después; EV-018 solo muestra la recreación. |
| T-03 | Tres cursos completos | Inventariar 2 recursos auténticos + 1 cuestionario por curso. Desde estudiante completar actividad y desde profesor visualizar nota. |
| T-04 | Aislamiento entre departamentos | Cuenta de Informática entra a URL de Administración y se rechaza. Repetir matriz cruzada 3×3, incluyendo archivos y actividades, no solo índice de cursos. |
| T-05 | Rol profesor limitado | Profesor puede gestionar su curso y no ejecutar administración global. El superusuario no sirve como cuenta negativa. |
| T-06 | DNS | `dig @192.168.50.1 moodle.ctcr.test A +short` desde Mint devuelve IP del servidor. |
| T-07 | HTTPS | Certificado con SAN, conexión cifrada por nombre, HTTP→HTTPS, recursos Moodle sin errores de contenido o redirección. |
| T-08 | FTPS | Cuenta A sube archivo propio; B no puede leer/modificar/borrar archivo de A; registrar código/error real y cuentas ficticias. |
| T-09 | Backups | Cron programado y ejecutado, SQL válido, importado en DB separada, recuento de tablas; plan de moodledata. |
| T-10 | Reproducción cruzada | Otra persona reproduce un paso sobre una segunda VM e identifica diferencias sin ayuda del autor. |

## Dónde guardar cada resultado y cómo enlazarlo

Las capturas pertenecen al procedimiento del servicio, con ficha EV que explique **lo que muestran y lo que no muestran**. Este archivo ofrece una perspectiva transversal de QA y enlaza a la [matriz oficial](../docs/00-proyecto/matriz-requisitos.md). Un estado histórico o un screenshot de un selector abierto es insuficiente para pasar una prueba funcional.

## Reglas de reporte

Nunca escribir “PASS” basándose únicamente en un resultado esperado del manual. En fallo, crear incidencia y retener salida para diagnóstico redactando datos privados. Cada prueba se vuelve a realizar tras cambios en Moodle, roles, redes, Nginx, FTPS o recuperación que puedan afectarla.
