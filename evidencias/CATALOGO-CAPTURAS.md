# Catálogo maestro de evidencias históricas — Elevaquitas

> Este catálogo es un **índice**, no un depósito de imágenes. Cada captura reside en `docs/procedimientos/<fase>/<paso>/evidencias/` junto al paso al que pertenece, con ficha propia, explicación, origen y límites probatorios.

## Cómo interpretar las evidencias

Una captura de una interfaz muestra que se abrió o editó esa pantalla, pero no verifica automáticamente persistencia, autorización, seguridad ni reproducibilidad en cinco VMs. La validación de aceptación requiere resultados observados de las pruebas definidas en cada paso.

## Ubicación y significado de las 50 capturas

### [01-01 — PASO 01.01 — Topología NAT e interna y verificación entre Ubuntu y Mint](../docs/procedimientos/01-servidor-red/01-01.md)

- **[EV-001 — Mint: ping hacia Ubuntu Server](../docs/procedimientos/01-servidor-red/01-01/evidencias/EV-001.md)** (p. 2): La terminal de Linux Mint recibe respuestas ICMP de la IP interna de Ubuntu; evidencia una ruta de red en esa VM. **Limitación:** No certifica el resultado en las cinco VMs ni el cumplimiento del resto de requisitos.
- **[EV-002 — Ubuntu: ping hacia Mint](../docs/procedimientos/01-servidor-red/01-01/evidencias/EV-002.md)** (p. 2): Ubuntu recibe respuestas ICMP desde Linux Mint; se observa comunicación de retorno en la red de laboratorio. **Limitación:** No certifica el resultado en las cinco VMs ni el cumplimiento del resto de requisitos.
- **[EV-003 — Ubuntu: conectividad exterior](../docs/procedimientos/01-servidor-red/01-01/evidencias/EV-003.md)** (p. 3): Ubuntu muestra respuestas de un nombre público; es evidencia puntual de conectividad/resolución saliente. **Limitación:** No certifica el resultado en las cinco VMs ni el cumplimiento del resto de requisitos.

### [01-02 — PASO 01.02 — Estado de discos, LVM y recuperación del incidente histórico](../docs/procedimientos/01-servidor-red/01-02.md)

- **[EV-050 — Diagnóstico de disco lleno y ampliación LVM](../docs/procedimientos/01-servidor-red/01-02/evidencias/EV-050.md)** (p. 25): Se observa el diagnóstico de espacio, el estado LVM y comandos ejecutados para ampliar la raíz; corresponde al incidente INC-001. **Limitación:** No autoriza replicar cambios LVM en otra VM: requiere comprobar volumen, filesystem y copia de seguridad del equipo concreto.

### [04-02 — PASO 04.02 — Confirmar las versiones de las imágenes](../docs/procedimientos/04-contenedores/04-02.md)

- **[EV-004 — Etiquetas de las imágenes Docker verificadas](../docs/procedimientos/04-contenedores/04-02/evidencias/EV-004.md)** (p. 3): La terminal devuelve disponibilidad de las etiquetas solicitadas en el registro de imágenes. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.

### [04-03 — PASO 04.03 — Generar las contraseñas](../docs/procedimientos/04-contenedores/04-03.md)

- **[EV-005 — OpenSSL: generación del archivo privado .env](../docs/procedimientos/04-contenedores/04-03/evidencias/EV-005.md)** (p. 3): Se ven los comandos para generar el archivo privado .env y consultar OpenSSL; no se presenta su contenido. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.
- **[EV-006 — Protección de permisos del .env](../docs/procedimientos/04-contenedores/04-03/evidencias/EV-006.md)** (p. 3): Se aplica chmod 600 al .env; la captura no muestra una comprobación posterior con stat. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.

### [04-04 — PASO 04.04 — Crear el archivo Compose](../docs/procedimientos/04-contenedores/04-04.md)

