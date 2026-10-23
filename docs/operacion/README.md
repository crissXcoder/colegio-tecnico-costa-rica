# Operación diaria de las VMs: guía para el equipo

Esta documentación corresponde al **uso continuo de un laboratorio ya montado**. A diferencia de los guiones de instalación nueva, prioriza conservar Moodle, datos y servicios activos. Si un integrante encuentra un problema se detiene esa operación, se diagnostica y se actualizan la sesión y el paso afectado.

## A. Reabrir el laboratorio después de apagar computadoras

Leer [`REINICIO-Y-RECUPERACION.md`](REINICIO-Y-RECUPERACION.md) antes de intentar reinstalar Docker o Moodle. En Ubuntu, comprobar estado del sistema y contenedores; en Mint verificar red interna y acceso a la URL según etapa (HTTP inicial o HTTPS final).

```bash
ip -br a
df -hT
sudo ss -lntup
cd "$HOME/proyecto-moodle"  # solo si ES el directorio real de esta VM
sudo docker compose ps
```

Si hay fallos, revisar logs y recursos antes de `up -d`. **No se debe ejecutar `down -v`** bajo ningún supuesto como solución de arranque.

## B. Diagnóstico antes de un cambio

[`COPIAR-PEGAR.md`](COPIAR-PEGAR.md) organiza comandos de inspección, instalación nueva y cambios por servicio, con instrucciones para evitar mostrar contraseñas. [`INVENTARIO-POR-INTEGRANTE.md`](INVENTARIO-POR-INTEGRANTE.md) registra lo que realmente tienen las cinco VMs, no solo la VM de la primera captura.

## C. Recuperación como prueba académica

[`RESTAURACION-ENSAYO.md`](RESTAURACION-ENSAYO.md) indica cómo importar una copia a `moodle_restore_test` **sin sobrescribir `moodle`**. Comprobar también consistencia de los archivos persistentes (`moodle_data`). Git no es almacenamiento válido para contraseñas, contenido de usuarios o backups restaurables.

## D. Almacenamiento y capacidad

La incidencia [INC-001](../../bitacora/incidentes/INC-001-almacenamiento-lvm.md) documenta cómo se detectó la raíz al 100 % en una VM. **No repetir `lvextend`, `resize2fs` o `prune` en otra VM sin analizar su partición, filesystem y snapshots**. Preferir inventario preventivo (`lsblk -f`, `df -hT`, `docker system df`) y documentar la decisión.

## Cómo documentar resultado

Después de cada sesión, conservar salida observada y prueba de aceptación en el paso; registrar host, ejecutor, revisor, fecha y commit. Las capturas de GUI/terminal deben ir a `docs/procedimientos/.../<paso>/evidencias` con ficha, no a la raíz de esta carpeta.
