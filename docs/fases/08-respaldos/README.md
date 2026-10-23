# Cron, backups y restauración

- Estado documental: **pendiente** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: no comprobado en bitácora.

## Objetivo

Dump con retención y copia coherente de moodledata; restauración de prueba.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Copia automática verificable y recuperación sin tocar BD activa.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
sudo crontab -l; ls -lh /var/backups/moodle; gzip -t respaldo.sql.gz; restaurar en BD de prueba
```

## Evidencias pendientes

- [ ] EV-08-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-08-02: resultado de aceptación positivo.
- [ ] EV-08-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-10-01 — Estrategia de respaldo completo](pasos/STEP-10-01.md)
- [STEP-10-02 — Ejecutar respaldo SQL validado](pasos/STEP-10-02.md)
- [STEP-10-03 — Cron automático](pasos/STEP-10-03.md)
- [STEP-10-04 — Restauración segura en entorno aparte](pasos/STEP-10-04.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 10-respaldos](../../procedimientos/10-respaldos/README.md)
