# Análisis del repositorio externo `cachac/dockerlabs`

- Repositorio consultado: https://github.com/cachac/dockerlabs
- Rama: `main`; README original «DOCKERLABS», actualizado, según su propio texto, en marzo de 2022.
- Objetivo de esta revisión: identificar qué conceptos, ejercicios y archivos **sí** sirven al proyecto Colegio Técnico, y qué código de laboratorio no se debe incorporar como una receta de despliegue sin adaptar.
- Se inspeccionó el árbol de la rama principal, los 21 capítulos de laboratorios, ejemplos de Compose y los servicios de proxy, logs, monitoreo y algunas aplicaciones demo. No se ejecutaron sus contenedores ni se hizo un pentest.

## Capítulos de documentación (01-21)

| Capítulo(s) | Tema | Relevancia para Elevaquitas |
| --- | --- | --- |
| 01–03 | instalación, ciclo de vida y CLI | conceptos iniciales y diagnóstico del daemon, contenedores e imágenes |
| 04 | práctica básica | ilustrativo; usa `mysql:latest`, inapropiado para imágenes fijadas del proyecto |
| 05–06 | Dockerfile, multi-stage y desarrollo | útil para explicar diferencia imagen propia vs imagen Oksigenia; no implica necesidad de Dockerfile Moodle |
| 07 | Networking | alta: bridge, DNS entre contenedores y conflicto de puertos host |
| 08 | recursos CPU/memoria | útil con VM de memoria reducida; no copiar limpieza global |
| 09–10 | volúmenes, bind mounts y práctica | alta: persistencia de Moodle/DB y pruebas de recreación |
| 11 | Compose | alta: `compose config`, `up`, `ps`, logs y dependencias. Ejemplos de balanceo no aplican sin adaptación |
| 12–13 | Prometheus/Grafana, Dozzle | opcional: interesa comprender logs, pero un stack completo consume memoria y abre más servicios |
| 14 | práctica Compose + MySQL | muestra DB y volumen, **incluye `mysql:5.7` y contraseña `12345` de demostración** |
| 15–17 | Dockprom, Portainer, ELK | bonus exploratorio, NO requisito oficial de Moodle y potencial carga innecesaria |
| 18 | Proxy | concepto de proxy inverso, pero el ejemplo usa nginx-proxy/Let’s Encrypt asociado a dominio público, no es el mismo caso que certificado local autofirmado |
| 19 | confianza de imágenes | referencia histórica a Docker Content Trust; para Oksigenia investigar digest, SBOM y cosign actual |
| 20 | logs y rotación | alta: relevante al INC-001 por espacio en disco; revisar configuración Docker y límites de tamaño de logs |
| 21 | práctica extra React/API | no necesaria para la evaluación del escenario Moodle |

## Archivos de ejemplo fuera de los capítulos

- `compose_loadbalancer/`: despliegue de aplicación y balanceador, con un YAML de red `11.0.0.0/27`. Enseña escalado/contenedores; **no es una receta de alta disponibilidad automática para Moodle** (habría que resolver sesiones, DB, ficheros y salud).
- `compose_multiapps/` y `dockerfiles_demo/mysql-docker-compose.yml`: demostraciones con MySQL 5.7, usuarios root y secretos fijos. No se incorporan.
- `dev/`: demo de frontend Nuxt y API Node; totalmente distinta a Moodle y fuera de alcance.
- `monitoreo/`, `log/` y `proxy/`: colecciones de observabilidad, dashboards Grafana, ELK/Dozzle y proxy. Algunos Compose montan `/var/run/docker.sock` incluso en modo de lectura: **el acceso al socket confiere gran capacidad de control sobre el daemon y necesita análisis de permisos y aislamiento**. El proxy ocupa 80/443, potencialmente en conflicto con Nginx del laboratorio.
- En `monitoreo/docker-compose.yml` aparecen imágenes `latest`, inadecuadas para requisito de versiones concretas.

## Fragmentos que NO se deben ejecutar literalmente en la VM del proyecto

1. `docker rm -f $(docker ps -a -f status=running -q)`: intenta eliminar **todos** los contenedores en ejecución, no solo los del laboratorio externo; puede destruir el servicio Moodle y otras prácticas.
2. `docker image prune -a` sin revisar: puede retirar imágenes no usadas en ese instante, incluso necesarias para recuperación offline. Fue utilizado puntualmente en INC-001 bajo un contexto concreto; no se convierte en mantenimiento automático.
3. `docker compose down -v`: elimina volúmenes de la aplicación de este Compose. No usar para probar reinicios.
4. `mysql:5.7`, `node:12-alpine`, `ubuntu:20.04`, `latest` o dependencias viejas: son referencias de ejercicios históricos, no versiones aceptadas para el proyecto 2026.
5. Credenciales `12345`, `MYSQL_USER: root`, `admin/admin`: inseguras como valores finales; se sustituyen por usuarios dedicados/variables privadas.
6. Portainer, Dozzle y proxy montando `docker.sock`: no montar ni publicar sin necesidad, revisión y protección de administración.
7. ELK/Prometheus/Grafana completos: exceden los seis requisitos comunes del profesor y podrían agravar la presión sobre RAM/disco.

## Qué sí incorporar al flujo real

**Networking (07):** verificar puente Docker, visibilidad entre contenedores y publicación precisa de puertos. La DB no debe exponerse a la red interna de VirtualBox.

**Storage (09):** tres volúmenes persistentes en la imagen Oksigenia; además de mantener datos después de recrear contenedores, probar que sigue existiendo un curso creado y su archivo asociado.

**Compose (11):** archivo declarativo con imágenes/versiones exactas, dependencias/health checks, red Docker, configuración interpolada y pruebas. Se conserva `.env` fuera de Git.

**Logs/monitoreo (20,12):** `docker compose logs`, `docker stats` y `docker system df`; definir rotación de logs para evitar repetir la saturación documentada del disco. No hace falta desplegar Grafana para demostrar estos puntos.

**Proxy (18):** comprender DNS, HTTPS, SNI y reenvío de cabeceras, adaptándolo al **Nginx host + dominio local** elegido por el equipo, sin registrar certificados públicos para un `.test`.

## Valoración

El recurso `dockerlabs` es útil como material de enseñanza, pero **no satisface por sí mismo** BIND9, FTPS aislado, Moodle con cohortes, recuperación de Moodledata, gestión segura de credenciales ni documentación del caso. La estructura y los scripts específicos de Elevaquitas deben seguir el enunciado oficial y las pruebas reales del grupo.
