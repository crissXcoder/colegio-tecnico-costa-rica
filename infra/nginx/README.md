# Nginx: HTTPS como frontera de acceso a Moodle

En el estado final Mint navega a `https://aulavirtual.ctcr` por puerto 443. El archivo [`moodle.conf.example`](moodle.conf.example) define dos bloques virtuales: HTTP 80 **redirecciona** a HTTPS y HTTPS presenta certificado autofirmado de laboratorio y hace `proxy_pass` a `127.0.0.1:8080` (solo acceso local del host).

## Qué contiene y qué depende de qué

- **`listen 192.168.50.1:80/443`**: IP del servidor en la red interna. Antes de copiar comprobar nombre real de interfaz/IP y disponibilidad de los puertos.
- **`server_name aulavirtual.ctcr`**: depende de que BIND9 resuelva dicho dominio desde Mint.
- **`ssl_certificate` y `ssl_certificate_key`**: rutas absolutas al certificado y **clave privada fuera de Git**. Se generan para el mismo SAN de dominio; el navegador puede advertir que es autofirmado.
- **`proxy_pass http://127.0.0.1:8080`**: requiere que el Compose real publique Moodle solo a localhost y que Moodle configure URL HTTPS canónica.
- **Cabeceras de proxy**: preservan host y esquema al servicio interno; probar generación de enlaces/sesiones.

## Propuesta de aplicación

1. Verificar BIND9 y puertos 80/443/8080; no desactivar Apache de otras prácticas sin inventario.
2. Crear certificado con SAN y permisos de clave usando [paso 08-02](../../docs/procedimientos/08-https-nginx/08-02.md); no versionar `.key`.
3. Respaldar sitio Nginx previo, adaptar `moodle.conf.example` y copiar al `sites-available` si procede. Enlazarlo en `sites-enabled` y ejecutar `sudo nginx -t` **antes de `systemctl reload nginx`**.
4. Adaptar **el Compose efectivamente instalado** para `MOODLE_URL=https://aulavirtual.ctcr` y backend `127.0.0.1:8080`; consultar [paso 08-05](../../docs/procedimientos/08-https-nginx/08-05.md).
5. Desde Mint probar HTTPS, nombre, certificado y sesiones. `curl -k` solo evita verificación de CA en laboratorio: **no certifica que el cliente confíe realmente en el certificado**.

**Estado verificado localmente:** fase 08 comprobada con instalación de Nginx 1.28.3, certificado SAN `aulavirtual.ctcr`, VirtualHost con redirección 301 y proxy SSL a 127.0.0.1:8080, validación sintáctica (`nginx -t`), y navegación en Mozilla Firefox desde Linux Mint, respaldada por las evidencias `EV-067`, `EV-068`, `EV-069` y `EV-070`.
