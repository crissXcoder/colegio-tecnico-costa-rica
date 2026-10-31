# Catálogo maestro de evidencias históricas — CTCR / Elevaquitas

> Este catálogo es un **índice**, no un depósito de imágenes. Cada captura reside en `docs/procedimientos/<fase>/<paso>/evidencias/` junto al paso al que pertenece, con ficha propia, explicación, origen y límites probatorios.

## Cómo interpretar las evidencias

Una captura de una interfaz muestra que se abrió o editó esa pantalla, pero no verifica automáticamente persistencia, autorización, seguridad ni reproducibilidad en cinco VMs. La validación de aceptación requiere resultados observados de las pruebas definidas en cada paso.

## Ubicación y significado de las 130 capturas (EV-001 a EV-130)

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

- **[EV-075 — «Mis cursos» con los tres cursos departamentales](../docs/procedimientos/06-moodle/06-03/evidencias/EV-075.md)** (p. 25): Página «Mis cursos» (`my/courses.php`) del administrador con tres tarjetas: «Gestión Documental y Procesos Administrativos» (categoría Administración), «Planificación Didáctica y Evaluación de los Aprendizajes» (Docencia) y «Seguridad Digital y Protección de la Información» (Informática).

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

- **[EV-038 — Formulario «Crear un nuevo usuario»](../docs/procedimientos/06-moodle/06-05/evidencias/EV-038.md)** (p. 18): Formulario vacío de Moodle en `user/editadvanced.php?id=-1` (sitio todavía llamado «Colegio Tecnico»). Se ven los campos que hay que llenar para cada cuenta: nombre de usuario, método de identificación «Cuentas manuales», casilla «Generar contraseña y notificar al usuario», nueva contraseña con su política (mínimo 8 caracteres, 1 dígito, 1 minúscula, 1 mayúscula y 1 carácter especial), «Forzar cambio de contraseña», nombre, apellidos y dirección de correo.
- **[EV-039 — Lista de usuarios después de guardar la primera cuenta](../docs/procedimientos/06-moodle/06-05/evidencias/EV-039.md)** (p. 18): En `admin/user.php` aparece el aviso verde «Cambios actualizados» y la tabla con dos cuentas: «Administrador Usuario» (`admin@example.com`, último acceso hace 58 segundos) y la cuenta personal de una integrante del grupo, cuyo correo se ocultó. Es el estado inmediatamente posterior a guardar el formulario de EV-038.

- **[EV-040 — Lista completa de cuentas institucionales](../docs/procedimientos/06-moodle/06-05/evidencias/EV-040.md)** (p. 19): Lista «Examinar lista de usuarios» del sitio «Colegio Técnico de Costa Rica» con 11 cuentas: el administrador, las 9 cuentas ficticias de DATOS-MAESTROS (Andrea Castillo Mora, Carlos Méndez Rojas, Daniel Vargas Chacón, Diego Fernández Ruiz, José Ramírez Salazar, Laura Rodríguez Vargas, Marta Jiménez Solano, Sofía Hernández Vega y Valeria Sánchez López, todas con correo `@ctcr.example`) y una cuenta personal de una integrante con el correo oculto. Todas las cuentas institucionales muestran «Nunca» como último acceso.

- **[EV-056 — Cuentas departamentales registradas en Moodle](../docs/procedimientos/06-moodle/06-05/evidencias/EV-056.md)**: Las 9 identidades institucionales con nombres completos reales y correo institucional.

- **[EV-076 — Ruta a «Crear un nuevo usuario»](../docs/procedimientos/06-moodle/06-05/evidencias/EV-076.md)** (p. 17): Administración del sitio → pestaña **Usuarios** → bloque **Cuentas**, con una flecha roja sobre el enlace «Crear un nuevo usuario». En el mismo bloque se ven «Examinar lista de usuarios» y «Cohortes», que se usan en los pasos siguientes.

### [06-06 — PASO 06.06 — Crear las cohortes departamentales](../docs/procedimientos/06-moodle/06-06.md)

- **[EV-041 — Navegación a cohortes](../docs/procedimientos/06-moodle/06-06/evidencias/EV-041.md)** (p. 19): Se observa en Moodle la pantalla correspondiente a «Navegación a cohortes»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida la sincronización de matrícula ni aislamiento. Las cohortes no restringen el acceso por sí solas.
- **[EV-042 — Creación de una cohorte](../docs/procedimientos/06-moodle/06-06/evidencias/EV-042.md)** (p. 20): Se observa en Moodle la pantalla correspondiente a «Creación de una cohorte»; evidencia que el grupo navegó/configuró esta sección del LMS. **Limitación:** No valida la sincronización de matrícula ni aislamiento. Las cohortes no restringen el acceso por sí solas.
- **[EV-043 — Tres cohortes creadas, todavía vacías](../docs/procedimientos/06-moodle/06-06/evidencias/EV-043.md)** (p. 20): Pantalla «Cohortes del sistema» (`cohort/index.php?contextid=1`) con las tres cohortes: Personal de Administración (`CTCR-COH-ADM`), Personal de Docencia (`CTCR-COH-DOC`) y Personal de Informática (`CTCR-COH-INF`). Las tres tienen «Tamaño de la cohorte» 0 y origen «Creada manualmente».

- **[EV-044 — Menú «Asignar» de la cohorte de Informática](../docs/procedimientos/06-moodle/06-06/evidencias/EV-044.md)** (p. 21): Lista de cohortes en un momento intermedio: `CTCR-COH-ADM` y `CTCR-COH-DOC` ya tienen 2 miembros y `CTCR-COH-INF` todavía 0. Está abierto el menú ⋮ de la cohorte de Informática (marca 1) con las opciones Ocultar, Editar, Borrar y **Asignar** (marca 2).

- **[EV-057 — Cohortes institucionales creadas a nivel de sistema](../docs/procedimientos/06-moodle/06-06/evidencias/EV-057.md)**: Cohortes CTCR-COH-ADM, CTCR-COH-DOC y CTCR-COH-INF con 2 estudiantes cada una.

