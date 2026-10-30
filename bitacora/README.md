# Bitácora operativa: historia del laboratorio sin perder el conocimiento

Aquí se registra **lo que pasó realmente** en las reuniones del equipo: fecha, integrantes, VM, decisión, comando o clic, error, diagnóstico, solución, prueba posterior y cambio de documentación. Una captura no sustituye este texto; cada captura reside con su procedimiento y tiene una ficha EV que documenta qué demuestra.

## Dos tipos de registros, dos responsabilidades

### [`sesiones/`](sesiones/)

- [`2026-10-30-sesion-paso10-respaldos-cron.md`](sesiones/2026-10-30-sesion-paso10-respaldos-cron.md): ejecución técnica del Bloque 10 (Respaldos automáticos con Cron y Restauración DRP), script `respaldo.sh` con MariaDB en Docker, retención de 7 días, crontab diario de root a las 02:00 AM CST, restauración de 494 tablas en `moodle_restore_test` y evidencias `EV-096` a `EV-099`.
- [`2026-10-30-incorporacion-documentos-reales-cursos.md`](sesiones/2026-10-30-incorporacion-documentos-reales-cursos.md): estandarización e incorporación de documentos reales del Drive a los tres cursos en `documentos-cursos/` y en Moodle local (Paso 6.4), reemplazo de páginas por PDFs en la sección 2 y ajuste de nombres oficiales.
- [`2026-10-30-documentacion-paso6-moodle.md`](sesiones/2026-10-30-documentacion-paso6-moodle.md): documentación completa del Bloque 06 (Moodle): capturas re-saneadas EV-039/040/043/044, evidencias nuevas `EV-075` a `EV-095`, ocultación de correos personales y registro de INC-011.

- [`2026-10-28-sesion-paso9-ftps-vsftpd.md`](sesiones/2026-10-28-sesion-paso9-ftps-vsftpd.md): ejecución técnica del Bloque 09 (FTPS con vsftpd y enjaulamiento), creación de 6 cuentas departamentales, TLSv1.3, pruebas de aislamiento local y remoto, y evidencias `EV-071` a `EV-074`.
- [`2026-10-28-sesion-paso8-https-nginx.md`](sesiones/2026-10-28-sesion-paso8-https-nginx.md): ejecución técnica del Bloque 08 (Nginx HTTPS Reverse Proxy), certificado SSL con SAN, integración de Moodle, pruebas de redirección y evidencias `EV-067` a `EV-070`.
- [`2026-10-28-sesion-paso7-dns-bind9.md`](sesiones/2026-10-28-sesion-paso7-dns-bind9.md): ejecución técnica del Bloque 07 (DNS privado BIND9), configuración de zona `ctcr`, resolución en Ubuntu Server y Linux Mint, e integración de evidencias `EV-063` a `EV-066`.
- [`2026-10-23-estado-heredado.md`](sesiones/2026-10-23-estado-heredado.md): recoge el estado encontrado antes de construir el manual completo. Es **reconstrucción documental**, no prueba de presencia de los cinco participantes en una sesión ese día.
- [`2026-10-22-reconstruccion-bitacora-v2.md`](sesiones/2026-10-22-reconstruccion-bitacora-v2.md): sintetiza acciones que aparecen fotografiadas en el Word actualizado, sin inventar horas de captura y enlazando a procedimientos.
- [`plantillas/sesion.md`](../plantillas/sesion.md): modelo recomendado para futuras reuniones; registrar quién ejecutó cada parte y qué se corrigió en tiempo real.

### [`incidentes/`](incidentes/)

- [`INC-012-wildcard-expansion-permisos-0700.md`](incidentes/INC-012-wildcard-expansion-permisos-0700.md): fallo de expansión de comodines en carpetas con permisos 0700 bajo sudo; resolución con subshell de root `sudo sh -c 'gzip -t ...'`.
- [`INC-011-moodle-matricula-cohorte-incorrecta.md`](incidentes/INC-011-moodle-matricula-cohorte-incorrecta.md): estudiantes de Docencia matriculados en el curso de Administración; «eliminado de la selección» no desmatricula; corrección en Métodos de matriculación.

