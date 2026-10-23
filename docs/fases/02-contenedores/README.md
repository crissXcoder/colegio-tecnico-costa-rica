# Docker, Moodle y MariaDB

- Estado documental: **evidencia parcial** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: bitacora inicial págs. 3-8.

## Objetivo

Versiones e imágenes, secretos .env, compose, salud, volúmenes, persistencia.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Dos servicios sanos, volúmenes persistentes, DB inicializada, acceso Moodle.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
docker compose ps; docker images --digests; docker volume ls; docker compose logs --tail=60
```

## Evidencias pendientes

- [ ] EV-02-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-02-02: resultado de aceptación positivo.
- [ ] EV-02-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-04-01 — Versiones y manifiestos](pasos/STEP-04-01.md)
- [STEP-04-02 — Variables privadas y credenciales](pasos/STEP-04-02.md)
- [STEP-04-03 — Crear y validar Compose](pasos/STEP-04-03.md)
- [STEP-04-04 — Descargar e iniciar los dos servicios](pasos/STEP-04-04.md)
- [STEP-04-05 — Verificar base y volúmenes](pasos/STEP-04-05.md)
- [STEP-05-01 — Acceso web y persistencia](pasos/STEP-05-01.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 04-contenedores](../../procedimientos/04-contenedores/README.md)
- [Manual de 05-cliente-mint](../../procedimientos/05-cliente-mint/README.md)
