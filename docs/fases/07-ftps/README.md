# vsftpd con FTPS y aislamiento

- Estado documental: **pendiente** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: no comprobado en bitácora.

## Objetivo

Cuentas individuales, chroot, directorio raíz no escribible y carpetas de trabajo.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Usuario A no puede leer, editar o borrar archivos ajenos.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
sudo systemctl is-active vsftpd; pruebas reales de FTP desde cuenta A y B
```

## Evidencias pendientes

- [ ] EV-07-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-07-02: resultado de aceptación positivo.
- [ ] EV-07-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-09-01 — Decidir cuentas, rutas y PAM](pasos/STEP-09-01.md)
- [STEP-09-02 — Configurar vsftpd y certificados](pasos/STEP-09-02.md)
- [STEP-09-03 — Probar aislamiento de cuentas](pasos/STEP-09-03.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 09-ftps-vsftpd](../../procedimientos/09-ftps-vsftpd/README.md)
