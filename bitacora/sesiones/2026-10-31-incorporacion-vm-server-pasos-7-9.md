# Sesión 2026-10-31 — Incorporación de la VM `server@server` (pasos 7, 8 y 9)

- **Tipo:** sesión documental. No se ejecutaron comandos en las VMs.
- **Responsable de la documentación:** Katheryn Méndez Quirós. **Revisión:** pendiente por otra integrante.
- **Fuente:** documento del grupo «Proyecto Colegio Técnico con departamentos separados», versión de 54 páginas. Las páginas 1 (cédulas), 7 (contraseña de la base de datos en claro) y 18 (correo personal) **no** se incorporaron.

## Qué se encontró

- Las páginas 32 a 45 muestran los pasos 7, 8 y 9 hechos en **otra VM del grupo** (`server@server`, clientes Mint de Greilyn y Angélica). Hasta ahora el repositorio solo tenía esos pasos de la VM de Criss (`criss@server`). Las dos VMs se llaman `server` (R-43).
- Las páginas 46 a 48 repiten capturas de apariencia ya incorporadas (EV-045 a EV-049) y la 49 es la del disco lleno (INC-001, EV-050): no se duplicaron.
- Las páginas 49 a 54 documentan cuatro errores: disco lleno (INC-001), versión de Nginx no encontrada (INC-003), `CLI_SCRIPT` (INC-005) y UFW removido (INC-018).
- Diferencias con la VM de Criss: Nginx `…1.11` desde `.deb`, usuarios FTP con guion bajo, dos carpetas de proyecto, zonas DNS de otras prácticas, UFW inactivo y **sin evidencia del paso 10**. Resumen en [ADR-0004](../../docs/decisiones/ADR-0004-servidor-unico-de-demostracion.md).

## Qué se hizo

| Área | Resultado |
|---|---|
| Evidencias | EV-107 a EV-130 (24), cada una con ficha, SHA-256, manifiesto y catálogo, dentro de su subpaso (07-01 a 09-08 y 11-04). Se ocultó el identificador de sesión de Moodle en EV-121. |
| Errores nuevos | [INC-019](../incidentes/INC-019-apt-bloqueado-unattended-upgrades.md): APT bloqueado por `unattended-upgrades`. |
| Errores ampliados | INC-003 (solución con `.deb` y riesgo de actualización), INC-005 (captura del error), INC-007 (tabla de las tres soluciones y nombres distintos), INC-018 (procedencia confirmada). |
| Riesgos | R-41 a R-46 en [RIESGOS-Y-FALLOS-ANTICIPADOS](../../docs/operacion/RIESGOS-Y-FALLOS-ANTICIPADOS.md). |
| Pendientes | P-15 confirmado, P-16 cerrado, P-05 con fuentes citadas, nuevos P-17 y P-18 en [PENDIENTES](../../docs/00-proyecto/PENDIENTES.md). |
