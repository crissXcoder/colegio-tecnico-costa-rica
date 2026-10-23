# ADR-0002 — HTTPS finalizado en Nginx del host

- Estado: propuesto en chat, no verificado en bitácora
- Contexto: Moodle y MariaDB funcionan en contenedores; el proyecto exige HTTPS bajo dominio interno.
- Alternativas: TLS en contenedor, Nginx host, Apache host, Caddy.
- Propuesta: Nginx en Ubuntu maneja 80/443 y hace proxy a Moodle por `127.0.0.1:8080`.
- Riesgos: conflictos de puertos con Apache preexistente; incorrecto `MOODLE_URL`/`MOODLE_SSL_PROXY`; certificado autofirmado sin confianza por defecto; filtros UFW; redirección y cookies.
- Comprobación previa: `sudo ss -lntup`, `sudo systemctl --type=service --state=running`, `docker compose ps`.
- Reversión: restaurar configuración Nginx y Compose respaldada; mantener volúmenes. No realizar cambios en el mismo momento de una presentación.
