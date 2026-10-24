# Datos maestros: lo que los cinco integrantes crean idéntico en cada VM

**Esta es la fuente única de nombres, usuarios, cursos, cohortes, cuentas FTP, dominio y certificado.** Los procedimientos enlazan aquí; si un dato difiere en otro archivo, este manda y el otro se corrige. Estado: **to-be acordado por el grupo** (2026-10-24). Nada de esto prueba que ya exista en una VM: la evidencia va en [ESTADO](ESTADO.md).

Todo es ficticio y para simulación académica. Los correos usan el dominio reservado `ctcr.example` (no recibe correo real).

## 1. Contraseñas: convención (no se escriben en Git)

- En este repositorio **nunca** va una contraseña real. Donde dice `<CONTRASEÑA-ACORDADA>` se usa la que el grupo reparta por un canal privado (gestor de contraseñas o mensaje directo).
- Una contraseña distinta por cuenta; mínimo 12 caracteres con mayúscula, minúscula, número y símbolo (cumple la política por defecto de Moodle).
- Las contraseñas de las 5 VMs son las mismas por cuenta, para que cualquiera pueda demostrar el sistema.
- No capturar la pantalla en el momento de escribir o mostrar una contraseña.

## 2. Identidad

| Dato | Valor |
|---|---|
| Nombre completo del sitio | Colegio Técnico de Costa Rica |
| Nombre corto | CTCR |
| Año académico | 2026 |
| Idioma / zona horaria | Español / `America/Costa_Rica` |
| URL inicial (HTTP, antes del paso 8) | `http://192.168.50.1:8080` |
| URL final (HTTPS) | `https://aulavirtual.ctcr` |
| Colores | Azul `#17365D` · Gris claro `#F3F6FA` · Blanco `#FFFFFF` · Verde acento `#27806B` |

Resumen de la página principal:

> Plataforma institucional de aprendizaje del Colegio Técnico de Costa Rica, destinada a la formación continua, actualización profesional y gestión de recursos académicos de los departamentos de Administración, Docencia e Informática.

Ruta en Moodle: Administración del sitio → Página principal → Ajustes de la página principal. Tema: Boost (no instalar otro).

## 3. Categorías

Ruta: Administración del sitio → Cursos → Administrar cursos y categorías. Categoría padre: Superior. **No duplicar** las que ya existan: editarlas.

| Nombre | ID | Descripción |
|---|---|---|
| Administración | `DEP-ADM` | Departamento responsable de la organización administrativa del Colegio Técnico de Costa Rica, la gestión documental, el control de expedientes, la trazabilidad de procesos institucionales y el resguardo de información administrativa. |
| Docencia | `DEP-DOC` | Departamento encargado de la planificación didáctica, la implementación de estrategias pedagógicas, la evaluación de los aprendizajes y el fortalecimiento de las competencias profesionales del personal docente. |
| Informática | `DEP-INF` | Departamento responsable de la formación tecnológica, las buenas prácticas de seguridad digital, la administración responsable de recursos informáticos y la protección de la información institucional. |

## 4. Cursos

Formato Temas, 3 secciones, visibilidad Mostrar, inicio 21/10/2026.

| | Curso 1 | Curso 2 | Curso 3 |
|---|---|---|---|
| Nombre completo | Gestión Documental y Procesos Administrativos | Planificación Didáctica y Evaluación de los Aprendizajes | Seguridad Digital y Protección de la Información |
| Nombre corto | `CTCR-ADM-101` | `CTCR-DOC-101` | `CTCR-INF-101` |
| Categoría | Administración | Docencia | Informática |
| Sección 1 | Fundamentos de gestión documental | Principios de evaluación educativa | Fundamentos de ciberseguridad |
| Sección 2 | Clasificación y custodia de expedientes | Diseño de instrumentos | Prevención y gestión de incidentes |
| Sección 3 | Evaluación de conocimientos | Evaluación de conocimientos | Evaluación de conocimientos |
| Recurso 1 (sección 1) | Archivo PDF | Archivo PDF | Archivo PDF |
| Recurso 2 (sección 2) | Página | Página | Página |
| Actividad (sección 3) | Cuestionario | Cuestionario | Cuestionario |

Los textos de descripción, nombres de recursos, contenido de las páginas y las 15 preguntas están en [CONTENIDO-CURSOS.md](CONTENIDO-CURSOS.md).

El requisito del profesor son 2 recursos y 1 actividad evaluable por curso; el PDF no es obligatorio para los dos recursos. Se pueden reutilizar los PDF que el grupo ya elaboró si el tema corresponde.

