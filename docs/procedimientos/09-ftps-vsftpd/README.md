# Transferencia de archivos FTPS aislada — manual de operación

**Bloque:** `09-ftps-vsftpd` · **Capturas históricas integradas:** 0 · **Estado:** evidencia local parcial o documentación proyectada, no validación cruzada del grupo.

## Por qué existe este bloque

vsftpd proporciona cuentas independientes, directorios `chroot` y TLS explícito. Es una prueba de permisos del host distinta de los permisos de Moodle.

Este bloque no es un listado de archivos: proporciona la **secuencia operativa**, el vínculo entre decisiones, configuraciones reales y evidencia, y el criterio con el que una persona ajena al equipo puede saber si el servicio funciona. Para comprender el recorrido general se recomienda comenzar por el [README principal](../../../README.md) y el [estado del proyecto](../../00-proyecto/ESTADO.md).

## Cómo usarlo sin perder datos

**En una VM nueva:** reunir prerrequisitos, ejecutar cada archivo de subpaso en orden y capturar el resultado antes de avanzar. **En una VM que ya tiene Moodle funcionando:** realizar inventario primero, comparar la configuración activa y omitir comandos de creación; nunca cambiar contraseñas y nombres de volúmenes con la intención de repetir el tutorial. Todos implementan juntos durante la sesión, pero un responsable documenta y otra persona revisa el bloque.

**Riesgo más importante:** Hay que configurar `user_sub_token=$USER`, comprobar PAM y que el directorio raíz no sea escribible; no revelar credenciales en pruebas curl.

## Guías paso a paso, con prueba y evidencia al lado

| Guía | Qué se obtiene y cómo verificarlo | Captura vinculada |
|---|---|---|
| [09-01: Instalar el servicio](09-01.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [09-02: Crear usuarios FTP](09-02.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [09-03: Crear los directorios separados](09-03.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [09-04: Crear una lista de usuarios permitidos](09-04.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [09-05: Configurar vsftpd](09-05.md) | Cada usuario FTPS confinado en su directorio con sustitución $USER activa. |  |
| [09-06: Reiniciar FTP](09-06.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [09-07: Probar un usuario FTP](09-07.md) | Ejecutar el procedimiento y comparar su resultado observado con el comportamiento descrito, adjuntando salida verificable. |  |
| [09-08: Comprobar que los permisos funcionan](09-08.md) | Intento de modificar o eliminar archivo ajeno recibe denegación real. |  |

Cada guía incluye el procedimiento completo procedente de la fuente compartida, comandos originales, correcciones de seguridad, comprobaciones, imágenes históricas **en su propia carpeta** y una ficha por captura (`EV-XXX.md`). Las guías sin imágenes existentes tienen una sección explícita de evidencia pendiente. No deben asociarse screenshots de otros servicios solo para llenar un hueco.

## Interfaces y archivos de configuración

Para realizar un cambio versionable, comenzar por los modelos en [`infra/`](../../../infra/README.md) y los scripts de [`scripts/`](../../../scripts/README.md), y comprobar el archivo realmente instalado en el host. No hay una sincronización automática entre Git y `/etc`: el procedimiento del paso explica dónde copiar, validar y reiniciar el servicio.

## Criterio de cierre del bloque

Inicio FTPS, subida y listado propios, denegación de lectura/escritura/borrado ajenos, puertos pasivos controlados. Registrar fecha, identificador de VM, ejecutor, revisor, comando o acción exacta, **resultado observado**, prueba de aceptación y `EV-XXX` en la [bitácora](../../../bitacora/README.md). Los registros de una sola VM permanecen como evidencia local; para validar el trabajo conjunto se repite en otros equipos.

## Si algo falla

No ejecutar limpiezas destructivas ni alterar LVM/firewall/cuentas como primer diagnóstico. Crear una ficha a partir de [`plantillas/incidente.md`](../../../plantillas/incidente.md), enlazar al [registro de incidencias](../../../bitacora/README.md), conservar la salida de error redactada y documentar la reversión. Incorporar la solución a este paso solo cuando esté reproducida y revisada.
