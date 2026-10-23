# DNS local con BIND9

Archivos de ejemplo separados de la configuración del host: `named.conf.local.fragment`, `named.conf.options.fragment`, `db.colegio.test`. Confirmar interfaces `192.168.50.1`, coexistencia con `systemd-resolved` y ausencia de conflictos en puerto 53 antes de aplicar.

No sobrescribir opciones existentes: integrar fragmentos, validar `sudo named-checkconf`, `sudo named-checkzone colegio.test ...`, reiniciar/reload cuando corresponda, comprobar `dig @192.168.50.1 moodle.colegio.test A +short` desde Mint. La IP de otros integrantes puede cambiar.
