# Infraestructura como configuración revisable

- `compose/`: **configuración objetivo propuesta**, NO copia textual exacta del compose actualmente desplegado.
- `bind9/`: fragmentos de zona DNS. No sobrescribir a ciegas `named.conf.options`/`named.conf.local`.
- `nginx/`: VirtualHost local y TLS de laboratorio. La clave no va a Git.
- `vsftpd/`: plantilla FTPS para revisión y prueba, no instalación automática.
- `cron/`: ejemplo de programación; sustituir ruta del repo según VM.

Antes de aplicar cualquier configuración guardar archivo vigente, comparar cambios (`diff -u`), comprobar puertos, credenciales, permisos, rollback y ejecutar las pruebas estáticas de cada servicio.
