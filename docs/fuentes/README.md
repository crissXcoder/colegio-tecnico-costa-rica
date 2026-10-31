# Fuentes: de qué afirmaciones podemos fiarnos

El material de entrada mezcla un enunciado oficial, una plantilla académica, capturas históricas, instrucciones de un chat y laboratorios externos de Docker. No tienen la misma autoridad: **la rúbrica define qué deben cumplir**, la bitácora describe hechos observados, y la guía del chat aporta comandos que requieren validación.

## Fuentes primarias y uso exacto

| Fuente | Qué soporta | Qué no autoriza asumir |
|---|---|---|
| `Proyecto_Curso_EIF431O.pdf` | Escenario 3 (Moodle), tres cursos, aislamiento y requisitos comunes; define evaluación y entrega. | No certifica que el grupo ejecutó ningún servicio. |
| `Plantilla.docx` | Orden de capítulos del documento técnico, objetivos de cada bloque, distribución propuesta y revisión cruzada. | No atribuye los responsables reales y no confirma configuraciones del servidor. |
| `Proyecto_Colegio_Técnico_con_departamentos_separados(1).docx` | Bitácora de 26 páginas: terminal, pantallas Moodle, usuarios, cohortes y problema LVM. Las 50 capturas saneadas están integradas en los pasos. | No demuestra DNS, TLS, FTPS o restauración que aún no aparecen. No debe publicarse la versión Word con datos sensibles. |
| [Conversación compartida](https://chatgpt.com/share/6ad95286-f07c-83e8-b2d4-70f340772f6f) y [`GUIA-HISTORICA-INTEGRA.md`](GUIA-HISTORICA-INTEGRA.md) | Orden de pasos 4–12 y bloques literales de terminal/configuraciones para comparar. | No es una sesión de ejecución; contiene propuestas que requieren revisión técnica. |
| «Lineamientos de presentación y entrega» (sesión 16, 07/11/2026) | Qué archivos entregar, reparto de los 25 minutos, guion de la demo y rúbrica detallada. Resumen en [LINEAMIENTOS-PROFESOR](../entrega/LINEAMIENTOS-PROFESOR.md). | Es la regla de evaluación; no describe nuestra infraestructura. |
| Anexo técnico del grupo «Escenario 3», corte 31/10/2026 | Estado de otra VM del grupo (UFW, servicios ajenos, rutas), incidentes INC-015 a INC-018 y encargos de entrega. | Se redactó con información anterior a las sesiones de los pasos 10 y 11: donde contradice evidencia `EV-…` de la VM #1, manda la evidencia ([PENDIENTES §3](../00-proyecto/PENDIENTES.md)). Describe una VM distinta a la VM #1 ([ADR-0004](../decisiones/ADR-0004-servidor-unico-de-demostracion.md)). |
| [`auditoria-dockerlabs.md`](auditoria-dockerlabs.md) y [cachac/dockerlabs](https://github.com/cachac/dockerlabs) | Referencia didáctica sobre Docker networking, volúmenes, Compose y logs. | Sus ejemplos con tags viejos, claves fijas y limpieza destructiva no son parámetros aceptados para este proyecto. |

## Lecturas técnicas de implementación

- [Docker Compose](https://docs.docker.com/compose/): servicios, redes y volúmenes; revisar versión usada en cada VM.
- [Moodle](https://docs.moodle.org/) y [imagen Oksigenia](https://hub.docker.com/r/oksigenia/moodle): compatibilidad, URL, proxy, permisos y tareas programadas.
- [MariaDB](https://mariadb.com/kb/en/): dumping/restauración.
- [BIND9](https://bind9.readthedocs.io/), [Nginx](https://nginx.org/en/docs/) y [vsftpd](https://security.appspot.com/vsftpd.html): sintaxis y seguridad de cada servicio.

## Cómo citar y mantener coherencia

Cada procedimiento indica qué parte provino de la guía histórica y cuál es corrección local; cada ficha `EV-XXX` identifica página de la bitácora y limitación; cada ADR distingue una decisión propuesta de la ejecutada. El [catálogo](../../evidencias/CATALOGO-CAPTURAS.md) enlaza la evidencia en su contexto. No introducir en el informe afirmaciones actuales de seguridad que no se hayan contrastado con el software/imagen efectivamente instalada.
