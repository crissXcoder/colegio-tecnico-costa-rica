# Matriz Integral de QA y Pruebas de Aceptación Final — Proyecto Final EIF431O

Esta matriz consolida la ejecución y los resultados comprobados de los **diez criterios de aceptación críticos (`T-01` a `T-10`)** definidos en [`pruebas/README.md`](README.md) para la infraestructura del Colegio Técnico de Costa Rica (Moodle LMS sobre Docker Compose, BIND9, Nginx HTTPS Reverse Proxy, vsftpd con FTPS y respaldos Cron con DRP).

---

## 1. Resumen Ejecutivo de QA

- **Fecha de corte de auditoría:** 2026-10-30
- **Entorno evaluado:**
  - VM #1: Ubuntu Server 26.04 LTS (`192.168.50.1`, `server`)
  - VM #2: Linux Mint 22.3 (`192.168.50.101`, `criss-VirtualBox`)
- **Total de pruebas críticas evaluadas:** 10
- **Total aprobadas (PASS):** **10 / 10 (100%)**
- **Total fallidas (FAIL):** 0
- **Total evidencias transversales asociadas:** `EV-001` a `EV-106`

---

## 2. Matriz Detallada de Pruebas de Aceptación (T-01 a T-10)

| ID | Criterio de Aceptación | Comando / Procedimiento de Validación | Resultado Observado | Estado | Evidencias Clave |
|---|---|---|---|---|---|
| **T-01** | Dos contenedores operativos y base de datos saludable | `cd ~/proyecto-moodle && sudo docker compose ps`<br>`sudo docker compose exec moodle php -r 'define("CLI_SCRIPT", true); require "/var/www/moodle/config.php"; echo $CFG->wwwroot;'` | Ambos contenedores (`oksigenia/moodle:4.5.15` y `mariadb:11.4.13`) en estado `Up (healthy)`. URL canónica devuelve exactamente `https://aulavirtual.ctcr`. MariaDB contiene 494 tablas de Moodle 4.5. | **PASS** | [`EV-100`](../docs/procedimientos/11-verificacion/11-01/evidencias/EV-100.md), [`EV-010`](../docs/procedimientos/04-contenedores/04-07/evidencias/EV-010.md) |
| **T-02** | Persistencia real de volúmenes tras recreación/reinicio | `sudo docker compose restart`<br>Consulta en base de datos de usuarios y cursos tras reinicio de contenedores | Cursos (`CTCR-ADM-101`, `CTCR-DOC-101`, `CTCR-INF-101`), cohortes y 12 cuentas intactas tras ciclo de parada y reinicio sin alteración de IDs ni borrado de datos. | **PASS** | [`EV-106`](../docs/procedimientos/11-verificacion/11-07/evidencias/EV-106.md), [`EV-018`](../docs/procedimientos/05-cliente-mint/05-03/evidencias/EV-018.md) |
| **T-03** | Tres cursos completos con 2 recursos auténticos y 1 cuestionario | Recorrido funcional de los cursos en Moodle y resolución de cuestionarios con 5 preguntas ponderadas | 3 cursos departamentales estructurados con documentos institucionales oficiales en PDF y cuestionarios de 5 preguntas evaluados con calificación perfecta de 100/100 para Sofía Hernández y Valeria Sánchez. | **PASS** | [`EV-105`](../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.md), [`EV-051`](../docs/procedimientos/06-moodle/06-01/evidencias/EV-051.md) a [`EV-055`](../docs/procedimientos/06-moodle/06-04/evidencias/EV-055.md) |
| **T-04** | Aislamiento departamental estricto y denegación de accesos cruzados | Solicitud autenticada de `marta.jimenez` (Administración) hacia curso ajeno de Informática (`/course/view.php?id=4`) y recursos directos (`/mod/resource/view.php?id=...`) | Acceso terminantemente rechazado por Moodle con código de redirección `HTTP 303 See Other` hacia aviso de error por ausencia de matrícula. Sin fuga de contenidos ni permisos cruzados. | **PASS** | [`EV-104`](../docs/procedimientos/11-verificacion/11-06/evidencias/EV-104.md), [`EV-060`](../docs/procedimientos/06-moodle/06-08/evidencias/EV-060.md), [`EV-092`](../docs/procedimientos/06-moodle/06-08/evidencias/EV-092.md) |
| **T-05** | Rol profesor docente funcional y restringido | Inicio de sesión con `daniel.vargas`, acceso a libro de calificaciones de Informática e intento de apertura de `/admin/index.php` | El profesor gestiona su curso, evalúa a estudiantes y revisa calificaciones (100.00 de Valeria Sánchez); el acceso a herramientas administrativas globales de Moodle permanece vedado. | **PASS** | [`EV-105`](../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.md), [`EV-062`](../docs/procedimientos/06-moodle/06-08/evidencias/EV-062.md) |
| **T-06** | Resolución de nombres autoritativa BIND9 | Desde Linux Mint (`192.168.50.101`):<br>`dig @192.168.50.1 aulavirtual.ctcr A +short`<br>`getent ahostsv4 aulavirtual.ctcr` | BIND 9.20.24 resuelve de forma autoritativa `aulavirtual.ctcr` devolviendo la IP `192.168.50.1` sin retraso ni pérdida de paquetes. | **PASS** | [`EV-103`](../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.md), [`EV-063`](../docs/procedimientos/07-dns-bind9/07-05/evidencias/EV-063.md), [`EV-066`](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-066.md) |
| **T-07** | Publicación segura Nginx HTTPS y redirección 301 | Desde Linux Mint y Ubuntu Server:<br>`curl -k -I http://aulavirtual.ctcr`<br>`curl -k -I https://aulavirtual.ctcr` | Redirección forzosa inmediata `HTTP/1.1 301 Moved Permanently` hacia HTTPS. Conexión segura TLSv1.3 con certificado con SAN institucional respondiendo `HTTP/1.1 200 OK`. | **PASS** | [`EV-103`](../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.md), [`EV-067`](../docs/procedimientos/08-https-nginx/08-04/evidencias/EV-067.md), [`EV-070`](../docs/procedimientos/08-https-nginx/08-07/evidencias/EV-070.md) |
| **T-08** | Aislamiento FTPS con enjaulamiento chroot seguro | Conexión FTPS explícita TLSv1.3 con `carlos.mendez` e intento de cambio de directorio hacia `/etc` o `/srv/ftp/sofia.hernandez` | Confinamiento chroot estricto en `/srv/ftp/carlos.mendez/archivos` (`0700`). El servidor vsftpd 3.0.5 deniega el escape con error `550 Failed to change directory`. | **PASS** | [`EV-106`](../docs/procedimientos/11-verificacion/11-07/evidencias/EV-106.md), [`EV-071`](../docs/procedimientos/09-ftps-vsftpd/09-03/evidencias/EV-071.md) a [`EV-074`](../docs/procedimientos/09-ftps-vsftpd/09-08/evidencias/EV-074.md) |
| **T-09** | Respaldos periódicos Cron y prueba DRP en base aislada | Inspección de crontab de root (`0 2 * * *`), archivo gzip en `/var/backups/moodle/` e importación en `moodle_restore_test` | Tarea programada activa a las 02:00 AM CST. Volcado SQL comprimido íntegro. Restauración en esquema aislado recuperando con éxito las **494 tablas** de Moodle (100% de coincidencia estructural). | **PASS** | [`EV-106`](../docs/procedimientos/11-verificacion/11-07/evidencias/EV-106.md), [`EV-096`](../docs/procedimientos/10-respaldos/10-02/evidencias/EV-096.md) a [`EV-099`](../docs/procedimientos/10-respaldos/10-06/evidencias/EV-099.md) |
| **T-10** | Reproducción cruzada e interconectividad multi-VM | Ejecución de pruebas de conectividad de red, DNS, HTTP, HTTPS y FTPS desde Linux Mint hacia Ubuntu Server | Ping bidireccional con 0% de pérdida, resolución autoritativa remota, navegación web sin colisiones y pruebas de no regresión superadas íntegramente. | **PASS** | [`EV-103`](../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.md), [`EV-066`](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-066.md), [`EV-070`](../docs/procedimientos/08-https-nginx/08-07/evidencias/EV-070.md) |

