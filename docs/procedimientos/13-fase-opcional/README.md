# Capítulo 13 — Fase Opcional: Alta Disponibilidad (HA), Balanceo de Carga y Resiliencia Multi-VM

Este capítulo documenta la implementación completa, verificación y aseguramiento operativo de la **Fase Opcional (Bonus)** del proyecto final del Colegio Técnico de Costa Rica (CTCR), conforme al lineamiento oficial de evaluación:

> *"Bonus opcional, disponible para los seis escenarios:  
> **Alta disponibilidad:** al menos dos instancias del mismo servicio (dos contenedores, o dos VMs) sirviendo el mismo sitio, con demostración de que si una cae la otra responde. No se cubre formalmente en el curso (balanceo de carga) — queda como bonus para quien quiera investigarlo por su cuenta, en cualquiera de los seis escenarios, no solo en uno."*

En esta fase, la plataforma evoluciona hacia una **arquitectura de Alta Disponibilidad Activa** con dos instancias del servicio Moodle sirviendo simultáneamente el dominio institucional `aulavirtual.ctcr` bajo un balanceador de carga Nginx con conmutación por error (*failover*) automática sub-segundo, conectadas a un motor de base de datos MariaDB común con sesiones en base de datos (`dbsessions = 1`).

```mermaid
flowchart TD
    subgraph LAN ["Red LAN Institucional (192.168.50.0/24)"]
        Mint["Linux Mint Cliente<br/>192.168.50.101"]
    end

    subgraph VM1 ["VM 1 — Ubuntu Server (192.168.50.1 / 192.168.56.103)"]
        direction TB
        Nginx["Nginx Reverse Proxy & Load Balancer<br/>:80 (301) / :443 (TLS)<br/>proxy_next_upstream (failover)"]
        DNS["BIND9 DNS<br/>aulavirtual.ctcr -> 192.168.50.1"]
        FTPS["vsftpd FTPS TLS<br/>:21, :40000-40010"]
        Moodle1["Moodle Instancia 1<br/>oksigenia/moodle:4.5.15<br/>127.0.0.1:8080 (healthy)"]
        Nginx -->|Upstream Primario / Round-Robin| Moodle1
    end

    subgraph HostOnly ["Red Privada Host-Only (192.168.56.0/24)"]
        VM1_IP["VM 1: 192.168.56.103"]
        VM2_IP["VM 2: 192.168.56.104"]
        VM1_IP <-->|Enlace Privado| VM2_IP
    end

    subgraph VM2 ["VM 2 — Ubuntu Server (192.168.56.104)"]
        direction TB
        Moodle2["Moodle Instancia 2<br/>oksigenia/moodle:4.5.15<br/>192.168.56.104:8080 (healthy)"]
        MariaDB["Contenedor MariaDB<br/>mariadb:11.4.13<br/>192.168.56.104:3306 (healthy)<br/>494 tablas"]
        Cron["Cron Respaldo SQL<br/>02:00 AM diario<br/>/var/backups/moodle/"]
    end

    Mint -->|HTTPS :443| Nginx
    Mint -->|DNS :53| DNS
    Mint -->|FTPS :21| FTPS
    Nginx -->|Upstream Secundario / Failover| Moodle2
    Moodle1 -.->|SQL + Sesiones (dbsessions)| MariaDB
    Moodle2 -.->|SQL + Sesiones (dbsessions)| MariaDB
```

## Resumen de Máquinas y Roles

| Parámetro | VM 1 — Web Tier / Load Balancer | VM 2 — Web Replica / Data Tier |
|---|---|---|
| **Hostname** | `server` | `server` |
| **Usuario / Sudo** | `criss` / `NOPASSWD` | `criss` / `NOPASSWD` |
| **Interfaz WAN (NAT)** | `enp0s3` (`10.0.2.15/24`) | `enp0s3` (`10.0.2.15/24`) |
| **Interfaz LAN (`intnet`)** | `enp0s8` (`192.168.50.1/24`) | Desactivada (para evitar colisión de IP con `192.168.50.1`) |
| **Interfaz Host-Only** | `enp0s9` (`192.168.56.103/24`) | `enp0s9` (`192.168.56.104/24`) |
| **Servicios Activos** | Nginx (LB), BIND9, vsftpd, Docker (Moodle 1) | Docker (Moodle 2, MariaDB), Cron DRP |
| **Puertos de Red** | `:80`, `:443`, `:53`, `:21`, `40000:40010` | `192.168.56.104:8080` (Moodle), `192.168.56.104:3306` (DB) |
| **Ruta del Proyecto** | `/home/criss/proyecto-moodle/` | `/home/criss/proyecto-moodle/` |

## Subpasos del Capítulo

| Subpaso | Título y Enlace | Propósito Operativo | Evidencias |
|---|---|---|:---:|
| **13.01** | [Configuración de Red e Interfaces Netplan](13-01.md) | Asignación estática de IPs en `192.168.56.0/24` y comprobación de ping bidireccional. | [EV-131](13-01/evidencias/EV-131.md) |
| **13.02** | [Aislamiento y Preparación de MariaDB en VM 2](13-02.md) | Enlace exclusivo a `192.168.56.104:3306`, auditoría de tablas y preparación de entorno. | [EV-132](13-02/evidencias/EV-132.md), [EV-133](13-02/evidencias/EV-133.md) |
| **13.03** | [Conexión de Moodle en VM 1 a MariaDB Remota](13-03.md) | Configuración de `MOODLE_DB_HOST: 192.168.56.104`, arranque de Moodle y verificación de `config.php`. | [EV-134](13-03/evidencias/EV-134.md) |
| **13.04** | [Verificación Funcional, Alta Disponibilidad y FTPS](13-04.md) | Checklist de 8 puntos, despliegue de Instancia 2 en VM 2, upstream Nginx y prueba empírica de failover. | [EV-135](13-04/evidencias/EV-135.md), [EV-136](13-04/evidencias/EV-136.md), [EV-137](13-04/evidencias/EV-137.md) |
| **13.05** | [Ajuste de Respaldos, DRP, Cron y Reversión](13-05.md) | Ejecución de `respaldo.sh` y `restauracion-prueba.sh` en VM 2, reubicación de Cron y plan de rollback. | [EV-138](13-05/evidencias/EV-138.md) |

## Criterios de Aceptación del Bloque

1. **Redundancia Activa:** Existen al menos dos instancias del mismo servicio (Moodle) en ejecución simultánea sirviendo el mismo sitio `aulavirtual.ctcr`.
2. **Conmutación por Error (Failover) Demostrada:** Al detener la Instancia 1, la Instancia 2 atiende de inmediato las peticiones entrantes con `HTTP 200 OK` (0.165s). Al detener la Instancia 2, la Instancia 1 asume el tráfico igualmente con `HTTP 200 OK` (0.193s).
3. **Persistencia de Sesiones Transparentes:** Las sesiones de usuario persisten en MariaDB (`dbsessions = 1`), asegurando que la conmutación entre nodos no desautentique al usuario.
4. **Preservación Íntegra de Datos:** Las 494 tablas de Moodle, los 12 usuarios y los 3 cursos departamentales se conservan intactos en el motor relacional.
5. **Continuidad de Servicios del Host:** Nginx TLS, BIND9 y vsftpd con enjaulamiento departamental 700 continúan operando sin interrupción en VM 1.
6. **Autonomía de Respaldos:** Las copias de seguridad de la base de datos y su ciclo de ensayo de restauración operan localmente en VM 2 mediante Cron.
