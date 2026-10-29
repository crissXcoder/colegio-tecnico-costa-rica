# Minuta de Sesión de Bitácora — Despliegue y Validación del Paso 7 (DNS BIND9)

- **Fecha:** 2026-10-28 (19:45 a 19:55 CST)
- **Bloque:** `07-dns-bind9` (Fase 5: DNS BIND9 Privado)
- **Integrantes / Operador:** criss (Estudiante EIF431O)
- **Revisor Técnico:** Antigravity AI Pair Programmer
- **Máquinas involucradas:** 
  - VM #1 Ubuntu Server (`192.168.50.1`) — Hostname: `server`
  - VM #2 Linux Mint (`192.168.50.101`) — Hostname: `criss-VirtualBox`
- **Objetivo:** Implementar la zona autoritativa `ctcr` para la resolución de `aulavirtual.ctcr` -> `192.168.50.1`, verificar opciones de BIND9, validar sintaxis con `named-checkconf` y `named-checkzone`, reiniciar el servicio y comprobar la resolución en frío desde Linux Mint, preservando las zonas preexistentes y documentando sin realizar commits en el repositorio compartido.

---

## 1. Comandos Ejecutados y Resultados

1. **Revisión de Sockets en Puerto 53 (Paso 7.3):**
   - Comando: `sudo ss -lntup | grep ':53 '`
   - Resultado: `systemd-resolve` escuchando en `127.0.0.53/54`, y `named` (BIND9) escuchando en `192.168.50.1:53` (TCP/UDP). No hay colisión.
2. **Respaldo y Opciones de BIND9 (Paso 7.4):**
   - Comandos: `sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak`
   - Verificación: Archivo `/etc/bind/named.conf.options` configurado con recursión permitida para `127.0.0.1` y `192.168.50.0/24`, escucha exclusiva en `192.168.50.1`, y reenvío (*forwarders*) a `8.8.8.8` y `1.1.1.1`.
3. **Registro de Zona del Colegio (Paso 7.5):**
   - Archivo: `/etc/bind/named.conf.local` (respaldado previamente como `.bak`).
   - Bloque incorporado:
     ```bind
     zone "ctcr" {
         type master;
         file "/etc/bind/db.ctcr";
         allow-transfer { none; };
     };
     zone "ctcr.test" {
         type master;
         file "/etc/bind/db.ctcr.test";
         allow-transfer { none; };
     };
     ```
   - Zonas preexistentes preservadas: `resDigital.internal`, `altamiranomontes.internal`, `examencristhian.internal`, `cooperativa.internal`.
4. **Creación de Archivo de Zona (Paso 7.6):**
   - Archivo: `/etc/bind/db.ctcr` (y `/etc/bind/db.ctcr.test`).
   - Serial: `2026102401`.
   - Registros: `ns1 IN A 192.168.50.1`, `aulavirtual IN A 192.168.50.1`, `moodle IN A 192.168.50.1`.
5. **Validación Sintáctica y Reinicio (Paso 7.7):**
   - `sudo named-checkconf` -> Retornó código 0 (sin salida de error).
   - `sudo named-checkzone ctcr /etc/bind/db.ctcr` -> `zone ctcr/IN: loaded serial 2026102401 OK`.
   - `sudo systemctl restart named` y `sudo systemctl is-active named` -> `active`.
6. **Comprobación desde Ubuntu Server (Paso 7.8):**
   - `dig @192.168.50.1 aulavirtual.ctcr` -> Respuesta autoritativa (`flags: qr aa rd ra`), `status: NOERROR`, sección de respuesta `192.168.50.1` en 1 ms.
   - `dig @192.168.50.1 aulavirtual.ctcr +short` -> `192.168.50.1`.
7. **Comprobación desde Linux Mint (Paso 7.9):**
   - `nmcli device show enp0s3 | grep IP4.DNS` -> `192.168.50.1`.
   - `dig @192.168.50.1 aulavirtual.ctcr +short` -> `192.168.50.1`.
   - `dig aulavirtual.ctcr +short` -> `192.168.50.1`.
   - `getent ahostsv4 aulavirtual.ctcr` -> `192.168.50.1 STREAM / DGRAM / RAW`.
   - `ping -c 2 aulavirtual.ctcr` -> 2 paquetes transmitidos, 2 recibidos, 0% packet loss.
   - `dig google.com +short` -> `172.217.162.110` (recursión externa operativa).

---

## 2. Evidencias Generadas (Paso 7.10)
- `EV-063` (`EV07_01_ubuntu_bind9_config_y_checkzone.webp`) (SHA-256: `3b1c8e538a9b9e0669e5201107292a90264f472f8d362347602a536a9006dd6d`)
- `EV-064` (`EV07_02_ubuntu_dig_resolucion_local.webp`) (SHA-256: `efc2ca54ead422ae5dc015c9b0fd87bee51efe4f394b7cbeb4fd6a2eda384466`)
- `EV-065` (`EV07_03_mint_dns_resolucion_terminal.webp`) (SHA-256: `f8fd9bb9a7a36bc9f5b57d2f9985bc3d7e5fca1b037212971d90e278922221b3`)
- `EV-066` (`EV07_03_mint_dns_resolucion_desktop.webp`) (SHA-256: `07a056a898fe295cc87d5cd2905eafd4035f60ab4afe2c1b04a33042d683fa7d`)

---

## 3. Estado de Repositorio y Gobernanza Git
- Repositorio `/home/criss/agente/colegio-tecnico-costa-rica` actualizado con los procedimientos de Paso 7, zonas BIND9 y evidencias `EV-063` a `EV-066`.
- Todos los artefactos, logs y fichas técnicas se encuentran incorporados canónicamente en `docs/procedimientos/07-dns-bind9/`.
- Criterio de aceptación T-06: **CUMPLE (PASS)** al 100%.