- **[EV-007 — Primer bloque de configuración Compose](../docs/procedimientos/04-contenedores/04-04/evidencias/EV-007.md)** (p. 4): Se observa el archivo compose.yaml abierto en un editor; es evidencia de edición, no de sintaxis válida ni de ejecución. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.
- **[EV-008 — Segundo bloque de configuración Compose](../docs/procedimientos/04-contenedores/04-04/evidencias/EV-008.md)** (p. 5): Se observa el archivo compose.yaml abierto en un editor; es evidencia de edición, no de sintaxis válida ni de ejecución. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.

### [04-06 — PASO 04.06 — Descargar las imágenes](../docs/procedimientos/04-contenedores/04-06.md)

- **[EV-009 — Compose config, pull e imágenes](../docs/procedimientos/04-contenedores/04-06/evidencias/EV-009.md)** (p. 6): Se observa la secuencia de configuración y descarga de imágenes; confirma actividad en la terminal de esta VM. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.

### [04-07 — PASO 04.07 — Levantar los contenedores](../docs/procedimientos/04-contenedores/04-07.md)

- **[EV-010 — docker compose up y estado de los servicios](../docs/procedimientos/04-contenedores/04-07/evidencias/EV-010.md)** (p. 6): Se observa la creación/inicio de servicios y el listado de Compose; refleja un inicio de los contenedores. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.
- **[EV-011 — Registros iniciales de MariaDB](../docs/procedimientos/04-contenedores/04-07/evidencias/EV-011.md)** (p. 6): Se muestran logs del arranque/inicialización; sirven para explicar el proceso y diagnosticar errores de la primera ejecución. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.
- **[EV-012 — Registros de instalación de Moodle](../docs/procedimientos/04-contenedores/04-07/evidencias/EV-012.md)** (p. 6): Se muestran logs del arranque/inicialización; sirven para explicar el proceso y diagnosticar errores de la primera ejecución. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.

### [04-08 — PASO 04.08 — Confirmar la base de datos](../docs/procedimientos/04-contenedores/04-08.md)

- **[EV-013 — Inicio de sesión en MariaDB con credenciales del .env](../docs/procedimientos/04-contenedores/04-08/evidencias/EV-013.md)** (p. 7): Se observa el cliente MariaDB abierto contra la base moodle; la línea con credencial fue ocultada. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.
- **[EV-014 — Consulta SHOW TABLES de Moodle](../docs/procedimientos/04-contenedores/04-08/evidencias/EV-014.md)** (p. 7): SHOW TABLES enumera tablas con prefijo mdl_; confirma que existe un esquema Moodle inicializado en esa base. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.

### [04-09 — PASO 04.09 — Verificar los volúmenes](../docs/procedimientos/04-contenedores/04-09.md)

- **[EV-015 — Persistencia: docker volume ls](../docs/procedimientos/04-contenedores/04-09/evidencias/EV-015.md)** (p. 7): docker volume ls enumera los tres volúmenes esperados; prueba existencia de volúmenes, no integridad de sus contenidos. **Limitación:** No certifica que todos los integrantes tengan la misma versión/digest, salud estable o persistencia de datos.

### [05-02 — PASO 05.02 — Abrir Moodle desde Mint](../docs/procedimientos/05-cliente-mint/05-02.md)

- **[EV-016 — Pantalla inicial de Moodle](../docs/procedimientos/05-cliente-mint/05-02/evidencias/EV-016.md)** (p. 8): Se muestra la pantalla de inicio de sesión Moodle accesible desde el navegador. **Limitación:** No certifica el resultado en las cinco VMs ni el cumplimiento del resto de requisitos.
- **[EV-017 — Perfil del administrador Moodle](../docs/procedimientos/05-cliente-mint/05-02/evidencias/EV-017.md)** (p. 8): Se observa una pantalla autenticada del perfil administrativo Moodle; los datos privados deben revisarse antes de publicación. **Limitación:** No certifica el resultado en las cinco VMs ni el cumplimiento del resto de requisitos.

