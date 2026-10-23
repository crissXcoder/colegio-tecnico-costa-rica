# Registro de consolidación documental — NO es una nueva sesión técnica

- Fecha de **consolidación**: 2026-10-23
- Fuente: `Proyecto_Colegio_Técnico_con_departamentos_separados.docx` (24 pág.)
- Fecha exacta de los trabajos realizados: **confirmar con el grupo**. Hay capturas cuyos logs muestran fechas anteriores; no atribuir toda la sesión a un mismo día sin evidencia.
- VM/es: Ubuntu `server`, Linux Mint cliente. Alias técnicos, sin datos personales.
- Alcance: recopilación del avance constatado, no ejecución de nuevos comandos.

## Observado en capturas

1. Ping y conexión de la red interna.
2. Comprobación de imágenes Moodle 4.5.15 y MariaDB 11.4.13; generación/protección de `.env`.
3. Archivo Compose, descarga e inicio de `db` y `moodle`; logs de creación y tablas de Moodle.
4. Volúmenes `mariadb_data`, `moodle_code`, `moodle_data` y acceso a la interfaz Moodle.
5. Detención/recreación de contenedores con `down`/`up -d` (necesita verificar persistencia funcional, no solo `up`).
6. Personalización, categorías, cursos, recursos, cuestionarios y comienzo de usuarios/roles.
7. INC-001: raíz al 100%, ampliación LVM y limpieza puntual de imágenes.

## No constatado suficientemente

- Matriz de accesos entre tres departamentos, incluyendo intento directo a archivos de otra cohorte.
- Tres cursos completos con mínimo dos recursos reales + una actividad evaluable por cada uno.
- BIND9, HTTPS, FTPS, Cron y restauración integral.
- Versiones/digests en **todas** las VMs del grupo.

## Pendientes de la próxima reunión

- Registrar inventario de cinco equipos sin datos personales.
- Comprobar la versión/parches de la imagen Oksigenia antes de actualizar.
- Finalizar/verificar contenido departamental y aislamiento.
- Preparar paso de DNS con revisión de conflicto de puertos.
