# Cron: respaldo automático, no solo un comando programado

El archivo [`moodle-backup.cron.example`](moodle-backup.cron.example) contiene la línea **real** del crontab de root de la VM #1 (EV-098): todos los días a las **02:00**, `respaldo.sh` de la carpeta del proyecto, con salida a `/var/log/moodle-backup.log`. En otra VM, cambiar `/home/criss/proyecto-moodle` por su carpeta real (el anexo técnico menciona `/root/proyecto-moodle` y `/home/server`).

En el servidor corre `respaldo.sh` (contenido en [10-02](../../docs/procedimientos/10-respaldos/10-02.md)), que genera `ctcr_moodle_<fecha>.sql.gz`. El script [`scripts/backup-db.sh`](../../scripts/backup-db.sh) del repositorio es una variante para el modelo de `infra/compose` (genera `moodle_<fecha>.sql.gz`); **no** es el que se entrega. La restauración de ensayo se hace con [`scripts/restauracion-prueba.sh`](../../scripts/restauracion-prueba.sh), que reconoce ambos nombres. Ninguno de los dos respaldos incluye el volumen `moodle_data` (archivos subidos); ver [10-07](../../docs/procedimientos/10-respaldos/10-07.md).

## Puesta en marcha después de validación manual

1. Ejecutar `bash -n scripts/backup-db.sh`; revisar nombre del proyecto y volúmenes antes de instalar el Cron.
2. Ejecutar manualmente y comprobar que el archivo se crea fuera de Git, tiene tamaño razonable y supera `gzip -t`.
3. Practicar **restauración de ensayo** en base `moodle_restore_test`, comprobando tablas. Solo entonces programar `sudo crontab -e` con ruta correcta.
4. Confirmar zona horaria de Ubuntu con `timedatectl`, tarea con `sudo crontab -l` y servicio `cron` activo. Si la VM está apagada a las 02:00, esta configuración no ejecuta retroactivamente la tarea.
5. Documentar conservación de respaldos y planificar copia externa a la VM, junto a datos de Moodle consistentes.

No subir SQL, claves ni logs sensibles a Git. El [manual de respaldos](../../docs/procedimientos/10-respaldos/README.md) distingue observación, restauración y evidencia obligatoria.
