# Inventario de versiones y procedencia

| Elemento | Acordado en el chat | Observación documental | Objetivo recomendado |
| --- | --- | --- | --- |
| Ubuntu Server | 26.04 LTS | Docker info de otra VM lo reporta; bitácora corre Ubuntu | Confirmar `lsb_release -a` por VM |
| Linux Mint | 22.3 | cliente Mint en capturas | Confirmar release por VM |
| Docker Engine | 29.9.0 | comprobado en chat previo | `docker version` por VM |
| Docker Compose | 5.6.0 | comprobado en chat previo | `docker compose version` |
| Moodle | 4.5.15 | imágenes y logs en bitácora | Confirmar **compilación parchada** e inmovilizar digest |
| MariaDB | 11.4.13 | imágenes y logs en bitácora | Guardar tag y digest |
| PHP | 8.3 en imagen Moodle | acuerdo previo | ejecutar `php -v` en contenedor |
| BIND9 | 9.20.24 | BIND 9.20.24-1ubuntu0.4 instalado en VM #1 | Verificado con `named -v` (Paso 7) |
| Nginx, vsftpd | por determinar | sin pruebas suficientes | capturar versión al configurar |

## Seguridad (2026-10-23)

El mantenedor de `oksigenia/moodle` informa correcciones de dos RCE sin autenticación publicadas el 21/10/2026 en `4.5.15-r17` para la rama 4.5. La etiqueta `4.5.15` puede apuntar a un build reconstruido; **no demuestra qué digest tienen las VMs instaladas**. Primero respaldar, luego inspeccionar imágenes/digests y decidir actualización validada en equipo.

Referencias: https://hub.docker.com/r/oksigenia/moodle ; https://github.com/OksigeniaSL/docker-moodle ; https://hub.docker.com/_/mariadb

## Comandos de inventario no destructivos

```bash
lsb_release -a
uname -r
docker version
docker compose version
docker image ls --digests
docker compose -f infra/compose/compose.yaml --env-file infra/compose/.env images
```

El último comando requiere disponer del proyecto objetivo y su `.env`, no instala ni actualiza nada.
