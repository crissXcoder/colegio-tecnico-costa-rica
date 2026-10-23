# Restauración de MariaDB sin pisar la base real

**Requisitos:** SQL creado, comprobado con `gzip -t`, nombre de proyecto `proyecto-moodle`, servicio db saludable, respaldo lógico y autorización. **No ejecutar comandos destructivos contra `moodle`.**

```bash
# En VM cuya carpeta original sea ~/proyecto-moodle
cd "$HOME/proyecto-moodle"
# Apuntar al archivo real sin publicarlo: sustituir la ruta siguiente por el nombre verificado.
BACKUP=/var/backups/moodle/archivo-verificado.sql.gz
sudo gzip -t "$BACKUP"
# Leer variable de root sin mostrar valor:
set -a; source .env; set +a
# Crear esquema aislado con nombre explícito:
sudo docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db \
  mariadb -u root -e 'CREATE DATABASE IF NOT EXISTS moodle_restore_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;'
# Importar en la base de ensayo:
sudo gzip -dc "$BACKUP" | sudo docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db \
  mariadb -u root moodle_restore_test
# Comprobar tablas restauradas:
sudo docker compose exec -T -e MYSQL_PWD="$DB_ROOT_PASSWORD" db \
  mariadb -u root -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='moodle_restore_test';"
```

**No ejecutar `DROP DATABASE` automáticamente.** Registrar tablas y capturas sanitizadas, dejar la base de ensayo hasta completar la evaluación y retirarla solo con autorización del grupo. Para restauración integral de Moodle se necesita también el volumen `moodle_data`, código/configuración y pruebas de funcionamiento, no solo SQL.

Si el backup se generó con Compose de la carpeta del repo, mantener `-p proyecto-moodle`, el Compose exacto y el `.env` correspondiente; no alternar archivos a mitad de recuperación.
