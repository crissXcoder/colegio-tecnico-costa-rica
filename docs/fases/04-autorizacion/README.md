# Usuarios, roles y aislamiento

- Estado documental: **evidencia parcial** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: bitacora inicial págs. 17-18 (solo inicio).

## Objetivo

Cohortes departamentales, matrículas, docente limitado, accesos negativos.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Tres grupos exclusivos + URL directa de recurso ajeno rechazada.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
Ingresar como alumno de otra cohorte y probar URL directa
```

## Evidencias pendientes

- [ ] EV-04-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-04-02: resultado de aceptación positivo.
- [ ] EV-04-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-06-06 — Usuarios y roles](pasos/STEP-06-06.md)
- [STEP-06-07 — Cohortes y matrícula](pasos/STEP-06-07.md)
- [STEP-06-08 — Denegación de acceso directo](pasos/STEP-06-08.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 06-moodle](../../procedimientos/06-moodle/README.md)
