# Sesión 2026-10-31 — Preparación de la entrega y la presentación

- **Tipo:** sesión documental. No se ejecutaron comandos en las VMs. Los scripts nuevos se revisaron con `bash -n` y la lógica de comparación de hashes se probó con archivos de prueba en Windows; **falta probarlos en Ubuntu Server**.
- **Responsable de la documentación:** Katheryn Méndez Quirós. **Revisión:** pendiente por otra integrante.
- **Fuentes:** «Lineamientos de presentación y entrega» del profesor (sesión 16) y anexo técnico del grupo «Escenario 3» (corte 31/10/2026).

## Hallazgos al contrastar el anexo con el repositorio

1. **Hay al menos dos servidores distintos documentados.** El repositorio describe la VM #1 (`/home/criss/proyecto-moodle`, Nginx `…1.12`, sin UFW). El anexo describe otra VM (`/root/proyecto-moodle`, Nginx `…1.11`, UFW inactivo, `lab5`, MariaDB y PostgreSQL del host). Como el profesor compara lo entregado con lo que corre, se propuso usar una sola VM ([ADR-0004](../../docs/decisiones/ADR-0004-servidor-unico-de-demostracion.md)).
2. **`infra/compose/compose.yaml` es un modelo**, no el compose del servidor; no puede entregarse como `docker-compose.yml`.
3. El anexo marca como pendientes cosas que ya tienen evidencia en la VM #1 (pasos 10 y 11). Se reconciliaron en [PENDIENTES §3](../../docs/00-proyecto/PENDIENTES.md).
4. Faltaba un **script de restauración**, que el profesor pide explícitamente.
5. La contraseña de laboratorio seguía en texto plano en INC-007, 11-06 y 11-07.

## Qué se hizo

| Área | Archivos |
|---|---|
| Lineamientos y paquete | [LINEAMIENTOS-PROFESOR](../../docs/entrega/LINEAMIENTOS-PROFESOR.md), [PAQUETE-ENTREGA](../../docs/entrega/PAQUETE-ENTREGA.md) |
| Scripts para el servidor | [`restauracion-prueba.sh`](../../scripts/restauracion-prueba.sh), [`verificar-servicios.sh`](../../scripts/verificar-servicios.sh), [`armar-entrega.sh`](../../scripts/armar-entrega.sh) |
| Presentación | [GUIA-DEMO](../../docs/entrega/GUIA-DEMO.md), [PREGUNTAS-TECNICAS](../../docs/entrega/PREGUNTAS-TECNICAS.md), [comparativa-software](../../docs/entrega/comparativa-software.md) ampliada |
| Riesgos anticipados | [RIESGOS-Y-FALLOS-ANTICIPADOS](../../docs/operacion/RIESGOS-Y-FALLOS-ANTICIPADOS.md) (R-01 a R-40) |
| Decisiones | [ADR-0003](../../docs/decisiones/ADR-0003-firewall-iptables-sin-ufw.md) (firewall), [ADR-0004](../../docs/decisiones/ADR-0004-servidor-unico-de-demostracion.md) (servidor único, propuesta) |
| Incidentes del anexo | INC-015 (502), INC-016 (vsftpd), INC-017 (`curl 26`), INC-018 (UFW) |
| Control | [PENDIENTES](../../docs/00-proyecto/PENDIENTES.md), [COBERTURA-Y-TRAZABILIDAD](../../docs/00-proyecto/COBERTURA-Y-TRAZABILIDAD.md), ESTADO, matriz, `infra/cron` con la ruta real |
| Privacidad | Contraseña retirada de INC-007, 11-06 y 11-07 (sigue en el historial de Git: P-10) |

## Pendiente inmediato

Ver [PENDIENTES](../../docs/00-proyecto/PENDIENTES.md): decidir el servidor (P-01), instalar y probar los scripts en él (P-02), armar el paquete (P-03) y ensayar (P-07).
