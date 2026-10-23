# Manual de campo — instalación, operación, evidencia y control de cambios

**Esta es la referencia para ejecutar el proyecto de principio a fin.** A diferencia de `docs/fases`, que describe responsabilidades y requisitos, aquí cada subpaso ofrece comandos/configuraciones completos, la ruta donde van, qué se espera observar, qué se vio realmente en la bitácora y las capturas almacenadas al lado. **No todas las fases han sido ejecutadas**.

## 1. ¿En qué situación está mi máquina?

**Camino A — VM nueva:** sigue `00` → `12` en orden, saltando solamente pasos que ya pasaron pruebas de aceptación, no porque el texto diga “completado”. El archivo `.env` solo se genera una vez; el nombre de proyecto Docker debe coincidir con el que se usará para persistencia.

**Camino B — VM existente con Moodle:** las capturas ya demuestran Compose, BD inicializada y recursos en una VM. Usa primero [operación e inventario](../operacion/README.md); localiza la carpeta Compose real `~/proyecto-moodle`, los volúmenes y digest. **No reejecutes comandos de creación ni `generate-env.sh`** sobre una instalación existente. Guarda respaldo antes de migrar a HTTPS.

## 2. Guía de lectura del paso individual

Un `04-04.md`, por ejemplo, indica que se debe editar Compose, enlaza el archivo versionable propuesto y el histórico, explica los dos servicios, contiene comandos completos, da un criterio de comprobación y muestra fotos **EV-007/008 dentro de `04-04/evidencias/`**. La ficha de cada foto explica qué evidencia y qué NO demuestra. Los resultados que todavía no existen permanecen marcados como pendientes.

## 3. Orden sugerido y entregable de cada bloque

| Capítulo (abre el README de ese bloque) | Dependencia y valor de negocio/técnico | Capturas históricas en sus pasos |
|---|---|---:|
| [00-prerrequisitos](00-prerrequisitos/README.md) | Comprobar capacidad, VirtualBox, interfaces y prerrequisitos de VM sin alterar datos existentes. | 0 |
| [01-servidor-red](01-servidor-red/README.md) | Validar red Mint↔Ubuntu y salida a Internet en Ubuntu; guardar INC-001 cuando el disco limita el despliegue. | 4 |
| [02-ubuntu](02-ubuntu/README.md) | Identificar distro y servicios del host, red/puertos/UFW e inventario para no colisionar con prácticas previas. | 0 |
| [03-docker](03-docker/README.md) | Verificar Engine, Compose, daemon, permisos y recursos antes de instalar imágenes. | 0 |
| [04-contenedores](04-contenedores/README.md) | Crear o inspeccionar Docker Compose, credenciales, volúmenes, MariaDB y Moodle; fotos EV-004–015. | 12 |
| [05-cliente-mint](05-cliente-mint/README.md) | Entrar a Moodle por IP desde Mint y comprobar persistencia; fotos EV-016–018. | 3 |
| [06-moodle](06-moodle/README.md) | Personalización, categorías, cursos, recursos, cuestionarios, usuarios, cohortes, matrícula y denegación; fotos EV-019–049. | 31 |
| [07-dns-bind9](07-dns-bind9/README.md) | Instalar/configurar zona DNS, validar named y resolver desde Mint. | 0 |
| [08-https-nginx](08-https-nginx/README.md) | Certificado autofirmado y proxy a localhost, migración segura de URL y prueba HTTPS. | 0 |
| [09-ftps-vsftpd](09-ftps-vsftpd/README.md) | Cuentas y chroot por usuario, FTPS, pruebas de lectura/escritura y acceso cruzado. | 0 |
| [10-respaldos](10-respaldos/README.md) | Cron, dump SQL, retención y restauración de ensayo; datos Moodle aparte. | 0 |
| [11-verificacion](11-verificacion/README.md) | Integración end-to-end, firewall, puertos, permisos y pruebas negativas. | 0 |
| [12-entrega](12-entrega/README.md) | Inventario para el informe técnico y demostración reproducible. | 0 |

## 4. Regla de seguridad de comandos

El apartado “Procedimiento completo y comandos originales” recoge la guía textual proporcionada por el grupo. **No se garantiza que un comando histórico sea adecuado para un host ya configurado**. Antes de usarlo, leer “Archivos relacionados”, “Correcciones”, la receta versionada en [`infra/`](../../infra/README.md) y el resultado de preflight. Los comandos con pérdida potencial de datos (`down -v`, `prune`, borrado SQL, LVM, firewall y cambio de URL) requieren plan de reversión y respaldo probado.

Si un comando necesita contraseñas, usarlas desde archivos privados o introducirlas cuando el cliente las solicita; no guardar `grep PASSWORD` ni `docker compose config` completo en Git/capturas. La variante segura de comandos está explicada en [`operacion/COPIAR-PEGAR.md`](../operacion/COPIAR-PEGAR.md).

## 5. Estado, pruebas y evidencia por VM

La fotografía histórica acredita una actividad puntual realizada. Para marcar un paso **verificado** hace falta indicar VM, fecha, usuario de prueba, comando/acción, salida observada y resultado esperado. Para declarar el bloque **validado cruzado**, otro integrante debe repetirlo o revisarlo independientemente. La matriz de [requisitos](../00-proyecto/matriz-requisitos.md) y las [pruebas](../../pruebas/README.md) indican cuáles son obligatorias.

La imagen va a `docs/procedimientos/<capítulo>/<paso>/evidencias/EV-NNN.webp` y junto a ella su `EV-NNN.md`. El [catálogo](../../evidencias/CATALOGO-CAPTURAS.md) es **solo índice transversal**: no hay un cajón de capturas anónimas. Se preservan EV-001 a EV-050; nuevas capturas continúan la numeración y requieren revisión de privacidad antes de GitHub.

## 6. Flujo de equipo en reunión

Los cinco ejecutan juntos la secuencia acordada en máquinas propias; el responsable del bloque redacta o corrige el manual, y otro revisor comprueba un resultado local y los enlaces. Registrar problemas y decisiones en [bitácora](../../bitacora/README.md), no ocultarlos. El camino elegido se documenta y las diferencias por VM quedan explícitas. [Revisar estado actual](../00-proyecto/ESTADO.md).
