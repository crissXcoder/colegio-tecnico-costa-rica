# ADR-0004 — Un único servidor para la entrega y la demostración

- ADR-ID: ADR-0004
- Estado: **propuesta**. El grupo debe confirmarla antes del ensayo del 06/11/2026.
- Fecha / Autores / Revisores: 2026-10-31 / redactada al contrastar el repositorio con el anexo técnico del 31/10 / revisión pendiente.

## Contexto y problema

El profesor revisa los archivos entregados y en la demo comprueba que **lo que corre en el servidor es lo mismo que se entregó** (`hashes.txt`). Cada integrante trabajó en su propia VM, y el repositorio documenta al menos dos servidores que **no son iguales**:

Las dos se llaman `server`; se distinguen por el usuario del prompt (riesgo R-43). La VM `server@server` es la del anexo técnico y la del documento del grupo de 54 páginas (EV-107 a EV-130, del 31/10).

| Aspecto | VM #1, `criss@server` (EV-063..EV-106) | VM `server@server` (anexo y EV-107..EV-130) |
|---|---|---|
| Carpeta del proyecto | `/home/criss/proyecto-moodle` | **Dos**: `/root/proyecto-moodle` y `/home/server/proyecto-moodle`, con el mismo nombre de proyecto Compose (R-41) |
| DNS BIND9 | Zona `ctcr` verificada | Zona `ctcr` verificada (EV-111..EV-114), junto a tres zonas de otras prácticas (EV-110) |
| Nginx | `1.28.3-2ubuntu1.12` | `1.28.3-2ubuntu1.11` instalado desde `.deb` (INC-003, EV-115) |
| Cuentas FTP | `marta.jimenez` (con punto, como DATOS-MAESTROS) | `marta_jimenez` (con guion bajo, EV-124; P-17) |
| Aislamiento FTP | Por FTPS y sistema de archivos (EV-072, EV-073) | Solo sistema de archivos con `sudo -u` (EV-129) |
| Firewall | iptables, UFW no instalado (EV-102) | UFW reinstalado e **inactivo** con 7 reglas (INC-018, EV-130) |
| Otros servicios | No documentados | MariaDB del host `0.0.0.0:3306`, PostgreSQL `0.0.0.0:5432`, contenedores `lab5-web-1` (`localhost:8081`) y `lab5-db-1` (`mariadb:11.8`) |
| Cron de respaldo y restauración | Verificado (EV-096..EV-099) | **Sin evidencia**: el documento del grupo tiene el título «Paso 10» vacío |
| Aislamiento Moodle | Verificado (EV-104, EV-105) | Verificado en el documento del grupo (EV-092..EV-095, págs. 30–32) |

## Opciones y criterios

- **A. VM #1** como servidor de entrega y demo: es la que tiene la batería completa de evidencias (pasos 7 a 11).
- **B. Otra VM**: obliga a repetir y documentar en ella el paso 10 (respaldo y restauración) y la verificación del paso 11, y a revisar sus servicios ajenos.

Criterio principal: que la VM elegida tenga **evidencia propia** de cada requisito y que el paquete se arme desde ella.

## Decisión y justificación

**Propuesta: opción A, la VM #1.** Es la única con evidencia de todos los requisitos. Si el grupo elige la VM `server@server`, antes de armar el paquete hay que: hacer y documentar el paso 10 completo, probar el aislamiento FTPS por el protocolo, resolver cuál de las dos carpetas de proyecto vale (R-41) y ajustar los nombres FTP en las guías (P-17). Las demás VMs sirven para la reproducción cruzada (otra persona sigue las guías), pero no para la demo.

Requisito práctico: la computadora anfitriona de la VM #1 debe estar disponible el 07/11 y alguien más del grupo debe haber practicado con ella (contraseña `sudo`, ruta del proyecto, cuentas de prueba).

## Consecuencias, riesgos y trade-offs

- El paquete se arma **solo** en la VM elegida ([PAQUETE-ENTREGA](../entrega/PAQUETE-ENTREGA.md)).
- Las rutas de los documentos de entrega deben usar la carpeta real de esa VM.
- Si el día de la demo se usa otra VM, los hashes no van a coincidir: decirlo y explicar por qué es preferible a fingir.
- Los servicios ajenos de otras VMs (`lab5`, bases de datos del host) no se detienen ni borran sin saber a qué práctica pertenecen.

## Evidencias para validar y plan de reversión

- Antes del ensayo: correr `scripts/verificar-servicios.sh` en la VM elegida y guardar la salida con fecha.
- Si la VM elegida falla de forma irrecuperable antes de la entrega: elegir otra, repetir en ella los pasos 10 y 11 con evidencia y volver a armar el paquete. Registrar el cambio aquí.
