# Operación de sesiones, restauración y recuperación

## Inicio de clase

```bash
# Lectura y diagnóstico; ejecutar desde la VM correcta
pwd
ip -br address
df -h
sudo ss -lntup
cd ~/proyecto-moodle
docker compose ps
```

Si `compose ps` indica contenedores detenidos, revisar logs y recursos antes de decidir ejecutar `docker compose up -d`. **No se debe ejecutar un reinicio indiscriminado como primer diagnóstico.**

## Almacenamiento

En el incidente INC-001 el disco virtual tenía espacio asignable en LVM pero la raíz estaba llena. Verificar primero `df -h`, `lsblk -f`, `sudo pvs`, `sudo vgs`, `sudo lvs`, `docker system df`; los comandos `lvextend`, `resize2fs`, `prune` y eliminación de volúmenes requieren respaldo, identificación exacta del dispositivo y aprobación humana.

## Datos

Git contiene recetas y evidencias, no los volúmenes persistentes reales. Hacer respaldo y **restauración de ensayo**, con archivos Moodle + DB consistentes; no suponer que SQL solo permite reponer una plataforma con contenido.
