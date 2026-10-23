# Auditoría documental v3 — alcance, calidad y tareas abiertas

## Qué se reconstruyó

El archivo base fue `Elevaquitas_Monorepo_Completo_v2.zip`. Se conservaron sus archivos originales de configuración y scripts, las fichas STEP, el registro de cambios v2, las sesiones e INC-001 y el texto íntegro de la guía. Se movieron físicamente 50 fotografías WebP a los pasos correspondientes y se añadieron 50 fichas MD individuales; no se borraron ni se reemplazaron por imágenes generadas artificialmente.

## Correcciones de organización detectadas

- Existía un directorio central de capturas que obligaba a adivinar el orden. Ahora cada captura se ve dentro del paso y su ficha tiene nombre, acción, contexto, procedencia, SHA y límite probatorio.
- El catálogo previo mezclaba fotografías de cuestionario con `06-05` creación de usuarios; se corrigieron EV-028 a EV-037 hacia `06-04`. Las cuentas EV-038 a EV-040 quedaron en `06-05` y las cohortes EV-041 a EV-044 en `06-06`. EV-003 describe red exterior, no LVM.
- El esquema documental conservaba simultáneamente `docs/fases` (gestión) y `docs/procedimientos` (comandos). Ahora sus README explican exactamente la distinción y se enlazan en ambos sentidos.
- Los README de la v2 eran mayoritariamente índices. Se sustituyeron por textos que explican alcance, uso, riesgos, dependencias, criterios de cierre, contenido y propósito de los archivos vinculados.
- La política `.gitignore` no habilitaba inequívocamente `.env.https.example`; quedó explícitamente permitida y el CI fue actualizado para aceptar plantillas `.env.*.example` pero rechazar credenciales.

## Qué NO se ha verificado aquí

No se dispone de consola Ubuntu de ninguno de los cinco integrantes ni de una instalación de Moodle en ejecución. Por eso **no se ejecutaron** `docker compose up`, BIND9, Nginx, FTP o un restore de MariaDB. La validación de este ZIP es **estática**, no una certificación del laboratorio. Tampoco se conoce de forma confiable quién tomó todas las capturas ni la hora exacta: las fichas no inventan estos datos.

## Pruebas que el equipo debe ejecutar

1. Verificar digest y versión instalada de Moodle, no solo tag de la guía, antes de cualquier actualización.
2. Repetir estado de Docker/MariaDB y persistencia en las cinco máquinas con un registro por VM.
3. Crear recursos y cuestionarios completos por departamento, comprobar matrícula y 3×3 de denegación con cuentas de prueba.
4. Demostrar `dig` desde Mint, HTTPS por nombre, FTPS aislado y restauración separada (SQL más política de datos Moodle).
5. Revisar manualmente todas las capturas antes de abrir el repositorio al público, especialmente donde hay información de usuario oculta o barras de navegador.
6. Reproducir el procedimiento siguiendo exclusivamente los README, y registrar los puntos ambiguos como incidencias.

## Qué valida el paquete sin entrar a las VMs

`scripts/validate-repository.py` comprueba archivos esperados, enlaces Markdown incluidas imágenes, 50 IDs EV únicos, correspondencia de ruta y paso, existencia de foto + ficha, SHA-256, manifiestos idénticos y ausencia de archivos `.env` reales. Se ejecutó `bash -n` para los tres scripts Bash y se analizaron los YAML con un parser. El informe no debe afirmar que estas verificaciones prueban los servicios de Ubuntu.
