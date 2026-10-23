# Evidencias: significado, procedencia y límites de verificación

Las capturas de la bitácora están colocadas **en el procedimiento que documentan**. Ejemplo: [`EV-010`](../docs/procedimientos/04-contenedores/04-07/evidencias/EV-010.md) y su imagen se encuentran dentro del paso de arranque Docker. El lector ve primero el comando, luego la captura y después la explicación de qué prueba y qué falta probar. El [`catálogo`](CATALOGO-CAPTURAS.md) es solo una referencia transversal para localizar y auditar las 50 imágenes.

## Archivos de esta carpeta

| Archivo | Para qué sirve | Cuándo editarlo |
|---|---|---|
| [`CATALOGO-CAPTURAS.md`](CATALOGO-CAPTURAS.md) | Índice narrativo agrupado por procedimiento, con interpretación y enlace a la ficha de cada imagen. | Cuando se incorpora o reclasifica una captura. |
| [`manifiesto-detallado.csv`](manifiesto-detallado.csv) | Registro estructurado: ID, archivo real, origen, página, paso, descripción, estado de revisión, hash, privacidad. Permite auditorías automáticas y comprobar que no hay archivos huérfanos. | En cada alta o modificación de evidencia, recalculando el hash real. |
| [`manifiesto.csv`](manifiesto.csv) | Copia compatible con la estructura anterior para no romper flujos existentes; se mantiene sincronizada. | En paralelo al manifiesto detallado. |

## Dónde está una captura

```
docs/procedimientos/06-moodle/
├── 06-04.md              # procedimiento que cita las pruebas
└── 06-04/
    └── evidencias/
        ├── EV-025.webp  # imagen histórica saneada
        └── EV-025.md    # interpretación, procedencia y límites
```

## Niveles de confianza

1. **Histórica:** una captura documenta lo que una VM mostraba durante una sesión. No implica que las otras cuatro máquinas estén al mismo nivel.
2. **Observación local:** se ha repetido el comando en la VM identificada y el resultado coincide con lo esperado.
3. **Aceptación funcional:** una prueba definida fue ejecutada, con comparación esperado/observado y resultado explícito.
4. **Validación cruzada:** otro integrante reprodujo o examinó suficientemente el caso en una máquina diferente.

## Privacidad y publicación

Las imágenes 013, 039, 040, 043 y 044 incluyen zonas ocultadas o revisión especial según la bitácora. **El ocultamiento negro impide demostrar el contenido tapado**, por lo que para demostrar usuarios y cohortes se necesitarán capturas nuevas sin datos personales reales. Las demás imágenes también deben pasar revisión humana antes de publicar el repositorio; nunca confiar únicamente en borrado automático. Los documentos Word originales con datos privados se mantienen fuera de Git.

## Regla de edición

Si una imagen se reemplaza por una versión mejor saneada: registrar por qué cambió, conservar su procedencia, calcular `sha256sum` y actualizar el manifiesto. No inventar una fecha de captura o un nombre del ejecutor cuando no estén registrados.