### [05-03 — PASO 05.03 — Probar la persistencia](../docs/procedimientos/05-cliente-mint/05-03.md)

- **[EV-018 — Recreación de contenedores para comprobar persistencia](../docs/procedimientos/05-cliente-mint/05-03/evidencias/EV-018.md)** (p. 8): Se observa la bajada y subida de servicios Docker; acredita ejecución de la maniobra de recreación. **Limitación:** No prueba por sí sola que después de reiniciar siguen los recursos cargados y la base íntegra; requiere una comprobación funcional adicional.

### [06-01 — PASO 06.01 — Personalizar la plataforma](../docs/procedimientos/06-moodle/06-01.md)

- **[EV-019 — Ajustes de la portada de Moodle](../docs/procedimientos/06-moodle/06-01/evidencias/EV-019.md)** (p. 9): Se observa en Moodle la pantalla correspondiente a «Ajustes de la portada de Moodle»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-045 — Navegación a personalización](../docs/procedimientos/06-moodle/06-01/evidencias/EV-045.md)** (p. 21): Se observa en Moodle la pantalla correspondiente a «Navegación a personalización»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-046 — Opción de editar la página principal](../docs/procedimientos/06-moodle/06-01/evidencias/EV-046.md)** (p. 22): Se observa en Moodle la pantalla correspondiente a «Opción de editar la página principal»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-047 — Información institucional del Colegio](../docs/procedimientos/06-moodle/06-01/evidencias/EV-047.md)** (p. 22): Se observa en Moodle la pantalla correspondiente a «Información institucional del Colegio»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-048 — Administración del sitio](../docs/procedimientos/06-moodle/06-01/evidencias/EV-048.md)** (p. 23): Se observa en Moodle la pantalla correspondiente a «Administración del sitio»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-049 — Menú de apariencia de Moodle](../docs/procedimientos/06-moodle/06-01/evidencias/EV-049.md)** (p. 23): Se observa en Moodle la pantalla correspondiente a «Menú de apariencia de Moodle»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-051 — Personalización de la portada institucional](../docs/procedimientos/06-moodle/06-01/evidencias/EV-051.md)**: Portada principal mostrando «Colegio Técnico de Costa Rica», tema Boost corporativo y catálogo de cursos.

### [06-02 — PASO 06.02 — Crear las categorías de cursos](../docs/procedimientos/06-moodle/06-02.md)

- **[EV-020 — Categorías de Administración, Docencia e Informática](../docs/procedimientos/06-moodle/06-02/evidencias/EV-020.md)** (p. 9): Se observa en Moodle la pantalla correspondiente a «Categorías de Administración, Docencia e Informática»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-052 — Categorías departamentales creadas en Moodle](../docs/procedimientos/06-moodle/06-02/evidencias/EV-052.md)**: Estructura de Administración (DEP-ADM), Docencia (DEP-DOC) e Informática (DEP-INF).

### [06-03 — PASO 06.03 — Crear los tres cursos](../docs/procedimientos/06-moodle/06-03.md)

- **[EV-021 — Gestión de cursos en Moodle](../docs/procedimientos/06-moodle/06-03/evidencias/EV-021.md)** (p. 10): Se observa en Moodle la pantalla correspondiente a «Gestión de cursos en Moodle»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-022 — Edición del curso de Docencia](../docs/procedimientos/06-moodle/06-03/evidencias/EV-022.md)** (p. 10): Se observa en Moodle la pantalla correspondiente a «Edición del curso de Docencia»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida por sí sola todos los cursos, rol de profesor, políticas de seguridad ni separación de accesos.
- **[EV-053 — Cursos institucionales asignados a sus categorías](../docs/procedimientos/06-moodle/06-03/evidencias/EV-053.md)**: Cursos CTCR-ADM-101, CTCR-DOC-101 y CTCR-INF-101 correctamente clasificados.

