# INC-017 — `curl: (26)` al subir por FTPS un archivo que no existía

- INC-ID: INC-017
- Fecha / VM / paso: durante el paso 9 (fecha exacta no registrada) / Ubuntu Server de la VM descrita en el anexo técnico del 31/10/2026 / Paso 9.7 (probar un usuario FTP)
- Estado: resuelto. **Sin captura en el repositorio**; procedencia: anexo técnico del grupo, sección G.

## Síntoma y contexto

La prueba de carga FTPS de Marta terminó con:

```text
curl: (26) Failed to open/read local data from file/application
```

## Impacto, severidad y riesgo

Baja. No era un fallo del servidor FTP; el riesgo era diagnosticarlo como tal y cambiar `vsftpd.conf` sin necesidad.

## Diagnóstico con comandos y salida saneada

El código 26 de curl es un error de **lectura local**: curl no pudo abrir el archivo indicado en `--upload-file`. El archivo `/tmp/expediente-administrativo.txt` no existía en la máquina desde la que se ejecutó curl.

```bash
ls -l /tmp/expediente-administrativo.txt   # No such file or directory
```

## Solución y por qué

Crear el archivo de prueba antes de subirlo:

```bash
echo "Colegio Tecnico de Costa Rica - Expediente administrativo de Marta Jimenez" > /tmp/expediente-administrativo.txt
curl --ssl-reqd --insecure --user marta.jimenez --upload-file /tmp/expediente-administrativo.txt \
  ftp://192.168.50.1/archivos/expediente-administrativo.txt
```

`--user marta.jimenez` sin `:contraseña` hace que curl la pida por teclado, para no dejarla en el historial. `--insecure` solo se usa porque el certificado del laboratorio es autofirmado.

## Verificación y recuperación

Carga al 100 % (75 bytes) y archivo presente: `sudo ls -l /srv/ftp/marta.jimenez/archivos/`.

## Prevención y documentación asociada

- Leer el código de salida de curl antes de tocar el servidor: 26 es local; 64 es TLS; 67 es usuario o contraseña; 9 o 550 es permiso o ruta en el servidor.
- Procedimiento: [09-07](../../docs/procedimientos/09-ftps-vsftpd/09-07.md).
