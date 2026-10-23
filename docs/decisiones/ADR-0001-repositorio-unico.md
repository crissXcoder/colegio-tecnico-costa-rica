# ADR-0001 — Monorepositorio para infraestructura, bitácora y evidencias

- Estado: propuesta para ratificación del grupo
- Fecha: 2026-10-23
- Contexto: configuración repartida entre documentos Word, capturas y un chat; cinco VMs pueden divergir aunque se reúnan y trabajen juntas.
- Decisión: centralizar los archivos versionables, instrucciones, bitácoras e índice de capturas en un repo privado con PR y revisión cruzada.
- Alternativas: solo Word compartido (falta historial/comandos enlazados); cinco repos separados (riesgo de divergencias y duplicidad).
- Consecuencias: menor duplicidad, trazabilidad, revisión colectiva; requiere higiene de secretos y disciplina por fase.
- Validación pendiente: definir propiedad del repo, personas y política de ramas.
