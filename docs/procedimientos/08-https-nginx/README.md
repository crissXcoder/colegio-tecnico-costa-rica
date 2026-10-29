# Nginx, VirtualHost y HTTPS — manual de operación

**Bloque:** `08-https-nginx` · **Capturas históricas integradas:** 4 (`EV-067`..`EV-070`) · **Estado:** verificado localmente (VM #1 Server y VM #2 Mint).

## Por qué existe este bloque

Nginx termina TLS en 443 y pasa peticiones a Moodle enlazado en localhost:8080. Moodle debe registrar su URL canónica HTTPS para generar enlaces y cookies correctos.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** Cambiar URL y bind debe hacerse como una transición coordinada; no aplicar Compose de otro proyecto a volúmenes existentes.

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [08-01: Instalar Nginx](08-01.md) | Instalación de Nginx 1.28.3 y OpenSSL en Ubuntu Server; verificación con `nginx -v`. | Verificada en [08-04](08-04.md) |
| [08-02: Crear el certificado](08-02.md) | Certificado autofirmado RSA 3072 con SAN `aulavirtual.ctcr` y clave privada protegida. | Verificada en [08-04](08-04.md) |
| [08-03: Crear el VirtualHost](08-03.md) | VirtualHost con redirección 301 en puerto 80 y proxy SSL en 443 hacia 127.0.0.1:8080. | Verificada en [08-04](08-04.md) |
| [08-04: Habilitar el sitio](08-04.md) | Validación sintáctica con `sudo nginx -t` (OK) y servicio activo en systemd. | [EV-067](08-04/evidencias/EV-067.md) |
| [08-05: Cambiar la URL de Moodle](08-05.md) | Moodle mantiene URL HTTPS canónica con backend solo en 127.0.0.1:8080. | Verificada en [08-06](08-06.md) |
| [08-06: Probar HTTPS desde Ubuntu](08-06.md) | Pruebas de curl verificando redirección 301 y respuesta 200 OK con cabecera Nginx. | [EV-068](08-06/evidencias/EV-068.md) |
| [08-07: Abrir Moodle desde Linux Mint](08-07.md) | Navegación gráfica en Firefox a `https://aulavirtual.ctcr/` y pruebas curl en Cinnamon. | [EV-069](08-07/evidencias/EV-069.md), [EV-070](08-07/evidencias/EV-070.md) |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

nginx -t, SAN y vigencia del certificado, redirección 80->443, página usable por nombre desde Mint. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