- **[EV-077 — Asignar miembros a la cohorte «Personal de Informática»](../docs/procedimientos/06-moodle/06-06/evidencias/EV-077.md)** (p. 21): Pantalla `cohort/assign.php?id=3` «Miembros de la cohorte 'Personal de Informática'». A la izquierda, «Usuarios actuales: Ninguno»; a la derecha, «Usuarios potenciales (11)». Está seleccionada Valeria Sánchez López (marca 1) y señalado el botón **◄ Añadir** (marca 2). Arriba, Moodle advierte en rojo que quitar usuarios de una cohorte puede darlos de baja de los cursos sincronizados.

### [06-07 — PASO 06.07 — Configurar la matrícula por cohorte](../docs/procedimientos/06-moodle/06-07.md)

- **[EV-058 — Matrícula autorizada por cohorte y profesor manual](../docs/procedimientos/06-moodle/06-07/evidencias/EV-058.md)**: Participantes de CTCR-INF-101 con roles asignados estrictamente (cohorte estudiantes, profesor manual).

- **[EV-078 — Ubicar la sección «Matriculaciones» en Extensiones](../docs/procedimientos/06-moodle/06-07/evidencias/EV-078.md)** (p. 22): Administración del sitio → pestaña **Extensiones** (señalada). Más abajo, recuadrada, la sección **Matriculaciones** con los enlaces Gestionar plugins de matriculación, Acceso de invitados, Auto-matriculación, Matriculación manual y Sincronizar cohorte.

- **[EV-079 — Plugin «Sincronizar cohorte» habilitado a nivel de sitio](../docs/procedimientos/06-moodle/06-07/evidencias/EV-079.md)** (p. 23): «Categoría: Matriculaciones → Gestionar plugins de matriculación» (`admin/category.php?category=enrolments`). La tabla muestra Matriculación manual (3/3), Acceso de invitados (3/0), Auto-matriculación (3/0) y **Sincronizar cohorte (0/0)**, recuadrado y con el ojo de «Habilitar» activo, versión 2024100700. Los demás conectores (Base de datos externa, LDAP, CSV, pago, etc.) aparecen deshabilitados.

- **[EV-080 — Abrir «Participantes» del curso de Administración](../docs/procedimientos/06-moodle/06-07/evidencias/EV-080.md)** (p. 25): Curso «Gestión Documental y Procesos Administrativos» (`course/view.php?id=2`) con sus secciones (General, Fundamentos de gestión documental, Clasificación y custodia de expedientes, Evaluación de conocimientos) y la pestaña **Participantes** recuadrada.

- **[EV-081 — Menú hacia «Métodos de matriculación»](../docs/procedimientos/06-moodle/06-07/evidencias/EV-081.md)** (p. 26): En Participantes (`user/index.php?id=2`) está abierto el desplegable «Usuarios matriculados» (marca 1) y señalada la opción **Métodos de matriculación** (marca 2). En ese momento el único participante es Administrador Usuario con rol Profesor.

- **[EV-082 — Métodos de matriculación iniciales del curso](../docs/procedimientos/06-moodle/06-07/evidencias/EV-082.md)** (p. 26): `enrol/instances.php?id=2`: Matriculación manual (1 usuario), Acceso de invitados (0) y Auto-matriculación (Estudiante) (0). Las dos últimas filas aparecen en gris, es decir, desactivadas. Abajo está recuadrado el selector **Añadir método**.

- **[EV-083 — Elegir «Sincronizar cohorte» en «Añadir método»](../docs/procedimientos/06-moodle/06-07/evidencias/EV-083.md)** (p. 27): Desplegable «Añadir método» abierto con las opciones Elegir…, Auto-matriculación y **Sincronizar cohorte** (recuadrada).

- **[EV-084 — Formulario «Sincronizar cohorte» para Administración](../docs/procedimientos/06-moodle/06-07/evidencias/EV-084.md)** (p. 5): `enrol/editinstance.php?type=cohort&courseid=2` en el curso «Gestión Documental y Procesos Administrativos»: Activa = Sí, Cohorte = **Personal de Administración**, Asignar rol = **Estudiante**, Agregar al grupo = Ninguno, y el botón «Añadir método».

- **[EV-085 — Sincronización de cohorte creada (2 usuarios)](../docs/procedimientos/06-moodle/06-07/evidencias/EV-085.md)** (p. 28): Métodos de matriculación del curso de Administración: Matriculación manual (1), Acceso de invitados (0, desactivado), Auto-matriculación (Estudiante) (0, desactivada) y una nueva fila **«Sincronizar cohorte (Personal de Administración - Estudiante)» con 2 usuarios**.

- **[EV-086 — Matrícula manual de la profesora con rol «Profesor»](../docs/procedimientos/06-moodle/06-07/evidencias/EV-086.md)** (p. 28): «Gestionar inscripciones manuales» del curso de Administración. A la izquierda, «Usuarios matriculados (1)»: Administrador Usuario. Al centro, el selector «Asignar rol» abierto con Ninguno, Gestor, **Profesor** (recuadrado), Profesor sin permiso de edición y Estudiante, y el botón **◄ Añadir** recuadrado. A la derecha, «Usuarios no matriculados (10)».

- **[EV-087 — Participantes finales de Gestión Documental (ADM)](../docs/procedimientos/06-moodle/06-07/evidencias/EV-087.md)** (p. 29): Participantes del curso «Gestión Documental y Procesos Administrativos»: 4 participantes. Marta Jiménez Solano y Carlos Méndez Rojas como **Estudiante**, Laura Rodríguez Vargas como **Profesor** y Administrador Usuario como Estudiante. Ya no aparecen Sofía ni José (ver INC-011).

- **[EV-088 — Participantes finales de Planificación Didáctica (DOC)](../docs/procedimientos/06-moodle/06-07/evidencias/EV-088.md)** (p. 29): Participantes del curso «Planificación Didáctica y Evaluación de los Aprendizajes»: 4 participantes. Andrea Castillo Mora como **Profesor**, Sofía Hernández Vega y José Ramírez Salazar como **Estudiante** y Administrador Usuario como Estudiante.