### [06-04 — PASO 06.04 — Agregar los recursos y actividades](../docs/procedimientos/06-moodle/06-04.md)

- **[EV-023 — Edición del curso de Informática](../docs/procedimientos/06-moodle/06-04/evidencias/EV-023.md)** (p. 10): Se observa en Moodle la pantalla correspondiente a «Edición del curso de Informática»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-024 — Selector de tipo de recurso](../docs/procedimientos/06-moodle/06-04/evidencias/EV-024.md)** (p. 11): Se observa en Moodle la pantalla correspondiente a «Selector de tipo de recurso»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-025 — Carga de recurso PDF en Moodle](../docs/procedimientos/06-moodle/06-04/evidencias/EV-025.md)** (p. 11): Se observa en Moodle la pantalla correspondiente a «Carga de recurso PDF en Moodle»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-026 — Secciones del curso de Informática](../docs/procedimientos/06-moodle/06-04/evidencias/EV-026.md)** (p. 12): Se observa en Moodle la pantalla correspondiente a «Secciones del curso de Informática»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-027 — Selector de actividades para cuestionario](../docs/procedimientos/06-moodle/06-04/evidencias/EV-027.md)** (p. 12): Se observa en Moodle la pantalla correspondiente a «Selector de actividades para cuestionario»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-028 — Configuración del cuestionario y puntuación](../docs/procedimientos/06-moodle/06-04/evidencias/EV-028.md)** (p. 13): Se observa en Moodle la pantalla correspondiente a «Configuración del cuestionario y puntuación»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-029 — Cuestionario creado en el curso](../docs/procedimientos/06-moodle/06-04/evidencias/EV-029.md)** (p. 13): Se observa en Moodle la pantalla correspondiente a «Cuestionario creado en el curso»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-030 — Pestaña de preguntas del cuestionario](../docs/procedimientos/06-moodle/06-04/evidencias/EV-030.md)** (p. 14): Se observa en Moodle la pantalla correspondiente a «Pestaña de preguntas del cuestionario»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-031 — Añadir pregunta al cuestionario](../docs/procedimientos/06-moodle/06-04/evidencias/EV-031.md)** (p. 14): Se observa en Moodle la pantalla correspondiente a «Añadir pregunta al cuestionario»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-032 — Selector de tipo de pregunta](../docs/procedimientos/06-moodle/06-04/evidencias/EV-032.md)** (p. 15): Se observa en Moodle la pantalla correspondiente a «Selector de tipo de pregunta»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-033 — Formulario de pregunta de opción múltiple](../docs/procedimientos/06-moodle/06-04/evidencias/EV-033.md)** (p. 15): Se observa en Moodle la pantalla correspondiente a «Formulario de pregunta de opción múltiple»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-034 — Opciones de respuesta](../docs/procedimientos/06-moodle/06-04/evidencias/EV-034.md)** (p. 16): Se observa en Moodle la pantalla correspondiente a «Opciones de respuesta»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-035 — Ponderación de respuesta correcta](../docs/procedimientos/06-moodle/06-04/evidencias/EV-035.md)** (p. 16): Se observa en Moodle la pantalla correspondiente a «Ponderación de respuesta correcta»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-036 — Vista del cuestionario creado](../docs/procedimientos/06-moodle/06-04/evidencias/EV-036.md)** (p. 17): Se observa en Moodle la pantalla correspondiente a «Vista del cuestionario creado»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-037 — Vista del cuestionario después de crear las preguntas](../docs/procedimientos/06-moodle/06-04/evidencias/EV-037.md)** (p. 17): Se observa en Moodle la pantalla correspondiente a «Vista del cuestionario después de crear las preguntas»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No confirma por sí sola dos recursos genuinos y una actividad evaluable terminada en cada uno de los tres cursos, ni un intento de estudiante calificado.
- **[EV-054 — Estructura académica de tres secciones en Informática](../docs/procedimientos/06-moodle/06-04/evidencias/EV-054.md)**: Curso CTCR-INF-101 con PDF institucional, Página interactiva y Cuestionario.
- **[EV-055 — Configuración y banco de preguntas del cuestionario](../docs/procedimientos/06-moodle/06-04/evidencias/EV-055.md)**: Cuestionario con 5 preguntas a 20 pts (100 total) y aprobación en 70.

