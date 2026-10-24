# Fases del producto: qué se construye y por qué

Esta capa es equivalente al **mapa de componentes y requisitos** de un proyecto de infraestructura. Explica el propósito de cada bloque, qué servicio aporta al Colegio Técnico, cómo se comprueba y quién debe responsabilizarse de documentarlo. No es el lugar para copiar literalmente 54 guías de terminal: esas instrucciones están en [`docs/procedimientos`](../procedimientos/README.md) y las fotografías están **dentro del subpaso correspondiente**.

## Cadena de dependencias

Primero conectividad y servidor, después Moodle/DB persistentes, luego contenido/roles, finalmente DNS/HTTPS, FTPS y recuperación. La fase de pruebas atraviesa todas. DNS/HTTPS no reemplaza el control de acceso de Moodle y FTPS no aporta derechos sobre cursos; son subsistemas separados.

## Documentos de fase y criterio central

| Fase | Razón de negocio y resultado esperado |
|---|---|
| [01-servidor-red — Infraestructura del host y conectividad](01-servidor-red/README.md) | Resolver primero el camino Mint↔Ubuntu y las restricciones de capacidad. Aquí las capturas EV-001 a EV-003 muestran ping y salida de Ubuntu; EV-050 explica por qué el espacio de /var y LVM importaron al despliegue. |
| [02-contenedores — Servicios Moodle y MariaDB bajo Docker](02-contenedores/README.md) | Separar aplicación de DB es obligatorio. La evidencia de Compose, arranque y volúmenes está en el manual 04, mientras el acceso desde Mint está en el manual 05. |
| [03-moodle-contenidos — Organización académica y recursos](03-moodle-contenidos/README.md) | Aquí se diseña el contenido educativo: categorías, cursos, PDF/páginas, cuestionarios y personalización. Las capturas históricas muestran navegación y edición, no prueban todavía un curso terminado por departamento. |
| [04-autorizacion — Identidades, cohortes y aislamiento](04-autorizacion/README.md) | Los roles actúan dentro de un contexto Moodle. La cohorte agrupa cuentas para sincronizar matrícula, pero no es un permiso por sí misma. La prueba de URL directa debe realizarse con cuentas no privilegiadas. |
| [05-dns — Zona autoritativa ctcr.test](05-dns/README.md) | BIND9 resuelve el dominio solo dentro de la red del laboratorio. Linux Mint no necesita NAT; consulta a Ubuntu por 53/UDP y TCP. |
| [06-https — Frontera HTTPS en Nginx](06-https/README.md) | Nginx escucha 443, mantiene una redirección desde HTTP, y envía al servicio Docker local. Moodle debe generar URL HTTPS y no dar acceso directo al 8080 desde Mint en el estado final. |
| [07-ftps — Acceso a archivos con cuentas confinadas](07-ftps/README.md) | vsftpd utiliza FTPS explícito y cuentas del sistema sin shell interactiva. Deben probar subida propia y denegación de modificación o borrado en carpetas ajenas. |
| [08-respaldos — Recuperación verificable de datos Moodle](08-respaldos/README.md) | Se diferencian dump SQL y datos del directorio persistente moodledata. Cron genera copias de base, pero la prueba de restauración sobre una BD independiente es lo que demuestra utilidad. |
| [09-presentacion — Cierre de pruebas y defensa técnica](09-presentacion/README.md) | La entrega reúne capturas verificadas, comparativa de software libre, decisiones, incidencias, arquitectura y demostración. La rúbrica oficial manda y debe ser trazable hasta un paso y resultado observado. |

## Cómo documentar trabajo en grupo sin duplicidad

La fase tiene un responsable documental y un revisor, pero la implementación se desarrolla de manera simultánea en las máquinas del equipo. La fuente de verdad sobre lo instalado es la salida observada de cada VM; las plantillas en `infra/` son el diseño propuesto. Para cerrar la fase, enlazar un `EV-ID` sanitizado, un registro de sesión, la comparación esperado/observado y el commit/PR. No es suficiente marcar el README como “hecho”.

[Volver al mapa documental](../README.md) · [Matriz de requisitos](../00-proyecto/matriz-requisitos.md).
