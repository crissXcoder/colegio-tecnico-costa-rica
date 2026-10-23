# Automatización de revisión y colaboración en GitHub

Este directorio contiene controles **del repositorio de documentación**, no acciones que administren VMs. El workflow no descarga Docker Moodle ni toca el servidor del grupo.

- [`workflows/validar-documentacion.yml`](workflows/validar-documentacion.yml) corre en pushes a `main` y PR: revisa estructura, enlaces Markdown e imágenes, manifiesto/hash de evidencias y sintaxis Bash, impidiendo que secretos `.env` se versionen inadvertidamente.
- [`ISSUE_TEMPLATE/incidencia.md`](ISSUE_TEMPLATE/incidencia.md) normaliza un ticket de error: síntomas, VM, comandos exactos (sin credenciales), esperado/obtenido, evidencia y enlace a bitácora.
- [`PULL_REQUEST_TEMPLATE.md`](PULL_REQUEST_TEMPLATE.md) permite al revisor comprobar que se actualizaron comandos, evidencia, resultado y estado en la fase correspondiente.

## Flujo de revisión de cinco personas

El responsable del bloque prepara cambios en rama corta y abre PR; otro integrante revisa archivos de servicio, enlaces y seguridad de capturas. El trabajo se implementa en sesiones conjuntas y se fusiona únicamente cuando la validación documental pasa. Para evitar cambios imprevistos en la demostración, se recomienda proteger `main` y no actualizar imágenes justo antes del ensayo.
