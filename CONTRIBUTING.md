# Protocolo de trabajo colaborativo — Elevaquitas

**Regla:** se implementa por sesiones comunes para que los cinco entiendan y ejecuten el mismo paso, pero cada bloque tiene responsable de preparación/documentación y un revisor diferente. **No significa dividir a las personas en entornos inconexos.**

## Preparar una sesión

- Actualizar `main`, leer `docs/00-proyecto/ESTADO.md` y el README de la fase.
- El/la responsable prepara comandos, riesgos y evidencias esperadas; el/la revisor/a cuestiona supuestos y seguridad.
- Abrir registro a partir de `plantillas/sesion.md`; asociar `STEP-XX` y, si hay fallos, `INC-XXX`.
- Identificar qué máquina ejecutó cada paso sin comprometer secretos. Las IPs del laboratorio pueden variar entre integrantes.

## Durante la sesión

1. Una persona explica qué hace cada comando.
2. Todos ejecutan el mismo paso sobre sus VMs **sin copiar comandos que afecten otros servicios**.
3. Ante un error se registra salida sanitizada, causa e hipótesis. El grupo diagnostica antes de continuar.
4. Se comprueba el resultado positivo y, en seguridad, el resultado negativo (acceso que debe rechazarse).
5. Las capturas reciben ID y nombre estable: `EV-<PASO>-<NN>-<descripcion>.png`.

## Al terminar

- Actualizar README de fase, registro de sesión, incidencia, matriz de pruebas y estado global.
- PR con cambios para revisión por otra persona; no modificar `main` directamente.
- No marcar **verificado** hasta disponer de comando/resultado/evidencia. Marcar **integrado** solo después de prueba cruzada.
- Toda configuración en `infra/` debe indicar ruta de despliegue y validación. Los `*.example` son plantillas, no prueba de instalación.

## Criterios de aceptación de un PR

- [ ] Vincula requisito del profesor y fase/STEP.
- [ ] Incluye objetivo, prerrequisitos, comandos exactos y explicación.
- [ ] Preserva configuración existente y documenta rollback o recuperación.
- [ ] Incluye resultado esperado y **observado** con capturas sanitizadas.
- [ ] Explica desvíos entre procedimiento común y VMs individuales.
- [ ] Actualiza bitácora, errores, decisiones y estado.
- [ ] Ha sido revisado por alguien distinto del autor.
- [ ] No contiene claves, contraseñas, identificaciones personales ni backups.

## Política de ramas

`main` protegida; `feat/fase-04-dns`, `docs/sesion-2026-10-23`, `fix/inc-001-espacio`. PR con revisión, squash merge y commits descriptivos. Si GitHub no permite reglas de protección por plan/permisos, acordar no hacer pushes directos.

## Límites

`dockerlabs` es recurso educativo externo, no un submódulo ni una dependencia del proyecto. No importar su contenido con credenciales de ejemplo o versiones obsoletas. Para el informe académico pueden exportar evidencia revisada, pero el repositorio **no** guarda los datos reales de Moodle, que requieren backups aparte.
