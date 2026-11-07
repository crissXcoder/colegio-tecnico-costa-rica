# ADR-0005 — Arquitectura Distribuida Multi-VM para Desacoplamiento de Base de Datos y Capa Web (Fase Opcional)

- ADR-ID: ADR-0005
- Estado: **aceptada**. Implementada y validada integralmente para la Fase Opcional del proyecto final CTCR (07/11/2026).
- Fecha / Autores / Revisores: 2026-11-07 / Cristhian Altamirano Montes / equipo CTCR EIF431O.

## Contexto y problema

La arquitectura base del proyecto CTCR opera sobre un único servidor Ubuntu Server monolítico (VM 1), donde conviven los contenedores de Moodle y MariaDB junto con el proxy Nginx, el DNS BIND9 y el servidor FTPS vsftpd.

Para la **Fase Opcional** del proyecto docente, se requiere implementar un desacoplamiento horizontal en dos niveles (*two-tier architecture*), segregando la capa de base de datos en una segunda máquina virtual (VM 2 — MariaDB) y manteniendo la capa web y de servicios perimetrales en VM 1 (Moodle).

Los desafíos críticos identificados fueron:
1. **Conflicto de direccionamiento LAN:** Ambos clones de Ubuntu Server compartían la configuración original con IP fija `192.168.50.1/24` en el adaptador `enp0s8`.
2. **Aislamiento y seguridad de la base de datos:** El puerto TCP 3306 de MariaDB no debe exponerse a la red LAN de estudiantes ni a Internet, sino canalizarse por un enlace punto a punto privado.
3. **Persistencia e integridad de datos:** Los volúmenes existentes (`mariadb_data`, `moodle_code`, `moodle_data`) y los registros relacionales (494 tablas, 12 usuarios, 3 cursos) deben preservarse sin reinicializaciones destructivas.
4. **Reversibilidad garantizada:** Capacidad de retornar a la arquitectura monolítica en menos de 2 minutos sin pérdida de datos en caso de contingencia.

## Opciones consideradas

- **Opción A — Mantener arquitectura monolítica:** Cero riesgo de conectividad, pero no cubre el puntaje de la fase opcional ni demuestra competencias de integración de red multi-VM.
- **Opción B — Separación en dos VMs mediante red Host-Only dedicada (`192.168.56.0/24`):**
  - VM 1 (`192.168.56.103`): Web Tier (Nginx HTTPS, Moodle, BIND9, vsftpd).
  - VM 2 (`192.168.56.104`): Data Tier (MariaDB 11.4.13, Cron de respaldos).
  - Desactivación del adaptador LAN `enp0s8` en VM 2 para erradicar cualquier conflicto con `192.168.50.1`.
- **Opción C — Comunicación por la red LAN `192.168.50.0/24` asignando una segunda IP:** Expondría el tráfico SQL y el puerto 3306 en el mismo segmento donde navegan los clientes (Mint), vulnerando el principio de mínimo privilegio y aislamiento de tiers.

## Decisión y justificación

Se adopta la **Opción B**.

**Justificación técnica:**
1. **Seguridad y Aislamiento por Diseño:** La red Host-Only (`192.168.56.0/24`) es inaccesible desde el cliente Linux Mint (`192.168.50.101`). MariaDB escucha exclusivamente en `192.168.56.104:3306`, protegiendo el motor relacional de escaneos o accesos no autorizados.
2. **Prevención de Colisión ARP:** Al desactivar el adaptador 2 (`enp0s8`) en VM 2, la IP `192.168.50.1` permanece como propiedad única e indiscutida de VM 1, garantizando que el gateway, el DNS y el proxy inverso sigan estables para el cliente Mint.
3. **Carga Operativa y Desempeño:** VM 2 apaga Moodle, Nginx, BIND9 y vsftpd, dedicando sus recursos de CPU y RAM de forma exclusiva al motor relacional MariaDB y al proceso de respaldo.
4. **Resiliencia Probada:** La tolerancia a fallos fue comprobada empíricamente (EV-136): detener MariaDB genera un error controlado de base de datos en Moodle, y al restablecerla, Moodle reanuda el servicio de inmediato sin requerir reinicio del contenedor.

## Consecuencias y mitigaciones

| Consecuencia | Mitigación Implementada |
|---|---|
| Moodle requiere conocer la nueva IP de la BD | Se configuró `MOODLE_DB_HOST: 192.168.56.104` en `compose.yaml` y la imagen Oksigenia regeneró `/var/www/moodle/config.php` (EV-134). |
| `depends_on: db` ya no es válido en VM 1 | Se eliminó el bloque `depends_on` del Compose de VM 1, desacoplando el ciclo de vida de los contenedores. |
| El respaldo SQL debe ejecutarse donde está el motor | `respaldo.sh` y `restauracion-prueba.sh` se ejecutan en VM 2; la tarea de Cron se activó en VM 2 y se comentó en VM 1 (EV-138). |
| Necesidad de reversión rápida | Se resguardó `compose.antes-red.yaml` y se preservó intacto el volumen local `mariadb_data` en VM 1. |

## Evidencias de validación

- Asignación IP y ping bidireccional: [EV-131](../procedimientos/13-fase-opcional/13-01/evidencias/EV-131.md).
- Aislamiento de MariaDB en VM 2: [EV-132](../procedimientos/13-fase-opcional/13-02/evidencias/EV-132.md) y [EV-133](../procedimientos/13-fase-opcional/13-02/evidencias/EV-133.md).
- Conexión efectiva y `config.php`: [EV-134](../procedimientos/13-fase-opcional/13-03/evidencias/EV-134.md).
- Comprobación web, cursos y fallo controlado: [EV-135](../procedimientos/13-fase-opcional/13-04/evidencias/EV-135.md) y [EV-136](../procedimientos/13-fase-opcional/13-04/evidencias/EV-136.md).
- Persistencia y FTPS: [EV-137](../procedimientos/13-fase-opcional/13-04/evidencias/EV-137.md).
- Respaldos y DRP en VM 2: [EV-138](../procedimientos/13-fase-opcional/13-05/evidencias/EV-138.md).
