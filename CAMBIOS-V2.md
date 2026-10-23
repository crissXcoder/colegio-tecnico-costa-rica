# Cambios respecto al primer paquete

**No se ha eliminado ni renombrado ninguna fase, script o plantilla original.** Esta edición añade:

1. Texto íntegro de la guía de chat compartida en `docs/fuentes/GUIA-HISTORICA-INTEGRA.md` (sin resumir comandos).
2. 54 subpasos de la guía desarrollados como procedimientos individuales numerados 04–11; cada uno con comandos, verificaciones, precauciones, registro de ejecución y evidencias aplicables.
3. Cinco pasos documentales complementarios 00–03 para los preparativos previos, marcados como propuestas y no como tareas observadas.
4. 50 capturas históricas extraídas del DOCX de 26 páginas, enlazadas a sus pasos; zonas potencialmente sensibles ocultas, hash SHA256 y catálogo.
5. Enlaces cruzados desde los `STEP-XX-XX.md` antiguos para no perder las plantillas anteriores.
6. Registro de diferencias entre imagen Moodle documentada vs nueva compilación de seguridad, con advertencias de migración, credenciales, proyecto Compose, LVM, FTP y respaldo completo.
7. Matriz de cobertura fuente→procedimiento→captura→prueba pendiente y correcciones de estado sobre cohortes.

## Diferencias que NO hemos supuesto

- No sabemos que cada VM del grupo esté idéntica.
- No sabemos si las capturas de crear curso equivalen a tres cursos terminados con todos los recursos y las actividades evaluables.
- No hay prueba de autorización cruzada ni de DNS, HTTPS, FTPS o recuperación final de Moodle.
- No hemos tocado las VMs ni creado contenedores en ellas.
- La última bitácora contiene capturas personales; solo se agregaron versiones sanitizadas para Git.

8. Guía corta para copiar/pegar en VMs existentes o nuevas, restauración aislada, reinicio tras apagar equipos y versión inicial HTTP antes de migrar a HTTPS.
9. Ajuste de `scripts/backup-db.sh` para conservar el nombre de proyecto Compose original al operar desde el repositorio.
10. Guía de entrega detallada `12-01` y bitácora reconstituida con 50 EV históricas.
