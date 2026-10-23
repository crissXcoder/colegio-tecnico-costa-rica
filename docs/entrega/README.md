# Entrega académica: traducir evidencia técnica a informe y demo

La `Plantilla.docx` del profesor estructura el informe; el monorepositorio mantiene las **fuentes vivas** y no usa Word como único lugar donde viven comandos o fotografías. La entrega debe ser reproducible para un lector externo y coherente con el estado real de las cinco máquinas. **Fecha prevista:** 7 de noviembre de 2026.

## Qué sección de la plantilla se alimenta desde qué archivo

| Sección de informe | Fuente de verdad y enfoque al redactar |
|---|---|
| 1. Introducción, problema, alcance | [`00-proyecto/README.md`](../00-proyecto/README.md): incidente de alteración de notas, tres departamentos, solución prevista y limitaciones. |
| 2. Elección de software libre | [`comparativa-software.md`](comparativa-software.md): contrastar Moodle/Ubuntu/MariaDB/BIND9/Nginx/vsftpd con alternativas libres y propietarias, justificación y trade-offs. |
| 3. Arquitectura, red, versiones | [`00-proyecto`](../00-proyecto/README.md), [`versiones.md`](../00-proyecto/versiones.md): diagrama, interfaces, puertos, imágenes y digest observado. |
| 4. Ubuntu y red | [`fase 01`](../fases/01-servidor-red/README.md) + pasos 00–03: instalación, NAT/interna, inventario y problema LVM. |
| 5. Docker + Moodle | [`fase 02`](../fases/02-contenedores/README.md) + [04](../procedimientos/04-contenedores/README.md): Compose, volúmenes, DB y persistencia. |
| 6. Organización del colegio | [`fase 03`](../fases/03-moodle-contenidos/README.md) y [04](../fases/04-autorizacion/README.md): cursos, recursos, cuestionarios, cuentas, cohortes y permisos. |
| 7. DNS/HTTPS | [DNS](../procedimientos/07-dns-bind9/README.md) y [proxy](../procedimientos/08-https-nginx/README.md), con comandos y prueba de certificado. |
| 8. FTP con permisos | [FTPS](../procedimientos/09-ftps-vsftpd/README.md): usuarios, chroot y rechazo cruzado. |
| 9. Respaldo y restauración | [10 respaldos](../procedimientos/10-respaldos/README.md), cron, dump, tabla restaurada y limitaciones. |
| 10. Pruebas | [`pruebas/README.md`](../../pruebas/README.md) y [manifiesto EV](../../evidencias/README.md): esperado vs obtenido y figura numerada. |
| 11. Problemas | [`bitácora`](../../bitacora/README.md) y ADR: reconstruir síntoma, diagnóstico, corrección verificada y trade-off. |
| 12–13. Conclusiones y fuentes | [`fuentes`](../fuentes/README.md) y resultados reales; no inventar conclusiones ni bibliografía no consultada. |
| Anexos | [`infra`](../../infra/README.md), [`scripts`](../../scripts/README.md) y **solo capturas aprobadas** que tengan ficha EV. |

## Cómo redactar sin perder trazabilidad

Para cada figura: «Figura n. Descripción de la acción/resultado (VM, fecha)», breve texto interpretativo, procedencia por código `EV-XXX`, condición esperado/observado y enlace a ficha. No pegar las 50 imágenes sin narración: seleccionar las necesarias para demostrar los requisitos y conservar el resto en el repo.

## Ensayo y preguntas del profesor

El 4/11 otra persona intenta reproducir pasos que no redactó; el 6/11 se ensaya la demo con cuentas de cada departamento. Preparar acceso autorizado, acceso rechazado, dominio HTTPS, transferencia aislada y restauración separada. Si el profesor solicita versiones/limitaciones, mostrar matriz de componentes y explicar por qué HTTPS termina en Nginx, por qué los volúmenes persisten y qué no cubre Git como respaldo de datos.
