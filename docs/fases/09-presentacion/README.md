# QA integral y entrega

- Estado documental: **pendiente** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: plantilla con fechas 4/11 y 6/11.

## Objetivo

Pruebas cruzadas, diagrama, explicación técnica y ensayo de demo.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Rúbrica cubierta con prueba visual para cada requisito.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
pruebas/README.md y matriz de requisitos completadas
```

## Evidencias pendientes

- [ ] EV-09-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-09-02: resultado de aceptación positivo.
- [ ] EV-09-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-11-01 — Pruebas integrales en frío](pasos/STEP-11-01.md)
- [STEP-12-01 — Construir informe y exposición](pasos/STEP-12-01.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 11-verificacion](../../procedimientos/11-verificacion/README.md)
