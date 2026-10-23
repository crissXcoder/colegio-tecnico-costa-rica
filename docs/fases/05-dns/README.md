# Zona autoritativa colegio.test — alcance, decisiones y trazabilidad

## Qué resuelve esta fase en el Colegio Técnico

BIND9 resuelve el dominio solo dentro de la red del laboratorio. Linux Mint no necesita NAT; consulta a Ubuntu por 53/UDP y TCP.

Esta es la **vista de producto/requisito** de la fase: por qué se construye, qué se espera demostrar, decisiones, dueño y criterios de aceptación. Los procedimientos ejecutables y las capturas residen en `docs/procedimientos/`; por tanto, **no se duplican comandos en dos lugares que podrían divergir**. Las fichas STEP históricas se conservan abajo como trazabilidad de v1/v2.

## Relación con la infraestructura

Antes de aplicar algo aquí revisar el [estado real](../../00-proyecto/ESTADO.md) y la [matriz de requisitos](../../00-proyecto/matriz-requisitos.md). Los archivos versionados de servicio están explicados en [`infra`](../../../infra/README.md), y los cambios en el host requieren comparar con el archivo activo y guardar copia. La evidencia fotográfica pertenece al mismo subpaso que enseña dónde ejecutarlo.

## Manuales que sí se usan para ejecutar

- **[Manual 07-dns-bind9](../../procedimientos/07-dns-bind9/README.md)**: procedimiento completo con comandos, capturas in situ, validación y estados de ejecución.

## Qué se comprueba al cerrar

**Comando o acción representativa:** `named-checkconf`, `named-checkzone`, `dig @192.168.50.1 moodle.colegio.test`. **Resultado requerido:** prueba observada en una VM identificada, con contraste entre esperado y obtenido. Cuando corresponda, incluir prueba negativa (denegación) y demostrar que el cambio no afecta los demás servicios. Una captura de configuración abierta no es una prueba funcional.

## Responsable, revisión y evidencia

El equipo de cinco desarrolla en sesiones sincronizadas. Para mantener responsabilidad real, la persona asignada a esta fase deja el procedimiento y la evidencia; otra persona ejecuta/revisa independientemente. Identidades por asignar en [`responsabilidades`](../../00-proyecto/responsabilidades.md). Las sesiones van a [`bitacora/sesiones`](../../../bitacora/README.md); errores a incidencias.

## Fichas de pasos conservadas desde la estructura inicial

Son referencias de gestión y diseño, no sustituyen a los manuales integrales enlazados arriba.

- [STEP-07-01 — Revisar puerto 53 y BIND9](pasos/STEP-07-01.md)
- [STEP-07-02 — Crear zona y registros](pasos/STEP-07-02.md)
- [STEP-07-03 — Resolver desde Linux Mint](pasos/STEP-07-03.md)
