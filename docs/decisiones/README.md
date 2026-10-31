# Decisiones de arquitectura (ADR) — por qué, no solo cómo

Los ADR explican opciones consideradas y consecuencias antes/después de implementar. Son el soporte para responder preguntas de diseño y evitar decisiones implícitas en archivos YAML.

- [`ADR-0001-repositorio-unico.md`](ADR-0001-repositorio-unico.md): razón para mantener una fuente de verdad colaborativa y revisable, con trabajo distribuido pero sesiones conjuntas.
- [`ADR-0002-proxy-https.md`](ADR-0002-proxy-https.md): razones y limitaciones de terminar TLS en Nginx frente a servir HTTPS dentro del contenedor Moodle.
- [`ADR-0003-firewall-iptables-sin-ufw.md`](ADR-0003-firewall-iptables-sin-ufw.md): por qué no se activa UFW antes de la entrega y qué se entrega como `ufw.txt`.
- [`ADR-0004-servidor-unico-de-demostracion.md`](ADR-0004-servidor-unico-de-demostracion.md) (**propuesta**): una sola VM para armar el paquete y presentar, porque hay VMs del grupo con configuraciones distintas.
- [`plantillas/adr.md`](../../plantillas/adr.md): registrar contexto, alternativas, criterios, trade-offs, seguridad, consecuencias y cómo se verificó la decisión.

## Cuándo crear un ADR

Abrir uno nuevo cuando cambie una decisión que otros pasos usan: imagen Moodle o versión, nombre de proyecto/volúmenes, red y DNS, esquema de identidades, método de respaldo, certificados o permiso FTP. **No** abrir ADR para una captura nueva o typo; actualizar la guía y el PR. Las propuestas deben indicarse como tales, no como decisiones ya desplegadas.

## Integración con otros documentos

Cada ADR cita archivo `infra/` al que afecta, el procedimiento completo, la incidencia que lo motivó y la prueba de aceptación posterior. No duplicar aquí comandos del procedimiento. El [estado](../00-proyecto/ESTADO.md) controla si la opción realmente se aplicó.