- **[EV-089 — Participantes finales de Seguridad Digital (INF)](../docs/procedimientos/06-moodle/06-07/evidencias/EV-089.md)** (p. 30): Participantes del curso de Informática: 4 participantes. Diego Fernández Ruiz y Valeria Sánchez López como **Estudiante**, Administrador Usuario como Profesor y Daniel Vargas Chacón como **Profesor**.

- **[EV-090 — INC-011: estudiantes de Docencia matriculados en Administración](../docs/procedimientos/06-moodle/06-07/evidencias/EV-090.md)** (p. 7): Participantes del curso «Gestión Documental y Procesos Administrativos» con **6 participantes**: además de Marta, Carlos, Laura y el administrador, aparecen Sofía Hernández Vega y José Ramírez Salazar como Estudiante. Las casillas de Sofía y José están marcadas.

- **[EV-091 — INC-011: «eliminado de la selección» no desmatricula](../docs/procedimientos/06-moodle/06-07/evidencias/EV-091.md)** (p. 7): La misma lista tras intentar quitar a Sofía y José: Moodle muestra los avisos «Usuario 'Sofía Hernández Vega' eliminado de la selección», «Usuario 'José Ramírez Salazar' eliminado de la selección» y «No hay usuarios seleccionados», pero siguen apareciendo **6 participantes** encontrados.

### [06-08 — PASO 06.08 — Comprobar el aislamiento](../docs/procedimientos/06-moodle/06-08.md)

- **[EV-059 — Acceso legítimo de estudiante a su curso departamental](../docs/procedimientos/06-moodle/06-08/evidencias/EV-059.md)**: Marta Jiménez ingresando con éxito a CTCR-ADM-101.

- **[EV-060 — Denegación estricta de acceso a curso ajeno](../docs/procedimientos/06-moodle/06-08/evidencias/EV-060.md)**: Bloqueo explícito «No se puede matricular en este curso» al intentar acceder a CTCR-INF-101.

- **[EV-061 — Evaluación completada por estudiante](../docs/procedimientos/06-moodle/06-08/evidencias/EV-061.md)**: Intento finalizado por Valeria Sánchez con 100.00 / 100.00.

- **[EV-062 — Informe del calificador visualizado por profesor](../docs/procedimientos/06-moodle/06-08/evidencias/EV-062.md)**: Daniel Vargas revisando la nota de Valeria Sánchez en el calificador.

- **[EV-092 — Profesora de Administración sin acceso al curso de Docencia](../docs/procedimientos/06-moodle/06-08/evidencias/EV-092.md)** (p. 30): Sesión de Laura Rodríguez Vargas (avatar «LR», profesora de Administración) abriendo el curso de Docencia: Moodle la redirige a `enrol/index.php?id=3` «Planificación Didáctica y Evaluación de los Aprendizajes – Opciones de matriculación», indica «Profesor: Andrea Castillo Mora» y el mensaje **«No se puede auto matricular en este curso»**, con un único botón «Continuar».

- **[EV-093 — El administrador copia la URL directa del PDF de Informática](../docs/procedimientos/06-moodle/06-08/evidencias/EV-093.md)** (p. 31): En la VM cliente (`linux_mint_clon`), con sesión de administrador, está abierto el PDF «Curso_Informatica_Seguridad_Basica.pdf» y seleccionada su URL directa: `http://192.168.50.1:8080/pluginfile.php/26/mod_resource/content/1/Curso_Informatica_Seguridad_Basica.pdf`. Debajo se ve parte del contenido («Propósito de la guía», «Al finalizar podrás»).

- **[EV-094 — Marta dentro de su curso de Administración](../docs/procedimientos/06-moodle/06-08/evidencias/EV-094.md)** (p. 31): Sesión de Marta Jiménez Solano (avatar «MJ») en `course/view.php?id=2`, «Gestión Documental y Procesos Administrativos». Ve Avisos, la sección «Clasificación y custodia de expedientes» con «Guía de clasificación documental» (PDF) y «Procedimiento institucional para la clasificación y custodia de expedientes», y «Evaluación de Gestión Documental Institucional». Su menú no muestra «Administración del sitio».

- **[EV-095 — Marta no puede abrir el PDF de Informática por URL directa](../docs/procedimientos/06-moodle/06-08/evidencias/EV-095.md)** (p. 32): Con la sesión de Marta («MJ») se pega la URL copiada en EV-093 (`pluginfile.php/26/mod_resource/content/1/Curso_Informatica_Seguridad_Basica.pdf`). Moodle no entrega el archivo: muestra la página de error «Colegio Técnico de Costa Rica — Lo sentimos, el archivo solicitado no se encuentra» con el enlace «Más información sobre este error» y el botón «Continuar».

## Bloque 07 — DNS privado BIND9

### [07-01 — PASO 07.01 — Instalar BIND9 en Ubuntu](../docs/procedimientos/07-dns-bind9/07-01.md)

- **[EV-107 — Versión de BIND9 e interfaces del servidor](../docs/procedimientos/07-dns-bind9/07-01/evidencias/EV-107.md)** (VM `server@server`): `named -v` devuelve `BIND 9.20.24-1ubuntu0.4-Ubuntu (Stable Release)`. `ip -4 addr` muestra `lo` 127.0.0.1, `enp0s3` 10.0.2.15/24 (NAT), `enp0s8` 192.168.50.1/24 (red interna), `docker0` 172.17.0.1/16 en estado DOWN y dos redes de Docker `br-…` (172.18.0.1/16 y 172.19.0.1/16).

  ![EV-107](../docs/procedimientos/07-dns-bind9/07-01/evidencias/EV-107.webp)

