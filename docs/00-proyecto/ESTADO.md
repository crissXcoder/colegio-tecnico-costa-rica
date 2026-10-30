# Estado de avance — corte documental 2026-10-23

**Leyenda:** `propuesta` / `evidencia parcial` / `verificado local` / `validado cruzado`. Nunca convertir evidencia de una VM en estado global de las cinco.

| Bloque | Estado respaldado en documentos | Próxima evidencia faltante |
| --- | --- | --- |
| NAT, red interna y ping | evidencia parcial (pantallas de bitácora) | IP/ifaces registradas por cada integrante y pruebas de conectividad |
| Docker Engine/Compose | evidencia parcial | versión e instalación en las cinco VMs |
| Contenedores Moodle + MariaDB | evidencia y capturas de una VM | digest, salud y `ps` por entorno |
| Volúmenes de Moodle/DB | evidencia y capturas de una VM | prueba completa de persistencia incluyendo contenidos y archivos |
| Personalización y cursos | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-051..EV-055 (3 categorías, 3 cursos y 3×(2 recursos + 1 quiz de 100 pts)); actualizados con documentos reales del Drive en documentos-cursos/ y en Moodle (2026-10-30) |
| Roles/cohortes/matrículas | verificado local (VM #1 Server + VM #2 Mint) | Verificado con EV-056..EV-062 (9 usuarios, 3 cohortes, bloqueo sin automatriculación, intento de estudiante y calificador). Recorrido del grupo EV-075..EV-095 (2026-10-30): métodos de matrícula de los 3 cursos, profesora denegada en otro curso y PDF ajeno denegado por URL directa; INC-011 resuelto. Falta: matriz 3×3 completa y prueba `/admin/` con profesor |
| DNS BIND9 | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-063..EV-066 (BIND 9.20.24, named-checkconf/checkzone OK, resolución local dig y cliente Mint ping/dig 0% pérdida) |
| Nginx/HTTPS | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-067..EV-070 (Nginx 1.28.3, SAN aulavirtual.ctcr, 301 a HTTPS, curl 200 OK y Firefox cliente) |
| vsftpd/FTPS | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-071..EV-074 (vsftpd 3.0.5, 6 cuentas departamentales nologin, TLSv1.3, enjaulamiento chroot 0700 y error 550 ante escape) |
| Cron, respaldo y restauración | no demostrado | cron, copia generada, restauración real y validación |
| Documento final | plantilla disponible | texto final, citas, diagrama y anexos |
| Demostración | no demostrada | ensayo, verificaciones cruzadas |

## Datos maestros (2026-10-24)

Se acordó por el grupo un conjunto único de datos (dominio `aulavirtual.ctcr`, cursos `CTCR-*-101`, 9 usuarios `@ctcr.example`, cohortes `CTCR-COH-*`, 6 cuentas FTP): [DATOS-MAESTROS](DATOS-MAESTROS.md) y [CONTENIDO-CURSOS](CONTENIDO-CURSOS.md). Es **to-be**: ninguna fila de arriba cambia de estado por esto. As-is observado con capturas: las 9 cuentas `@ctcr.example` (EV-040, EV-056), las 3 cohortes con 2 miembros (EV-043, EV-057) y la matrícula de los 3 cursos (EV-087..EV-089). Las VMs que ya usan `moodle.colegio.test` deben migrar la zona y el certificado.

## Último error documentado

INC-001: falta de espacio en `/` con LVM subutilizado; se amplió de ~12 a ~23 GB y se liberaron imágenes sin uso. Revisar capacidad por VM y crecimiento futuro de Docker antes de seguir.

## Regla de actualización

Cada cambio de estado exige **fecha + VM + responsable + comando/acción + resultado observado + `EV-...`** y revisión cruzada. No insertar `completado` solo porque un comando figura en una guía.
