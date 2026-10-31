# INC-005 — Bloqueo de Ejecución PHP CLI al Requerir config.php de Moodle

- INC-ID: INC-005
- Fecha / VM / paso: 2026-10-28 20:16 CST / VM #1 Ubuntu Server / Paso 8 (Nginx HTTPS Reverse Proxy)
- Estado: resuelto y verificado

## Síntoma y contexto
Al ejecutar una prueba no destructiva para verificar el valor de la variable `$CFG->wwwroot` dentro del contenedor Moodle mediante:
```bash
sudo docker compose exec moodle php -r 'require("/var/www/moodle/config.php"); echo $CFG->wwwroot;'
```
El motor PHP abortó de inmediato arrojando el error:
```text
Command line scripts must define CLI_SCRIPT before requiring config.php
```

## Impacto, severidad y riesgo
- Severidad: Baja (fallo de script de verificación, no de producción).
- Riesgo: Imposibilidad de auditar programáticamente el estado interno de Moodle sin pasar por la interfaz gráfica.

## Diagnóstico con comandos y salida saneada
El archivo `/var/www/moodle/config.php` incluye una comprobación de seguridad que exige que cualquier script ejecutado desde la interfaz de línea de comandos (CLI) declare explícitamente la constante `CLI_SCRIPT` como `true` antes de inicializar el entorno Moodle, evitando así ejecuciones web no autorizadas.

## Solución y por qué
Se ajustó el comando CLI para definir la constante requerida antes del `require`:
```bash
sudo docker compose exec moodle php -r 'define("CLI_SCRIPT", true); require("/var/www/moodle/config.php"); echo "wwwroot: " . $CFG->wwwroot . "\nsslproxy: " . var_export($CFG->sslproxy, true) . "\n";'
```

## Verificación y recuperación
Salida obtenida con éxito:
```text
wwwroot: https://aulavirtual.ctcr
sslproxy: '1'
```
Confirmando que la recreación con `compose.yaml` regeneró correctamente la configuración de Moodle bajo esquema HTTPS.

## Evidencia de resolución

### EV-068 — Verificación PHP CLI de wwwroot y Sslproxy en Moodle

![EV-068](../../docs/procedimientos/08-https-nginx/08-06/evidencias/EV-068.webp)

- **Ficha descriptiva:** [EV-068.md](../../docs/procedimientos/08-https-nginx/08-06/evidencias/EV-068.md)
- **Validación:** La captura registra la salida por terminal del script con `define("CLI_SCRIPT", true)` confirmando `wwwroot: https://aulavirtual.ctcr` y `sslproxy: '1'`.

## Prevención y documentación asociada
- Documentado en la sesión de trabajo [`bitacora/sesiones/2026-10-28-sesion-paso8-https-nginx.md`](../sesiones/2026-10-28-sesion-paso8-https-nginx.md) y en el procedimiento [`docs/procedimientos/08-https-nginx/08-05.md`](../../docs/procedimientos/08-https-nginx/08-05.md).

## Captura del error en la VM `server@server`

El mismo error, con el comando sin `define("CLI_SCRIPT", true)`, quedó registrado en el documento del grupo (pág. 50): [EV-120](../../docs/procedimientos/08-https-nginx/08-05/evidencias/EV-120.md). La versión corregida y su salida `https://aulavirtual.ctcr` están en [EV-119](../../docs/procedimientos/08-https-nginx/08-05/evidencias/EV-119.md).
