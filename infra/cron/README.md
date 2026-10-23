# Cron: respaldo automático, no solo un comando programado

El archivo [`moodle-backup.cron.example`](moodle-backup.cron.example) contiene la frecuencia objetivo **02:00 cada día** y una redirección de salida a `/var/log/elevaquitas-backup.log`. La ruta `/opt/elevaquitas` es ilustrativa: **debe reemplazarse** por la ubicación real del repositorio y su script instalado, preferiblemente ruta absoluta.

La tarea invoca [`scripts/backup-db.sh`](../../scripts/backup-db.sh), que requiere acceso al Compose efectivo, `.env` privado y directorio protegido de respaldo. El script hace dump comprimido de MariaDB y retención; **no es por sí solo una copia completa de Moodle** porque Moodle también tiene un volumen `moodle_data` con archivos.

## Puesta en marcha después de validación manual

1. Ejecutar `bash -n scripts/backup-db.sh`; revisar nombre del proyecto y volúmenes antes de instalar el Cron.
2. Ejecutar manualmente y comprobar que el archivo se crea fuera de Git, tiene tamaño razonable y supera `gzip -t`.
3. Practicar **restauración de ensayo** en base `moodle_restore_test`, comprobando tablas. Solo entonces programar `sudo crontab -e` con ruta correcta.
4. Confirmar zona horaria de Ubuntu con `timedatectl`, tarea con `sudo crontab -l` y servicio `cron` activo. Si la VM está apagada a las 02:00, esta configuración no ejecuta retroactivamente la tarea.
5. Documentar conservación de respaldos y planificar copia externa a la VM, junto a datos de Moodle consistentes.

No subir SQL, claves ni logs sensibles a Git. El [manual de respaldos](../../docs/procedimientos/10-respaldos/README.md) distingue observación, restauración y evidencia obligatoria.
