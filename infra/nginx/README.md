# VirtualHost Nginx / TLS de laboratorio

- Certificado autofirmado SAN `DNS:moodle.colegio.test`. No guardar `.key` en Git.
- Verificar ocupación de 80/443 (puede existir Apache del laboratorio previo): `sudo ss -lntup`.
- Copiar configuración con revisión a `/etc/nginx/sites-available/moodle` y habilitar enlace, validar `sudo nginx -t`.
- El backend se enlaza a `127.0.0.1:8080` **cuando la VM ya está en estado de proxy final**, mientras el cliente accede por HTTPS.
- Cambiar URL de Moodle en Compose, confirmar cookies, CSS y redirecciones. No asumir que el cambio de `.env` basta en toda instalación anterior.
- Certificado autofirmado no es equivalente a CA públicamente confiable; para el lab documentar advertencia y, si procede, confianza explícita controlada.
