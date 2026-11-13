# ADR-0005 — Arquitectura de Alta Disponibilidad Multi-VM con Balanceo y Failover Activo (Bonus Opcional)

- ADR-ID: ADR-0005
- Estado: **aceptada**. Implementada, ampliada y validada integralmente para el Bonus Opcional del proyecto final CTCR (12/11/2026).
- Fecha / Autores / Revisores: 2026-11-12 / Cristhian Altamirano Montes / equipo CTCR EIF431O.

## Contexto y problema

El lineamiento oficial del curso EIF431O para el **Bonus Opcional** establece literalmente:
> *«Alta disponibilidad: al menos dos instancias del mismo servicio (dos contenedores, o dos VMs) sirviendo el mismo sitio, con demostración de que si una cae la otra responde. No se cubre formalmente en el curso (balanceo de carga) — queda como bonus para quien quiera investigarlo por su cuenta, en cualquiera de los seis escenarios, no solo en uno.»*

La implementación inicial segregaba Moodle (VM 1) y MariaDB (VM 2) en una arquitectura *two-tier*, pero contenía una única instancia de la aplicación web; al detener MariaDB en VM 2, el sitio devolvía un error HTTP 500. Aunque demostraba desacoplamiento de red, **no cumplía formalmente con el criterio de Alta Disponibilidad**, pues no ofrecía redundancia del servicio web ni tolerancia a fallos con continuidad operativa hacia el cliente.

Los desafíos técnicos para alcanzar la verdadera Alta Disponibilidad fueron:
1. **Redundancia del servicio:** Desplegar una segunda instancia idéntica de Moodle (`oksigenia/moodle:4.5.15`) en VM 2 (`192.168.56.104:8080`) manteniendo la instancia primaria en VM 1 (`127.0.0.1:8080`).
2. **Balanceo de carga y detección de fallos:** Configurar Nginx en VM 1 como balanceador de carga TLS con conmutación por error (*failover*) automática e instantánea hacia la instancia superviviente ante caídas.
3. **Consistencia de sesiones entre nodos:** Evitar la desautenticación de los usuarios cuando sus peticiones conmuten entre VM 1 y VM 2.
4. **Preservación de datos y aislamiento:** Mantener las 494 tablas de la base de datos MariaDB y la seguridad de la red Host-Only (`192.168.56.0/24`).

## Opciones consideradas

- **Opción A — Arquitectura Two-Tier simple (Moodle único en VM 1, MariaDB en VM 2):** Resuelve la separación de base de datos pero no provee redundancia web ni failover; si Moodle en VM 1 cae, el servicio muere.
- **Opción B — Alta Disponibilidad Multi-Contenedor en VM 1:** Dos contenedores Moodle en VM 1 balanceados por Nginx local. Cubre la opción de «dos contenedores», pero mantiene dependencia de un único sistema operativo host.
- **Opción C — Alta Disponibilidad Multi-VM con Nginx Load Balancer y `dbsessions` (Seleccionada):**
  - Dos instancias activas de Moodle: Instancia 1 en VM 1 (`127.0.0.1:8080`) e Instancia 2 en VM 2 (`192.168.56.104:8080`), ambas conectadas a MariaDB en VM 2.
  - Nginx en VM 1 con bloque `upstream moodle_ha_cluster` y directivas de conmutación sub-segundo `proxy_next_upstream`.
  - Persistencia de sesiones en base de datos (`$CFG->dbsessions = 1` en MariaDB), garantizando que cualquier usuario autenticado conserve su sesión sin importar qué instancia atienda la petición.

## Decisión y justificación

Se adopta la **Opción C**.

**Justificación técnica:**
1. **Cumplimiento estricto del enunciado:** Dispone de dos instancias reales del mismo servicio corriendo sobre dos VMs distintas y sirviendo concurrentemente el mismo dominio `https://aulavirtual.ctcr`.
2. **Failover transparente e instantáneo:** Ante la caída de cualquiera de las dos instancias (`docker stop`), Nginx detecta el evento en menos de 2 milisegundos y despacha la petición a la otra instancia en menos de 0.2 segundos, entregando siempre `HTTP 200 OK` al cliente Linux Mint sin caída de servicio.
3. **Sesiones compartidas sin estado local:** La directiva `dbsessions` de Moodle desacopla las sesiones del almacenamiento local en disco (`moodledata/sessions`), centralizándolas en la tabla `mdl_sessions` de MariaDB.
4. **Trazabilidad de upstream comprobable:** Se añadió un formato de log dedicado (`upstream_ha`) en Nginx que audita en tiempo real la IP del cliente, el upstream atendedor y el tiempo de respuesta.

## Consecuencias y mitigaciones

| Consecuencia | Mitigación Implementada |
|---|---|
| Moodle requiere compartir sesiones entre nodos | Se activó `$CFG->dbsessions = 1` en la base de datos MariaDB y se purgó la caché MUC en ambas VMs. |
| Posible retardo si un nodo cae | Se fijaron `proxy_connect_timeout 2s`, `max_fails 1` y `fail_timeout 3s` en Nginx para garantizar conmutación casi instantánea. |
| Ambos nodos escriben en MariaDB | El contenedor MariaDB en VM 2 gestiona bloqueos transaccionales InnoDB concurrentes de forma nativa. |
| Verificación ágil durante la defensa de 25 min | Se desarrolló el script [`scripts/verificar-alta-disponibilidad.sh`](../../scripts/verificar-alta-disponibilidad.sh) que automatiza las pruebas de corte bidireccionales en 60 segundos. |

## Evidencias de validación

- Asignación IP y ping bidireccional: [EV-131](../procedimientos/13-fase-opcional/13-01/evidencias/EV-131.md).
- Aislamiento de MariaDB en VM 2: [EV-132](../procedimientos/13-fase-opcional/13-02/evidencias/EV-132.md) y [EV-133](../procedimientos/13-fase-opcional/13-02/evidencias/EV-133.md).
- Conexión efectiva y `config.php`: [EV-134](../procedimientos/13-fase-opcional/13-03/evidencias/EV-134.md).
- Verificación HTTPS y consulta de cursos: [EV-135](../procedimientos/13-fase-opcional/13-04/evidencias/EV-135.md).
- **Demostración de Alta Disponibilidad y Failover:** [EV-136](../procedimientos/13-fase-opcional/13-04/evidencias/EV-136.md).
- Persistencia y FTPS: [EV-137](../procedimientos/13-fase-opcional/13-04/evidencias/EV-137.md).
- Respaldos y DRP en VM 2: [EV-138](../procedimientos/13-fase-opcional/13-05/evidencias/EV-138.md).
