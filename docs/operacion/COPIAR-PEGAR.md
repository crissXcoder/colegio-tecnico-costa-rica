# Libro de comandos operativo — rutas probadas conceptualmente y secuencia segura

> Esta guía concentra las recetas resumidas para la VM. Para detalles completos y capturas abrir el [manual paso a paso](../procedimientos/README.md). Los comandos se ejecutan **solo en el equipo indicado** y adaptando usuario, interfaz e IP. El hecho de que sean copiables no significa que se hayan probado en la VM del lector.

## A. Si ya tienen Moodle funcionando (camino recomendado para su estado actual)

En **Ubuntu** ejecutar exclusivamente inspección no destructiva:

```bash
pwd
hostnamectl
ip -br a
ip route
df -hT
lsblk -f
sudo docker compose ls
sudo docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
sudo docker volume ls
sudo ss -lntup
```

Si el Compose **real** está en `~/proyecto-moodle`:

```bash
cd "$HOME/proyecto-moodle"
sudo docker compose ps
sudo docker compose images
sudo docker compose logs --tail=50 db
sudo docker compose logs --tail=50 moodle
sudo docker compose config --images
sudo docker image inspect oksigenia/moodle:4.5.15 --format '{{json .RepoDigests}}' || true
```

**No mostrar** `docker compose config` completo: revela secretos. No pegar salidas de `.env` en una captura.

## B. Instalación desde cero, SOLO en VM sin plataforma existente

En Ubuntu, tras revisar el preflight y clonar el repositorio en `$HOME/elevaquitas`:

```bash
cd "$HOME/elevaquitas"
# El script comprueba por sí solo que .env no exista; si existe, se niega a sobrescribirlo.
bash scripts/generate-env.sh
sudo docker compose -p proyecto-moodle \
  --env-file infra/compose/.env -f infra/compose/compose.yaml config --quiet
sudo docker compose -p proyecto-moodle \
  --env-file infra/compose/.env -f infra/compose/compose.yaml pull
sudo docker compose -p proyecto-moodle \
  --env-file infra/compose/.env -f infra/compose/compose.yaml up -d
sudo docker compose -p proyecto-moodle \
  --env-file infra/compose/.env -f infra/compose/compose.yaml ps
```

**Detenerse si la variable `MOODLE_BIND_IP` no coincide con la IP interna real.** El `generate-env.sh` produce imagen con versión fija y clave aleatoria solo una vez. **Importante:** `generate-env.sh` no sobrescribe `.env`; detenerse y diagnosticar cualquier error antes de continuar con Compose.

En Mint, al inicio (sin Nginx): `http://192.168.50.1:8080` desde Firefox.

## C. DNS BIND9 — inspeccionar antes de instalar

En Ubuntu:

```bash
sudo ss -lntup | grep ':53 ' || true
sudo systemctl is-active named || true
sudo apt update
sudo apt install -y bind9 bind9-utils dnsutils
sudo named-checkconf
```

Para instalar configuración **solo si el archivo tiene exclusivamente un bloque `options` y no perderás configuraciones anteriores**, revisar primero:

```bash
sudo cp -a /etc/bind/named.conf.options "/etc/bind/named.conf.options.pre-elevaquitas-$(date +%Y%m%d%H%M%S)"
sudo nano /etc/bind/named.conf.options
```

Copiar *un único bloque options adaptado*, desde [`infra/bind9/named.conf.options.fragment`](../../infra/bind9/named.conf.options.fragment); integrar [`named.conf.local.fragment`](../../infra/bind9/named.conf.local.fragment) al archivo existente y copiar la zona **solo después de adaptar IP**:

```bash
sudo install -m 644 infra/bind9/db.colegio.test /etc/bind/db.colegio.test
sudo named-checkconf
sudo named-checkzone colegio.test /etc/bind/db.colegio.test
sudo systemctl restart named
dig @192.168.50.1 moodle.colegio.test +short
```

En Mint, **sin añadir NAT** (verificar nombre de conexión con `nmcli connection show`):

```bash
nmcli connection show
sudo nmcli connection modify "Wired connection 1" ipv4.dns "192.168.50.1"
sudo nmcli connection modify "Wired connection 1" ipv4.ignore-auto-dns yes
sudo nmcli device reapply enp0s3
getent hosts moodle.colegio.test
```

## D. HTTPS Nginx — antes de tocar Compose, copia de seguridad

