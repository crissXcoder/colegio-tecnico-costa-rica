# Automatización utilitaria: qué hace cada script, límites y seguridad

La automatización aquí es **deliberadamente pequeña**: mantiene calidad documental y ayuda con tareas repetibles, pero nunca reemplaza preflight y validación humana de IP, LVM, firewall, cuentas Moodle ni datos. Todos los scripts deben revisarse antes de ejecutarse con `sudo`.

| Archivo | Función concreta | Entradas/salidas y precauciones |
|---|---|---|
| [`generate-env.sh`](generate-env.sh) | Crea credenciales aleatorias para una **VM nueva**. | Escribe `infra/compose/.env` con modo 600; se niega a sobrescribir una existente. Revisar IP y URL sin exponer el contenido. No volver a ejecutarlo sobre una plataforma instalada. |
| [`inventory.sh`](inventory.sh) | Obtiene estado y versiones del host sin modificar sus servicios. | Capturar salida por VM, revisar que no incluya datos identificables antes de commitear; sirve como referencia para detectar divergencias. |
| [`backup-db.sh`](backup-db.sh) | Ejecuta `mariadb-dump` mediante Compose, comprime a temporal, verifica gzip, mueve a carpeta de respaldo y borra copias anteriores fuera de retención. | Requiere `.env` privado, `db` saludable y **nombre exacto de proyecto Compose**. No incluye `moodledata`; hacer restauración separada para validar. |
| [`restauracion-prueba.sh`](restauracion-prueba.sh) | **Se instala en el servidor**, junto a `respaldo.sh`. Restaura el último respaldo (o el indicado) en `moodle_restore_test`, compara tablas, cursos y usuarios con la base real y borra la base de ensayo. | No puede escribir en `moodle`. Se detiene si `db` no está healthy o si ya existe una base de ensayo. Usar con `\| tee restauracion_<fecha>.log` para dejar evidencia. Es el «script de restauración» que pide el profesor. |
| [`verificar-servicios.sh`](verificar-servicios.sh) | **Se instala en el servidor.** Chequeo previo a la demo: red, hora, disco, servicios, contenedores, configuraciones, puertos, DNS, HTTPS, certificado, Cron y respaldos. Con un segundo argumento compara los archivos vivos con `hashes.txt` del paquete. | Solo lectura. Requiere `sudo`. Termina con código 1 si algo falla. |
| [`armar-entrega.sh`](armar-entrega.sh) | **Se ejecuta en el servidor de la demo.** Arma `entrega-ctcr/` copiando sin editar Compose, configuraciones, scripts, crontab, firewall y versiones; genera `.env.example`, `mapa-origen.txt` y `hashes.txt`. | Solo escribe en la carpeta de salida. Se niega a comprimir si detecta secretos. Ver [PAQUETE-ENTREGA](../docs/entrega/PAQUETE-ENTREGA.md). |
| [`validate-repository.py`](validate-repository.py) | Revisa enlaces Markdown y de imágenes, integridad del manifiesto EV, estructura y exclusión de secretos. | Solo lee Git y archivos locales; no comprueba conectividad ni si una VM tiene Moodle funcionando. |

## Ejemplos de operación

```bash
# Desde la raíz del repositorio
python3 scripts/validate-repository.py
bash -n scripts/generate-env.sh scripts/inventory.sh scripts/backup-db.sh
bash scripts/inventory.sh
```

**No ejecutar automáticamente el generador `.env`** ni el backup sobre una VM existente hasta comparar el Compose en uso; podrían referir a una base diferente. Los procedimientos comentados están en [`docs/operacion`](../docs/operacion/README.md); las definiciones de imágenes/volúmenes en [`infra/compose`](../infra/compose/README.md).