- **[EV-108 — Estado de named y puertos 53 antes de configurar](../docs/procedimientos/07-dns-bind9/07-01/evidencias/EV-108.md)** (VM `server@server`): `systemctl status named`: `active (running)` desde el sábado 2026-10-24 16:18:52 CST y `enabled`. Los registros repiten `network unreachable resolving '…/AAAA/IN'`. `ss` muestra a `named` escuchando el puerto 53 en `::1` y en direcciones IPv6 de `enp0s3`, `enp0s8`, los puentes de Docker y varias interfaces `veth`.

  ![EV-108](../docs/procedimientos/07-dns-bind9/07-01/evidencias/EV-108.webp)

### [07-02 — PASO 07.02 — Configurar las opciones DNS](../docs/procedimientos/07-dns-bind9/07-02.md)

- **[EV-109 — Copia de seguridad y bloque options de BIND9](../docs/procedimientos/07-dns-bind9/07-02/evidencias/EV-109.md)** (VM `server@server`): Se copia `named.conf.options` a `named.conf.options.bak` y se reemplaza el bloque `options`: `recursion yes`; `allow-query` y `allow-recursion` para `127.0.0.1` y `192.168.50.0/24`; `listen-on { 192.168.50.1; }`; `listen-on-v6 { none; }`; `forwarders` 8.8.8.8 y 1.1.1.1; `dnssec-validation auto`.

  ![EV-109](../docs/procedimientos/07-dns-bind9/07-02/evidencias/EV-109.webp)

### [07-03 — PASO 07.03 — Registrar la zona del proyecto](../docs/procedimientos/07-dns-bind9/07-03.md)

- **[EV-110 — Zona ctcr registrada junto a zonas de otras prácticas](../docs/procedimientos/07-dns-bind9/07-03/evidencias/EV-110.md)** (VM `server@server`): `named.conf.local` ya contenía las zonas `hobbier.internal`, `salazarchavarria.internal` y `examenkrystel.internal` de prácticas anteriores. Al final se agrega, recuadrada, `zone "ctcr" { type master; file "/etc/bind/db.ctcr"; allow-transfer { none; }; };`.

  ![EV-110](../docs/procedimientos/07-dns-bind9/07-03/evidencias/EV-110.webp)

### [07-04 — PASO 07.04 — Crear el archivo de zona](../docs/procedimientos/07-dns-bind9/07-04.md)

- **[EV-111 — Archivo de zona db.ctcr](../docs/procedimientos/07-dns-bind9/07-04/evidencias/EV-111.md)** (VM `server@server`): `/etc/bind/db.ctcr` con `$TTL 604800`, SOA `ns1.ctcr. admin.ctcr.` con serial `2026102401` y tiempos 604800/86400/2419200/604800, `NS ns1.ctcr.`, `ns1 A 192.168.50.1` y `aulavirtual A 192.168.50.1`.

  ![EV-111](../docs/procedimientos/07-dns-bind9/07-04/evidencias/EV-111.webp)

### [07-05 — PASO 07.05 — Validar BIND9](../docs/procedimientos/07-dns-bind9/07-05.md)

- **[EV-063 — Validación sintáctica de opciones y zonas en BIND9](../docs/procedimientos/07-dns-bind9/07-05/evidencias/EV-063.md)**: Validación de `named-checkconf` (código 0) y `named-checkzone ctcr /etc/bind/db.ctcr` (`OK`, serial `2026102401`), estado del servicio `active (running)` y socket en `192.168.50.1:53` delimitado para convivir con `systemd-resolved`. **Limitación:** Prueba de configuración y servicio en el servidor; no certifica resolución desde clientes de la red interna.

- **[EV-112 — Validación y reinicio de BIND9](../docs/procedimientos/07-dns-bind9/07-05/evidencias/EV-112.md)** (VM `server@server`): `named-checkconf` sin salida (correcto); `named-checkzone ctcr /etc/bind/db.ctcr` → `zone ctcr/IN: loaded serial 2026102401` y `OK`; `systemctl restart named`; `systemctl is-active named` → `active`.

  ![EV-112](../docs/procedimientos/07-dns-bind9/07-05/evidencias/EV-112.webp)

### [07-06 — PASO 07.06 — Probar el DNS desde Ubuntu](../docs/procedimientos/07-dns-bind9/07-06.md)

- **[EV-064 — Comprobación de resolución DNS local en Ubuntu Server](../docs/procedimientos/07-dns-bind9/07-06/evidencias/EV-064.md)**: Consultas `dig @192.168.50.1 aulavirtual.ctcr +short` y `ns1.ctcr` devolviendo `192.168.50.1`, con registro SOA autoritativo cargado. **Limitación:** Consulta local en el servidor autoritativo; no valida la configuración del resolver en Linux Mint.

- **[EV-113 — Consulta autoritativa con dig desde Ubuntu](../docs/procedimientos/07-dns-bind9/07-06/evidencias/EV-113.md)** (VM `server@server`): `dig @192.168.50.1 aulavirtual.ctcr`: `status: NOERROR`, banderas `qr aa rd ra`, respuesta `aulavirtual.ctcr. 604800 IN A 192.168.50.1`, `SERVER: 192.168.50.1#53` y fecha `Sat Oct 24 19:21:51 CST 2026`.

  ![EV-113](../docs/procedimientos/07-dns-bind9/07-06/evidencias/EV-113.webp)

### [07-07 — PASO 07.07 — Configurar Linux Mint para utilizar BIND9](../docs/procedimientos/07-dns-bind9/07-07.md)

- **[EV-065 — Configuración y resolución DNS remota desde Linux Mint](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-065.md)**: Resolución exitosa en Mint mediante `dig` y `getent ahostsv4 aulavirtual.ctcr` apuntando a `192.168.50.1`, con ping al 0% de pérdida (2 paquetes transmitidos y recibidos). **Limitación:** Prueba de capa de red y DNS; no certifica disponibilidad de servicios HTTP/HTTPS en ese puerto.
- **[EV-066 — Captura de escritorio de Linux Mint resolviendo el dominio institucional](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-066.md)**: Vista completa de escritorio Cinnamon en Linux Mint demostrando resolución y conectividad hacia el Aula Virtual. **Limitación:** Evidencia visual de terminal en cliente; no sustituye la verificación de certificados TLS ni la navegación en navegador.

