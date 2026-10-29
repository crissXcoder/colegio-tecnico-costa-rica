# vsftpd: transferencia FTPS con aislamiento real

`vsftpd.conf.example` es una configuración de referencia para una práctica donde cada usuario puede modificar su directorio `archivos/`, pero no ver ni alterar archivos de los demás. No es SFTP (que utiliza SSH): aquí se usa **FTPS explícito** con TLS sobre el servicio FTP y sus puertos pasivos.

## Campos críticos del archivo

- `anonymous_enable=NO`, `local_enable=YES`, `userlist_*`: restringen identidades autenticadas a una lista explícita.
- `chroot_local_user=YES` y `allow_writeable_chroot=NO`: confinan la sesión; la raíz de cada cuenta se crea propiedad de `root`, mientras `archivos/` es la carpeta escribible del usuario.
- `user_sub_token=$USER` y `local_root=/srv/ftp/$USER`: **pareja necesaria** para sustituir la ruta por cuenta; faltaba el primer parámetro en la guía de chat histórica.
- `pasv_min_port=40000`/`pasv_max_port=40010`: rango de transferencias pasivas que el firewall del laboratorio debe permitir desde la red interna.
- `ssl_enable=YES` y `force_local_*_ssl=YES`: protegen sesión y datos por TLS. Certificado/ruta deben existir, normalmente generados en etapa Nginx.

## Protocolo de ejecución

Comparar con `/etc/vsftpd.conf` real y guardar copia. Crear cuentas **únicamente si no existen**, bloquear shell de acceso interactivo, preparar `/srv/ftp/<usuario>/archivos`, permisos y lista blanca. Revisar compatibilidad PAM de `/usr/sbin/nologin` con el sistema; probar con una cuenta antes de crear las cinco. El [manual 09](../../docs/procedimientos/09-ftps-vsftpd/README.md) contiene comandos de creación y pruebas curl sin incrustar contraseñas.

**Prueba de aceptación:** usuario A sube y lee archivo propio; usuario B no puede descargar, sobrescribir ni borrar el archivo ajeno, incluso si intenta ruta traversal. Registrar salida exacta del rechazo, no solo permisos `ls -l`.

**Estado verificado localmente:** fase 09 comprobada con 6 cuentas departamentales con shell restrictiva `/usr/sbin/nologin`, enjaulamiento chroot en `/srv/ftp/$USER/archivos` (`0700`), FTPS forzado con TLSv1.3, subida legítima de archivos y bloqueo estricto ante intentos de escape chroot con error `550 Failed to change directory`, respaldada por las evidencias `EV-071`, `EV-072`, `EV-073` y `EV-074`.
