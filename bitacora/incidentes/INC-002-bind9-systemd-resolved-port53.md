# INC-002 — Coexistencia de BIND9 con systemd-resolved en el Puerto 53

- INC-ID: INC-002
- Fecha / VM / paso: 2026-10-28 19:40 CST / VM #1 Ubuntu Server / Paso 7 (DNS BIND9)
- Estado: resuelto y verificado

## Síntoma y contexto
Al preparar la instalación de BIND9 para resolver el dominio institucional `ctcr`, se detectó que el puerto 53 ya registraba actividad en el sistema operativo mediante el resolver local `systemd-resolved`. Si BIND9 intentaba escuchar en todas las interfaces (`0.0.0.0:53`) o en `127.0.0.1:53`, colisionaría con el demonio local o interferiría con la resolución DNS WAN que utiliza Ubuntu Server para acceder a Internet a través de la interfaz NAT.

## Impacto, severidad y riesgo
- Severidad: Media (potencial interrupción de conectividad externa de la VM).
- Riesgo: Si BIND9 tomaba el puerto 127.0.0.1, las consultas internas de resolución de paquetes (`apt update`) y Docker podían fallar al carecer de resolución autoritativa hacia Internet.

## Diagnóstico con comandos y salida saneada
Se ejecutó la inspección de sockets antes de configurar BIND9:
```bash
sudo ss -lntup | grep ':53 '
```
Salida observada:
```text
udp UNCONN 0 0 127.0.0.54:53 0.0.0.0:* users:(("systemd-resolve",pid=762,fd=17))
udp UNCONN 0 0 127.0.0.53%lo:53 0.0.0.0:* users:(("systemd-resolve",pid=762,fd=15))
tcp LISTEN 0 4096 127.0.0.53%lo:53 0.0.0.0:* users:(("systemd-resolve",pid=762,fd=16))
tcp LISTEN 0 4096 127.0.0.54:53 0.0.0.0:* users:(("systemd-resolve",pid=762,fd=18))
```
El diagnóstico confirmó que `systemd-resolved` escuchaba en las direcciones de loopback `127.0.0.53` y `127.0.0.54`, dejando libre la dirección fija de la red interna `192.168.50.1`.

## Solución y por qué
Se configuró `/etc/bind/named.conf.options` para que BIND9 escuche **única y exclusivamente** en la IP LAN del servidor:
```named
listen-on { 192.168.50.1; };
listen-on-v6 { none; };
```
Esta arquitectura permite que:
1. Las máquinas de la LAN (Linux Mint `192.168.50.101`) consulten a BIND9 en `192.168.50.1:53`.
2. Ubuntu Server mantenga su resolución WAN nativa mediante `systemd-resolved` sin ninguna interferencia.

## Verificación y recuperación
1. Validación sintáctica: `named-checkconf` retornó código 0.
2. Comprobación de sockets:
   ```bash
   sudo ss -lntup | grep ':53 '
   ```
   Confirmó `named` escuchando en `192.168.50.1:53` (TCP/UDP) y `systemd-resolved` en `127.0.0.53/54`.
3. Prueba remota desde Linux Mint: `dig @192.168.50.1 aulavirtual.ctcr +short` devolvió inmediatamente `192.168.50.1`.

## Evidencia de resolución

### EV-063 — Inspección de Sockets y Coexistencia en Puerto 53

![EV-063](../../docs/procedimientos/07-dns-bind9/07-05/evidencias/EV-063.webp)

- **Ficha descriptiva:** [EV-063.md](../../docs/procedimientos/07-dns-bind9/07-05/evidencias/EV-063.md)
- **Validación:** La captura demuestra que `named` escucha exclusivamente en `192.168.50.1:53` (TCP y UDP) mientras `systemd-resolved` permanece en las direcciones de loopback `127.0.0.53` y `127.0.0.54`, eliminando cualquier conflicto de puerto.

## Prevención y documentación asociada
- Documentado en la sesión de trabajo [`bitacora/sesiones/2026-10-28-sesion-paso7-dns-bind9.md`](../sesiones/2026-10-28-sesion-paso7-dns-bind9.md) y en el procedimiento [`docs/procedimientos/07-dns-bind9/07-01.md`](../../docs/procedimientos/07-dns-bind9/07-01.md).
- Regla incorporada: Nunca configurar `listen-on { any; };` ni `127.0.0.1` en BIND9 en este entorno.
