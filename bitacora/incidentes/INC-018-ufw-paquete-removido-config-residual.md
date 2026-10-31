# INC-018 — UFW figuraba como instalado pero el comando no existía

- INC-ID: INC-018
- Fecha / VM / paso: antes del 31/10/2026 / Ubuntu Server de la VM descrita en el anexo técnico / Paso 11.4 (firewall)
- Estado: **mitigado, no cerrado**: UFW se reinstaló y tiene siete reglas cargadas, pero está **inactivo**. Procedencia: anexo técnico del grupo, sección I. Sin captura en el repositorio.

## Síntoma y contexto

`dpkg-query -W ufw` mostraba la versión `0.36.2-9build1`, pero `sudo ufw status` respondía que el comando no existía.

## Impacto, severidad y riesgo

- Severidad: media. Se creía tener un firewall disponible y no lo había.
- Riesgo: entregar un `ufw.txt` o afirmar en la presentación que UFW protege el servidor cuando no está activo.

## Diagnóstico con comandos y salida saneada

```bash
dpkg-query -W ufw                       # muestra versión aunque el paquete esté removido
dpkg -s ufw | grep -E "Status|Version"  # Status: deinstall ok config-files
```

`deinstall ok config-files` significa que el paquete se **desinstaló** (`apt remove`) pero quedaron sus archivos de configuración. `dpkg-query -W` sigue mostrando la versión, por eso parecía instalado.

## Solución y por qué

Reinstalar exactamente la versión fijada y comprobar:

```bash
apt-cache madison ufw
sudo apt install ufw=0.36.2-9build1
sudo ufw status verbose     # Status: inactive
sudo ufw show added         # (None) al inicio
```

Después se agregaron siete reglas limitadas a la interfaz y la red correctas (SSH por `enp0s3`; 53/tcp, 53/udp, 80, 443, 21 y 40000–40010 por `enp0s8` desde `192.168.50.0/24`). `ufw show added` las confirmó.

## Verificación y recuperación

**Último estado confirmado: UFW inactivo, con siete reglas cargadas pero sin aplicar.** No se activó porque falta revisar las políticas por defecto, la interacción con las reglas de Docker y los servicios ajenos de esa VM.

## Prevención y documentación asociada

- Para saber si un paquete está realmente instalado, usar `dpkg -s <paquete>` y mirar `Status: install ok installed`, o `command -v ufw`.
- La decisión sobre UFW está en [ADR-0003](../../docs/decisiones/ADR-0003-firewall-iptables-sin-ufw.md). En la VM #1 UFW no está instalado y el filtrado es con iptables (EV-102).
- **No afirmar que UFW protege el servidor** mientras `ufw status` diga `inactive`.
- Riesgo R-32 en [RIESGOS-Y-FALLOS-ANTICIPADOS](../../docs/operacion/RIESGOS-Y-FALLOS-ANTICIPADOS.md).

## Evidencia y procedencia confirmada

El documento del grupo (págs. 51–54) confirma que este incidente ocurrió en la VM `server@server` y registra el mismo procedimiento: reinstalación de `ufw=0.36.2-9build1`, `Status: inactive`, `ufw show added` con `(None)`, identificación de interfaces, siete reglas y la advertencia de no activar todavía. Captura del síntoma inicial: [EV-130](../../docs/procedimientos/11-verificacion/11-04/evidencias/EV-130.md).

La VM de Criss tiene el mismo síntoma (`ufw: command not found`, EV-102) pero **no** se reinstaló UFW allí: su filtrado se hace con iptables ([ADR-0003](../../docs/decisiones/ADR-0003-firewall-iptables-sin-ufw.md)).
