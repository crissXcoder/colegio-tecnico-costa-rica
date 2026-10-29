# INC-010 — Bloqueo de vsftpd por Raíz de Enjaulamiento con Permisos de Escritura

- INC-ID: INC-010
- Fecha / VM / paso: 2026-10-28 20:28 CST / VM #1 Ubuntu Server / Paso 9 (FTPS vsftpd)
- Estado: resuelto y verificado

## Síntoma y contexto
Al enjaular un usuario local mediante `chroot_local_user=YES`, si el directorio raíz del enjaulamiento (`/srv/ftp/<usuario>`) es propiedad del usuario y cuenta con permisos de escritura para él, `vsftpd` aborta la conexión inmediatamente tras la autenticación con el error:
```text
500 OOPS: vsftpd: refusing to run with writable root inside chroot
Login failed.
```

## Impacto, severidad y riesgo
- Severidad: Alta (inutiliza el inicio de sesión y la subida de archivos).
- Riesgo: Para "evadir" este error, muchas guías sugieren activar `allow_writeable_chroot=YES`, lo cual es desaconsejado formalmente por los mantenedores de seguridad de vsftpd debido a que introduce vulnerabilidades de escape de jaula (chroot jailbreak) en sistemas Linux.

## Diagnóstico con comandos y salida saneada
El demonio `vsftpd` desde la versión 2.3.5 implementa un control de seguridad estricto que prohíbe que la raíz del entorno chroot sea modificable por el usuario enjaulado. Si `/srv/ftp/marta.jimenez` pertenece a `marta.jimenez` con permisos `0755` o `0700`, el usuario tiene permisos de escritura en la raíz, disparando la excepción `500 OOPS`.

## Solución y por qué
Se implementó la arquitectura segura de directorios de dos niveles recomendada formalmente por vsftpd:
1. **Directorio Raíz Chroot:** `/srv/ftp/<usuario>/` configurado como propiedad exclusiva de `root:root` con permisos `0755` (`drwxr-xr-x`). El usuario solo tiene permisos de lectura/ejecución (navegación), por lo que vsftpd aprueba el chroot seguro.
2. **Subdirectorio Operativo Privado:** `/srv/ftp/<usuario>/archivos/` configurado como propiedad de `<usuario>:<usuario>` con permisos estrictos **`0700` (`drwx------`)**. Aquí el usuario tiene plenos permisos para crear, subir y eliminar sus documentos de trabajo sin tocar la raíz enjaulada.

Comandos aplicados:
```bash
for u in marta.jimenez carlos.mendez sofia.hernandez jose.ramirez valeria.sanchez diego.fernandez; do
  sudo mkdir -p "/srv/ftp/$u/archivos"
  sudo chown root:root "/srv/ftp/$u"
  sudo chmod 755 "/srv/ftp/$u"
  sudo chown "$u:$u" "/srv/ftp/$u/archivos"
  sudo chmod 700 "/srv/ftp/$u/archivos"
done
```

## Verificación y recuperación
1. Verificación de permisos con `ls -ld`:
   ```bash
   ls -ld /srv/ftp/marta.jimenez /srv/ftp/marta.jimenez/archivos
   drwxr-xr-x 3 root          root          4096 Oct 28 20:28 /srv/ftp/marta.jimenez
   drwx------ 2 marta.jimenez marta.jimenez 4096 Oct 28 20:30 /srv/ftp/marta.jimenez/archivos
   ```
2. Inicio de sesión y subida de archivos exitosa con `curl --ssl-reqd --insecure`:
   ```text
   > STOR expediente-administrativo.txt
   < 150 Ok to send data.
   < 226 Transfer complete.
   ```
3. Aislamiento POSIX verificado: otro usuario no puede acceder al subdirectorio debido a los permisos `0700`.

## Prevención y documentación asociada
- Documentado en `GEMINI.md` (Sección 10.2), `doc_paso9/INFORME_PASO9_FTPS_VSFTPD.md` y `EV09_01_ubuntu_cuentas_y_carpetas_privadas.md`.
- Regla persistida: Nunca usar `allow_writeable_chroot=YES`; mantener siempre la raíz chroot propiedad de `root:root` y carpetas de subida internas propiedad del usuario.
