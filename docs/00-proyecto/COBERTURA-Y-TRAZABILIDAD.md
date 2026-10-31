# Trazabilidad: requisito → archivo entregado → comando → evidencia

**Corte:** 31/10/2026. Sirve para responder «¿dónde está eso?» durante la revisión del profesor y las preguntas. Los requisitos y su estado oficial están en la [matriz de requisitos](matriz-requisitos.md); los archivos entregados, en el paquete que se arma con [PAQUETE-ENTREGA](../entrega/PAQUETE-ENTREGA.md).

Las evidencias son de la VM #1 salvo que se indique otra cosa. «Paquete» = archivo dentro de `entrega-ctcr/`.

| Requisito | Archivo entregado (paquete) | Comando para demostrarlo | Evidencia | Procedimiento |
|---|---|---|---|---|
| RC-01 Zona DNS propia | `configuraciones/bind/named.conf.local`, `named.conf.options`, `db.ctcr` | `sudo named-checkzone ctcr /etc/bind/db.ctcr`; desde Mint `dig @192.168.50.1 aulavirtual.ctcr +short` | EV-063..EV-066, EV-103 | [07](../procedimientos/07-dns-bind9/README.md) |
| RC-02 HTTPS con dominio y certificado propio | `configuraciones/nginx/aulavirtual.ctcr.conf`, `sites-enabled.txt` | `sudo nginx -t`; desde Mint `curl -vk https://aulavirtual.ctcr`; `curl -I http://aulavirtual.ctcr` (301) | EV-067..EV-070, EV-103 | [08](../procedimientos/08-https-nginx/README.md) |
| RC-03 Moodle + base de datos en Docker, versiones fijas, volúmenes | `docker-compose.yml`, `.env.example`, `versiones.txt` | `sudo docker compose ps`; `sudo docker images --digests`; `sudo docker volume ls`; `sudo docker compose restart` | EV-007..EV-015, EV-100, EV-106 | [04](../procedimientos/04-contenedores/README.md), [05](../procedimientos/05-cliente-mint/README.md) |
| RC-04 FTP por usuario con aislamiento | `configuraciones/vsftpd/vsftpd.conf` | `sudo ls -ld /srv/ftp/*/archivos`; `curl --ssl-reqd --insecure -u marta.jimenez "ftp://192.168.50.1/../carlos.mendez/archivos/"` (550) | EV-071..EV-074, EV-106 | [09](../procedimientos/09-ftps-vsftpd/README.md) |
| RC-05 Respaldo con Cron y restauración | `crontab.txt`, `scripts/respaldo.sh`, `scripts/restauracion-prueba.sh`, `evidencia/restauracion_<fecha>.log` | `sudo crontab -l`; `sudo ls -lh /var/backups/moodle`; `sudo ./restauracion-prueba.sh` | EV-096..EV-099, EV-106; **log del script: pendiente (P-02)** | [10](../procedimientos/10-respaldos/README.md) |
| RC-06 Documentación reproducible | `documentacion/`, `LEEME.txt`, `hashes.txt` | `sha256sum -c hashes.txt`; `sudo ./verificar-servicios.sh <proyecto> <paquete>` | Este repositorio; **reproducción cruzada pendiente (P-13)** | [12](../procedimientos/12-entrega/README.md) |
| RE-01 Tres cursos reales, 2 recursos + 1 actividad | — (vive en la base de datos) | Navegador: «Mis cursos» y cada curso | EV-053..EV-055, EV-075 | [06-03](../procedimientos/06-moodle/06-03.md), [06-04](../procedimientos/06-moodle/06-04.md) |
| RE-02 Grupos con acceso exclusivo | — | Participantes → Métodos de matriculación de cada curso | EV-057, EV-085..EV-089, EV-104 | [06-06](../procedimientos/06-moodle/06-06.md), [06-07](../procedimientos/06-moodle/06-07.md) |
| RE-03 Acceso ajeno denegado | `evidencia/` (capturas seleccionadas) | Como `marta.jimenez`: URL del curso y del PDF de Informática | EV-060, EV-092..EV-095, EV-104 | [06-08](../procedimientos/06-moodle/06-08.md), [11-06](../procedimientos/11-verificacion/11-06.md) |
| RX-01 Profesor sin privilegios de administrador | — | Como `daniel.vargas`: calificador de su curso y `/admin/` denegado | EV-062, EV-092, EV-105 | [06-08](../procedimientos/06-moodle/06-08.md) |
| Firewall (si se usa) | `ufw.txt`, `firewall-iptables.txt` | `sudo iptables -S`; `command -v ufw` | EV-102; [ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md) | [11-04](../procedimientos/11-verificacion/11-04.md) |
| RA-01 Justificación de software libre | `documentacion/` | — | [comparativa-software.md](../entrega/comparativa-software.md) (fuentes pendientes, P-05) | — |
| RA-02 Demostración y defensa | — | [GUIA-DEMO](../entrega/GUIA-DEMO.md) | Ensayo pendiente (P-07) | — |

**Qué no prueba una captura:** que la misma configuración exista en las cinco VMs. Lo verificado es local a la VM #1 hasta que otra persona lo reproduzca.
