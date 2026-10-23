# Servidor y red

- Estado documental: **evidencia parcial** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: bitacora inicial págs. 2-3; INC-001 págs. 23-24.

## Objetivo

Ubuntu/VirtualBox, NAT + red interna, direccionamiento, SSH, espacio LVM, firewall.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Red y almacenamiento listos para trabajar; ping bidireccional; recursos suficientes.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
ip -br a; ip route; ping -c 4 192.168.50.1; df -h; lsblk -f
```

## Evidencias pendientes

- [ ] EV-01-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-01-02: resultado de aceptación positivo.
- [ ] EV-01-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-01-01 — Red interna de VirtualBox y direcciones](pasos/STEP-01-01.md)
- [STEP-01-02 — Diagnóstico de recursos y almacenamiento](pasos/STEP-01-02.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 00-prerrequisitos](../../procedimientos/00-prerrequisitos/README.md)
- [Manual de 01-servidor-red](../../procedimientos/01-servidor-red/README.md)
- [Manual de 02-ubuntu](../../procedimientos/02-ubuntu/README.md)
- [Manual de 03-docker](../../procedimientos/03-docker/README.md)
