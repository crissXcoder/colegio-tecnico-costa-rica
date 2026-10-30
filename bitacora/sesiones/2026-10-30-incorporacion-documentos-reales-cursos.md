# Sesión 2026-10-30 — Estandarización e incorporación de documentos reales a los cursos de Moodle

- **Fecha:** 2026-10-30
- **Tipo:** Sesión técnica y documental (repositorio e instancia Moodle local).
- **Entorno:** Ubuntu Server (`192.168.50.1`), contenedor `proyecto-moodle-moodle-1`, cliente Linux Mint (`192.168.50.101`).
- **Fuente externa:** Carpeta compartida de Google Drive con documentos reales y guía de asignación `8fc85ecd-83bc-48aa-a3ea-a4e5bb71f814.jpg`.

---

## 1. Propósito y antecedentes

El aula virtual contaba inicialmente con archivos PDF provisionales de prueba y páginas de texto genéricas (`mod_page`) en la sección 2. Se requirió estandarizar todos los cursos del Colegio Técnico de Costa Rica para que los cinco integrantes del grupo compartan la misma base de documentos genuinos, normalizando los nombres de archivo y actualizando la plataforma local.

---

## 2. Acciones ejecutadas

### 2.1. Análisis de la guía de distribución (`Paso 6.4`)
Se procesó por OCR la imagen de guía provista en el Drive (`8fc85ecd-83bc-48aa-a3ea-a4e5bb71f814.jpg`), estableciendo la correspondencia exacta:

| Curso / Departamento | Recurso 1 (Sección 1) | Recurso 2 (Sección 2) | Actividad Evaluativa (Sección 3) |
|---|---|---|---|
| **Administración** (`CTCR-ADM-101`) | **PDF sobre archivo institucional**<br>`Manual_archivo_institucional.pdf` | **Guía de clasificación documental**<br>`CTCR_Guia_Clasificacion_Documental_v1.pdf` | **Cuestionario sobre clasificación de expedientes** |
| **Docencia** (`CTCR-DOC-101`) | **Presentación sobre evaluación formativa**<br>`La Docencia.pdf` | **Guía sobre elaboración de rúbricas**<br>`Guia_Rubricas_CTCR.pdf` | **Cuestionario sobre evaluación** |
| **Informática** (`CTCR-INF-101`) | **Guía de contraseñas seguras**<br>`CTCR_Manual_Seguridad_Digital.pdf` | **PDF sobre phishing**<br>`CTCR_Guia_Prevencion_y_Gestion_de_Incidentes.pdf` | **Cuestionario de seguridad informática** |

### 2.2. Normalización e integración en el repositorio
Se descargaron los documentos y se estructuraron bajo [`documentos-cursos/`](../../documentos-cursos/), normalizando los nombres para eliminar identificadores UUID, espacios y sufijos de versión:
- `guia-recursos-actividades.jpg` (SHA-256: `ac6498801284b986c7c3e8dc3583791ca28ba33b332f1f86725dba267aeb05df`)
- `01-administracion/01-Manual_Archivo_Institucional.pdf` (892.8 KB, SHA-256: `f3174b52...`)
- `01-administracion/02-Guia_Clasificacion_Documental.pdf` (163.8 KB, SHA-256: `01f384b3...`)
- `02-docencia/01-Presentacion_Docencia_Evaluacion_Formativa.pdf` (4.95 MB, SHA-256: `a1409bec...`)
- `02-docencia/02-Guia_Elaboracion_Rubricas.pdf` (77.6 KB, SHA-256: `77ba0953...`)
- `03-informatica/01-Guia_Contrasenas_Seguras_Manual_Seguridad_Digital.pdf` (705.7 KB, SHA-256: `2cf236ec...`)
- `03-informatica/02-PDF_Phishing_Prevencion_Incidentes.pdf` (707.8 KB, SHA-256: `b78dfd3e...`)

Se agregó el archivo [`documentos-cursos/README.md`](../../documentos-cursos/README.md) con las instrucciones de descarga y asignación.

### 2.3. Actualización técnica en el aula virtual (Moodle)
A través de un script PHP automatizado utilizando la API oficial de Moodle (`/var/www/moodle/config.php` con `CLI_SCRIPT`):
1. **Recurso 1 (Sección 1):** Reemplazo de archivos en `mod_resource` mediante `get_file_storage()`, adjuntando los documentos reales y actualizando títulos e introducciones.
2. **Recurso 2 (Sección 2):** Eliminación limpia de las antiguas páginas de texto provisionales mediante `course_delete_module()` y creación de nuevas instancias `mod_resource` enlazadas a la sección 2 con los PDFs correspondientes.
3. **Cuestionarios (Sección 3):** Actualización de los nombres de los tres cuestionarios en `mdl_quiz`.
4. **Caché:** Reconstrucción integral de modinfo y caché con `rebuild_course_cache()`.

---

## 3. Verificación de resultados

### 3.1. Estado de módulos en la base de datos de Moodle
```text
cmid  course  modname   instance  section  título
12    2       resource  3         2        Manual de archivo institucional
21    2       resource  6         3        Guía de clasificación documental
14    2       quiz      2         4        Cuestionario sobre clasificación de expedientes
15    3       resource  4         7        Presentación sobre evaluación formativa
22    3       resource  7         8        Guía sobre elaboración de rúbricas
17    3       quiz      3         9        Cuestionario sobre evaluación
18    4       resource  5         12       Guía de contraseñas seguras
23    4       resource  8         13       PDF sobre phishing
20    4       quiz      4         14       Cuestionario de seguridad informática
```

### 3.2. Archivos físicos en almacenamiento de Moodle (`mdl_files`)
Se verificó que los seis archivos PDF reales quedaron registrados con sus tamaños exactos y tipos MIME `application/pdf`.

### 3.3. Comprobación de no regresión y validación estática
- Petición HTTP 200 OK hacia `https://aulavirtual.ctcr/` desde Linux Mint (`192.168.50.101`).
- Ejecución de `python3 scripts/validate-repository.py` con resultado `OK — 100% PASS`.
