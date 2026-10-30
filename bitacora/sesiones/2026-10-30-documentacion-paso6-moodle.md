# Sesión 2026-10-30 — Documentación completa del paso 6 (Moodle)

- **Tipo:** sesión documental. No se ejecutaron comandos ni cambios en las VMs; se incorporaron capturas históricas del grupo.
- **Responsable de la documentación:** Katheryn Méndez Quirós. **Revisión:** pendiente por otra integrante.
- **Fuentes revisadas:**
  - Documento del grupo «Proyecto Colegio Técnico con departamentos separados» (PDF de 47 páginas), páginas 17–32.
  - Informe de implementación CTCR, pasos 2 a 6 (PDF de 8 páginas), figuras 2, 5 y 6.
  - Los documentos fuente contienen datos personales y permanecen fuera de Git.

## Qué se hizo

1. **Capturas re-saneadas.** EV-039, EV-040, EV-043 y EV-044 estaban casi totalmente tapadas y no probaban nada. Se volvieron a extraer del PDF original ocultando **solo** los correos personales; el resto son datos ficticios `@ctcr.example`.
2. **21 capturas nuevas** (EV-075 a EV-095), extraídas, saneadas y con ficha propia:
   - 06-03: EV-075 (los tres cursos en «Mis cursos»).
   - 06-05: EV-076 (ruta a crear usuario).
   - 06-06: EV-077 (asignar miembros a una cohorte).
   - 06-07: EV-078 a EV-089 (plugin de cohortes, métodos de matrícula, sincronización, matrícula manual del profesor y participantes finales de los tres cursos) y EV-090, EV-091 (incidente).
   - 06-08: EV-092 a EV-095 (profesora denegada en otro curso y PDF de Informática denegado por URL directa).
3. **Privacidad:** se ocultaron correos personales (gmail) de cuentas de integrantes en EV-039, EV-040, EV-077, EV-086 y en la evidencia ya publicada EV-056, y el historial del navegador en EV-093. Se retiró del registro de 06-05 la contraseña de laboratorio que figuraba en texto plano.
4. **Incidente documentado:** [INC-011](../incidentes/INC-011-moodle-matricula-cohorte-incorrecta.md), estudiantes de Docencia matriculados en Administración.
5. **Procedimientos reescritos:** 06-05 a 06-08 con pasos numerados, para qué sirve cada pantalla, resultado esperado y referencia a cada captura; 06-01 a 06-04 con propósito específico y valores finales. Se eliminó de 06-08 un bloque del paso 7 que había quedado pegado por error.
6. Matriz de requisitos, ESTADO, catálogo y manifiestos actualizados.

## Resultado observado en las capturas incorporadas

| Prueba | Resultado | Evidencia |
|---|---|---|
| Plugin «Sincronizar cohorte» habilitado | Sí | EV-079 |
| Invitados y auto-matriculación en el curso | Desactivados | EV-082, EV-085 |
| Participantes ADM / DOC / INF | Solo su cohorte y su profesor | EV-087, EV-088, EV-089 |
| Profesora de ADM abre curso DOC | Denegado | EV-092 |
| Estudiante de ADM abre PDF de INF por URL directa | Denegado | EV-095 |

## Pendiente

- Completar la matriz 3×3 con capturas de Docencia e Informática hacia los otros cursos.
- Prueba RX-01: un profesor no puede abrir `/admin/`.
- Unificar el rol del administrador en los tres cursos (aparece como Estudiante en ADM y DOC y como Profesor en INF).
- Revisión de esta sesión por otra integrante.
