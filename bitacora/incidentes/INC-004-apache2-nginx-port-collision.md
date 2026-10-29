# INC-004 — Colisión de Sockets en Puertos 80 y 443 entre Apache2 y Nginx

- INC-ID: INC-004
- Fecha / VM / paso: 2026-10-28 20:12 CST / VM #1 Ubuntu Server / Paso 8 (Nginx HTTPS Reverse Proxy)
- Estado: resuelto y verificado

## Síntoma y contexto
Al intentar iniciar el servicio Nginx tras configurarlo como proxy inverso en `192.168.50.1:80` y `192.168.50.1:443`, existía riesgo inminente de fallo `bind() to 0.0.0.0:80 failed (98: Address already in use)` debido a que Apache2 se encontraba en ejecución activa en el host (servicio heredado de laboratorios anteriores: Joomla, phpMyAdmin y Lab 5).

## Impacto, severidad y riesgo
- Severidad: Alta (bloqueo total del servidor web Nginx y del acceso HTTPS hacia Moodle).
- Riesgo: Dos servidores web compitiendo por los mismos puertos estándar provocarían fallos intermitentes de red y caída del servicio.

## Diagnóstico con comandos y salida saneada
Se inspeccionó la ocupación de puertos web antes del inicio de Nginx:
```bash
sudo ss -lntup | grep -E ':(80|443) '
```
Salida observada:
```text
tcp LISTEN 0 511 *:80 *:* users:(("apache2",pid=1120,fd=4))
tcp LISTEN 0 511 *:443 *:* users:(("apache2",pid=1120,fd=6))
```
El diagnóstico demostró que Apache2 tenía abiertos sockets comodín (`*:80` y `*:443`), bloqueando cualquier otro demonio en esas interfaces.

## Solución y por qué
Dado que la asignación docente oficial del Proyecto Final establece Nginx como el proxy reverso institucional de Moodle LMS, se procedió a detener y deshabilitar Apache2 en systemd:
```bash
sudo systemctl stop apache2
sudo systemctl disable apache2
```
Esto liberó inmediatamente los sockets sin desinstalar Apache ni eliminar sus configuraciones de laboratorios previos (resguardadas íntegramente en `/etc/apache2/`).

## Verificación y recuperación
1. Verificación de estado de Apache2:
   ```bash
   sudo systemctl is-active apache2 # Salida: inactive
   sudo systemctl is-enabled apache2 # Salida: disabled
   ```
2. Inicio y verificación de Nginx:
   ```bash
   sudo systemctl restart nginx
   sudo ss -lntup | grep -E ':(80|443) '
   ```
   Confirmó Nginx escuchando limpiamente en `192.168.50.1:80` y `192.168.50.1:443`.

## Prevención y documentación asociada
- Documentado en `GEMINI.md` (Sección 6 y 10) y en `doc_paso8/INFORME_PASO8_HTTPS_NGINX.md`.
- Regla persistida: Apache2 debe permanecer inactivo mientras Nginx sea el frontend oficial del proyecto CTCR.