- [`INC-010-vsftpd-writable-root-chroot-500.md`](incidentes/INC-010-vsftpd-writable-root-chroot-500.md): error 500 OOPS en vsftpd por raíz de usuario escribible dentro de chroot; separación estricta de raíz (`0755` `root:root`) y subcarpeta `archivos` (`0700` `<user>:<user>`).
- [`INC-009-vsftpd-user-sub-token-omission-bug.md`](incidentes/INC-009-vsftpd-user-sub-token-omission-bug.md): fallo de expansión de `$USER` en `local_root` por omisión de `user_sub_token=$USER` en `vsftpd.conf`.
- [`INC-008-vsftpd-pam-shells-nologin-denial.md`](incidentes/INC-008-vsftpd-pam-shells-nologin-denial.md): rechazo de autenticación PAM de usuarios con shell `/usr/sbin/nologin` por ausencia de la shell en `/etc/shells`.
- [`INC-007-vsftpd-adduser-name-regex-failure.md`](incidentes/INC-007-vsftpd-adduser-name-regex-failure.md): rechazo de nombres de usuario con punto (`marta.jimenez`) en `adduser` por expresión regular por defecto.
- [`INC-006-zip-command-not-found.md`](incidentes/INC-006-zip-command-not-found.md): comando `zip` ausente en imagen base de Ubuntu Server 26.04 durante empaquetado de entregables.
- [`INC-005-moodle-cli-script-constant.md`](incidentes/INC-005-moodle-cli-script-constant.md): bloqueo en PHP CLI al requerir `config.php` de Moodle sin definir la constante `CLI_SCRIPT`.
- [`INC-004-apache2-nginx-port-collision.md`](incidentes/INC-004-apache2-nginx-port-collision.md): colisión de puertos 80 y 443 entre Apache2 y Nginx; resolución con desactivación permanente de Apache2.
- [`INC-003-nginx-apt-package-version-404.md`](incidentes/INC-003-nginx-apt-package-version-404.md): error 404 en repositorio APT por actualización de revisión de seguridad de Nginx 1.28.3 (`.11` a `.12`).
- [`INC-002-bind9-systemd-resolved-port53.md`](incidentes/INC-002-bind9-systemd-resolved-port53.md): colisión de socket en puerto 53 entre BIND9 y `systemd-resolved` en Ubuntu Server 26.04; diagnóstico de interfaces y mitigación con `listen-on { 192.168.50.1; };`.
- [`INC-001-almacenamiento-lvm.md`](incidentes/INC-001-almacenamiento-lvm.md): disco raíz lleno, detección de espacio libre en LVM, ampliación y precauciones. La [evidencia EV-050](../docs/procedimientos/01-servidor-red/01-02/evidencias/EV-050.md) está adjunta al diagnóstico, no escondida en un catálogo general.
- [`plantillas/incidente.md`](../plantillas/incidente.md): anotar síntomas, impacto, causa comprobada, alternativas, pasos ejecutados, rollback, responsables y verificación posterior.

## Método durante las sesiones sin perder la distribución de trabajo

Aunque se desarrollen las cinco VMs simultáneamente, cada bloque tiene **una persona responsable del documento y otra revisora**. Si un comando falla en alguna máquina, registrar la variante; no reescribir retrospectivamente capturas de otras máquinas para simular uniformidad. Un incidente nuevo genera `INC-002`, `INC-003`, etc. y enlaza el subpaso preciso.

## Estado y confidencialidad

La **fuente de estado** es [`ESTADO.md`](../docs/00-proyecto/ESTADO.md) junto con la [`matriz de requisitos`](../docs/00-proyecto/matriz-requisitos.md). El Word original puede contener información personal y permanece fuera de Git. El manifiesto de las 50 capturas sanitizadas se consulta en [`evidencias`](../evidencias/README.md), pero cada imagen se lee y explica en el paso correspondiente.
