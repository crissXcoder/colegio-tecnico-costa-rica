# INC-001 — Partición raíz llena durante la edición de Compose

- Estado: resuelto **en la VM documentada**, no necesariamente en las cinco.
- Fuente: bitácora Word, páginas 23 y 24.
- Síntoma: editor no pudo guardar `compose.yaml`, mensaje `make room on disk`.
- Diagnóstico: `df -h` mostró `/` al 100%, ~12 GB asignados. `sudo vgs` reveló ~11,5 GB libres en el grupo de volúmenes LVM.
- Corrección registrada: expansión del volumen lógico y del sistema de archivos, raíz de ~12 a ~23 GB y uso en ~51%; posteriormente limpieza de imágenes Docker sin uso, liberando ~1,8 GB.
- Comandos **relatados en la fuente**, no receta para otras VMs: `lvextend -l +100%FREE`, `resize2fs`, `docker image prune -a`.
- Riesgo: la ruta del volumen, sistema de archivos, particiones y estado de Docker varían en cada equipo. Los comandos de extensión/limpieza NO son universalmente seguros ni deben repetirse de forma automática.

## Lecciones verificables

- Antes de instalar nuevas imágenes, capturar `df -h`, `docker system df`, `lsblk -f`, `pvs`, `vgs`, `lvs`.
- Calcular tamaño de imágenes, logs y volúmenes; revisar rotación y retención.
- Mantener backup antes de modificar LVM; no limpiar imágenes utilizadas ni volúmenes con datos.
- Documentar la ruta exacta del dispositivo y la verificación posterior sin publicar contraseñas.

## Verificación pendiente

- [ ] Captura saneada del estado antes y después en evidencias.
- [ ] Comprobación de espacio libre en las otras cuatro VMs.
- [ ] Confirmar política de rotación de logs de Docker.
