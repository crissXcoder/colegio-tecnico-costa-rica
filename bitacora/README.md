# Bitácora operativa: historia del laboratorio sin perder el conocimiento

Aquí se registra **lo que pasó realmente** en las reuniones del equipo: fecha, integrantes, VM, decisión, comando o clic, error, diagnóstico, solución, prueba posterior y cambio de documentación. Una captura no sustituye este texto; cada captura reside con su procedimiento y tiene una ficha EV que documenta qué demuestra.

## Dos tipos de registros, dos responsabilidades

### [`sesiones/`](sesiones/)

- [`2026-10-28-sesion-paso8-https-nginx.md`](sesiones/2026-10-28-sesion-paso8-https-nginx.md): ejecución técnica del Bloque 08 (Nginx HTTPS Reverse Proxy), certificado SSL con SAN, integración de Moodle, pruebas de redirección y evidencias `EV-067` a `EV-070`.
- [`2026-10-28-sesion-paso7-dns-bind9.md`](sesiones/2026-10-28-sesion-paso7-dns-bind9.md): ejecución técnica del Bloque 07 (DNS privado BIND9), configuración de zona `ctcr`, resolución en Ubuntu Server y Linux Mint, e integración de evidencias `EV-063` a `EV-066`.
- [`2026-10-23-estado-heredado.md`](sesiones/2026-10-23-estado-heredado.md): recoge el estado encontrado antes de construir el manual completo. Es **reconstrucción documental**, no prueba de presencia de los cinco participantes en una sesión ese día.
- [`2026-10-22-reconstruccion-bitacora-v2.md`](sesiones/2026-10-22-reconstruccion-bitacora-v2.md): sintetiza acciones que aparecen fotografiadas en el Word actualizado, sin inventar horas de captura y enlazando a procedimientos.
- [`plantillas/sesion.md`](../plantillas/sesion.md): modelo recomendado para futuras reuniones; registrar quién ejecutó cada parte y qué se corrigió en tiempo real.

### [`incidentes/`](incidentes/)

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
