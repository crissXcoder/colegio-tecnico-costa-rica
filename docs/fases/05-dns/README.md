# BIND9 y zona local

- Estado documental: **pendiente** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: no comprobado en bitácora.

## Objetivo

Zona colegio.test, forwarders, clientes resolviendo FQDN.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** moodle.colegio.test -> 192.168.50.1 desde Mint.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
sudo named-checkconf; sudo named-checkzone colegio.test /etc/bind/db.colegio.test; dig @192.168.50.1 moodle.colegio.test +short
```

## Evidencias pendientes

- [ ] EV-05-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-05-02: resultado de aceptación positivo.
- [ ] EV-05-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-07-01 — Revisar puerto 53 y BIND9](pasos/STEP-07-01.md)
- [STEP-07-02 — Crear zona y registros](pasos/STEP-07-02.md)
- [STEP-07-03 — Resolver desde Linux Mint](pasos/STEP-07-03.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 07-dns-bind9](../../procedimientos/07-dns-bind9/README.md)
