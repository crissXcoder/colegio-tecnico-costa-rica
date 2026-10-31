# Estado de avance — corte documental 2026-10-23

**Leyenda:** `propuesta` / `evidencia parcial` / `verificado local` / `validado cruzado`. Nunca convertir evidencia de una VM en estado global de las cinco.

| Bloque | Estado respaldado en documentos | Próxima evidencia faltante |
| --- | --- | --- |
| NAT, red interna y ping | evidencia parcial (pantallas de bitácora) | IP/ifaces registradas por cada integrante y pruebas de conectividad |
| Docker Engine/Compose | evidencia parcial | versión e instalación en las cinco VMs |
| Contenedores Moodle + MariaDB | verificado local (VM #1 Server + VM #2 Mint) | Verificado con EV-100 y EV-106 (salud healthy, URL canónica y aislamiento de puerto 3306) |
| Volúmenes de Moodle/DB | verificado local (VM #1 Server) | Verificado con EV-106 (persistencia de datos, cursos y usuarios tras restart de contenedores) |
| Personalización y cursos | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-051..EV-055 (3 categorías, 3 cursos y 3×(2 recursos + 1 quiz de 100 pts)); actualizados con documentos reales del Drive en documentos-cursos/ y en Moodle (2026-10-30) |
| Roles/cohortes/matrículas | verificado local (VM #1 Server + VM #2 Mint) | Verificado con EV-056..EV-062, EV-075..EV-095, y consolidado en Paso 11 con EV-104 (aislamiento con rechazo 303 a curso ajeno) y EV-105 (cuestionarios 100/100 y calificador de Daniel Vargas). INC-011 resuelto |
| DNS BIND9 | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-063..EV-066 (BIND 9.20.24, named-checkconf/checkzone OK, resolución local dig y cliente Mint ping/dig 0% pérdida) |
| Nginx/HTTPS | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-067..EV-070 (Nginx 1.28.3, SAN aulavirtual.ctcr, 301 a HTTPS, curl 200 OK y Firefox cliente) |
| vsftpd/FTPS | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-071..EV-074 (vsftpd 3.0.5, 6 cuentas departamentales nologin, TLSv1.3, enjaulamiento chroot 0700 y error 550 ante escape) |
| Cron, respaldo y restauración | verificado local (VM #1 Server) | Verificado íntegro con EV-096..EV-099 (script respaldo.sh 0700, volcado gzip 384 KB, cron diario 02:00 AM CST, restauración de 494 tablas en moodle_restore_test y DROP limpio) |
| QA y Verificación Final (Paso 11) | verificado local (VM #1 Server + VM #2 Mint) | Verificado íntegro con EV-100..EV-106 y matriz transversal en pruebas/MATRIZ-QA-FINAL.md (10/10 PASS: contenedores saludables, URL canónica, servicios systemd y puertos, iptables sin UFW, conectividad/DNS/HTTP 301/HTTPS en Mint, aislamiento departamental con rechazo a URL ajena, cuestionarios calificados 100/100, calificador docente, reinicio de contenedores, jaula FTPS y DRP con 494 tablas) |
| Firewall | verificado local (VM #1) con iptables; UFW no se usa | EV-102 y [ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md). En otra VM del grupo UFW está instalado e **inactivo** (INC-018): no afirmar que UFW protege el servidor |
| Paquete de entrega (`docker-compose.yml`, configuraciones, `crontab.txt`, `ufw.txt`, `hashes.txt`) | **pendiente** | Scripts listos (`armar-entrega.sh`, `restauracion-prueba.sh`, `verificar-servicios.sh`); falta instalarlos en el servidor, ejecutarlos y armar el paquete ([PAQUETE-ENTREGA](../entrega/PAQUETE-ENTREGA.md)) |
| Segunda VM del grupo (`server@server`) | evidencia parcial | Pasos 7, 8 y 9 documentados con EV-107..EV-130 (documento del grupo, 54 págs.); sin paso 10 ni prueba FTPS cruzada; usuarios FTP con guion bajo (P-17, P-18) |
| Servidor de la demostración | **por decidir** | Propuesta VM #1 ([ADR-0004](../decisiones/ADR-0004-servidor-unico-de-demostracion.md)); hay VMs con configuraciones distintas |
| Documento final | plantilla disponible | texto final, citas, diagrama y anexos; comparativa ampliada sin fuentes citadas todavía |
| Demostración | batería técnica verificada (pasos 11.1 a 11.7) | Guion en [GUIA-DEMO](../entrega/GUIA-DEMO.md); falta el ensayo cronometrado de 25 minutos. Lista completa en [PENDIENTES](PENDIENTES.md) |

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
