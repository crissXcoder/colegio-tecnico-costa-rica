# Docker Compose: Moodle + MariaDB con persistencia

El [`compose.yaml`](compose.yaml) es el **diseño compartido revisado** para ejecutar dos servicios separados. Moodle contiene Apache/PHP y se conecta a la base mediante la red bridge `backend`; MariaDB tiene volumen `mariadb_data` y **no publica 3306**. Moodle usa volúmenes `moodle_code` y `moodle_data`, que deben permanecer ligados al mismo nombre de proyecto Docker.

## Archivo por archivo

- [`compose.yaml`](compose.yaml): configuración versionable de ambos servicios, dependencia `service_healthy`, red, nombres de volúmenes, puerto de Moodle y variables suministradas desde un archivo externo. **No se debe interpretar como copia exacta del Compose capturado en Word.**
- [`.env.example`](.env.example): contrato de variables para **etapa HTTP local**; muestra imagen Moodle objetivo, IP interna de ejemplo, etiquetas, nombres de credenciales sin valores privados. No se debe ejecutar como archivo de credenciales.
- [`.env.https.example`](.env.https.example): ejemplo de modificaciones de la URL `https://moodle.ctcr.test`, publicación solo en `127.0.0.1` y modo proxy TLS. Sirve para comparar campos; **no sustituir el `.env` real**.
- [`scripts/generate-env.sh`](../../scripts/generate-env.sh): crea `infra/compose/.env` con claves aleatorias en una instalación nueva, se niega a sobrescribir uno existente.

## Dos rutas operativas que no deben mezclarse

### A. Moodle ya está instalado en `~/proyecto-moodle`

Esta es la situación que aparece en la bitácora. **Antes de cualquier migración**, ejecutar solo diagnósticos:

```bash
cd "$HOME/proyecto-moodle"
sudo docker compose ps
sudo docker compose config --images
sudo docker volume ls
sudo docker compose images
```

Luego comparar el Compose histórico con el modelo del repo, verificar los volúmenes reales y respaldar la base/archivos. **No copiar el nuevo Compose y ejecutarlo como si fuera la instalación original.** Cambiar rutas/proyecto puede hacer que Docker monte volúmenes vacíos y Moodle parezca recién instalado.

### B. Instalación nueva expresamente autorizada

```bash
cd "$HOME/elevaquitas"  # ajustar ubicación donde se clonó el repositorio
bash scripts/generate-env.sh  # solo si infra/compose/.env NO existe
# Abrir y revisar infra/compose/.env SIN imprimirlo en una captura
sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml config --quiet
sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml pull
sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml up -d
sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml ps
```

**Verificar** antes de `up`: IP real de Ubuntu, tag/digest, puertos, permisos, recursos, espacio libre y ausencia de datos preexistentes. El ejemplo fija `-p proyecto-moodle` para evitar divergencias de nombre de volúmenes.

## Verificación de persistencia y riesgos

La pantalla de login y `docker volume ls` no bastan: registrar un curso/recurso de prueba y comprobar que persiste después de detener y arrancar sin `-v`. Nunca utilizar `docker compose down -v`. Registrar [EV-007/008](../../docs/procedimientos/04-contenedores/04-04.md) (configuración), [EV-010/012](../../docs/procedimientos/04-contenedores/04-07.md) (arranque) y [EV-015](../../docs/procedimientos/04-contenedores/04-09.md) (volúmenes), manteniendo el contexto histórico y pruebas posteriores.

La transición a HTTPS necesita Nginx funcional, actualizaciones de `MOODLE_URL`/`MOODLE_BIND_IP` en el **Compose efectivo**, revisión de variables soportadas y prueba de cookies/redirecciones. Véase [manual de proxy](../../docs/procedimientos/08-https-nginx/README.md).
