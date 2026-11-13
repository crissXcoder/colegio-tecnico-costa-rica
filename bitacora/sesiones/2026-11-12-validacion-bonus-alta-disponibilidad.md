# Sesión 2026-11-12 — Implementación, Validación y Certificación del Bonus Opcional de Alta Disponibilidad

- **Fecha:** Jueves 12 de Noviembre de 2026
- **Participantes:** Cristhian Altamirano Montes (responsable técnico y ejecución).
- **Entorno de Trabajo:** VM 1 (`criss@server` — `192.168.50.1` / `192.168.56.103`), VM 2 (`criss@server` — `192.168.56.104`) y Cliente Linux Mint (`criss@criss-VirtualBox` — `192.168.50.101`).
- **Objetivo de la Sesión:** Auditar el paso opcional del proyecto frente al enunciado oficial de la rúbrica docente, corregir la discrepancia técnica (transición de *Two-Tier* simple a verdadera *Alta Disponibilidad* con balanceo y conmutación automática), verificar la tolerancia a fallos en tiempo real y actualizar la documentación y evidencias.

---

## 1. Análisis del Problema y Diagnóstico

### 1.1. Discrepancia Identificada
El enunciado oficial del curso EIF431O para el **Bonus Opcional** exige:
> *«Alta disponibilidad: al menos dos instancias del mismo servicio (dos contenedores, o dos VMs) sirviendo el mismo sitio, con demostración de que si una cae la otra responde. No se cubre formalmente en el curso (balanceo de carga) — queda como bonus para quien quiera investigarlo por su cuenta, en cualquiera de los seis escenarios, no solo en uno.»*

En la documentación previa (Capítulo 13), se había implementado una segregación en dos niveles (Moodle en VM 1 y MariaDB en VM 2). En la prueba histórica de corte (EV-136), al detener MariaDB en VM 2, Moodle caía reportando error `HTTP 500`.
Esto demostraba desacoplamiento, pero **no cumplía con Alta Disponibilidad**:
1. Existía un único contenedor web de Moodle.
2. No había balanceo de carga ni redundancia de servicio.
3. Existía un Punto Único de Fallo (*SPOF*).

---

## 2. Acciones y Cambios Técnicos Ejecutados

### 2.1. Despliegue de la Segunda Instancia Web en VM 2
1. En VM 2 (`192.168.56.104`), se configuró en `compose.yaml` el servicio `moodle` escuchando en `192.168.56.104:8080` conectado a MariaDB (`192.168.56.104:3306`).
2. Se inició el contenedor con `docker compose up -d`, verificándose estado `healthy`.

### 2.2. Centralización de Sesiones en Base de Datos (`dbsessions`)
Para evitar que la conmutación entre nodos desconecte a los usuarios autenticados:
1. Se activó `$CFG->dbsessions = 1` en MariaDB mediante la CLI interna de Moodle.
2. Se purgó la caché MUC en ambas instancias (`php admin/cli/purge_caches.php`), confirmando que las sesiones se almacenan en la tabla `mdl_sessions` accesible por ambos nodos.

### 2.3. Configuración del Balanceador de Carga Nginx en VM 1
1. En `/etc/nginx/sites-available/aulavirtual.ctcr`, se definió el upstream:
   ```nginx
   upstream moodle_ha_cluster {
       server 127.0.0.1:8080 max_fails=1 fail_timeout=3s;
       server 192.168.56.104:8080 max_fails=1 fail_timeout=3s;
   }
   ```
2. Se añadieron directivas de resiliencia y tolerancia a fallos:
   ```nginx
   proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
   proxy_next_upstream_tries 2;
   proxy_next_upstream_timeout 5s;
   ```
3. Se creó `/etc/nginx/conf.d/ha-log.conf` con formato `upstream_ha` para auditar en tiempo real la IP del cliente, el nodo upstream atendedor y el tiempo de respuesta.

### 2.4. Automatización de Pruebas
Se programó el script [`scripts/verificar-alta-disponibilidad.sh`](../../scripts/verificar-alta-disponibilidad.sh) para validar de manera desatendida:
- Coexistencia de instancias.
- Consistencia de 494 tablas.
- Corte de Instancia 1 con failover inmediato a Instancia 2.
- Corte de Instancia 2 con failover inmediato a Instancia 1.
- Peticiones continuas desde Linux Mint (`192.168.50.101`).

---

## 3. Pruebas y Evidencias Observadas

Se ejecutó `./scripts/verificar-alta-disponibilidad.sh`:
- **Instancia 1 (VM 1):** `running` en `127.0.0.1:8080`.
- **Instancia 2 (VM 2):** `running` en `192.168.56.104:8080`.
- **Corte de Instancia 1:** Al detener el contenedor de VM 1, Nginx conmutó automáticamente en `0.165s` respondiendo `HTTP 200 OK` vía VM 2. Traza en log: `upstream: 127.0.0.1:8080, 192.168.56.104:8080 (502, 200)`.
- **Corte de Instancia 2:** Al detener el contenedor de VM 2, Nginx conmutó automáticamente en `0.193s` respondiendo `HTTP 200 OK` vía VM 1. Traza en log: `upstream: 192.168.56.104:8080, 127.0.0.1:8080 (502, 200)`.
- **Navegación cliente Mint:** Todas las peticiones devolvieron `HTTP 200 OK` con cero pérdida de paquetes y cero interrupción.
- Se regeneró la captura estilizada `EV-136.webp` (SHA-256: `7a74afb500732f9d3755121c00484eb0c91f362981b632fe421ef1f41518d725`) y se actualizaron las matrices.

---

## 4. Estado Final y Conclusiones

El **Bonus Opcional de Alta Disponibilidad** queda formalmente implementado, verificado empíricamente y plenamente respaldado en la documentación y en el paquete del repositorio.
