# Centro documental — cómo navegar, ejecutar y auditar

El repositorio separa **cuatro tipos de conocimiento** que no deben confundirse: planificación/requisitos, procedimientos reproducibles, evidencia histórica y operación efectiva. Una empresa necesita poder responder qué se quería conseguir, qué comando/configuración lo implementa, qué pasó en la VM y qué prueba confirma la aceptación.

## Rutas para distintos lectores

| Lector | Comenzar por | Qué encontrará |
|---|---|---|
| Integrante que va a crear cuentas, cursos o FTP | [`DATOS-MAESTROS`](00-proyecto/DATOS-MAESTROS.md) y [`CONTENIDO-CURSOS`](00-proyecto/CONTENIDO-CURSOS.md) | Fuente única de nombres, usuarios, cohortes, matriz de acceso, cuentas FTP, dominio y las 15 preguntas. |
| Docente o auditor externo | [`00-proyecto`](00-proyecto/README.md) | Escenario, arquitectura, requisitos, versiones, matriz de trazabilidad, estado y limitaciones. |
| Integrante que sigue la reunión | [`procedimientos`](procedimientos/README.md) | Orden exacto, comandos completos, interfaz Moodle, precauciones, captura dentro de cada paso. |
| Responsable de un bloque | [`fases`](fases/README.md) | Resultado que debe entregar, decisiones relevantes, criterios de aceptación, responsable/revisor. |
| Operador de VM ya creada | [`operacion`](operacion/README.md) | Inspección, reinicio, diagnóstico, migraciones controladas y recuperación. |
| Redactor del informe | [`entrega`](entrega/README.md) | Correspondencia con el documento del curso, evidencias por requisito y material para la presentación. |
| Investigador de decisiones antiguas | [`fuentes`](fuentes/README.md) y [`decisiones`](decisiones/README.md) | Guía histórica íntegra, análisis de referencias Docker y por qué se seleccionaron alternativas. |

## Organización por responsabilidades

La arquitectura de archivos vive en [`../infra/`](../infra/README.md). Allí cada configuración se mantiene como texto versionable **sin secretos**. La bitácora cronológica e incidencias están en [`../bitacora/`](../bitacora/README.md). Las imágenes históricas se almacenan en `procedimientos/<fase>/<paso>/evidencias/`, pero su ubicación global se descubre desde el [`catálogo`](../evidencias/CATALOGO-CAPTURAS.md).

## Cómo leer el estado

- **Propuesto:** el archivo se preparó como receta sin evidencia de ejecución.
- **Histórico observado:** la bitácora contiene captura de una acción en una VM, pero puede faltar aceptación.
- **Verificado local:** alguien repitió la comprobación y guardó el resultado observado y VM.
- **Validado cruzado:** otra persona reprodujo o comprobó el caso de forma independiente.

La verdad histórica se conserva aunque más adelante se cambie una receta por seguridad. No ajustar resultados antiguos para coincidir con nuevas instrucciones.

## Cambios responsables

Documentar errores nuevos en `bitacora/incidentes/`, corregir el procedimiento aplicable, adjuntar prueba y abrir PR. Si el cambio afecta arquitectura, seguridad o datos, añadir un ADR y actualizar diagrama y matriz. No subir contraseñas, dump de Moodle ni capturas con datos de usuarios.
