# Elevaquitas — Colegio Técnico con departamentos separados

**EIF431O · Universidad Nacional, Campus Nicoya · Escenario 3 · Moodle LMS**

> **Estado:** repositorio base documental **propuesto**, reconstruido a partir de la plantilla, bitácora y conversación previa del grupo. Las evidencias parciales de implementación no equivalen a una validación final. **No ejecutar configuraciones sin revisarlas para la VM correspondiente.**

## Qué es este repositorio

Punto único de referencia para las cinco personas del equipo: configuración reproducible del laboratorio, procedimientos, decisiones, comandos, bitácoras, incidencias, resultados verificables, evidencias y documentación final. **Trabajo de implementación colaborativo y sincronizado; responsabilidad individual de preparar, documentar y revisar cada bloque.**

## Manual integral reconstruido (versión 2)

**[Abrir el manual paso a paso con todos los comandos, configuraciones y evidencias](docs/procedimientos/README.md)**. También incluye 50 imágenes extraídas de la bitácora actualizada y una [tabla de evidencias](evidencias/CATALOGO-CAPTURAS.md).

**[Registro de cambios v1→v2](CAMBIOS-V2.md)**. La versión anterior está preservada en las carpetas originales de `docs/fases/`, `infra/`, `scripts/`, `bitacora/` y plantillas.

## Operación cotidiana y sesiones

- [Comandos esenciales para copiar y ejecutar con precaución](docs/operacion/COPIAR-PEGAR.md)
- [Recuperación después de apagar las VMs](docs/operacion/REINICIO-Y-RECUPERACION.md)
- [Restauración de prueba sin sobrescribir la base real](docs/operacion/RESTAURACION-ENSAYO.md)
- [Inventario individual de los cinco integrantes](docs/operacion/INVENTARIO-POR-INTEGRANTE.md)
- [Sesión reconstruida a partir de la bitácora nueva](bitacora/sesiones/2026-10-22-reconstruccion-bitacora-v2.md)

## Entradas rápidas

- [Estado real y pendientes](docs/00-proyecto/ESTADO.md)
- [Arquitectura y alcance](docs/00-proyecto/README.md)
- [Requisitos y trazabilidad](docs/00-proyecto/matriz-requisitos.md)
- [Versiones (observadas frente a objetivo)](docs/00-proyecto/versiones.md)
- [Guía para los cinco integrantes](CONTRIBUTING.md)
- [Índice de fases](docs/fases/README.md)
- [Sesiones y problemas registrados](bitacora/README.md)
- [Evidencias y privacidad](evidencias/README.md)
- [Informe final: correspondencia con la plantilla](docs/entrega/README.md)
- [Análisis de fuentes y hallazgos](ANALISIS-FUENTES.md)

## Stack objetivo, **no necesariamente instalado en todas las VMs**

| Rol | Solución propuesta |
| --- | --- |
| Hipervisor | VirtualBox |
| Servidor | Ubuntu Server 26.04 LTS, NAT + red interna |
| Cliente | Linux Mint 22.3 en red interna |
| Aplicación | Moodle 4.5.15, imagen Oksigenia, revisar compilación con correcciones de seguridad |
| DB | MariaDB 11.4.13 |
| Orquestación | Docker Engine 29.9.0, Compose 5.6.0 (según VM registrada) |
| DNS | BIND9, `moodle.colegio.test` -> `192.168.50.1` |
| Proxy | Nginx con HTTPS autofirmado de laboratorio |
| FTP | vsftpd con FTPS y confinamiento de cuentas |
| Copias | Cron, dump MariaDB y respaldo coherente de datos de Moodle |

Los archivos en `infra/` son **configuraciones objetivo de referencia**, separados de los archivos reales ya desplegados. Nunca afirmar que una línea propuesta estaba ejecutándose sin capturar el resultado de la VM.

## Flujo resumido de una sesión

1. Sincronizar `main` y consultar [ESTADO](docs/00-proyecto/ESTADO.md) e incidencias abiertas.
2. Cada responsable explica el bloque a ejecutar; todos verifican prerrequisitos en su propia VM.
3. Ejecutar por pasos, recoger pruebas sanitizadas y documentar discrepancias; **detenerse si hay un error, no copiar un comando destructivo para intentar solucionarlo**.
4. En la reunión se acuerda la solución. El responsable redacta y otra persona valida independientemente.
5. Crear PR con comandos, configuración, bitácora, pruebas, capturas y actualización de estado.
6. `main` solo contiene el procedimiento aceptado. Las diferencias de cada equipo se registran sin sobrescribir el procedimiento general.

## Salvaguardas

- Nunca publicar `.env`, claves/certificados privados, backups, credenciales, capturas con contraseñas, tokens, datos reales de estudiantes ni números de identificación.
- Los hashes o identificadores de imágenes Docker son datos de inventario; guardarlos sin secretos.
- **No copiar imágenes y bases reales en Git**: Git es respaldo de configuraciones y trazabilidad, **no** sustituye copia restaurable de volúmenes/BD.
- No ejecutar `docker compose down -v`, `docker system prune`, `docker image prune -a`, `DROP DATABASE`, cambios a LVM o firewall sin revisión del impacto y respaldo comprobado.
- Las configuraciones finales son ejemplos: comparar con versiones, puertos, IPs, otros servicios y requisitos de cada VM.

## Estado académico

Entrega prevista: **7 noviembre 2026**. Requisitos académicos del escenario y criterios están recogidos en [matriz-requisitos](docs/00-proyecto/matriz-requisitos.md). La distribución de roles por área no cambia que las sesiones de construcción se realicen con todo el grupo.