---

## 3. Trazabilidad de Evidencias Transversales de Verificación

Las evidencias directas generadas durante la etapa de QA y Verificación Final se vinculan de la siguiente manera:

- [`EV-100`](../docs/procedimientos/11-verificacion/11-01/evidencias/EV-100.md): Estado saludable de contenedores Docker y comprobación PHP CLI de URL canónica `https://aulavirtual.ctcr`.
- [`EV-101`](../docs/procedimientos/11-verificacion/11-03/evidencias/EV-101.md): Mapeo de sockets y puertos del sistema (21, 53, 80, 443; 8080 en loopback; 3306 aislado en red Docker).
- [`EV-102`](../docs/procedimientos/11-verificacion/11-04/evidencias/EV-102.md): Auditoría de reglas de filtrado y enmascaramiento NAT de `iptables` sin interferencia de `ufw`.
- [`EV-103`](../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.md): Pruebas remotas desde Linux Mint (ping 0% pérdida, resolución de dominio, redirección 301 y respuesta HTTPS 200 OK).
- [`EV-104`](../docs/procedimientos/11-verificacion/11-06/evidencias/EV-104.md): Pruebas departamentales: acceso legítimo de Marta Jiménez a Administración vs rechazo inmediato (303) al intentar acceder a Informática.
- [`EV-105`](../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.md): Cuestionarios evaluados con calificación perfecta (100/100) e inspección docente de calificaciones por Daniel Vargas.
- [`EV-106`](../docs/procedimientos/11-verificacion/11-07/evidencias/EV-106.md): Resiliencia de infraestructura: reinicio sin pérdida de datos, denegación enjaulada en FTPS (error 550) y restauración DRP con 494 tablas.
