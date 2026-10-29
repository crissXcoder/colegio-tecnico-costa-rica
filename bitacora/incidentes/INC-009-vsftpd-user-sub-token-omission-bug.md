# INC-009 — Omisión de Directiva user_sub_token en vsftpd y Fallo de Enjaulamiento Dinámico

- INC-ID: INC-009
- Fecha / VM / paso: 2026-10-28 20:28 CST / VM #1 Ubuntu Server / Paso 9 (FTPS vsftpd)
- Estado: resuelto y verificado

## Síntoma y contexto
La guía histórica inicial del proyecto proponía la siguiente directiva para enjaular a cada usuario en su propio directorio:
```text
local_root=/srv/ftp/$USER
```
Sin embargo, al omitir la directiva complementaria de expansión de variables, `vsftpd` interpreta la cadena `$USER` de forma literal, intentando enjaular a cualquier usuario que inicia sesión en la ruta `/srv/ftp/$USER` (con el signo de dólar incluido) en lugar de `/srv/ftp/marta.jimenez`, provocando error crítico `500 OOPS: cannot change directory:/srv/ftp/$USER`.

## Impacto, severidad y riesgo
- Severidad: Crítica (anula por completo la capacidad multiusuario y de enjaulamiento por funcionario).
- Riesgo: Si no se comprende la causa, los administradores suelen crear carpetas compartidas sin aislamiento o deshabilitar el enjaulamiento chroot (`chroot_local_user=NO`), exponiendo el sistema de archivos completo del servidor a cualquier cliente FTP.

## Diagnóstico con comandos y salida saneada
Al revisar la documentación de manual oficial de vsftpd (`man vsftpd.conf`):
> `user_sub_token`: This option is useful is conjunction with virtual users. It is used to automatically generate a home directory for each virtual user, based on a template. For eg, if local_root is set to `/home/virtual/$USER`, then when user `chris` logs in, he will be chroot'd to `/home/virtual/chris`.

Sin la directiva explícita `user_sub_token=$USER`, vsftpd desactiva por completo la sustitución de tokens y trata la variable como texto plano.

## Solución y por qué
Se configuró en `/etc/vsftpd.conf` la directiva obligatoria de sustitución de token antes de definir `local_root`:
```text
user_sub_token=$USER
local_root=/srv/ftp/$USER
```
Con esta directiva activa, cuando el usuario `marta.jimenez` se autentica, vsftpd reemplaza automáticamente `$USER` por `marta.jimenez`, ubicándola de forma transparente en `/srv/ftp/marta.jimenez`.

## Verificación y recuperación
1. Inspección de sesión FTPS mediante curl con modo verbose:
   ```text
   > USER marta.jimenez
   < 331 Please specify the password.
   > PASS ********
   < 230 Login successful.
   > PWD
   < 257 "/" is the current directory
   ```
2. Marta observa únicamente su carpeta de trabajo privada `/archivos` correspondiente a `/srv/ftp/marta.jimenez/archivos`, sin errores de directorio inexistente.

## Evidencia de resolución

### EV-072 — Enjaulamiento Dinámico y Transferencia Exitosa

![EV-072](../../docs/procedimientos/09-ftps-vsftpd/09-07/evidencias/EV-072.webp)

- **Ficha descriptiva:** [EV-072.md](../../docs/procedimientos/09-ftps-vsftpd/09-07/evidencias/EV-072.md)
- **Validación:** Comprueba la carga de archivos sin error de directorio y la ubicación transparente del usuario en su propia carpeta enjaulada.

## Prevención y documentación asociada
- Documentado en la sesión de trabajo [`bitacora/sesiones/2026-10-28-sesion-paso9-ftps-vsftpd.md`](../sesiones/2026-10-28-sesion-paso9-ftps-vsftpd.md) y en el procedimiento [`docs/procedimientos/09-ftps-vsftpd/09-05.md`](../../docs/procedimientos/09-ftps-vsftpd/09-05.md).
- Regla persistida: En vsftpd, siempre que se use `$USER` en `local_root`, debe precederlo `user_sub_token=$USER`.