- **[EV-114 — Dos clientes Mint del grupo usan el DNS del servidor](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-114.md)** (VM `server@server`): En el Mint de Greilyn, `nmcli connection show --active` lista «Wired connection 1» en `enp0s8` y «netplan-enp0s3» en `enp0s3`. En el Mint de Angélica, `nmcli device show enp0s3 | grep IP4.DNS` → `192.168.50.1`; `dig @192.168.50.1 aulavirtual.ctcr +short` → `192.168.50.1`; `getent ahostsv4 aulavirtual.ctcr` → `192.168.50.1` (STREAM, DGRAM, RAW).

  ![EV-114](../docs/procedimientos/07-dns-bind9/07-07/evidencias/EV-114.webp)

## Bloque 08 — Nginx, VirtualHost y HTTPS

### [08-01 — PASO 08.01 — Instalar Nginx](../docs/procedimientos/08-https-nginx/08-01.md)

- **[EV-115 — Versión de Nginx instalada](../docs/procedimientos/08-https-nginx/08-01/evidencias/EV-115.md)** (VM `server@server`): `nginx -v` → `nginx version: nginx/1.28.3 (Ubuntu)`.

  ![EV-115](../docs/procedimientos/08-https-nginx/08-01/evidencias/EV-115.webp)

### [08-02 — PASO 08.02 — Crear el certificado](../docs/procedimientos/08-https-nginx/08-02.md)

- **[EV-116 — Certificado autofirmado con SAN y clave protegida](../docs/procedimientos/08-https-nginx/08-02/evidencias/EV-116.md)** (VM `server@server`): `mkdir -p /etc/nginx/certs`; `openssl req -x509 -nodes -days 365 -newkey rsa:3072 -keyout /etc/nginx/certs/aulavirtual.ctcr.key -out /etc/nginx/certs/aulavirtual.ctcr.crt -subj "/C=CR/O=Colegio Tecnico de Costa Rica/CN=aulavirtual.ctcr" -addext "subjectAltName=DNS:aulavirtual.ctcr"`; `chmod 600` sobre la clave.

  ![EV-116](../docs/procedimientos/08-https-nginx/08-02/evidencias/EV-116.webp)

### [08-03 — PASO 08.03 — Crear el VirtualHost](../docs/procedimientos/08-https-nginx/08-03.md)

- **[EV-117 — VirtualHost aulavirtual.ctcr](../docs/procedimientos/08-https-nginx/08-03/evidencias/EV-117.md)** (VM `server@server`): `/etc/nginx/sites-available/aulavirtual.ctcr` con dos bloques: `listen 192.168.50.1:80` que responde `return 301 https://$host$request_uri;`, y `listen 192.168.50.1:443 ssl` con el certificado y la clave, `ssl_protocols TLSv1.2 TLSv1.3`, `client_max_body_size 100M`, `proxy_pass http://127.0.0.1:8080`, cabeceras `Host`, `X-Real-IP`, `X-Forwarded-For` y `X-Forwarded-Proto https`, y tiempos de espera de 300 s.

  ![EV-117](../docs/procedimientos/08-https-nginx/08-03/evidencias/EV-117.webp)

### [08-04 — PASO 08.04 — Habilitar el sitio](../docs/procedimientos/08-https-nginx/08-04.md)

- **[EV-067 — Instalación de Nginx, Certificado SAN y Sintaxis](../docs/procedimientos/08-https-nginx/08-04/evidencias/EV-067.md)**: Instalación de Nginx 1.28.3, creación de certificado X.509 con extensión SAN (`aulavirtual.ctcr` y `moodle.ctcr.test`), verificación sintáctica `nginx -t` y servicio activo sin colisión con Apache2. **Limitación:** Certifica la configuración local y sintaxis en Ubuntu Server; no valida el enrutamiento del backend ni la navegación del cliente.

- **[EV-118 — Sitio habilitado y nginx -t correcto](../docs/procedimientos/08-https-nginx/08-04/evidencias/EV-118.md)** (VM `server@server`): `ln -s /etc/nginx/sites-available/aulavirtual.ctcr /etc/nginx/sites-enabled/aulavirtual.ctcr` y `nginx -t` → `syntax is ok` y `test is successful`.

  ![EV-118](../docs/procedimientos/08-https-nginx/08-04/evidencias/EV-118.webp)

### [08-05 — PASO 08.05 — Cambiar la URL de Moodle](../docs/procedimientos/08-https-nginx/08-05.md)

- **[EV-119 — Compose cambiado a 127.0.0.1:8080 y URL HTTPS](../docs/procedimientos/08-https-nginx/08-05/evidencias/EV-119.md)** (VM `server@server`): Se respalda el compose (`cp compose.yaml compose-http.backup.yaml`) y se edita el servicio `moodle`: `ports: "127.0.0.1:8080:8080"`, `MOODLE_URL: https://aulavirtual.ctcr` y `MOODLE_SSL_PROXY: "yes"`. Luego `docker compose config --quiet`, `up -d` (db Healthy, moodle Started) y `ps` con ambos `healthy` y moodle en `127.0.0.1:8080->8080/tcp`. La prueba por PHP CLI devuelve `https://aulavirtual.ctcr`.

  ![EV-119](../docs/procedimientos/08-https-nginx/08-05/evidencias/EV-119.webp)

- **[EV-120 — Error CLI_SCRIPT al consultar wwwroot](../docs/procedimientos/08-https-nginx/08-05/evidencias/EV-120.md)** (VM `server@server`): `docker compose exec moodle php -r 'require "/var/www/moodle/config.php"; echo $CFG->wwwroot, PHP_EOL;'` responde `Command line scripts must define CLI_SCRIPT before requiring config.php`.

  ![EV-120](../docs/procedimientos/08-https-nginx/08-05/evidencias/EV-120.webp)

### [08-06 — PASO 08.06 — Probar HTTPS desde Ubuntu](../docs/procedimientos/08-https-nginx/08-06.md)

