# Compose objetivo — Moodle y MariaDB

**Este no es el archivo original confirmado por la captura.** Es una propuesta revisable para **dos fases**: primero HTTP por IP en laboratorio y después Nginx HTTPS. El `.env.example` y `generate-env.sh` utilizan HTTP inicial; `.env.https.example` muestra las modificaciones finales. El grupo debe comparar con su `~/proyecto-moodle/compose.yaml` y preservar volúmenes antes de cambiar rutas o URL.

1. Copiar o adaptar `compose.yaml`, revisar redes/volúmenes/puertos y respaldar el Compose **actual**.
2. `./scripts/generate-env.sh` desde la raíz del repositorio genera `.env` en `infra/compose/` con secretos aleatorios **sin imprimirlos**.
3. `docker compose --env-file infra/compose/.env -f infra/compose/compose.yaml config --quiet` (esto valida interpolación; **NO publicar salida completa de `config`**, puede mostrar secretos).
4. Para laboratorio inicial por IP antes del proxy, usar `MOODLE_URL=http://192.168.50.1:8080`, `MOODLE_BIND_IP=192.168.50.1` solo temporalmente; luego migrar a HTTPS, cambiar bind a 127.0.0.1 y comprobar Moodle, sesiones y redirecciones.
5. Verificar el digest/estado de los contenedores existentes y hacer backup de DB y moodledata **antes de pull/recreate**.

Oksigenia documenta `MOODLE_SSL_PROXY`, `MOODLE_URL`, `/var/www/moodle`, `/var/www/moodledata`. Elegir imagen con correcciones vigentes y registrarla en el inventario. Los admin-password/env se aplican en la primera instalación, no sustituyen cambiar credenciales de un sitio existente.


## Importante: nombre de proyecto Docker persistente

La bitácora utiliza `~/proyecto-moodle`, por lo que Compose creó volúmenes como `proyecto-moodle_mariadb_data`. Si se ejecuta el `compose.yaml` de otra ruta SIN `-p proyecto-moodle`, Docker puede crear volúmenes nuevos. Los comandos estándar para el repo son:

```bash
cd "$HOME/elevaquitas"  # adaptar al directorio real del repositorio
sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml ps
sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml config --quiet
```

**No mover la VM en ejecución del Compose original hacia este modelo sin inventario, copia completa y comparación:** puede contener configuración adaptada por el grupo; mantener el estado histórico como referencia.
