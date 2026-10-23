# Elevaquitas — Colegio Técnico con departamentos separados

**Universidad Nacional · EIF431O · Escenario 3 · Moodle LMS**  
**Tipo de repositorio:** guía técnica reproducible + configuración versionada + bitácora de equipo + evidencia probatoria + preparación de entrega.  
**Corte documental:** 23/10/2026. **Entrega prevista:** 7/11/2026.

> **Estado operativo:** existen capturas históricas reales de Docker, MariaDB y trabajo dentro de Moodle, pero **no debe interpretarse la presencia de un comando como prueba de ejecución** ni una captura en una VM como un despliegue idéntico en cinco máquinas. La plataforma ya tiene datos: los cambios sensibles requieren inventario y respaldo.

## 1. Problema que resuelve

El colegio técnico tiene tres departamentos —**Administración, Docencia e Informática**— cuyos materiales no deben ser consultados ni modificados por personas de otros departamentos. La plataforma Moodle organiza **tres cursos reales**, contenidos evaluables, identidades, cohortes y matrículas limitadas. La aceptación central es un intento de abrir por URL un curso o recurso ajeno **denegado** usando una cuenta sin privilegios de administrador.

El proyecto también demuestra administración Linux: Ubuntu Server en VirtualBox, cliente Linux Mint interno, Moodle/MariaDB con Docker, DNS BIND9, Nginx/HTTPS, FTPS por usuario y respaldos Cron/restauración. El motivo y las decisiones técnicas se explican en el [documento del escenario](docs/00-proyecto/README.md) y en la [rúbrica trazable](docs/00-proyecto/matriz-requisitos.md).

## 2. ¿Por dónde empiezo? Cuatro recorridos para cuatro necesidades

| Necesidad real | Inicio recomendado | Qué aprenderé/haré |
|---|---|---|
| **Soy externo al equipo y quiero entender el sistema** | [Contexto y arquitectura](docs/00-proyecto/README.md) → [mapa de documentación](docs/README.md) | Por qué existe cada servicio, qué está construido, qué falta, cuáles son los archivos confiables. |
| **Estoy con los otros cuatro integrantes ejecutando el siguiente paso** | [Manual operativo paso a paso](docs/procedimientos/README.md) → [comandos rápidos](docs/operacion/COPIAR-PEGAR.md) | El comando completo, en qué VM correrlo, resultado que esperar y foto histórica del mismo paso. |
| **Quiero saber exactamente lo que se probó y cómo lo documentamos** | [Estado del grupo](docs/00-proyecto/ESTADO.md) → [catálogo de pruebas](evidencias/CATALOGO-CAPTURAS.md) → [bitácora](bitacora/README.md) | Diferencia entre ejecución histórica y aceptación, evidencia original contextualizada y pendientes por máquina. |
| **Voy a editar una configuración o solucionar un error** | [Archivos de infraestructura](infra/README.md) → [operación de VM](docs/operacion/README.md) → [incidencias](bitacora/README.md) | Qué archivo afecta a qué servicio, validación sintáctica, copia de seguridad, rollback y documentación del error. |

## 3. Arquitectura y estado que se puede sostener

El esquema final conecta **Linux Mint (Firefox)** con **Ubuntu Server** por una red interna. Ubuntu aloja Nginx/TLS y BIND9 en el host, Moodle y MariaDB en dos contenedores separados y vsftpd/Cron para transferencia y respaldo. Los datos de Moodle persisten en volúmenes; las contraseñas `.env` nunca se suben. El [diagrama arquitectónico](docs/00-proyecto/README.md) identifica puertos y relaciones.

| Componente | Decisión de implementación | Estado que respaldan los documentos |
|---|---|---|
| Ubuntu + Mint/VirtualBox | Ubuntu NAT+interna; Mint solo interna | Capturas de ping bidireccional, una VM; inventario grupal pendiente. |
| Docker + Moodle + MariaDB | `oksigenia/moodle:4.5.15` (revisar compilación segura), `mariadb:11.4.13`; Compose y volúmenes | Hay capturas de ejecución, esquema SQL y volúmenes en una VM. |
| Cursos y usuarios Moodle | Tres departamentos, cursos, preguntas, usuarios y cohortes | Hay trabajo histórico fotografiado; falta comprobación completa por curso y denegación 3×3. |
| BIND9 / Nginx / FTPS / Cron | Configuraciones y procedimientos de implementación | **Objetivos documentados**; sin capturas de aceptación de estos servicios en la bitácora recibida. |
| Incidente de almacenamiento | Raíz llena, ampliación LVM en VM de grupo | Existe captura y explicación de corrección; ver [INC-001](bitacora/incidentes/INC-001-almacenamiento-lvm.md). |

## 4. Estructura razonada del repositorio — no duplicar información