- **[EV-068 — Docker Compose HTTPS, wwwroot Efectiva y Pruebas Curl](../docs/procedimientos/08-https-nginx/08-06/evidencias/EV-068.md)**: Moodle enlazado a `127.0.0.1:8080`, variable `MOODLE_URL=https://aulavirtual.ctcr`, verificación wwwroot y curl local comprobando redirección 301 en puerto 80 y respuesta 200 OK en 443. **Limitación:** Prueba de cabeceras HTTP locales; no certifica renderizado gráfico de la interfaz ni persistencia de sesión en el navegador cliente.

- **[EV-121 — HTTPS 200 desde Ubuntu con cookie segura](../docs/procedimientos/08-https-nginx/08-06/evidencias/EV-121.md)** (VM `server@server`): `curl -k -I --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr` → `HTTP/1.1 200 OK`, `Server: nginx/1.28.3 (Ubuntu)`, fecha `Tue, 27 Oct 2026 03:41:31 GMT` y `Set-Cookie: MoodleSession=…; path=/; secure; HttpOnly; SameSite=Lax`.

  ![EV-121](../docs/procedimientos/08-https-nginx/08-06/evidencias/EV-121.webp)

### [08-07 — PASO 08.07 — Abrir Moodle desde Linux Mint](../docs/procedimientos/08-https-nginx/08-07.md)

- **[EV-069 — Navegación Web en Mozilla Firefox bajo HTTPS](../docs/procedimientos/08-https-nginx/08-07/evidencias/EV-069.md)**: Acceso exitoso a `https://aulavirtual.ctcr/` en Firefox desde Linux Mint mostrando portada y cursos institucionales bajo TLS. **Limitación:** Prueba de visualización de portada; no verifica aislamiento de cursos por cohorte ni roles no privilegiados.
- **[EV-070 — Captura Visual de Escritorio en Linux Mint y Pruebas Curl](../docs/procedimientos/08-https-nginx/08-07/evidencias/EV-070.md)**: Entorno Cinnamon en Linux Mint ejecutando pruebas de terminal con redirección 301 a HTTPS y respuesta 200 OK. **Limitación:** Evidencia puntual de conectividad en cliente; no prueba transferencias seguras por otros protocolos como FTPS.

- **[EV-122 — Mint abre el aula por HTTPS y HTTP redirige](../docs/procedimientos/08-https-nginx/08-07/evidencias/EV-122.md)** (VM `server@server`): En el Mint de Greilyn: `getent ahostsv4 aulavirtual.ctcr` → `192.168.50.1`; Firefox abre `aulavirtual.ctcr` con el sitio «Colegio Tecnico» y la lista de cursos; `curl -I http://aulavirtual.ctcr` → `301 Moved Permanently` con `Location: https://aulavirtual.ctcr/`.

  ![EV-122](../docs/procedimientos/08-https-nginx/08-07/evidencias/EV-122.webp)

## Bloque 09 — Transferencia de archivos FTPS aislada

### [09-01 — PASO 09.01 — Instalar el servicio](../docs/procedimientos/09-ftps-vsftpd/09-01.md)

- **[EV-123 — Instalación de vsftpd esperando el bloqueo de APT](../docs/procedimientos/09-ftps-vsftpd/09-01/evidencias/EV-123.md)** (VM `server@server`): `apt install -y vsftpd` repite `Waiting for cache lock: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 3165 (unattended-upgr)`. Después, `vsftpd -v` → `vsftpd: version 3.0.5`.

  ![EV-123](../docs/procedimientos/09-ftps-vsftpd/09-01/evidencias/EV-123.webp)

### [09-02 — PASO 09.02 — Crear usuarios FTP](../docs/procedimientos/09-ftps-vsftpd/09-02.md)

- **[EV-124 — Cuentas FTP con guion bajo y shell nologin](../docs/procedimientos/09-ftps-vsftpd/09-02/evidencias/EV-124.md)** (VM `server@server`): `adduser` crea `marta_jimenez`, `carlos_mendez` (Administración), `sofia_hernandez`, `jose_ramirez` (Docencia), `valeria_sanchez` y `diego_fernandez` (Informática), pidiendo la contraseña sin mostrarla. Luego un ciclo `usermod -s /usr/sbin/nologin` para las seis.

  ![EV-124](../docs/procedimientos/09-ftps-vsftpd/09-02/evidencias/EV-124.webp)

### [09-03 — PASO 09.03 — Crear los directorios separados](../docs/procedimientos/09-ftps-vsftpd/09-03.md)

- **[EV-071 — Cuentas de Sistema, vsftpd 3.0.5 y Carpetas Privadas](../docs/procedimientos/09-ftps-vsftpd/09-03/evidencias/EV-071.md)**: Creación de las 6 cuentas departamentales con `/usr/sbin/nologin`, lista blanca en `/etc/vsftpd.user_list`, e infraestructura de enjaulamiento chroot con raíz `/srv/ftp/<usuario>` (`0755 root:root`) y carpetas de trabajo `/srv/ftp/<usuario>/archivos` (`0700`). **Limitación:** Prueba de aprovisionamiento de cuentas y permisos en el sistema de archivos; no valida la conexión por red ni la negociación TLS.

- **[EV-125 — Directorios por funcionario con permisos 700](../docs/procedimientos/09-ftps-vsftpd/09-03/evidencias/EV-125.md)** (VM `server@server`): `mkdir -p /srv/ftp` y un ciclo que, por usuario, crea `archivos/`, deja la raíz `/srv/ftp/$u` como `root:root 755`, la subcarpeta `archivos` como `$u:$u 700` y cambia el home con `usermod -d`. `ls -ld /srv/ftp/*/archivos` muestra `drwx------` para las seis cuentas (30 de octubre, 11:58 a 12:10).

  ![EV-125](../docs/procedimientos/09-ftps-vsftpd/09-03/evidencias/EV-125.webp)

### [09-05 — PASO 09.05 — Configurar vsftpd](../docs/procedimientos/09-ftps-vsftpd/09-05.md)