### [06-05 — PASO 06.05 — Crear los usuarios de prueba](../docs/procedimientos/06-moodle/06-05.md)

- **[EV-038 — Navegación de administración a cuentas de usuario](../docs/procedimientos/06-moodle/06-05/evidencias/EV-038.md)** (p. 18): Se observa en Moodle la pantalla correspondiente a «Navegación de administración a cuentas de usuario»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No comprueba roles efectivos por contexto ni que las contraseñas/identidades sean adecuadas; requiere ensayo con cuentas no privilegiadas.
- **[EV-039 — Formulario de creación de usuario Moodle](../docs/procedimientos/06-moodle/06-05/evidencias/EV-039.md)** (p. 18): Se aprecia el flujo de administración de cuentas/cohortes con secciones ocultadas por privacidad; el área tapada no sirve como prueba legible de su contenido. **Limitación:** No comprueba roles efectivos por contexto ni que las contraseñas/identidades sean adecuadas; requiere ensayo con cuentas no privilegiadas.
- **[EV-040 — Lista ampliada de cuentas de usuario](../docs/procedimientos/06-moodle/06-05/evidencias/EV-040.md)** (p. 19): Se aprecia el flujo de administración de cuentas/cohortes con secciones ocultadas por privacidad; el área tapada no sirve como prueba legible de su contenido. **Limitación:** No comprueba roles efectivos por contexto ni que las contraseñas/identidades sean adecuadas; requiere ensayo con cuentas no privilegiadas.
- **[EV-056 — Cuentas departamentales registradas en Moodle](../docs/procedimientos/06-moodle/06-05/evidencias/EV-056.md)**: Las 9 identidades institucionales con nombres completos reales y correo institucional.

### [06-06 — PASO 06.06 — Crear las cohortes departamentales](../docs/procedimientos/06-moodle/06-06.md)

- **[EV-041 — Navegación a cohortes](../docs/procedimientos/06-moodle/06-06/evidencias/EV-041.md)** (p. 19): Se observa en Moodle la pantalla correspondiente a «Navegación a cohortes»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida la sincronización de matrícula ni aislamiento. Las cohortes no restringen el acceso por sí solas.
- **[EV-042 — Creación de una cohorte](../docs/procedimientos/06-moodle/06-06/evidencias/EV-042.md)** (p. 20): Se observa en Moodle la pantalla correspondiente a «Creación de una cohorte»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida la sincronización de matrícula ni aislamiento. Las cohortes no restringen el acceso por sí solas.
- **[EV-043 — Lista de cohortes departamentales](../docs/procedimientos/06-moodle/06-06/evidencias/EV-043.md)** (p. 20): Se aprecia el flujo de administración de cuentas/cohortes con secciones ocultadas por privacidad; el área tapada no sirve como prueba legible de su contenido. **Limitación:** No valida la sincronización de matrícula ni aislamiento. Las cohortes no restringen el acceso por sí solas.
- **[EV-044 — Gestión de usuarios asignados a cohortes](../docs/procedimientos/06-moodle/06-06/evidencias/EV-044.md)** (p. 21): Se aprecia el flujo de administración de cuentas/cohortes con secciones ocultadas por privacidad; el área tapada no sirve como prueba legible de su contenido. **Limitación:** No valida la sincronización de matrícula ni aislamiento. Las cohortes no restringen el acceso por sí solas.
- **[EV-057 — Cohortes institucionales creadas a nivel de sistema](../docs/procedimientos/06-moodle/06-06/evidencias/EV-057.md)**: Cohortes CTCR-COH-ADM, CTCR-COH-DOC y CTCR-COH-INF con 2 estudiantes cada una.

