# QA funcional y de infraestructura — manual de operación

**Bloque:** `11-verificacion` · **Capturas integradas y verificadas:** 7 (`EV-100` a `EV-106`) · **Estado:** Verificación completa de aceptación transversal ejecutada en las dos máquinas virtuales del laboratorio.

## Por qué existe este bloque

Todos los servicios deben funcionar como un sistema integrado, no simplemente emitir el estado “active”: la prueba central del escenario institucional del **Colegio Técnico de Costa Rica (CTCR)** es garantizar el aislamiento estricto y la denegación de acceso a cursos o recursos didácticos de otros departamentos técnicos.

Este bloque proporciona la **secuencia operativa de aseguramiento de calidad (QA)**, vinculando la configuración de red, DNS, proxy reverso TLS, servicios de transferencia FTPS, políticas de firewall, resiliencia de contenedores, evaluaciones formativas y el plan de recuperación ante desastres (DRP). Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

1. **En una VM nueva:** reunir los prerrequisitos, ejecutar cada subpaso en orden estricto y registrar los resultados observados antes de avanzar.
2. **En una VM ya configurada:** realizar el inventario preliminar primero, comparar el estado activo con los comandos de comprobación y omitir reinicios destructivos; nunca alterar volúmenes o bases de producción durante las pruebas de recuperación.
3. **Rol de auditoría:** Las pruebas de acceso y denegación deben ejecutarse obligatoriamente con cuentas de estudiantes y profesores de cada departamento (`marta.jimenez`, `sofia.hernandez`, `valeria.sanchez`, `daniel.vargas`), dado que el superusuario administrador de Moodle siempre posee visibilidad global y distorsionaría las pruebas de aislamiento.

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [11-01: Comprobar los contenedores](11-01.md) | Inspección de salud en Docker Compose (`ps`) y extracción CLI de `$CFG->wwwroot` confirmando `https://aulavirtual.ctcr`. | [EV-100](11-01/evidencias/EV-100.md) |
| [11-02: Comprobar los servicios de Ubuntu](11-02.md) | Comprobación de estado `active` en `named`, `nginx`, `vsftpd` y `cron` sin unidades degradadas. | Verificada en [11-03](11-03.md) ([EV-101](11-03/evidencias/EV-101.md)) |
| [11-03: Comprobar los puertos](11-03.md) | Auditoría de sockets con `ss -lntup` (21, 53, 80, 443 en LAN; 8080 en loopback; MariaDB aislado en red interna). | [EV-101](11-03/evidencias/EV-101.md) |
| [11-04: Configurar y verificar el firewall](11-04.md) | Auditoría de `iptables` con cadenas `DOCKER-USER`, reenvío LAN-WAN y persistencia en `/etc/iptables/rules.v4`. | [EV-102](11-04/evidencias/EV-102.md) |
| [11-05: Pruebas desde Linux Mint](11-05.md) | Conectividad ICMP al 0% de pérdida, resolución DNS de `aulavirtual.ctcr` a `192.168.50.1` y redirección 301 a HTTPS. | [EV-103](11-05/evidencias/EV-103.md) |
| [11-06: Pruebas de los departamentos](11-06.md) | Aislamiento departamental con rechazo a URL ajena (`303`), cuestionarios completados (100 pts) y calificador docente. | [EV-104](11-06/evidencias/EV-104.md), [EV-105](11-06/evidencias/EV-105.md) |
| [11-07: Pruebas de infraestructura](11-07.md) | Persistencia tras reinicio de contenedores, jaula FTPS con error `550`, y ensayo DRP con 494 tablas recuperadas. | [EV-106](11-07/evidencias/EV-106.md) |

Cada guía incluye el procedimiento detallado, comandos exactos, salidas reales observadas, advertencias operativas, resolución de incidentes (como `CLI_SCRIPT` o comodines en subshells), imágenes optimizadas en formato WebP ubicadas en sus respectivas subcarpetas y fichas de trazabilidad criptográfica con hashes SHA-256.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. El procedimiento del paso explica dónde verificar la sintaxis y reiniciar el servicio de forma controlada.

## Criterio de cierre del bloque

Inventario de contenedores, puertos, servicios de sistema, firewall, DNS autoritativo, redirección HTTPS, jaula FTPS, aislamiento departamental y ciclo de recuperación ante desastres con resultados cuantitativos observados. Registrar fecha, VM, ejecutor, revisor y los identificadores de evidencia (`EV-100` a `EV-106`) en la [bitácora](../../../bitacora/README.md).

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM, firewall o cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), registrar el error en la bitácora, documentar la causa raíz y aplicar la solución validada antes de dar por cerrada la prueba.
