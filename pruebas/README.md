# Pruebas de aceptación y verificación cruzada

| ID | Prueba | Resultado esperado | Prueba real | Estado |
| --- | --- | --- | --- | --- |
| T-01 | Contenedores y DB | Moodle + DB sanos y SQL operativo | `docker compose ps`, consulta | Parcial |
| T-02 | Persistencia | cursos y archivos persisten tras recrear | comparar antes/después | Pendiente verificación integral |
| T-03 | 3 cursos reales | cada uno 2 recursos y 1 quiz evaluable | revisar UI y registrar inventario | Parcial |
| T-04 | Aislamiento de recursos | usuario de otro depto rechazado por URL | entrar como alumno B con URL de A | Pendiente |
| T-05 | Rol profesor limitado | profesor edita su curso pero no administracion global | pruebas positiva/negativa | Pendiente |
| T-06 | DNS BIND9 | dominio devuelve servidor | `dig` desde Mint | Pendiente |
| T-07 | HTTPS | CN/SAN correcto, sitio carga por dominio | `openssl s_client`, navegador | Pendiente |
| T-08 | FTPS | A no puede leer/borrar/modificar de B | dos cuentas reales | Pendiente |
| T-09 | Backup y restauración | datos recuperados sin tocar base activa | dump, restore en DB distinta | Pendiente |
| T-10 | Reproducción cruzada | otra persona ejecuta guía | registro de resultado | Pendiente |

Usar `plantillas/prueba.md` para cada caso. Capturar salida **observada** y enlaces al manifiesto, no solo el resultado esperado. Una pantalla de «cursos disponibles» no demuestra autorización.
