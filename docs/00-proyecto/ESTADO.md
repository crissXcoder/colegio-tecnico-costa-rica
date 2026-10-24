# Estado de avance — corte documental 2026-10-23

**Leyenda:** `propuesta` / `evidencia parcial` / `verificado local` / `validado cruzado`. Nunca convertir evidencia de una VM en estado global de las cinco.

| Bloque | Estado respaldado en documentos | Próxima evidencia faltante |
| --- | --- | --- |
| NAT, red interna y ping | evidencia parcial (pantallas de bitácora) | IP/ifaces registradas por cada integrante y pruebas de conectividad |
| Docker Engine/Compose | evidencia parcial | versión e instalación en las cinco VMs |
| Contenedores Moodle + MariaDB | evidencia y capturas de una VM | digest, salud y `ps` por entorno |
| Volúmenes de Moodle/DB | evidencia y capturas de una VM | prueba completa de persistencia incluyendo contenidos y archivos |
| Personalización y cursos | ejecución parcial evidenciada | 3 × (2 recursos reales + 1 actividad evaluable) |
| Roles/cohortes/matrículas | capturas de creación de usuarios y tres cohortes en bitácora actualizada (págs. 18–21); falta prueba de matrículas/aislamiento | matriz 3x3 verificada y prueba de URL de recurso ajeno |
| DNS BIND9 | no demostrado en bitácora | consultas desde Linux Mint |
| Nginx/HTTPS | no demostrado en bitácora | `nginx -t`, TLS SAN correcto, Moodle por FQDN |
| vsftpd/FTPS | no demostrado en bitácora | cinco cuentas y prueba de negación de lectura/escritura/borrado |
| Cron, respaldo y restauración | no demostrado | cron, copia generada, restauración real y validación |
| Documento final | plantilla disponible | texto final, citas, diagrama y anexos |
| Demostración | no demostrada | ensayo, verificaciones cruzadas |

## Datos maestros (2026-10-24)

Se acordó por el grupo un conjunto único de datos (dominio `moodle.ctcr.test`, cursos `CTCR-*-101`, 9 usuarios `@ctcr.example`, cohortes `CTCR-COH-*`, 6 cuentas FTP): [DATOS-MAESTROS](DATOS-MAESTROS.md) y [CONTENIDO-CURSOS](CONTENIDO-CURSOS.md). Es **to-be**: ninguna fila de arriba cambia de estado por esto. As-is observado en la VM con capturas: cohorte `CTCR-COH-ADM` (EV-042) y usuarios `sofia.hernandez`, `valeria.sanchez` (EV-040); el resto no está demostrado. Las VMs que ya usan `moodle.colegio.test` deben migrar la zona y el certificado.

## Último error documentado

INC-001: falta de espacio en `/` con LVM subutilizado; se amplió de ~12 a ~23 GB y se liberaron imágenes sin uso. Revisar capacidad por VM y crecimiento futuro de Docker antes de seguir.

## Regla de actualización

Cada cambio de estado exige **fecha + VM + responsable + comando/acción + resultado observado + `EV-...`** y revisión cruzada. No insertar `completado` solo porque un comando figura en una guía.
