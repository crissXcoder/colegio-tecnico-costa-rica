# vsftpd/FTPS — plantilla a probar

El requisito exige una cuenta por persona o rol y denegación de modificación/borrado ajenos. Este ejemplo incluye `user_sub_token=$USER`, necesario para interpolar `$USER` en `local_root`.

- `/srv/ftp/<usuario>`: propiedad root, no escribible por el usuario FTP.
- `/srv/ftp/<usuario>/archivos`: propiedad del usuario, 700.
- `chroot_local_user=YES` y FTPS explícito con TLS.
- `pam_service_name=vsftpd` y validación de shell no interactivo requieren revisión del PAM real de la distro. **No editar `/etc/shells` indiscriminadamente**.
- Verificar passive ports 40000-40010 y `listen_address` en UFW, NAT local y cliente.
- Certificado de FTPS debe identificar el nombre del servidor que emplea el cliente; no conectarse por IP y suponer que coincide con SAN.
- Documentar pruebas de lectura, escritura, borrado, salto de directorio y usuario no autorizado.