### [06-07 — PASO 06.07 — Configurar la matrícula por cohorte](../docs/procedimientos/06-moodle/06-07.md)

- **[EV-058 — Matrícula autorizada por cohorte y profesor manual](../docs/procedimientos/06-moodle/06-07/evidencias/EV-058.md)**: Participantes de CTCR-INF-101 con roles asignados estrictamente (cohorte estudiantes, profesor manual).

### [06-08 — PASO 06.08 — Comprobar el aislamiento](../docs/procedimientos/06-moodle/06-08.md)

- **[EV-059 — Acceso legítimo de estudiante a su curso departamental](../docs/procedimientos/06-moodle/06-08/evidencias/EV-059.md)**: Marta Jiménez ingresando con éxito a CTCR-ADM-101.
- **[EV-060 — Denegación estricta de acceso a curso ajeno](../docs/procedimientos/06-moodle/06-08/evidencias/EV-060.md)**: Bloqueo explícito «No se puede matricular en este curso» al intentar acceder a CTCR-INF-101.
- **[EV-061 — Evaluación completada por estudiante](../docs/procedimientos/06-moodle/06-08/evidencias/EV-061.md)**: Intento finalizado por Valeria Sánchez con 100.00 / 100.00.
- **[EV-062 — Informe del calificador visualizado por profesor](../docs/procedimientos/06-moodle/06-08/evidencias/EV-062.md)**: Daniel Vargas revisando la nota de Valeria Sánchez en el calificador.

## Bloque 07 — DNS privado BIND9

### [07-05 — PASO 07.05 — Validar BIND9](../docs/procedimientos/07-dns-bind9/07-05.md)

- **[EV-063 — Validación sintáctica de opciones y zonas en BIND9](../docs/procedimientos/07-dns-bind9/07-05/evidencias/EV-063.md)**: Validación de `named-checkconf` (código 0) y `named-checkzone ctcr /etc/bind/db.ctcr` (`OK`, serial `2026102401`), estado del servicio `active (running)` y socket en `192.168.50.1:53`.

### [07-06 — PASO 07.06 — Probar el DNS desde Ubuntu](../docs/procedimientos/07-dns-bind9/07-06.md)

- **[EV-064 — Comprobación de resolución DNS local en Ubuntu Server](../docs/procedimientos/07-dns-bind9/07-06/evidencias/EV-064.md)**: Consultas `dig @192.168.50.1 aulavirtual.ctcr +short` y `ns1.ctcr` devolviendo `192.168.50.1`, con registro SOA autoritativo.

### [07-07 — PASO 07.07 — Configurar Linux Mint para utilizar BIND9](../docs/procedimientos/07-dns-bind9/07-07.md)

- **[EV-065 — Configuración y resolución DNS remota desde Linux Mint](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-065.md)**: Resolución exitosa en Mint mediante `dig` y `getent ahostsv4 aulavirtual.ctcr` apuntando a `192.168.50.1`, con ping al 0% de pérdida.
- **[EV-066 — Captura de escritorio de Linux Mint resolviendo el dominio institucional](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-066.md)**: Vista completa de escritorio Cinnamon en Linux Mint demostrando resolución y conectividad hacia el Aula Virtual.

## Alta de evidencias nuevas

No reutilizar IDs EV-001–EV-050. Guardar una imagen junto al paso correspondiente, crear una ficha con procedencia, comando/acción, esperado, observado, privacidad, fecha, host y revisor, registrar SHA-256 y actualizar `manifiesto-detallado.csv`. Si no se ha ejecutado una prueba, dejar estado **pendiente**.