- **[EV-126 — nologin en /etc/shells y respaldo de vsftpd.conf](../docs/procedimientos/09-ftps-vsftpd/09-05/evidencias/EV-126.md)** (VM `server@server`): `grep -Fxq /usr/sbin/nologin /etc/shells || echo /usr/sbin/nologin | sudo tee -a /etc/shells` agrega la línea, y `cp /etc/vsftpd.conf /etc/vsftpd.conf.bak` guarda una copia antes de editar.

  ![EV-126](../docs/procedimientos/09-ftps-vsftpd/09-05/evidencias/EV-126.webp)

### [09-06 — PASO 09.06 — Reiniciar FTP](../docs/procedimientos/09-ftps-vsftpd/09-06.md)

- **[EV-127 — Reinicio de vsftpd](../docs/procedimientos/09-ftps-vsftpd/09-06/evidencias/EV-127.md)** (VM `server@server`): `systemctl restart vsftpd` y `systemctl is-active vsftpd` → `active`.

  ![EV-127](../docs/procedimientos/09-ftps-vsftpd/09-06/evidencias/EV-127.webp)

### [09-07 — PASO 09.07 — Probar un usuario FTP](../docs/procedimientos/09-ftps-vsftpd/09-07.md)

- **[EV-072 — Carga FTPS TLSv1.3 y Aislamiento en el Sistema de Archivos](../docs/procedimientos/09-ftps-vsftpd/09-07/evidencias/EV-072.md)**: Transferencia FTPS explícita bajo TLSv1.3 hacia la carpeta de trabajo del usuario y comprobación de denegación estricta de lectura (`Permiso denegado`) al intentar acceder a directorios de otros departamentos en Ubuntu Server. **Limitación:** Prueba local en el servidor; no valida la experiencia de conexión de red desde una máquina cliente remota.

- **[EV-128 — Subidas FTPS de tres departamentos](../docs/procedimientos/09-ftps-vsftpd/09-07/evidencias/EV-128.md)** (VM `server@server`): Se crean tres archivos de prueba (`expediente-administrativo.txt`, `planificacion-docente.txt`, `informe-soporte.txt`) y se suben con `curl --ssl-reqd --insecure --user <cuenta> --upload-file … ftp://192.168.50.1/archivos/…` como `marta_jimenez`, `sofia_hernandez` y `valeria_sanchez`. Las tres terminan al 100 % (43, 39 y 48 bytes); curl pide la contraseña sin mostrarla.

  ![EV-128](../docs/procedimientos/09-ftps-vsftpd/09-07/evidencias/EV-128.webp)

### [09-08 — PASO 09.08 — Comprobar que los permisos funcionan](../docs/procedimientos/09-ftps-vsftpd/09-08.md)

- **[EV-073 — Pruebas Remotas FTPS TLSv1.3 y Bloqueo de Escape Chroot](../docs/procedimientos/09-ftps-vsftpd/09-08/evidencias/EV-073.md)**: Transferencias remotas seguras desde Linux Mint con curl FTPS TLSv1.3 y respuesta de error `550 Failed to change directory` ante intentos de directory traversal (`..`) hacia directorios ajenos. **Limitación:** Prueba por línea de comandos; no evalúa clientes gráficos FTP.
- **[EV-074 — Entorno de Pruebas y Transferencia FTPS en Escritorio](../docs/procedimientos/09-ftps-vsftpd/09-08/evidencias/EV-074.md)**: Captura de escritorio Cinnamon en Linux Mint demostrando sesión interactiva de validación remota FTPS y verificación de políticas de aislamiento. **Limitación:** Evidencia fotográfica de escritorio; complementa pero no sustituye las respuestas numéricas del protocolo RFC 959 / RFC 4217.

- **[EV-129 — Permiso denegado a la carpeta de otro departamento](../docs/procedimientos/09-ftps-vsftpd/09-08/evidencias/EV-129.md)** (VM `server@server`): `sudo -u marta_jimenez ls /srv/ftp/sofia_hernandez/archivos` → `ls: cannot open directory … Permission denied`.

  ![EV-129](../docs/procedimientos/09-ftps-vsftpd/09-08/evidencias/EV-129.webp)

## Bloque 10 — Copias verificables y restauración de ensayo

### [10-02 — PASO 10.02 — Crear el script de respaldo](../docs/procedimientos/10-respaldos/10-02.md)

- **[EV-096 — Creación y Sintaxis del Script de Respaldo](../docs/procedimientos/10-respaldos/10-02/evidencias/EV-096.md)**: Inspección de `/home/criss/proyecto-moodle/respaldo.sh` con permisos `0700`, volcado de MariaDB por tubería con compresión gzip, retención de 7 días y validación sintáctica `bash -n`. **Limitación:** Valida la estructura y sintaxis del script en disco; no certifica la ejecución real ni la generación exitosa de volcados.

### [10-04 — PASO 10.04 — Ejecutar un respaldo manual](../docs/procedimientos/10-respaldos/10-04.md)

- **[EV-097 — Respaldo Manual y Validación de Integridad Gzip](../docs/procedimientos/10-respaldos/10-04/evidencias/EV-097.md)**: Ejecución de `sudo ./respaldo.sh`, creación del archivo `ctcr_moodle_2026-10-30_16-46-51.sql.gz` (384 KB) en `/var/backups/moodle` y comprobación con `gzip -t`. **Limitación:** Certifica la generación del volcado y la integridad del archivo comprimido; no prueba la recuperabilidad relacional del esquema Moodle.

### [10-05 — PASO 10.05 — Programar Cron](../docs/procedimientos/10-respaldos/10-05.md)

- **[EV-098 — Programación Cron de Root y Zona Horaria Institucional](../docs/procedimientos/10-respaldos/10-05/evidencias/EV-098.md)**: Comprobación de zona horaria `America/Costa_Rica`, servicio cron activo y programación diaria a las 02:00 AM en crontab de root con redirección a log. **Limitación:** Prueba la programación y estado del servicio cron; no valida la importación del respaldo ante contingencias.

### [10-06 — PASO 10.06 — Probar una restauración sin dañar Moodle](../docs/procedimientos/10-respaldos/10-06.md)

