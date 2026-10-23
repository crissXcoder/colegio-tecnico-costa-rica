# Registro de sesión — transcripción estructurada de la bitácora recibida (fecha exacta por confirmar)

**Fuente:** `Proyecto_Colegio_Técnico_con_departamentos_separados(1).docx` (26 páginas). Las fechas observables en terminales no se consideran, por sí solas, hora única de todas las actividades. **No es una sesión nueva ejecutada por ChatGPT.**

## Secuencia documentada

1. Comunicación entre VMs y acceso externo de Ubuntu — EV-001 a EV-003.
2. Comprobación de etiquetas Moodle 4.5.15 y MariaDB 11.4.13 — EV-004.
3. Creación de `.env` y restricciones de archivo — EV-005 a EV-006; no exponer valores.
4. Edición y validación de Compose, `pull` y `up -d` — EV-007 a EV-012.
5. Consulta de tablas de MariaDB y volúmenes persistentes — EV-013 a EV-015.
6. Acceso web Moodle y prueba de reinicio — EV-016 a EV-018.
7. Portada, categorías y cursos — EV-019 a EV-023.
8. Subida de recursos, cuestionarios y preguntas — EV-024 a EV-037.
9. Creación de cuentas, roles y cohortes — EV-038 a EV-044.
10. Ajustes adicionales de la apariencia — EV-045 a EV-049.
11. Problema **INC-001:** disco raíz al 100%, LVM con espacio libre, expansión y limpieza controlada — EV-050.

## Qué no queda demostrado

- Tres cursos con sus dos recursos y evaluación funcional cada uno.
- Matrícula efectiva y prueba de acceso denegado por URL directa entre departamentos.
- Servicio DNS BIND9, Nginx/HTTPS, FTPS, Cron y restauración funcional de Moodle.
- Estado idéntico de las cinco VM del equipo.

## Enlaces

- [Índice visual de EV](../../evidencias/CATALOGO-CAPTURAS.md)
- [Inventario individual por VM](../../docs/operacion/INVENTARIO-POR-INTEGRANTE.md)
- [Incidencia documentada INC-001](../incidentes/INC-001-almacenamiento-lvm.md)
- [Procedimientos completos](../../docs/procedimientos/README.md)
