# INC-012 — Fallo de expansión de comodines en carpetas con permisos 0700 bajo sudo

- INC-ID: INC-012
- Fecha / VM / paso: 2026-10-30 / VM #1 (Ubuntu Server 26.04.1 LTS, IP `192.168.50.1`) / Paso 10.4 (Ejecutar un respaldo manual)
- Estado: resuelto (verificado con `gzip -t` y prueba de restauración en EV-097 y EV-099)

## Síntoma y contexto

Tras ejecutar el script de respaldo manual `sudo ./respaldo.sh` y generarse satisfactoriamente el volcado `ctcr_moodle_2026-10-30_16-46-51.sql.gz` dentro de `/var/backups/moodle` (protegido con `chmod 700 root:root`), se ejecutó la comprobación de integridad recomendada en la guía:

```bash
sudo gzip -t /var/backups/moodle/ctcr_moodle_*.sql.gz
```

La consola devolvió inmediatamente el error:

```
gzip: /var/backups/moodle/ctcr_moodle_*.sql.gz: No such file or directory
```

Sin embargo, al verificar el directorio con `sudo ls -lh /var/backups/moodle`, el archivo existía y tenía un tamaño válido de 384 KB.

## Impacto, severidad y riesgo

- **Severidad:** baja-media operacional. No corrompe datos ni impide la creación del respaldo, pero genera falsos negativos de verificación que pueden inducir al administrador a asumir erróneamente que el respaldo no se creó o está defectuoso.
- **Riesgo:** si se incluye este comando en scripts automatizados sin evaluar el contexto de ejecución, fallará la validación post-respaldo (`test -s` o `gzip -t`).

## Diagnóstico

1. El directorio `/var/backups/moodle` fue asegurado con permisos estrictos `drwx------ (0700) root:root` en cumplimiento del requisito de seguridad institucional.
2. Al ejecutar `sudo gzip -t /var/backups/moodle/ctcr_moodle_*.sql.gz` desde una sesión de usuario no privilegiado (`criss`), el intérprete de comandos **Bash del usuario evalúa la línea antes de invocar a `sudo`**.
3. El globbing (expansión de comodines `*`) intenta listar el contenido de `/var/backups/moodle`. Al carecer el usuario `criss` de permisos de lectura y ejecución en ese directorio, la expansión falla silenciosamente.
4. Bash deja la cadena literal `/var/backups/moodle/ctcr_moodle_*.sql.gz` y se la entrega como argumento a `sudo`.
5. `sudo` escala privilegios y ejecuta `gzip -t` pasándole ese nombre literal, el cual evidentemente no existe en disco, produciendo el error `No such file or directory`.

## Solución y por qué

Para que la expansión del asterisco ocurra con los privilegios de superusuario que sí tienen acceso de lectura al directorio `0700`, se debe delegar la expansión a una subshell de root:

```bash
sudo sh -c 'gzip -t /var/backups/moodle/ctcr_moodle_*.sql.gz'
```

Alternativamente, se puede invocar el archivo con su ruta absoluta exacta (obtenida mediante `sudo find` o `sudo ls`):

```bash
BACKUP=$(sudo find /var/backups/moodle -name 'ctcr_moodle_*.sql.gz' -type f | sort -nr | head -1)
sudo gzip -t "$BACKUP"
```

## Verificación y recuperación

- Se ejecutó `sudo sh -c 'gzip -t /var/backups/moodle/ctcr_moodle_*.sql.gz'` comprobando código de salida 0 (éxito sin mensajes de error en stdout/stderr).
- Se ejecutó la prueba de integridad dentro del propio script `respaldo.sh` donde `$ARCHIVO` contiene la ruta resuelta directamente (`gzip -t "$ARCHIVO"`), confirmando que el script es totalmente autónomo y no depende de globbing no privilegiado.
- Ambas verificaciones quedaron documentadas en las evidencias `EV-097` y `EV-099`.

## Prevención y documentación asociada

- En los procedimientos operativos [10-04](../../docs/procedimientos/10-respaldos/10-04.md) y [10-06](../../docs/procedimientos/10-respaldos/10-06.md) se advierte expresamente sobre la necesidad de ejecutar comandos con comodines sobre directorios `0700` dentro de un subshell de root o empleando rutas resueltas.
- Se documenta en el estándar de scripts del proyecto la regla de evitar comodines no expandidos en variables de entorno compartidas entre comandos asíncronos.