## 5. Usuarios (9 cuentas, ninguna administradora global)

Ruta: Administración del sitio → Usuarios → Cuentas → Agregar un nuevo usuario. Autenticación: cuentas manuales. Contraseña: ver sección 1. `admin` sigue siendo el único administrador técnico.

| Nombre | Usuario | Correo | Función | Rol en Moodle |
|---|---|---|---|---|
| Laura Rodríguez Vargas | `laura.rodriguez` | `laura.rodriguez@ctcr.example` | Dirección general | Profesor en `CTCR-ADM-101` (matrícula manual) |
| Marta Jiménez Solano | `marta.jimenez` | `marta.jimenez@ctcr.example` | Asistente administrativa | Estudiante en `CTCR-ADM-101` (por cohorte) |
| Carlos Méndez Rojas | `carlos.mendez` | `carlos.mendez@ctcr.example` | Encargado de archivo | Estudiante en `CTCR-ADM-101` (por cohorte) |
| Andrea Castillo Mora | `andrea.castillo` | `andrea.castillo@ctcr.example` | Coordinadora docente | Profesor en `CTCR-DOC-101` (matrícula manual) |
| Sofía Hernández Vega | `sofia.hernandez` | `sofia.hernandez@ctcr.example` | Docente de especialidad | Estudiante en `CTCR-DOC-101` (por cohorte) |
| José Ramírez Salazar | `jose.ramirez` | `jose.ramirez@ctcr.example` | Docente de apoyo | Estudiante en `CTCR-DOC-101` (por cohorte) |
| Daniel Vargas Chacón | `daniel.vargas` | `daniel.vargas@ctcr.example` | Encargado de soporte | Profesor en `CTCR-INF-101` (matrícula manual) |
| Valeria Sánchez López | `valeria.sanchez` | `valeria.sanchez@ctcr.example` | Técnica informática | Estudiante en `CTCR-INF-101` (por cohorte) |
| Diego Fernández Ruiz | `diego.fernandez` | `diego.fernandez@ctcr.example` | Asistente de tecnologías | Estudiante en `CTCR-INF-101` (por cohorte) |

Reglas:
- Laura, Andrea y Daniel **no** pertenecen a ninguna cohorte. Si estuvieran en una, el cohort sync los matricularía además como estudiantes.
- Cada usuario pertenece como máximo a una cohorte.
- Ninguna cuenta recibe rol de sistema ni de categoría.

## 6. Cohortes y matrícula

Ruta de cohortes: Administración del sitio → Usuarios → Cuentas → Cohortes. Son cohortes (nivel sitio) y no grupos (nivel curso) porque representan mejor la estructura por departamento; el enunciado dice "grupos" y esta decisión se justifica en el informe final.

| Cohorte | ID | Miembros | Curso donde se sincroniza (rol Estudiante) |
|---|---|---|---|
| Personal de Administración | `CTCR-COH-ADM` | marta.jimenez, carlos.mendez | `CTCR-ADM-101` |
| Personal de Docencia | `CTCR-COH-DOC` | sofia.hernandez, jose.ramirez | `CTCR-DOC-101` |
| Personal de Informática | `CTCR-COH-INF` | valeria.sanchez, diego.fernandez | `CTCR-INF-101` |

Por curso, en Participantes → Métodos de matriculación:
- Activos únicamente: **Matrícula manual** (solo el profesor) y **Sincronización de cohortes** (su cohorte).
- **Desactivar** Acceso de invitados y Automatriculación (y confirmar que no están habilitados a nivel de sitio).
- Cero matrículas manuales de usuarios de otro departamento; el rol Profesor nunca se asigna a una cohorte.

## 7. Matriz de acceso esperada (prueba 3×3)

| Usuario | CTCR-ADM-101 | CTCR-DOC-101 | CTCR-INF-101 |
|---|---|---|---|
| marta.jimenez | Permitido | Denegado | Denegado |
| carlos.mendez | Permitido | Denegado | Denegado |
| sofia.hernandez | Denegado | Permitido | Denegado |
| jose.ramirez | Denegado | Permitido | Denegado |
| valeria.sanchez | Denegado | Denegado | Permitido |
| diego.fernandez | Denegado | Denegado | Permitido |
| laura.rodriguez (profesor) | Permitido y edita | Denegado | Denegado |
| andrea.castillo (profesor) | Denegado | Permitido y edita | Denegado |
| daniel.vargas (profesor) | Denegado | Denegado | Permitido y edita |

