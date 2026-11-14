# Estado de avance — corte documental 2026-11-13

**Leyenda:** `propuesta` / `evidencia parcial` / `verificado local` / `validado cruzado`. Nunca convertir evidencia de una VM en estado global de las cinco.

| Bloque | Estado respaldado en documentos | Próxima evidencia faltante |
| --- | --- | --- |
| NAT, red interna y ping | validado cruzado (VM 1 + VM 2 + VM 3 Mint) | Verificado íntegro con EV-131, ping bidireccional y navegación de Mint vía NAT |
| Docker Engine/Compose | validado cruzado (VM 1 y VM 2) | Docker 29.9.0 / Compose v5.6.0 en ambas máquinas |
| Contenedores Moodle + MariaDB | validado cruzado (VM 1 y VM 2) | Verificado con EV-134..EV-136 (salud healthy, MariaDB 11.4.13 en VM 2 :3306, dos instancias de Moodle 4.5.15 concurrentes) |
| Volúmenes de Moodle/DB | validado cruzado (VM 1 y VM 2) | Verificado con EV-137 (persistencia en `mariadb_data`, `moodle_code` y `moodle_data` tras reinicios concurrentes) |
| Personalización y cursos | validado cruzado (VM 1 + VM 2 + Mint) | Verificado íntegro con EV-051..EV-055 (3 categorías, 3 cursos y 3×(2 recursos + 1 quiz de 100 pts)); actualizados con documentos reales en Moodle |
| Roles/cohortes/matrículas | validado cruzado (VM 1 + VM 2 + Mint) | Verificado con EV-104 (aislamiento con rechazo a curso ajeno), EV-105 (cuestionarios 100/100 y calificador de Daniel Vargas). 9 usuarios departamentales + admin + criss |
| DNS BIND9 | validado cruzado (VM 1 + Mint) | Verificado con EV-063..EV-066 (BIND 9.20.24, `named-checkconf`/`checkzone` OK, resolución autoritativa de `aulavirtual.ctcr -> 192.168.50.1` en Mint) |
| Nginx/HTTPS y Balanceo HA | validado cruzado (VM 1 + VM 2 + Mint) | Verificado con EV-135..EV-137 y prueba empírica en caliente de failover sub-segundo (`upstream moodle_ha_cluster`, conmutación continua en 0.165 s con HTTP 200) |
| vsftpd/FTPS | validado cruzado (VM 1 + Mint) | Verificado con EV-071..EV-074 (vsftpd 3.0.5, 6 cuentas departamentales nologin, TLSv1.3, enjaulamiento chroot 0700 y error 550 ante escape traversal) |
| Cron, respaldo y restauración | validado cruzado (VM 1 y VM 2) | Verificado en VM 2 (EV-138): cron diario 02:00 AM, volcado comprimido gzip 776 KB en `/var/backups/moodle/`, restauración de ensayo fechada (13/11/2026) con 494 tablas, 3 cursos y 12 usuarios activos coincidentes |
| QA y Verificación Final (Paso 11) | validado cruzado (VM 1 + VM 2 + Mint) | Verificado íntegro (10/10 PASS: contenedores saludables, URL canónica, servicios systemd, iptables persistente sin UFW, DNS/HTTPS en Mint, aislamiento departamental, calificador docente, reinicio de contenedores, jaula FTPS y DRP con 494 tablas) |
| Fase Opcional (Alta Disponibilidad Multi-VM) | validado cruzado (VM 1 Moodle 1 + VM 2 MariaDB & Moodle 2) | Verificado íntegro con EV-131..EV-138 y [ADR-0005](../decisiones/ADR-0005-arquitectura-distribuida-multi-vm.md): red Host-Only 192.168.56.0/24, MariaDB 11.4.13 aislada en 192.168.56.104:3306 con 494 tablas, dos instancias concurrentes de Moodle 4.5.15, Nginx upstream con failover activo-activo, sesiones compartidas en BD (`dbsessions = 1`), prueba automatizada con `verificar-alta-disponibilidad.sh` |
| Firewall | verificado local (VM #1) con iptables; UFW no se usa | EV-102 y [ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md). En VM #1 UFW no está instalado (`command not found`); filtrado y NAT gestionados con iptables persistente (`/etc/iptables/rules.v4`). Anexo H actualizado con `sudo iptables-save` |
| Paquete de entrega (`docker-compose.yml`, configuraciones, `crontab.txt`, `firewall-iptables.txt`, `hashes.txt`) | validado cruzado (VM 1 + VM 2 + Mint) | Generado paquete oficial `/home/criss/entrega-final/` con 23 archivos verificados mediante `hashes.txt` (todos `OK`), documentado en [PAQUETE-ENTREGA](../entrega/PAQUETE-ENTREGA.md) y replicado en `/home/criss/proyecto-moodle/hashes.txt` para la demo |
| Documento final y Anexos | verificado local y cruzado | Documento auditado al 100% (1 072 párrafos y 29 imágenes vía OCR Tesseract). Generado `documento_tecnico_auditado_corregido.docx` con Anexos A, D, F, G, H, I y secciones de firewall corregidas |
| Demostración (Guion 25 minutos) | batería técnica verificada | Alineado en [GUIA-DEMO](../entrega/GUIA-DEMO.md) según el reparto exacto de 5 personas (P1 Contexto, P2 Lo que corre es lo entregado / DNS / HTTPS, P3 Contenedores y persistencia, P4 Respaldo y restauración, P5 Aislamiento y control de acceso) |

## Datos maestros (2026-10-24)

Se acordó por el grupo un conjunto único de datos (dominio `aulavirtual.ctcr`, cursos `CTCR-*-101`, 9 usuarios `@ctcr.example`, cohortes `CTCR-COH-*`, 6 cuentas FTP): [DATOS-MAESTROS](DATOS-MAESTROS.md) y [CONTENIDO-CURSOS](CONTENIDO-CURSOS.md). Es **to-be**: ninguna fila de arriba cambia de estado por esto. As-is observado con capturas: las 9 cuentas `@ctcr.example` (EV-040, EV-056), las 3 cohortes con 2 miembros (EV-043, EV-057) y la matrícula de los 3 cursos (EV-087..EV-089). Las VMs que ya usan `moodle.colegio.test` deben migrar la zona y el certificado.

## Último error documentado

- INC-019: APT bloqueado por `unattended-upgrades` al instalar vsftpd en la VM `server@server` (31/10, desde el documento del grupo). INC-003, INC-005, INC-007 e INC-018 se ampliaron con lo ocurrido en esa VM.

- INC-015 a INC-018 (incorporados el 31/10 desde el anexo técnico, de otra VM del grupo): 502 de Nginx durante la transición a HTTPS, vsftpd con valor inválido y directivas duplicadas, `curl (26)` por archivo local inexistente y UFW removido con configuración residual.
- Riesgos que todavía no ocurrieron: [RIESGOS-Y-FALLOS-ANTICIPADOS](../operacion/RIESGOS-Y-FALLOS-ANTICIPADOS.md).
- INC-014: excepción fatal por métodos deprecados en Question Engine API de Moodle 4.5 al automatizar la finalización de cuestionarios; resuelto adaptando llamadas a `$quizobj->get_structure()->get_slots()` y `question_engine::save_questions_usage_by_activity($quba)`.
- INC-013: fallo de resolución DNS local de `aulavirtual.ctcr` en Ubuntu Server por aislamiento entre `systemd-resolved` y BIND9 LAN; resuelto mapeando en `/etc/hosts`.
- INC-001: falta de espacio en `/` con LVM subutilizado; se amplió de ~12 a ~23 GB y se liberaron imágenes sin uso. Revisar capacidad por VM y crecimiento futuro de Docker antes de seguir.

## Regla de actualización

Cada cambio de estado exige **fecha + VM + responsable + comando/acción + resultado observado + `EV-...`** y revisión cruzada. No insertar `completado` solo porque un comando figura en una guía.
