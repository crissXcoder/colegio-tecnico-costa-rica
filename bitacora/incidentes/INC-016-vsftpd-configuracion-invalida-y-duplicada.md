# INC-016 — vsftpd no reinicia: valor inválido y directivas duplicadas de otra práctica

- INC-ID: INC-016
- Fecha / VM / paso: durante el paso 9 (fecha exacta no registrada) / Ubuntu Server de la VM descrita en el anexo técnico del 31/10/2026 / Paso 9.5 (configurar vsftpd)
- Estado: resuelto. **Sin captura en el repositorio**; procedencia: anexo técnico del grupo, sección G.

## Síntoma y contexto

Al probar FTPS aparecieron dos errores del lado del cliente:

```text
curl: (64) Requested SSL level failed
openssl s_client ... wrong version number
```

Ambos indican que el servidor **no estaba hablando TLS**. Al revisar el servicio se encontró que vsftpd no había reiniciado con la nueva configuración:

```text
500 OOPS: bad bool value in config file for: xferlog_enable
```

Además, `/etc/vsftpd.conf` tenía directivas **repetidas y contradictorias** (`chroot_local_user`, `allow_writeable_chroot`, `local_root`); una de ellas apuntaba a `/var/www/html/examen`, de una práctica anterior en la misma VM.

## Impacto, severidad y riesgo

- Severidad: alta para el paso 9. Mientras vsftpd no reiniciaba, seguía corriendo (o quedaba caído) con la configuración vieja, sin FTPS.
- Riesgo de seguridad: una directiva `local_root` de otra práctica podía dejar a los usuarios en una carpeta ajena al proyecto.

## Diagnóstico con comandos y salida saneada

```bash
sudo systemctl status vsftpd --no-pager
sudo journalctl -u vsftpd -n 20 --no-pager
# Directivas repetidas: cualquier nombre que aparezca más de una vez
grep -E '^[a-z_]+=' /etc/vsftpd.conf | cut -d= -f1 | sort | uniq -d
grep -nE '^(chroot_local_user|allow_writeable_chroot|local_root|xferlog_enable)=' /etc/vsftpd.conf
```

- `bad bool value`: vsftpd solo acepta `YES` o `NO` en esas directivas. Un valor distinto (por ejemplo con un comentario o un espacio al final en la misma línea) hace fallar el arranque completo.
- Con directivas repetidas, vsftpd usa la última que lee: el resultado no es el que se cree al leer el archivo de arriba hacia abajo.

## Solución y por qué

1. Copia del archivo antes de editar: `sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak-$(date +%F)`.
2. Dejar `xferlog_enable` con un valor válido, `YES` o `NO`, sin texto adicional en la línea. (El anexo no registra cuál de los dos quedó; verificarlo con `grep xferlog_enable /etc/vsftpd.conf`.)
3. Eliminar las directivas duplicadas y conservar **solo** las del proyecto CTCR (`chroot_local_user=YES`, `allow_writeable_chroot=NO`, `user_sub_token=$USER`, `local_root=/srv/ftp/$USER`). Se quitó la ruta `/var/www/html/examen`.
4. `sudo systemctl restart vsftpd` y comprobar `is-active`.

## Verificación y recuperación

- Una carga FTPS de Marta llegó al 100 % (75 bytes) y el archivo existía en `/srv/ftp/marta.jimenez/archivos/` (anexo técnico).
- La prueba completa de TLSv1.3 y aislamiento está en el paso 9 (EV-071 a EV-074) de la VM #1.

## Prevención y documentación asociada

- Antes de reiniciar, buscar duplicados con el comando `uniq -d` de arriba.
- No reutilizar una VM con prácticas anteriores sin revisar sus archivos de `/etc` (ver [ADR-0004](../../docs/decisiones/ADR-0004-servidor-unico-de-demostracion.md)).
- Riesgo R-25 en [RIESGOS-Y-FALLOS-ANTICIPADOS](../../docs/operacion/RIESGOS-Y-FALLOS-ANTICIPADOS.md).
- Relacionados: [INC-009](INC-009-vsftpd-user-sub-token-omission-bug.md) y [INC-010](INC-010-vsftpd-writable-root-chroot-500.md).
