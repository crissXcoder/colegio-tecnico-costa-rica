# INC-013 — Discrepancia de Resolución DNS Local en Ubuntu Server con systemd-resolved

- INC-ID: INC-013
- Fecha / VM / paso: 2026-10-30 17:35 CST / VM #1 Ubuntu Server / Paso 11 (Verificación final del proyecto / QA)
- Estado: resuelto y verificado

## Síntoma y contexto
Durante la ejecución de las pruebas transversales de QA del Paso 11 en Ubuntu Server, los scripts de prueba en Python y herramientas como `curl` arrojaron errores de resolución al intentar conectar con el FQDN institucional:
```text
urllib3.exceptions.NameResolutionError: <urllib3.connection.HTTPSConnection object>: Failed to resolve 'aulavirtual.ctcr' ([Errno -2] Name or service not known)
```
En contraste, desde la máquina virtual cliente Linux Mint (`192.168.50.101`), la resolución mediante `dig @192.168.50.1 aulavirtual.ctcr` y `getent ahostsv4 aulavirtual.ctcr` funcionaba perfectamente, devolviendo de inmediato `192.168.50.1`.

## Impacto, severidad y riesgo
- **Severidad:** Media (afecta las herramientas de prueba, diagnóstico y scripts administrativos ejecutados localmente en el servidor; no afecta a los clientes de la red interna).
- **Riesgo:** Imposibilidad de ejecutar pruebas automatizadas de integración continua y monitoreo de salud local en Ubuntu Server.

## Diagnóstico con comandos y salida saneada
Se inspeccionó la configuración DNS del servidor host:
```bash
cat /etc/resolv.conf
# nameserver 127.0.0.53
# options edns0 trust-ad
# search lan
```
Ubuntu Server 26.04 utiliza `systemd-resolved` escuchando en `127.0.0.53:53`, el cual está configurado para remitir consultas a los DNS ascendentes asignados por VirtualBox NAT en la interfaz `enp0s3` (`10.0.2.3`).

BIND9 está enlazado exclusivamente en la IP de la red LAN (`192.168.50.1:53`) para dar servicio a la subred `192.168.50.0/24` (Linux Mint), evitando la colisión de socket con `systemd-resolved` en `127.0.0.1:53` (previamente documentada en `INC-002`).

Como consecuencia, las consultas DNS originadas localmente en Ubuntu Server hacia nombres de la zona privada `ctcr` no alcanzaban la instancia autoritativa de BIND9.

## Solución y por qué
Para resolver el problema sin alterar la separación de puertos de `INC-002` ni interferir con la resolución de nombres hacia Internet vía VirtualBox NAT, se agregó una asignación estática autoritativa en `/etc/hosts` de Ubuntu Server:

```bash
sudo sed -i '/aulavirtual.ctcr/d' /etc/hosts
echo "192.168.50.1 aulavirtual.ctcr moodle.ctcr.test" | sudo tee -a /etc/hosts
```

Esta directiva garantiza que cualquier proceso local en el servidor resuelva de forma inmediata `aulavirtual.ctcr` hacia `192.168.50.1` (donde escucha Nginx en los puertos 80 y 443), respetando el orden del archivo de conmutación de nombres `/etc/nsswitch.conf` (`hosts: files dns`).

## Verificación y recuperación
1. Verificación de resolución local con `getent`:
   ```bash
   getent ahostsv4 aulavirtual.ctcr
   # 192.168.50.1     STREAM aulavirtual.ctcr
   # 192.168.50.1     DGRAM  
   # 192.168.50.1     RAW    
   ```
2. Verificación de cabeceras HTTP locales con `curl`:
   ```bash
   curl -k -I https://aulavirtual.ctcr
   # HTTP/1.1 200 OK
   # Server: nginx/1.28.3
   # Content-Type: text/html; charset=utf-8
   ```
3. Ejecución exitosa de la batería de pruebas de aislamiento y evaluación departamental.

## Evidencia de resolución
- **Subpaso asociado:** [`docs/procedimientos/11-verificacion/11-05.md`](../../docs/procedimientos/11-verificacion/11-05.md)
- **Captura relacionada:** [`EV-103.webp`](../../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.webp) y ficha [`EV-103.md`](../../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.md).

## Prevención y documentación asociada
- Documentado en la minuta de sesión [`bitacora/sesiones/2026-10-30-sesion-paso11-verificacion-final-qa.md`](../sesiones/2026-10-30-sesion-paso11-verificacion-final-qa.md).
- Incluido como guardrail en la memoria técnica y runbook de operaciones.
