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

## Prevención y documentación asociada
- Documentado en `GEMINI.md` (Sección 10.6) y en `doc_paso8/sesion/2026-10-28-sesion-paso8-https-nginx.md`.
