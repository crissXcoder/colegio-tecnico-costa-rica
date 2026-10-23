# Reglas de trabajo para asistentes/agentes

Antes de proponer o modificar archivos, leer README.md, docs/00-proyecto/ESTADO.md, la fase relevante, la matriz de requisitos y el ADR vinculado. Contrastar con evidencia real. No marcar hechos observados sin logs/salidas/capturas. Preguntar solo por lo indispensable si una modificación puede destruir datos. No ejecutar comandos de cambios en disco/LVM, firewall, puertos, bases de datos, eliminación de volúmenes ni renovación de certificados sin revisión previa.

No publicar secretos ni datos personales. No convertir capturas sin revisar en archivos versionados. Actualizar README de fase + bitácora + matriz de estado al mismo tiempo que las configuraciones. Usar nombres de fuentes/IDs; no inventar versiones o resultados. Distinguir *as-is* (observado) y *to-be* (configuración objetivo). El entorno académico no es producción ni requiere servicios extras sin beneficio directo.