Por cada celda "Denegado" se prueban **cuatro URL** con la sesión de ese usuario, y se registra URL, cuenta, hora y mensaje:
1. `/course/view.php?id=<id del curso ajeno>`
2. `/mod/resource/view.php?id=<id del recurso ajeno>` (o `mod/page/view.php?id=`)
3. La URL `pluginfile.php/...` del PDF ajeno.
4. `/mod/quiz/view.php?id=<id del cuestionario ajeno>`

Aprobado = no hay acceso **y no aparece** botón de automatriculación ni acceso como invitado. Una página que ofrece "Matricularme" es un fallo.

Pruebas complementarias (RX-01 y calificación):

| Prueba | Cuenta | Esperado |
|---|---|---|
| Abrir PDF, Página y Cuestionario del curso propio | marta.jimenez | Permitido |
| Resolver el cuestionario propio | valeria.sanchez | Permitido |
| Ver la calificación de Valeria | daniel.vargas | Permitido |
| Abrir el libro de calificaciones de otro curso | valeria.sanchez | Denegado |
| Abrir `/admin/` | daniel.vargas | Denegado |
| Editar un curso ajeno | andrea.castillo | Denegado |

## 8. Dominio, DNS y certificado

| Dato | Valor |
|---|---|
| Servidor (Ubuntu), red interna | `192.168.50.1` |
| Dominio / FQDN de Moodle | `ctcr` / `aulavirtual.ctcr` |
| Servidor de nombres | `ns1.ctcr` → `192.168.50.1` |
| Archivo de zona | `/etc/bind/db.ctcr` ([plantilla](../../infra/bind9/db.ctcr)) |
| Certificado | `/etc/nginx/certs/ctcr.crt` y `/etc/nginx/certs/ctcr.key` (CN y SAN `aulavirtual.ctcr`) |
| Sitio Nginx | `/etc/nginx/sites-available/ctcr-moodle` ([plantilla](../../infra/nginx/moodle.conf.example)) |
| Puerto de Moodle tras HTTPS | `127.0.0.1:8080` (ya no se publica en `192.168.50.1:8080`) |
| Proyecto Compose | `proyecto-moodle` (siempre `-p proyecto-moodle`) |

Firefox de Mint mostrará advertencia por el certificado autofirmado: importarlo como confiable o crear una excepción limitada al sitio. No equivale a una CA pública.

## 9. Cuentas FTP (una por funcionario, agrupadas por rol departamental)

Cuentas Linux independientes de Moodle (nologin, chroot en `/srv/ftp/<usuario>`, subcarpeta `archivos`), contraseña ver sección 1.

| Cuenta FTP | Funcionario | Departamento |
|---|---|---|
| `marta.jimenez` | Marta Jiménez | Administración |
| `carlos.mendez` | Carlos Méndez | Administración |
| `sofia.hernandez` | Sofía Hernández | Docencia |
| `jose.ramirez` | José Ramírez | Docencia |
| `valeria.sanchez` | Valeria Sánchez | Informática |
| `diego.fernandez` | Diego Fernández | Informática |

Parámetros comunes: `listen_address=192.168.50.1`, puertos pasivos `40000-40010`, `pasv_address=192.168.50.1`, `user_sub_token=$USER`, `local_root=/srv/ftp/$USER`, lista en `/etc/vsftpd.user_list`.

Prueba de aislamiento (con una cuenta de otro departamento, desde Mint): leer, sobrescribir y borrar un archivo ajeno deben fallar. Una respuesta 550 por "ruta inexistente" **no** prueba denegación; hay que probar también en Ubuntu con `sudo -u <cuenta> cat|rm` sobre `/srv/ftp/<otra cuenta>/archivos/` → "Permission denied".

## 10. Evidencias esperadas

| ID | Qué debe mostrar | Sin mostrar |
|---|---|---|
| 6.1 | Portada con "Colegio Técnico de Costa Rica" y colores | Barra con pestañas personales |
| 6.2 / 6.3 | Tres categorías / tres cursos con su categoría | — |
| 6.4 | Por curso: PDF, Página y Cuestionario; y las 5 preguntas | — |
| 6.5 | Lista de los 9 usuarios completa (todas las filas legibles) | Contraseñas, `sesskey` en la URL |
| 6.7 | Participantes de cada curso, solo las personas autorizadas | — |
| 6.8 | Una captura por celda "Denegado" con la URL visible, y la calificación revisada por el profesor | — |
| 7 a 9 | `named-checkzone` OK, `dig`/`getent` desde Mint, `nginx -t`, `curl -I` con 301/200, FTPS | Claves privadas |

Cada captura sigue la plantilla [evidencia.md](../../plantillas/evidencia.md) con fecha, VM y ejecutor.