En Ubuntu:

```bash
sudo ss -lntup | grep -E ':(80|443|8080) ' || true
sudo apt install -y nginx openssl
sudo mkdir -p /etc/nginx/certs
sudo openssl req -x509 -nodes -days 365 -newkey rsa:3072 \
  -keyout /etc/nginx/certs/moodle.key \
  -out /etc/nginx/certs/moodle.crt \
  -subj "/C=CR/O=Colegio Tecnico/CN=moodle.colegio.test" \
  -addext "subjectAltName=DNS:moodle.colegio.test"
sudo chmod 600 /etc/nginx/certs/moodle.key
test ! -f /etc/nginx/sites-available/moodle || sudo cp -a /etc/nginx/sites-available/moodle "/etc/nginx/sites-available/moodle.pre-elevaquitas-$(date +%Y%m%d%H%M%S)"
sudo install -m 644 infra/nginx/moodle.conf.example /etc/nginx/sites-available/moodle
sudo ln -sfn /etc/nginx/sites-available/moodle /etc/nginx/sites-enabled/moodle
sudo nginx -t
```

Antes de habilitar, ajustar **el `.env` PRIVADO existente** según [`infra/compose/.env.https.example`](../../infra/compose/.env.https.example): `MOODLE_URL=https://moodle.colegio.test`, `MOODLE_BIND_IP=127.0.0.1`, `MOODLE_SSL_PROXY=auto`. Verificar la configuración efectiva y generar backups antes de recrear Moodle. No regenerar contraseñas. La configuración Nginx espera `127.0.0.1:8080`. **Si el Compose real todavía está en `~/proyecto-moodle`, adaptar ese archivo y no ejecutar el Compose del repositorio hasta validar volúmenes/nombre e imagen.**

```bash
# Después de actualizar la URL del Compose ACTIVO y guardar un backup, aplicar la misma stack:
# Para proyecto basado en el compose del repositorio (NO mezclar con otro compose):
# sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml config --quiet
# sudo docker compose -p proyecto-moodle --env-file infra/compose/.env -f infra/compose/compose.yaml up -d
sudo systemctl reload nginx
sudo nginx -t
curl -kI --resolve moodle.colegio.test:443:192.168.50.1 https://moodle.colegio.test
openssl x509 -in /etc/nginx/certs/moodle.crt -noout -dates -subject -ext subjectAltName
```

**No interpretar `curl -k` como confianza validada del certificado.** Se usa solo en el laboratorio para comprobar transporte.

## E. FTPS y permisos

En Ubuntu, lista de usuarios de ejemplo definida por el grupo; ejecutar cada `adduser` únicamente si no existe:

```bash
getent passwd ftpadmin || true
getent passwd ftpdocencia || true
getent passwd ftpinformatica || true
sudo apt install -y vsftpd
sudo cp -a /etc/vsftpd.conf "/etc/vsftpd.conf.pre-elevaquitas-$(date +%Y%m%d%H%M%S)"
```

**Los cinco `adduser`, la preparación de `/srv/ftp` y la lista PAM están documentados completos en [09-02/09-03/09-04](../procedimientos/09-ftps-vsftpd/README.md).** No automatizarlos en VMs con cuentas de los laboratorios anteriores. Usar el [`vsftpd.conf.example`](../../infra/vsftpd/vsftpd.conf.example) corregido que incluye `user_sub_token=$USER`; probar lectura, subida y denegación de borrado ajeno.

## F. Respaldo y restauración

La copia recomendada de SQL del repo se implementó en [`scripts/backup-db.sh`](../../scripts/backup-db.sh). Antes de ejecutarlo, revisar el **nombre de proyecto Compose** y que las credenciales del `.env` correspondan a la DB instalada; el script presupone esta ruta y el nombre de proyecto configurado. Las instrucciones históricas completas están en `10-01` a `10-07`. Nunca restaurar pruebas sobre la base `moodle` existente.

## G. Evidencias y cierre

Por cada comando: guardar salida (con datos personales ocultos), registrar `EV-ID`, archivo, fecha, VM, quién ejecutó y revisor. Ir a [manifiesto de capturas](../../evidencias/CATALOGO-CAPTURAS.md) y [matriz de requisitos](../00-proyecto/matriz-requisitos.md). Si hay un error, no saltar al siguiente paso: registrar una `INC-XXX` y actualizar la bitácora.
