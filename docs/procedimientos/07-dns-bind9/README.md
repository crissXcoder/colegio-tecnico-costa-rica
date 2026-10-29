# DNS privado BIND9 — manual de operación

**Bloque:** `07-dns-bind9` · **Capturas históricas integradas:** 4 · **Estado:** verificado localmente (VM #1 Server + VM #2 Mint).

## Por qué existe este bloque

La zona `ctcr` publica `aulavirtual.ctcr -> 192.168.50.1`. Mint enviará consultas al DNS del servidor, exclusivamente por la red interna.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** El servicio DNS del host puede coexistir con `systemd-resolved`; no reemplazar opciones sin revisar colisiones del puerto 53 (ver [INC-002](../../../bitacora/incidentes/INC-002-bind9-systemd-resolved-port53.md)).

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [07-01: Instalar BIND9 en Ubuntu](07-01.md) | Instalación de bind9, utilidades y verificación de versión (BIND 9.20.24). | Verificado en sesión |
| [07-02: Configurar las opciones DNS](07-02.md) | Configuración de named.conf.options restringido a 192.168.50.1 y LAN 192.168.50.0/24. | Verificado en sesión |
| [07-03: Registrar la zona del proyecto](07-03.md) | Declaración autoritativa de la zona `ctcr` (y `ctcr.test`) en named.conf.local. | Verificado en sesión |
| [07-04: Crear el archivo de zona](07-04.md) | Creación de db.ctcr con serial 2026102401 y registros para ns1 y aulavirtual. | Verificado en sesión |
| [07-05: Validar BIND9](07-05.md) | named-checkconf y named-checkzone ctcr sin errores, servicio active. | [EV-063](07-05/evidencias/EV-063.md) |
| [07-06: Probar el DNS desde Ubuntu](07-06.md) | Consultas dig locales hacia 192.168.50.1 para aulavirtual.ctcr y SOA. | [EV-064](07-06/evidencias/EV-064.md) |
| [07-07: Configurar Linux Mint para utilizar BIND9](07-07.md) | Mint resuelve exclusivamente vía BIND9 (dig, getent, ping 0% pérdida). | [EV-065](07-07/evidencias/EV-065.md) y [EV-066](07-07/evidencias/EV-066.md) |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

Configuración y zona sintácticamente válidas, named activo y consulta desde Mint que devuelve la IP esperada. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
