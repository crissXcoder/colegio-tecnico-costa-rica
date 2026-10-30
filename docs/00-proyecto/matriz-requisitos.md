# Matriz de trazabilidad: enunciado -> fase -> prueba -> evidencia

| ID | Requisito oficial | Fase | Prueba de aceptación | Estado |
| --- | --- | --- | --- | --- |
| RC-01 | Zona propia BIND9 | 05-dns | `dig @192.168.50.1 aulavirtual.ctcr A +short` desde Mint | CUMPLE (verificado local EV-063..EV-066) |
| RC-02 | VirtualHost/HTTPS dominio | 06-https | GET HTTPS y TLS SAN correctos | CUMPLE (verificado local EV-067..EV-070) |
| RC-03 | Moodle+DB Docker, volumen, versiones fijas | 02-contenedores | `compose ps`, digest y persistencia tras recrear | Evidencia parcial |
| RC-04 | FTP usuario por integrante/rol, aislamiento | 07-ftp | 6 cuentas por funcionario; leer/sobrescribir/borrar ajeno rechazado (FTPS y `sudo -u` en Ubuntu) | CUMPLE (verificado local EV-071..EV-074) |
| RC-05 | Respaldo Cron y restauración | 08-respaldos | dump y restauración verificadas | Pendiente |
| RC-06 | Documentación reproducible | todas + entrega | tercero reproduce sin asistencia | En proceso |
| RE-01 | Tres cursos reales, 2 recursos + 1 actividad cada uno | 03-moodle | inventario de 9 elementos mínimos y pruebas | CUMPLE (verificado local; documentos reales oficiales incorporados en documentos-cursos/ y Moodle) |
| RE-02 | Tres grupos/cohortes con acceso exclusivo | 04-autorizacion | matriz de accesos por usuario | Evidencia parcial (cohortes y participantes de los 3 cursos EV-057, EV-085..EV-089; INC-011 corregido; matriz 3×3 incompleta) |
| RE-03 | Prueba de denegación de recurso ajeno | 04-autorizacion | 4 URL por celda "Denegado" (curso, PDF `pluginfile.php`, Página, Cuestionario) sin botón de matrícula; ver [DATOS-MAESTROS §7](DATOS-MAESTROS.md) | Evidencia parcial (curso ajeno EV-060, EV-092; PDF ajeno por `pluginfile.php` EV-093, EV-095; faltan Página, Cuestionario y resto de celdas) |
| RX-01 | Rol no superusuario funcional | 04-autorizacion | `daniel.vargas`/`andrea.castillo`/`laura.rodriguez` gestionan solo su curso y no abren `/admin/` | Evidencia parcial (profesor ve calificaciones EV-062; profesora denegada en otro curso EV-092; falta `/admin/`) |
| RA-01 | Justificación libre y alternativas | entrega | comparativa y conclusión | Pendiente |
| RA-02 | Demo y defensa del diseño | 09-presentacion | presentación funcional y ensayo | Pendiente |

Actualización: introducir vínculo a `evidencias/manifiesto.csv`, ID de prueba y revisión cuando exista evidencia, no antes.
