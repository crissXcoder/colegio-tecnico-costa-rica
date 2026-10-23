# Plantillas: documentos consistentes sin burocracia redundante

Las plantillas aseguran que **todos los integrantes documenten igual**, aunque ejecuten juntos. Copiar el archivo con ID y fecha propios; nunca editar la plantilla para registrar la sesión real.

- [`paso.md`](paso.md): guía técnica nueva; fija objetivo, sistema donde ejecutar, comandos/GUI, esperado vs observado, archivos vinculados, riesgos y rollback.
- [`sesion.md`](sesion.md): reunión de trabajo; registra participantes, VMs, avances, diferencias entre equipos, acuerdos, pruebas y siguiente paso sincronizado.
- [`incidente.md`](incidente.md): fallo (por ejemplo la raíz llena de INC-001); separa síntoma, hipótesis, diagnóstico probado, solución, impacto y prueba posterior.
- [`prueba.md`](prueba.md): caso de aceptación o prueba negativa, con paso y criterio, resultado real, captura y revisor.
- [`evidencia.md`](evidencia.md): ficha por imagen, con resultado real, límite de la captura, privacidad, hash y paso propietario.
- [`adr.md`](adr.md): decisión arquitectónica con contexto, alternativas, decisión, implicaciones y validación.

## Nomenclatura y dónde guardar resultados

Las capturas nuevas y sus fichas se colocan físicamente con el subpaso en `docs/procedimientos/<bloque>/<paso>/evidencias/`; sesiones en `bitacora/sesiones/`; errores `INC-###` en `bitacora/incidentes/`; ADR en `docs/decisiones/`; y casos de QA bajo `pruebas/`. No publicar credenciales, datos reales de personas ni salidas de `docker compose config` que pueden revelar secretos.
