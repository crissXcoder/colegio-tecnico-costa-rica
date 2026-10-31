# INC-019 — La instalación de vsftpd espera porque las actualizaciones automáticas tienen APT bloqueado

- INC-ID: INC-019
- Fecha / VM / paso: durante el paso 9 (fecha exacta no registrada) / VM `server@server` / Paso 9.1 (instalar el servicio)
- Estado: resuelto solo, sin intervención. Procedencia: documento del grupo (PDF de 54 páginas), pág. 42; evidencia [EV-123](../../docs/procedimientos/09-ftps-vsftpd/09-01/evidencias/EV-123.md).

## Síntoma y contexto

`sudo apt install -y vsftpd` no avanzaba y repetía:

```text
Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 3165 (unattended-upgr)
```

## Impacto, severidad y riesgo

- Severidad: baja. Solo demora.
- Riesgo real: perder la paciencia y **borrar los archivos de bloqueo** (`rm /var/lib/dpkg/lock*`) o matar el proceso. Si `dpkg` está a mitad de una instalación, eso puede dejar paquetes rotos.

## Diagnóstico con comandos y salida saneada

El proceso 3165 es `unattended-upgrades`, el servicio de Ubuntu que instala actualizaciones de seguridad solo, normalmente poco después de encender la VM. Mientras corre, APT está bloqueado para cualquier otra instalación.

```bash
ps -p 3165 -o pid,etime,cmd          # cuánto lleva y qué es
systemctl status unattended-upgrades --no-pager
tail -n 20 /var/log/unattended-upgrades/unattended-upgrades.log
```

## Solución y por qué

Esperar a que termine; APT reintenta solo y la instalación continúa. Después `vsftpd -v` mostró `version 3.0.5` (EV-123).

## Verificación y recuperación

Si alguna vez se interrumpiera APT a la fuerza: `sudo dpkg --configure -a` y luego `sudo apt -f install` para terminar la configuración pendiente.

## Prevención y documentación asociada

- No instalar paquetes justo después de encender la VM; esperar a que `unattended-upgrades` termine.
- Las actualizaciones automáticas pueden **cambiar versiones** (por ejemplo, subir Nginx de `…1.11` a `…1.12`, ver INC-003). La semana de la entrega, revisar con `apt list --upgradable` y fijar con `apt-mark hold` lo que deba quedar igual al paquete entregado (riesgo R-46).
- Nunca borrar `/var/lib/dpkg/lock*`.
