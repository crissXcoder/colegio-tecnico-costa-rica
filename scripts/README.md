# Automatización utilitaria: qué hace cada script, límites y seguridad

La automatización aquí es **deliberadamente pequeña**: mantiene calidad documental y ayuda con tareas repetibles, pero nunca reemplaza preflight y validación humana de IP, LVM, firewall, cuentas Moodle ni datos. Todos los scripts deben revisarse antes de ejecutarse con `sudo`.

| Archivo | Función concreta | Entradas/salidas y precauciones |
|---|---|---|
| [`generate-env.sh`](generate-env.sh) | Crea credenciales aleatorias para una **VM nueva**. | Escribe `infra/compose/.env` con modo 600; se niega a sobrescribir una existente. Revisar IP y URL sin exponer el contenido. No volver a ejecutarlo sobre una plataforma instalada. |
| [`inventory.sh`](inventory.sh) | Obtiene estado y versiones del host sin modificar sus servicios. | Capturar salida por VM, revisar que no incluya datos identificables antes de commitear; sirve como referencia para detectar divergencias. |
| [`backup-db.sh`](backup-db.sh) | Ejecuta `mariadb-dump` mediante Compose, comprime a temporal, verifica gzip, mueve a carpeta de respaldo y borra copias anteriores fuera de retención. | Requiere `.env` privado, `db` saludable y **nombre exacto de proyecto Compose**. No incluye `moodledata`; hacer restauración separada para validar. |
| [`validate-repository.py`](validate-repository.py) | Revisa enlaces Markdown y de imágenes, integridad del manifiesto EV, estructura y exclusión de secretos. | Solo lee Git y archivos locales; no comprueba conectividad ni si una VM tiene Moodle funcionando. |

## Ejemplos de operación

```bash
# Desde la raíz del repositorio
python3 scripts/validate-repository.py
bash -n scripts/generate-env.sh scripts/inventory.sh scripts/backup-db.sh
bash scripts/inventory.sh
```

**No ejecutar automáticamente el generador `.env`** ni el backup sobre una VM existente hasta comparar el Compose en uso; podrían referir a una base diferente. Los procedimientos comentados están en [`docs/operacion`](../docs/operacion/README.md); las definiciones de imágenes/volúmenes en [`infra/compose`](../infra/compose/README.md).
