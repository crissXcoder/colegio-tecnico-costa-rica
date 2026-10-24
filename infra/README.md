# Infraestructura versionada: de archivos Git a servicios operativos

`infra/` reúne **modelos editables de configuraciones reales**: no son transcripciones certificadas del contenido actual de `/etc` ni del Compose activo de un integrante. El fin es compartir decisiones en texto plano, revisar cambios por Pull Request y reproducirlos controladamente. El procedimiento que explica qué orden se debe seguir y qué capturar está en el [manual operativo](../docs/procedimientos/README.md).

## Qué servicio corresponde a cada subdirectorio

| Carpeta | Función, archivo crítico y comportamiento esperado | Cómo comprobar |
|---|---|---|
| [`compose/`](compose/README.md) | `compose.yaml` define Moodle+MariaDB, red y volúmenes. `.env.example` documenta nombres de variables; `.env.https.example` la transición segura a proxy. | `docker compose ... config --quiet`, `ps`, `images`, `volume ls`. |
| [`bind9/`](bind9/README.md) | `named.conf.options.fragment` restringe recursión/consultas; `named.conf.local.fragment` declara zona; `db.ctcr` traduce dominio a IP interna. | `named-checkconf`, `named-checkzone`, `dig`. |
| [`nginx/`](nginx/README.md) | `moodle.conf.example` escucha 80/443, certifica dominio local y reenvía a 127.0.0.1:8080. | `nginx -t`, SAN del certificado, `curl -I`. |
| [`vsftpd/`](vsftpd/README.md) | `vsftpd.conf.example` asegura FTPS, chroot y directorios separados por cuenta. | login FTPS, subida y acceso cruzado denegado. |
| [`cron/`](cron/README.md) | `moodle-backup.cron.example` invoca `scripts/backup-db.sh` en horario y escribe log. | `crontab -l`, dump creado y restauración de ensayo. |

## Contrato de cambio seguro

1. Inventariar **máquina objetivo**, archivo activo, servicio, puerto ocupado y datos persistentes, por ejemplo `sudo ss -lntup` o `sudo docker compose ls`.
2. Hacer copia de seguridad del archivo **del host** que será modificado y de los datos antes de recrear servicios. Nunca editar desde Git sin saber si el host ya tenía cambios de otras prácticas.
3. Comparar diferencias con `diff -u <archivo-vigente> <candidato>`; registrar en la bitácora qué parámetros se adaptaron (IP, nombre de red, directorios), sin copiar secretos al PR.
4. Validar la sintaxis **antes** de recargar y después ejecutar prueba positiva/negativa apropiada. Un `nginx -t` correcto prueba sintaxis, no una sesión Moodle.
5. Asociar captura y ficha de evidencia con el subpaso aplicable. Actualizar la matriz solo con resultado realmente observado.

**Regla sobre datos:** Git protege la receta y su historial; los volúmenes Docker, `.env`, backups SQL, claves TLS privadas y sesiones reales se guardan fuera de Git y requieren un sistema de copias adicional.
