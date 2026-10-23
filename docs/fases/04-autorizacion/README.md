# Identidades, cohortes y aislamiento — alcance, decisiones y trazabilidad

## Qué resuelve esta fase en el Colegio Técnico

Los roles actúan dentro de un contexto Moodle. La cohorte agrupa cuentas para sincronizar matrícula, pero no es un permiso por sí misma. La prueba de URL directa debe realizarse con cuentas no privilegiadas.

Esta es la **vista de producto/requisito** de la fase: por qué se construye, qué se espera demostrar, decisiones, dueño y criterios de aceptación. Los procedimientos ejecutables y las capturas residen en `docs/procedimientos/`; por tanto, **no se duplican comandos en dos lugares que podrían divergir**. Las fichas STEP históricas se conservan abajo como trazabilidad de v1/v2.

## Relación con la infraestructura

Antes de aplicar algo aquí revisar el [estado real](../../00-proyecto/ESTADO.md) y la [matriz de requisitos](../../00-proyecto/matriz-requisitos.md). Los archivos versionados de servicio están explicados en [`infra`](../../../infra/README.md), y los cambios en el host requieren comparar con el archivo activo y guardar copia. La evidencia fotográfica pertenece al mismo subpaso que enseña dónde ejecutarlo.

## Manuales que sí se usan para ejecutar

- **[Manual 06-moodle](../../procedimientos/06-moodle/README.md)**: procedimiento completo con comandos, capturas in situ, validación y estados de ejecución.
- **[Manual 11-verificacion](../../procedimientos/11-verificacion/README.md)**: procedimiento completo con comandos, capturas in situ, validación y estados de ejecución.

## Qué se comprueba al cerrar

**Comando o acción representativa:** Usuarios → Cohortes; Participantes → Métodos de matrícula; apertura directa de URL de curso ajeno. **Resultado requerido:** prueba observada en una VM identificada, con contraste entre esperado y obtenido. Cuando corresponda, incluir prueba negativa (denegación) y demostrar que el cambio no afecta los demás servicios. Una captura de configuración abierta no es una prueba funcional.

## Responsable, revisión y evidencia

El equipo de cinco desarrolla en sesiones sincronizadas. Para mantener responsabilidad real, la persona asignada a esta fase deja el procedimiento y la evidencia; otra persona ejecuta/revisa independientemente. Identidades por asignar en [`responsabilidades`](../../00-proyecto/responsabilidades.md). Las sesiones van a [`bitacora/sesiones`](../../../bitacora/README.md); errores a incidencias.

## Fichas de pasos conservadas desde la estructura inicial

Son referencias de gestión y diseño, no sustituyen a los manuales integrales enlazados arriba.

- [STEP-06-06 — Usuarios y roles](pasos/STEP-06-06.md)
- [STEP-06-07 — Cohortes y matrícula](pasos/STEP-06-07.md)
- [STEP-06-08 — Denegación de acceso directo](pasos/STEP-06-08.md)
