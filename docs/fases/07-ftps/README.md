# Acceso a archivos con cuentas confinadas — alcance, decisiones y trazabilidad

## Qué resuelve esta fase en el Colegio Técnico

vsftpd utiliza FTPS explícito y cuentas del sistema sin shell interactiva. Deben probar subida propia y denegación de modificación o borrado en carpetas ajenas.

Esta es la **vista de producto/requisito** de la fase: por qué se construye, qué se espera demostrar, decisiones, dueño y criterios de aceptación. Los procedimientos ejecutables y las capturas residen en `docs/procedimientos/`; por tanto, **no se duplican comandos en dos lugares que podrían divergir**. Las fichas STEP históricas se conservan abajo como trazabilidad de v1/v2.

## Relación con la infraestructura

Antes de aplicar algo aquí revisar el [estado real](../../00-proyecto/ESTADO.md) y la [matriz de requisitos](../../00-proyecto/matriz-requisitos.md). Los archivos versionados de servicio están explicados en [`infra`](../../../infra/README.md), y los cambios en el host requieren comparar con el archivo activo y guardar copia. La evidencia fotográfica pertenece al mismo subpaso que enseña dónde ejecutarlo.

## Manuales que sí se usan para ejecutar

- **[Manual 09-ftps-vsftpd](../../procedimientos/09-ftps-vsftpd/README.md)**: procedimiento completo con comandos, capturas in situ, validación y estados de ejecución.

## Qué se comprueba al cerrar

**Comando o acción representativa:** `systemctl status vsftpd`, `curl --ssl-reqd` (sin credenciales embebidas). **Resultado requerido:** prueba observada en una VM identificada, con contraste entre esperado y obtenido. Cuando corresponda, incluir prueba negativa (denegación) y demostrar que el cambio no afecta los demás servicios. Una captura de configuración abierta no es una prueba funcional.

**Estado de la fase:** **VERIFICADO LOCALMENTE (VM #1 Server y VM #2 Mint)**. Fase 09 ejecutada y validada con 4 evidencias (`EV-071`, `EV-072`, `EV-073`, `EV-074`), bitácora de sesión [2026-10-28-sesion-paso9-ftps-vsftpd.md](../../../bitacora/sesiones/2026-10-28-sesion-paso9-ftps-vsftpd.md) e incidentes [INC-007](../../../bitacora/incidentes/INC-007-vsftpd-adduser-name-regex-failure.md), [INC-008](../../../bitacora/incidentes/INC-008-vsftpd-pam-shells-nologin-denial.md), [INC-009](../../../bitacora/incidentes/INC-009-vsftpd-user-sub-token-omission-bug.md) e [INC-010](../../../bitacora/incidentes/INC-010-vsftpd-writable-root-chroot-500.md).

## Responsable, revisión y evidencia

El equipo de cinco desarrolla en sesiones sincronizadas. Para mantener responsabilidad real, la persona asignada a esta fase deja el procedimiento y la evidencia; otra persona ejecuta/revisa independientemente. Identidades por asignar en [`responsabilidades`](../../00-proyecto/responsabilidades.md). Las sesiones van a [`bitacora/sesiones`](../../../bitacora/README.md); errores a incidencias.

## Fichas de pasos conservadas desde la estructura inicial

Son referencias de gestión y diseño, no sustituyen a los manuales integrales enlazados arriba.

- [STEP-09-01 — Decidir cuentas, rutas y PAM](pasos/STEP-09-01.md)
- [STEP-09-02 — Configurar vsftpd y certificados](pasos/STEP-09-02.md)
- [STEP-09-03 — Probar aislamiento de cuentas](pasos/STEP-09-03.md)
