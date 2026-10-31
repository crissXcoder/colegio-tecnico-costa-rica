# ADR-0003 — Firewall: iptables en el servidor de la demo; UFW no se activa antes de la entrega

- ADR-ID: ADR-0003
- Estado: **aceptada para la VM #1** (observado en EV-102). **Pendiente de confirmar por el grupo** cuál VM presenta (ver [ADR-0004](ADR-0004-servidor-unico-de-demostracion.md)).
- Fecha / Autores / Revisores: 2026-10-31 / redactada a partir de 11-04 (EV-102) y del anexo técnico del 31/10 / revisión pendiente.

## Contexto y problema

El profesor pide entregar `ufw.txt` **si se usa UFW**. En el proyecto hay dos situaciones distintas documentadas:

| VM | Qué se observó | Fuente |
|---|---|---|
| VM #1 (Ubuntu `server`, proyecto en `/home/criss/proyecto-moodle`) | UFW **no instalado**. Filtrado y NAT de Mint con iptables persistente (`/etc/iptables/rules.v4`), cadena `DOCKER-USER` preservada. | [11-04](../procedimientos/11-verificacion/11-04.md), EV-102 |
| VM del anexo técnico | UFW reinstalado (`0.36.2-9build1`), siete reglas cargadas, **inactivo**. Además: MariaDB del host en `0.0.0.0:3306`, PostgreSQL en `0.0.0.0:5432` y contenedores `lab5`. | Anexo técnico, sección I; [INC-018](../../bitacora/incidentes/INC-018-ufw-paquete-removido-config-residual.md) |

## Opciones y criterios

| Opción | A favor | En contra |
|---|---|---|
| A. iptables persistente, sin UFW (VM #1) | Ya funciona y está verificado; no interfiere con las cadenas que crea Docker ni con el NAT de Mint. | Reglas menos legibles; hay que saber explicarlas con `iptables -S`. |
| B. Activar UFW con las siete reglas | Reglas fáciles de leer en `ufw status`. | Activarlo puede cortar SSH y alterar el reenvío que usa Mint; Docker publica puertos por sus propias cadenas y puede saltarse UFW; obliga a volver a probar todo a días de la entrega. |
| C. Sin filtrado | Nada que romper. | Deja expuestos servicios ajenos como las bases de datos del host. |

## Decisión y justificación

**Opción A** para la entrega: no se activa UFW antes del 07/11/2026. Se entrega `ufw.txt` diciendo que UFW no se usa (o su estado `inactive` si la VM elegida lo tiene instalado) y `firewall-iptables.txt` con las reglas reales. Así lo entregado describe lo que realmente filtra el servidor.

Moodle no depende del firewall para quedar protegido: escucha solo en `127.0.0.1:8080`, MariaDB no publica puertos y Nginx escucha solo en `192.168.50.1`.

## Consecuencias, riesgos y trade-offs

- No se puede decir en la presentación «UFW protege el servidor». Se dice: «el filtrado es con iptables; UFW no está activo».
- Si la VM de la demo es la del anexo, sus bases de datos del host en `0.0.0.0` quedan sin filtrar: saber explicarlo o detenerlas, previo acuerdo (riesgo R-33).
- Si en el futuro se activa UFW: revisar `DEFAULT_*_POLICY` en `/etc/default/ufw`, la regla de SSH, el rango pasivo FTP y la convivencia con Docker; activarlo desde la **consola de VirtualBox**, nunca por SSH, y repetir las pruebas desde Mint.

## Evidencias para validar y plan de reversión

- Validar: `sudo iptables -S`, `sudo iptables -t nat -S`, `command -v ufw && sudo ufw status verbose`.
- Reversión si alguien activa UFW y algo deja de funcionar: `sudo ufw disable` desde la consola de VirtualBox.