| Ruta o archivo | Responsabilidad, contenido y cuándo acudir |
|---|---|
| [`docs/00-proyecto/`](docs/00-proyecto/README.md) | El **porqué**: caso, requerimientos, restricciones, versiones y estado respaldado por las fuentes. Es el contrato de aceptación. |
| [`docs/fases/`](docs/fases/README.md) | El **qué se entrega por bloque**: alcance, decisiones de diseño, responsables, criterios y referencias a los subpasos. Conserva las fichas STEP de versiones anteriores. |
| [`docs/procedimientos/`](docs/procedimientos/README.md) | El **cómo se hace**: procedimientos desglosados, comandos y archivos completos, verificación, y **capturas dentro del paso exacto** con fichas EV explicativas. Fuente principal para copiar y ejecutar. |
| [`infra/`](infra/README.md) | El **qué configura la infraestructura**: Compose, DNS, Nginx, vsftpd, Cron. Son archivos editables de referencia, no duplicados confirmados de `/etc` ni de un servidor real. |
| [`scripts/`](scripts/README.md) | Operaciones controladas: generación de secretos, inventario, dump de DB y controles documentales. No existe un instalador ciego de todas las fases. |
| [`bitacora/`](bitacora/README.md) | El **qué pasó de verdad**: sesiones cronológicas, diagnósticos, causas, soluciones y responsables. Una incidencia enlaza al paso afectado y a su evidencia. |
| [`evidencias/`](evidencias/README.md) | Índice transversal y manifiestos de las **50 capturas**; las imágenes y sus fichas están guardadas en `docs/procedimientos/.../<paso>/evidencias/`. |
| [`pruebas/`](pruebas/README.md) | Pruebas repetibles con esperado/observado por VM, especialmente denegación de acceso, persistencia, FTP y recuperación. |
| [`docs/operacion/`](docs/operacion/README.md) | Manual para máquinas **ya instaladas**: iniciar la sesión, diagnosticar, reanudar Compose y recuperar datos sin destruirlos. |
| [`docs/entrega/`](docs/entrega/README.md) | Adaptación del contenido técnico a la plantilla académica, conclusiones, justificación de software libre y demo del 7 de noviembre. |
| [`docs/decisiones/`](docs/decisiones/README.md) y [`docs/fuentes/`](docs/fuentes/README.md) | Razón detrás de las elecciones, documentación histórica íntegra y material auxiliar; separan propuestas del chat y decisiones aprobadas. |
| [`.github/`](.github/README.md) | CI de sintaxis, enlaces, integridad de evidencias y plantillas para issues/PR; apoya revisión por otra persona del grupo. |
| [`plantillas/`](plantillas/README.md) | Modelos consistentes para sesiones, pasos, problemas, pruebas y ADR sin reinventar una bitácora distinta cada semana. |
| [`AGENTS.md`](AGENTS.md), [`CONTRIBUTING.md`](CONTRIBUTING.md) | Reglas para colaboradores y asistentes: conservar evidencias, no inventar estados, documentación y revisión cruzada obligatorias. |

**[Inventario comentado de artefactos y archivos](docs/00-proyecto/INVENTARIO-DE-ARTEFACTOS.md)**: contiene descripción funcional, editor/usuario objetivo, dependencias y restricciones de cambio de las principales piezas del repositorio.

## 5. Flujo de trabajo sincronizado de cinco integrantes

1. **Apertura:** sincronizar Git y revisar [ESTADO](docs/00-proyecto/ESTADO.md), incidencias, memoria/espacio/puertos de cada VM. El responsable propone el paso; los cinco mantienen la misma secuencia.
2. **Preflight:** comparar instalación **real** con archivo `infra/` de referencia y procedimiento completo. Si alguien tiene una variante, no asumir que su VM coincide.
3. **Ejecución conjunta:** cada persona ejecuta en su máquina; si falla una, **se detiene ese integrante** y se diagnostica en equipo sin borrar el avance de las demás.
4. **Evidencia:** adjuntar captura bajo el subpaso correcto, ficha EV con comando/acción, esperado, observado y límites, VM, fecha, ejecutor y revisor. Si se repite un paso, añadir evidencia nueva sin falsificar la anterior.
5. **Cierre:** responsable actualiza README de la fase, bitácora, pruebas y matriz; revisor comprueba desde otra máquina y abre/aprueba PR. Es un proyecto grupal, aunque la custodia de cada bloque esté repartida.

## 6. Seguridad de datos y cambios

No publicar `.env`, certificados privados, backups ni información de estudiantes. Tampoco incluir la bitácora DOCX original si contiene datos no revisados; la copia operativa Git mantiene solo capturas que deben someterse a revisión manual adicional antes de hacer público el repo. **No ejecutar `docker compose down -v`, `prune -a`, `DROP DATABASE`, `lvextend` ni habilitar UFW sin preflight, confirmación del objetivo y respaldo.**

## 7. Calidad documental y próximos hitos

Ejecutar `python3 scripts/validate-repository.py` desde la raíz y `bash -n scripts/*.sh` según indica [CI](.github/README.md). Estas comprobaciones **no ejecutan Ubuntu/Moodle**; solo verifican la coherencia de los artefactos. Las pruebas reales se deben completar sobre las VMs.

**Prioridad de grupo:** cerrar contenido Moodle/roles y denegación; luego BIND9/HTTPS, FTPS, backups y recuperación; hacer reproducción cruzada para el 4/11, ensayo el 6/11 y entrega el 7/11. Ver [CAMBIOS-V3.md](CAMBIOS-V3.md) para modificaciones de esta revisión, sin borrar los cambios anteriores.
