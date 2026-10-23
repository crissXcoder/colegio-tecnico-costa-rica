# Cobertura: fuente → paso → evidencia → resultado

| Bloque | Procedimiento reproducible | Capturas de bitácora | Qué aún falta verificar |
|---|---|---|---|
| Red + disco | `00`–`03` | EV-001–003, EV-050 | Por cada VM: NIC, IP, capacidad, puertos |
| Instalación Compose | `04-01`–`04-09` | EV-004–015 | Versiones/digests exactos y estado de cada miembro |
| Acceso Moodle y persistencia | `05-01`–`05-03` | EV-016–018 | Contenidos retenidos tras reinicio en todos los entornos |
| Cursos y cuestionarios | `06-01`–`06-05` | EV-019–037, EV-045–049 | 3 cursos completos, 2 recursos/curso, cuestionario evaluado |
| Usuarios y cohortes | `06-05`–`06-07` | EV-038–044 | Matrículas activas y seis denegaciones cruzadas |
| BIND9 | `07-01`–`07-07` | ninguna | `dig` desde Mint y servidor, configuración final |
| HTTPS/Nginx | `08-01`–`08-07` | ninguna | TLS certificado, redirección, acceso por FQDN |
| FTPS y permisos | `09-01`–`09-08` | ninguna | Listado/escritura/borrado denegados a otra cuenta |
| Cron y recuperación | `10-01`–`10-07` | ninguna | Respaldo SQL + archivos, cron, restauración probada |
| Integración | `11-01`–`11-05` | ninguna | Validación cruzada y demo |

Un solo video/captura puede representar un **paso ejecutado** pero no reemplazar prueba de aceptación. La versión de la guía compartida no describe instalaciones anteriores a 4; nuestros `00-03` son propuestas complementarias, **no citas de comandos ya utilizados**.
