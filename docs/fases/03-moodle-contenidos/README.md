# Moodle: colegio y contenidos

- Estado documental: **evidencia parcial** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: bitacora inicial págs. 9-17; falta inventario completo.

## Objetivo

Personalización, tres categorías, tres cursos y nueve elementos mínimos.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Cada curso tiene dos recursos propios y una actividad evaluable real.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
Revisión de cursos en UI como administrador + capturas
```

## Evidencias pendientes

- [ ] EV-03-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-03-02: resultado de aceptación positivo.
- [ ] EV-03-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-06-01 — Personalizar plataforma](pasos/STEP-06-01.md)
- [STEP-06-02 — Crear departamentos/categorías](pasos/STEP-06-02.md)
- [STEP-06-03 — Crear tres cursos](pasos/STEP-06-03.md)
- [STEP-06-04 — Cargar dos recursos genuinos por curso](pasos/STEP-06-04.md)
- [STEP-06-05 — Actividad evaluable y cuestionario](pasos/STEP-06-05.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 06-moodle](../../procedimientos/06-moodle/README.md)
