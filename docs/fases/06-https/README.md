# Nginx, certificado y proxy

- Estado documental: **pendiente** — ver [estado general](../../00-proyecto/ESTADO.md).
- Responsable: **asignar según tabla grupal**; revisor: integrante de otra fase.
- Fuente inicial: no comprobado en bitácora.

## Objetivo

TLS con SAN, redirección HTTP y wwwroot/SSL proxy.

## Prerrequisitos

1. La VM coincide con versión, interfaces y espacio definidos en el inventario individual.
2. El equipo ha revisado los comandos y el rollback antes de hacer cambios.
3. El paso anterior tiene evidencia suficiente para continuar.

## Procedimiento y archivos

- Consultar `infra/` y `scripts/` (ver los README de esas carpetas). **No ejecutar automáticamente** plantillas sin revisar valores, secretos y puertos.
- Registrar cada subpaso con `plantillas/paso.md`, enlazando el commit exacto y el comando utilizado.
- Registrar variantes por máquina en la sesión; un error local no cambia la receta global sin validación.

## Prueba de aceptación

**Criterio:** Moodle accesible con HTTPS por FQDN y certificado esperado.

**Comprobaciones sugeridas (ajustar al contexto):**

```text
sudo nginx -t; curl -k -I --resolve moodle.colegio.test:443:192.168.50.1 https://moodle.colegio.test
```

## Evidencias pendientes

- [ ] EV-06-01: ejecución/comprobación con salida observada y contexto de VM.
- [ ] EV-06-02: resultado de aceptación positivo.
- [ ] EV-06-03: fallo esperado o prueba de recuperación, cuando aplique.
- [ ] Capturas revisadas para excluir secretos o información personal.
- [ ] Revisor independiente reproduce o valida el resultado.

## Incidencias, decisiones y documentación final

Documentar enlaces `INC-XXX`, `ADR-XXX`, PR y el apartado de informe correspondiente. Actualizar estado solo cuando haya prueba.

## Pasos individuales de esta fase

- [STEP-08-01 — Revisar Nginx y certificados](pasos/STEP-08-01.md)
- [STEP-08-02 — Configurar VirtualHost proxy](pasos/STEP-08-02.md)
- [STEP-08-03 — Migrar wwwroot a HTTPS](pasos/STEP-08-03.md)
- [STEP-08-04 — Verificación TLS y navegador](pasos/STEP-08-04.md)


## Manuales detallados para copiar comandos y ver capturas

- [Manual de 08-https-nginx](../../procedimientos/08-https-nginx/README.md)