- **[EV-099 — Restauración de Ensayo en moodle_restore_test y Validación de Tablas](../docs/procedimientos/10-respaldos/10-06/evidencias/EV-099.md)**: Creación de base de ensayo `moodle_restore_test`, descompresión e importación por tubería, comparación estructural con 494 tablas recuperadas (100% coincidencia) y posterior eliminación de la base de prueba. **Limitación:** Demuestra recuperabilidad del esquema relacional MariaDB; no cubre archivos persistentes de moodledata (archivos adjuntos).

## Bloque 11 — QA funcional y de infraestructura

### [11-01 — PASO 11.01 — Comprobar los contenedores](../docs/procedimientos/11-verificacion/11-01.md)

- **[EV-100 — Comprobación de salud en contenedores Docker y URL canónica wwwroot](../docs/procedimientos/11-verificacion/11-01/evidencias/EV-100.md)**: Salida de `docker compose ps` con ambos servicios (`db` y `moodle`) en estado saludable (`healthy`), y resolución de la URL canónica institucional `https://aulavirtual.ctcr` mediante script CLI superando la validación defensiva `CLI_SCRIPT`. **Limitación:** Prueba la salud interna de los contenedores en el host; la conectividad externa se verifica desde Linux Mint.

### [11-03 — PASO 11.03 — Comprobar los puertos](../docs/procedimientos/11-verificacion/11-03.md)

- **[EV-101 — Auditoría de servicios systemd y verificación de puertos de escucha ss](../docs/procedimientos/11-verificacion/11-03/evidencias/EV-101.md)**: Verificación de estado `active` en `named`, `nginx`, `vsftpd` y `cron`, junto con inventario exhaustivo de sockets abiertos con `ss -lntup` (21, 53, 80, 443 expuestos a la LAN; 8080 en loopback; 3306 de Docker aislado de la red). **Limitación:** Confirma que los procesos están escuchando localmente; la conectividad de transporte se valida desde el cliente.

### [11-04 — PASO 11.04 — Configurar y verificar el firewall](../docs/procedimientos/11-verificacion/11-04.md)

- **[EV-102 — Auditoría de reglas iptables, cadenas DOCKER-USER y NAT en Ubuntu Server](../docs/procedimientos/11-verificacion/11-04/evidencias/EV-102.md)**: Inspección de políticas de firewall en `iptables`, cadenas `DOCKER-USER` para tráfico LAN/WAN, persistencia con `netfilter-persistent` y diagnóstico de ausencia de UFW para evitar colisiones con Docker. **Limitación:** Prueba la configuración en el host; el enrutamiento real se valida con tráfico desde el cliente.

- **[EV-130 — UFW: comando no encontrado](../docs/procedimientos/11-verificacion/11-04/evidencias/EV-130.md)** (VM `server@server`): `sudo ufw status verbose` → `sudo: 'ufw': command not found`.

  ![EV-130](../docs/procedimientos/11-verificacion/11-04/evidencias/EV-130.webp)

### [11-05 — PASO 11.05 — Pruebas desde Linux Mint](../docs/procedimientos/11-verificacion/11-05.md)

- **[EV-103 — Pruebas de conectividad ICMP, resolución DNS y redirección HTTP 301 desde Linux Mint](../docs/procedimientos/11-verificacion/11-05/evidencias/EV-103.md)**: Comprobaciones remotas desde Linux Mint con ping al 0% de pérdida, resolución DNS autoritativa de `aulavirtual.ctcr` devolviendo `192.168.50.1`, redirección HTTP 301 hacia HTTPS y respuesta TLS 200 OK con cookies de sesión. **Limitación:** Prueba la capa de red y transporte web; no valida la lógica de autenticación ni los permisos de roles.

### [11-06 — PASO 11.06 — Pruebas de los departamentos](../docs/procedimientos/11-verificacion/11-06.md)

- **[EV-104 — Aislamiento departamental: acceso a ADM y rechazo estricto a recurso de INF por URL](../docs/procedimientos/11-verificacion/11-06/evidencias/EV-104.md)**: Ingreso exitoso de Marta Jiménez (Administración) a su curso `CTCR-ADM-101` y su PDF, seguido de rechazo inmediato y redirección a `enrol/index.php` al intentar acceder al curso o recurso directo de Informática. **Limitación:** Prueba el aislamiento entre Administración e Informática; el aislamiento global se verifica con la matriz 3×3 de matrículas.
- **[EV-105 — Cuestionarios completados en Docencia e Informática y calificador docente revisado](../docs/procedimientos/11-verificacion/11-06/evidencias/EV-105.md)**: Verificación de cuestionarios completados con nota 100/100 para Valeria Sánchez (Informática) y Sofía Hernández (Docencia) en `mdl_quiz_grades`, y auditoría docente de Daniel Vargas en el Calificador del curso. **Limitación:** Muestra la evaluación de los cuestionarios probados; no reemplaza la resolución interactiva de estudiantes futuros.

### [11-07 — PASO 11.07 — Pruebas de infraestructura](../docs/procedimientos/11-verificacion/11-07.md)

- **[EV-106 — Resiliencia de contenedores, jaula FTPS con error 550 y ensayo DRP con 494 tablas](../docs/procedimientos/11-verificacion/11-07/evidencias/EV-106.md)**: Demostración de persistencia tras reinicio de contenedores Docker (3 cursos intactos), bloqueo estricto en FTPS con error `550 Failed to change directory` al intentar salir del chroot, y ciclo de respaldo e importación DRP con 494 tablas recuperadas. **Limitación:** Valida resiliencia y base de datos relacional; la recuperación completa de archivos adjuntos requiere instantáneas del volumen `moodledata`.

## Alta de evidencias nuevas

No reutilizar IDs EV-001–EV-050. Guardar una imagen junto al paso correspondiente, crear una ficha con procedencia, comando/acción, esperado, observado, privacidad, fecha, host y revisor, registrar SHA-256 y actualizar `manifiesto-detallado.csv`. Si no se ha ejecutado una prueba, dejar estado **pendiente**.
