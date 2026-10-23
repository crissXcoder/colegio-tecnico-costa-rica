# Guía completa de implementación — Escenario 3: Colegio Técnico con Moodle

Curso EIF431O — Administración de Servidores basados en Software Libre

Vamos a continuar desde donde quedaste, sin repetir la creación de las máquinas virtuales ni la instalación de Docker.

Esta guía reúne los comandos, configuraciones, verificaciones y pruebas necesarios para implementar el proyecto completo. Los cinco integrantes pueden seguir exactamente el mismo procedimiento en sus propias máquinas.

## 1. Configuración que ya tenemos

| Componente        | Versión / configuración                           |
| ----------------- | ------------------------------------------------- |
| Servidor          | Ubuntu Server 26.04 LTS                           |
| Cliente           | Linux Mint 22.3                                   |
| Docker Engine     | 29.9.0                                            |
| Docker Compose    | 5.6.0                                             |
| Moodle            | 4.5.15 LTS                                        |
| MariaDB en Docker | 11.4.13                                           |
| PHP en Moodle     | 8.3, incluido en la imagen                        |
| IP interna Ubuntu | `192.168.50.1`                                    |
| IP interna Mint   | `192.168.50.102`                                  |
| Red               | NAT para Ubuntu y red interna compartida con Mint |

Verifiqué la documentación de la imagen `oksigenia/moodle` y las etiquetas oficiales de MariaDB. Ambas permiten trabajar con las versiones elegidas, sin recurrir a `latest`.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://hub.docker.com\&sz=32)

Docker Image

+1



Importante: las IP anteriores corresponden a tu laboratorio. Si otro integrante utiliza direcciones diferentes, deberá reemplazarlas en los comandos y archivos de configuración.

## 2. Orden de implementación

4

Crear Moodle y MariaDB en Docker

5

Comprobar Moodle desde Linux Mint

6

Configurar los tres departamentos y permisos

7

Instalar y configurar BIND9

8

Configurar VirtualHost con HTTPS

9

Instalar FTP y separar usuarios

10

Automatizar respaldos con Cron

11

Realizar las pruebas de seguridad y restauración

12

Preparar la documentación y demostración

El PDF del profesor establece estos seis requisitos comunes: BIND9, HTTPS, dos servicios Docker con volúmenes, FTP con permisos separados, respaldo automático con restauración y documentación técnica. Para el escenario 3 exige además tres cursos departamentales, grupos con acceso exclusivo y una prueba documentada de acceso denegado.

# PASO 4. Instalar Moodle y MariaDB en Docker

Todo este paso se realiza en Ubuntu Server.

## 4.1. Entrar a la carpeta que ya creamos

```
cd ~/proyecto-moodle
```

Comprobá que estás en la ubicación correcta:

```
pwd
```

Resultado esperado:

```
/home/angelica/proyecto-moodle
```

## 4.2. Confirmar las versiones de las imágenes

Ya verificaste que Moodle 4.5.15 está disponible. Ahora comprobamos la versión exacta de MariaDB:

```
sudo docker manifest inspect mariadb:11.4.13 > /dev/null && echo "MariaDB disponible"
```

Después:

```
sudo docker manifest inspect oksigenia/moodle:4.5.15 > /dev/null && echo "Moodle disponible"
```

Ambos comandos deberían mostrar el mensaje de disponibilidad.

## 4.3. Generar las contraseñas

Comprobá que OpenSSL funciona:

```
openssl version
```

Después creá el archivo `.env`:

```
cat > .env <<EOF
DB_ROOT_PASSWORD=$(openssl rand -hex 20)
DB_PASSWORD=$(openssl rand -hex 20)
MOODLE_ADMIN_PASSWORD=$(openssl rand -hex 16)
EOF
```

Protegelo:

```
chmod 600 .env
```

Este archivo contiene las contraseñas iniciales. No debe publicarse en GitHub ni compartirse con otros equipos.

## 4.4. Crear el archivo Compose

Ejecutá:

```
nano compose.yaml
```

Pegá exactamente:

```
services:
  db:
    image: mariadb:11.4.13
    restart: unless-stopped

    environment:
      MARIADB_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MARIADB_DATABASE: moodle
      MARIADB_USER: moodle
      MARIADB_PASSWORD: ${DB_PASSWORD}

    volumes:
      - mariadb_data:/var/lib/mysql

    healthcheck:
      test:
        - CMD
        - healthcheck.sh
        - --connect
        - --innodb_initialized
      interval: 10s
      timeout: 5s
      retries: 15

    networks:
      - moodle_net

  moodle:
    image: oksigenia/moodle:4.5.15
    restart: unless-stopped

    depends_on:
      db:
        condition: service_healthy

    ports:
      - "192.168.50.1:8080:8080"

    environment:
      MOODLE_URL: http://192.168.50.1:8080
      MOODLE_DB_TYPE: mariadb
      MOODLE_DB_HOST: db
      MOODLE_DB_NAME: moodle
      MOODLE_DB_USER: moodle
      MOODLE_DB_PASSWORD: ${DB_PASSWORD}
      MOODLE_ADMIN_USER: admin
      MOODLE_ADMIN_PASSWORD: ${MOODLE_ADMIN_PASSWORD}
      MOODLE_SITE_NAME: Colegio Tecnico
      MOODLE_SITE_SHORTNAME: Colegio
      MOODLE_LANG: es
      MOODLE_TIMEZONE: America/Costa_Rica

    volumes:
      - moodle_code:/var/www/moodle
      - moodle_data:/var/www/moodledata

    networks:
      - moodle_net

networks:
  moodle_net:
    driver: bridge

volumes:
  mariadb_data:
  moodle_code:
  moodle_data:
```

Guardá con `Ctrl + O`, `Enter`, `Ctrl + X`.

### ¿Qué estamos configurando?

Moodle

Puerto 8080

MariaDB

Puerto 3306 interno

Red Docker moodle_net

Tres volúmenes persistentes

Base de datos, archivos y código de Moodle

El puerto de MariaDB no se publica en la red física; únicamente Moodle se conecta a él mediante Docker.

## 4.5. Validar Compose

```
sudo docker compose config --quiet
```

Si no aparecen errores, ejecutá:

```
sudo docker compose config --images
```

Debe mostrar:

```
mariadb:11.4.13
oksigenia/moodle:4.5.15
```

El orden puede variar.

## 4.6. Descargar las imágenes

```
sudo docker compose pull
```

Para comprobarlas:

```
sudo docker images
```

Anotá las versiones y sus identificadores. Como las etiquetas de Docker pueden reconstruirse manteniendo el mismo nombre, más adelante conviene registrar sus digests para garantizar una reproducción exacta.

## 4.7. Levantar los contenedores

```
sudo docker compose up -d
```

Verificá:

```
sudo docker compose ps
```

Deberían aparecer los servicios `db` y `moodle`.

Si alguno está iniciando o muestra un error, revisá:

```
sudo docker compose logs --tail=100 db
```

```
sudo docker compose logs --tail=100 moodle
```

La primera ejecución de Moodle realiza la instalación inicial y la creación de sus tablas.

## 4.8. Confirmar la base de datos

Ejecutá:

```
sudo docker compose exec db mariadb -u moodle -p moodle
```

El programa solicitará la contraseña `DB_PASSWORD`, guardada en `.env`.

Para consultarla en Ubuntu:

```
grep '^DB_PASSWORD=' .env
```

Dentro de MariaDB:

```
SHOW TABLES;
```

Deberían aparecer numerosas tablas con nombres que comienzan por `mdl_`.

Para salir:

```
exit;
```

## 4.9. Verificar los volúmenes

```
sudo docker volume ls
```

Deberían existir volúmenes relacionados con:

- `mariadb_data`
- `moodle_code`
- `moodle_data`

Evidencia 1: captura de `docker compose ps`, las imágenes versionadas y los volúmenes creados.

# PASO 5. Acceder a Moodle desde Linux Mint

## 5.1. Comprobar el servicio desde Ubuntu

En Ubuntu:

```
curl -I http://192.168.50.1:8080
```

Una respuesta HTTP, como `200` o `302`, indica que Apache está respondiendo.

## 5.2. Abrir Moodle desde Mint

En la máquina virtual Linux Mint, abrí Firefox y escribí:

```
http://192.168.50.1:8080
```

Debe aparecer Moodle.

[Moodle 4.3 LMS on Ubuntu 22.04 on Azure User Guide | cloudimg](https://images.openai.com/static-rsc-4/tHoAslOw6rXdWTgg7YyKfwL8cTyT4AdWkcq26PbAdxL_I_4RlOVD39DjpVArBsvXiyLlVqG7eGKT8K98p_nVPfc789OQsD-mlHSTYyWaYkMjolgOSuSU8MeLA5UAjZua39rJ12YATd3ItAiUrC0bMH8Xi0aUk9w0Ofe7l17SE50?purpose=inline)

[cloudimg.co.uk](https://www.cloudimg.co.uk/guides/moodle-4-3-12-on-ubuntu-22-04-azure/?utm_source=chatgpt.com)

Iniciá sesión utilizando:

```
Usuario: admin
Contraseña: la generada en MOODLE_ADMIN_PASSWORD
```

Podés consultar la contraseña en Ubuntu:

```
cd ~/proyecto-moodle
grep '^MOODLE_ADMIN_PASSWORD=' .env
```

No incluyás la contraseña en las capturas.

Si Moodle carga desde Mint y podés iniciar sesión, ya están funcionando la red entre las máquinas, el servidor web del contenedor, PHP y la conexión a MariaDB.

## 5.3. Probar la persistencia

En Ubuntu:

```
sudo docker compose down
```

Después:

```
sudo docker compose up -d
```

Volvé a abrir Moodle desde Mint y comprobá que sigue instalada la plataforma con el mismo administrador.

No utilicés `docker compose down -v`, porque eliminaría los volúmenes persistentes.

Evidencia 2: captura de Moodle funcionando desde el navegador de Linux Mint.

# PASO 6. Configurar el Colegio Técnico en Moodle

Esta parte se realiza desde Firefox en Linux Mint, iniciando sesión como administrador de Moodle.

No necesitamos programar una aplicación. Todas estas opciones se administran desde la interfaz de Moodle.

## 6.1. Personalizar la plataforma

Ingresá a:

Administración del sitio → Página principal → Ajustes de la página principal.

Configurá:

- Nombre completo: `Colegio Técnico`
- Nombre corto: `Colegio`
- Descripción: `Plataforma institucional de aprendizaje y gestión de recursos departamentales.`

Después, en la configuración de apariencia del sitio, personalizá el tema disponible, los colores y el logotipo.

Podés utilizar un logo propio que identifique al colegio ficticio del escenario.

## 6.2. Crear las categorías de cursos

Ingresá a:

Administración del sitio → Cursos → Administrar cursos y categorías.

Creá tres categorías:

1. Administración
2. Docencia
3. Informática

Estas categorías permiten organizar los cursos, pero no constituyen por sí solas un mecanismo de seguridad.

## 6.3. Crear los tres cursos

Dentro de cada categoría, seleccioná la opción para crear un curso nuevo.

| Categoría      | Nombre del curso                     | Nombre corto |
| -------------- | ------------------------------------ | ------------ |
| Administración | Gestión Documental Institucional     | `ADM101`     |
| Docencia       | Evaluación y Planificación Educativa | `DOC101`     |
| Informática    | Fundamentos de Seguridad Informática | `INF101`     |

Configurá los cursos como visibles para sus participantes autorizados. La restricción efectiva se hará mediante las matrículas y los permisos.

## 6.4. Agregar los recursos y actividades

Cada curso necesita como mínimo dos recursos y una actividad evaluable.

| Curso          | Recurso 1                               | Recurso 2                          | Actividad                                       |
| -------------- | --------------------------------------- | ---------------------------------- | ----------------------------------------------- |
| Administración | PDF sobre archivo institucional         | Guía de clasificación documental   | Cuestionario sobre clasificación de expedientes |
| Docencia       | Presentación sobre evaluación formativa | Guía sobre elaboración de rúbricas | Cuestionario sobre evaluación                   |
| Informática    | Guía de contraseñas seguras             | PDF sobre phishing                 | Cuestionario de seguridad informática           |

Para agregar contenido:

1. Entrá al curso.
2. Activá el modo de edición.
3. Seleccioná Añadir una actividad o recurso.
4. Elegí Archivo, Página u otro recurso apropiado.
5. Subí el material real que elaboraron.
6. Repetí el procedimiento y agregá un cuestionario con preguntas y calificación.

El profesor exige contenido genuino, así que no utilicen documentos vacíos ni texto genérico de relleno.

## 6.5. Crear los usuarios de prueba

Ingresá a:

Administración del sitio → Usuarios → Cuentas → Agregar un nuevo usuario.

Creá inicialmente los siguientes usuarios:

| Usuario      | Departamento   | Rol en su curso |
| ------------ | -------------- | --------------- |
| `admin01`    | Administración | Estudiante      |
| `docente01`  | Docencia       | Estudiante      |
| `info01`     | Informática    | Estudiante      |
| `profesor01` | Docencia       | Profesor        |

Utilizá correos de ejemplo válidos para el laboratorio, como direcciones bajo `example.com`, y contraseñas diferentes para cada usuario.

Conservá además el usuario `admin`, que será el administrador general del sitio.

## 6.6. Crear las cohortes departamentales

En Moodle una cohorte es una colección de usuarios que puede utilizarse para matricular participantes en cursos.

Buscá:

Administración del sitio → Usuarios → Cuentas → Cohortes.

Creá:

- `Cohorte_Administracion`
- `Cohorte_Docencia`
- `Cohorte_Informatica`

Asigná cada usuario a su cohorte correspondiente.

## 6.7. Configurar la matrícula por cohorte

Entrá al curso `ADM101`.

En la sección Participantes → Métodos de matriculación, agregá un método de sincronización de cohortes, si está disponible, y seleccioná `Cohorte_Administracion`.

Repetí:

| Curso    | Cohorte autorizada       |
| -------- | ------------------------ |
| `ADM101` | `Cohorte_Administracion` |
| `DOC101` | `Cohorte_Docencia`       |
| `INF101` | `Cohorte_Informatica`    |

Si el método de sincronización de cohortes no aparece, habilitalo desde Administración del sitio → Plugins → Matriculaciones → Gestionar plugins de matriculación.

Además, comprobá que no exista automatriculación abierta ni acceso de invitados a estos cursos.

Para `profesor01`, podés usar matriculación manual en `DOC101` con el rol Profesor. No otorgués a los participantes privilegios administrativos globales.

## 6.8. Comprobar el aislamiento

Cerrá la sesión del administrador e ingresá con `info01`.

Primero, comprobá que podés abrir `INF101`.

Luego intentá abrir directamente la URL del curso `ADM101`. Para obtenerla, ingresá previamente como administrador a ese curso y copiá su enlace.

El resultado esperado es que Moodle rechace el acceso, solicite una matrícula autorizada o informe que el usuario no puede acceder.

Repetí las pruebas con `admin01` y `docente01`.

Matriz de acceso esperado

| Usuario   | ADM101    | DOC101    | INF101    |
| --------- | --------- | --------- | --------- |
| admin01   | Permitido | Denegado  | Denegado  |
| docente01 | Denegado  | Permitido | Denegado  |
| info01    | Denegado  | Denegado  | Permitido |

Evidencia 3: capturas de los tres cursos, sus recursos, usuarios y accesos denegados.

# PASO 7. Configurar DNS con BIND9

Ahora vamos a crear el dominio local del proyecto.

Utilizaremos:

```
moodle.colegio.test
```

El dominio `.test` está reservado para pruebas y no necesita registrarse públicamente.

## 7.1. Instalar BIND9 en Ubuntu

```
sudo apt update
```

```
sudo apt install -y bind9 bind9-utils dnsutils
```

Comprobá:

```
named -v
```

Y verificá el estado del servicio:

```
sudo systemctl status named --no-pager
```

Ubuntu ya tiene servicios de resolución DNS propios, por lo que antes de modificar BIND comprobamos quién ocupa el puerto 53:

```
sudo ss -lntup | grep ':53 '
```

Es normal que `systemd-resolved` utilice una dirección local como `127.0.0.53`. Configuraremos BIND9 para escuchar específicamente en la IP interna `192.168.50.1`, evitando que compita por todas las interfaces.

## 7.2. Configurar las opciones DNS

Abrí:

```
sudo nano /etc/bind/named.conf.options
```

Dejá la configuración del bloque `options` así:

```
options {
    directory "/var/cache/bind";

    recursion yes;

    allow-recursion {
        127.0.0.1;
        192.168.50.0/24;
    };

    allow-query {
        127.0.0.1;
        192.168.50.0/24;
    };

    listen-on {
        127.0.0.1;
        192.168.50.1;
    };

    listen-on-v6 { none; };

    forwarders {
        8.8.8.8;
        1.1.1.1;
    };

    dnssec-validation auto;
};
```

Esto configura BIND9 para atender consultas del laboratorio y utilizar resolutores externos cuando se trate de dominios públicos.

## 7.3. Registrar la zona del proyecto

Abrí:

```
sudo nano /etc/bind/named.conf.local
```

Agregá al final:

```
zone "colegio.test" {
    type master;
    file "/etc/bind/db.colegio.test";
    allow-transfer { none; };
};
```

## 7.4. Crear el archivo de zona

Primero copiamos una plantilla:

```
sudo cp /etc/bind/db.local /etc/bind/db.colegio.test
```

Abrí:

```
sudo nano /etc/bind/db.colegio.test
```

Reemplazá el contenido por:

```
$TTL 604800

@   IN  SOA ns1.colegio.test. admin.colegio.test. (
        2026102101
        604800
        86400
        2419200
        604800 )

@       IN  NS  ns1.colegio.test.

ns1     IN  A   192.168.50.1
moodle  IN  A   192.168.50.1
```

El número `2026102101` es el serial inicial de la zona. Si posteriormente modificás los registros, incrementá ese número.

## 7.5. Validar BIND9

```
sudo named-checkconf
```

Luego:

```
sudo named-checkzone colegio.test /etc/bind/db.colegio.test
```

Esperamos un resultado que incluya:

```
OK
```

Reiniciá el servicio:

```
sudo systemctl restart named
```

Y comprobá:

```
sudo systemctl is-active named
```

Debe devolver:

```
active
```

## 7.6. Probar el DNS desde Ubuntu

```
dig @192.168.50.1 moodle.colegio.test
```

La respuesta debe contener:

```
moodle.colegio.test. IN A 192.168.50.1
```

También podés utilizar:

```
dig @192.168.50.1 moodle.colegio.test +short
```

Resultado:

```
192.168.50.1
```

## 7.7. Configurar Linux Mint para utilizar BIND9

Aquí sí necesitamos configurar DNS en Mint, pero únicamente para que pueda resolver el dominio interno del proyecto. No estamos agregando un adaptador NAT ni cambiando la arquitectura de la red.

Linux Mint seguirá usando solo su adaptador de red interna.

En Linux Mint:

```
sudo nmcli connection modify "Wired connection 1" \
  ipv4.dns "192.168.50.1"
```

Después:

```
sudo nmcli connection modify "Wired connection 1" \
  ipv4.ignore-auto-dns yes
```

Aplicá:

```
sudo nmcli device reapply enp0s3
```

Comprobá:

```
nmcli device show enp0s3 | grep IP4.DNS
```

Debe aparecer:

```
192.168.50.1
```

Ahora:

```
getent hosts moodle.colegio.test
```

Debería resolver el dominio a:

```
192.168.50.1
```

Si no lo hace, probá:

```
resolvectl query moodle.colegio.test
```

En esta etapa también podés instalar `dig` en Mint, si cuenta con acceso a paquetes, pero no es obligatorio porque `getent` permite hacer la comprobación básica.

Evidencia 4: captura de BIND9 activo y del dominio resolviendo correctamente desde Mint.

# PASO 8. Configurar HTTPS y el VirtualHost

El profesor solicita que Moodle funcione mediante un dominio y HTTPS.

Utilizaremos Nginx en Ubuntu Server como proxy inverso, mientras Moodle continúa ejecutándose en Docker.

La arquitectura será:

Linux Mint

Firefox: [https://moodle.colegio.test](https://moodle.colegio.test?utm_source=chatgpt.com)

Nginx + HTTPS

Ubuntu Server — puerto 443

Moodle en Docker

Puerto 8080 → MariaDB por red interna

## 8.1. Instalar Nginx

En Ubuntu:

```
sudo apt install -y nginx openssl
```

Comprobá:

```
nginx -v
```

Y:

```
sudo systemctl is-active nginx
```

## 8.2. Crear el certificado

Como el dominio es local, crearemos un certificado autofirmado para el laboratorio.

Creá la carpeta:

```
sudo mkdir -p /etc/nginx/certs
```

Generá la clave privada y el certificado, con una validez de 365 días:

```
sudo openssl req -x509 -nodes -days 365 \
  -newkey rsa:3072 \
  -keyout /etc/nginx/certs/colegio.key \
  -out /etc/nginx/certs/colegio.crt \
  -subj "/C=CR/O=Colegio Tecnico/CN=moodle.colegio.test" \
  -addext "subjectAltName=DNS:moodle.colegio.test"
```

Protegé la clave:

```
sudo chmod 600 /etc/nginx/certs/colegio.key
```

Verificá los datos del certificado:

```
openssl x509 -in /etc/nginx/certs/colegio.crt \
  -noout -subject -dates -ext subjectAltName
```

El certificado debe identificar el dominio `moodle.colegio.test`.

## 8.3. Crear el VirtualHost

En Ubuntu:

```
sudo nano /etc/nginx/sites-available/moodle
```

Pegá:

```
server {
    listen 192.168.50.1:80;

    server_name moodle.colegio.test;

    return 301 https://$host$request_uri;
}

server {
    listen 192.168.50.1:443 ssl;

    server_name moodle.colegio.test;

    ssl_certificate /etc/nginx/certs/colegio.crt;
    ssl_certificate_key /etc/nginx/certs/colegio.key;

    ssl_protocols TLSv1.2 TLSv1.3;

    client_max_body_size 100M;

    location / {
        proxy_pass http://192.168.50.1:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;

        proxy_http_version 1.1;

        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
    }
}
```

Guardá el archivo.

## 8.4. Habilitar el sitio

Creá el enlace:

```
sudo ln -s /etc/nginx/sites-available/moodle \
  /etc/nginx/sites-enabled/moodle
```

Si el enlace ya existe, no hace falta crearlo nuevamente.

Validá:

```
sudo nginx -t
```

Si muestra que la prueba es correcta:

```
sudo systemctl reload nginx
```

## 8.5. Cambiar la URL de Moodle

Ahora necesitamos indicarle al contenedor que su dirección definitiva será HTTPS.

En Ubuntu:

```
cd ~/proyecto-moodle
```

Guardá una copia del Compose anterior:

```
cp compose.yaml compose-http.backup.yaml
```

Abrí:

```
nano compose.yaml
```

Buscá esta línea:

```
MOODLE_URL: http://192.168.50.1:8080
```

Reemplazala por:

```
MOODLE_URL: https://moodle.colegio.test
```

En la sección `environment` del servicio `moodle`, agregá:

```
MOODLE_SSL_PROXY: "yes"
```

Esta opción le indica a Moodle que HTTPS termina en un proxy situado delante del contenedor.

Para que el puerto 8080 no quede expuesto a toda la red interna, también es recomendable cambiar:

```
- "192.168.50.1:8080:8080"
```

Por:

```
- "127.0.0.1:8080:8080"
```

Y en el archivo de Nginx reemplazar:

```
proxy_pass http://192.168.50.1:8080;
```

Por:

```
proxy_pass http://127.0.0.1:8080;
```

Así, Moodle solo se comunica directamente con Nginx desde el propio Ubuntu Server, y los clientes utilizan HTTPS.

Validá y aplicá:

```
sudo docker compose config --quiet
```

```
sudo docker compose up -d
```

Después:

```
sudo nginx -t
sudo systemctl reload nginx
```

## 8.6. Probar HTTPS desde Ubuntu

```
curl -k -I https://moodle.colegio.test
```

La opción `-k` se utiliza únicamente para probar el certificado autofirmado del laboratorio.

Si el sistema operativo Ubuntu no está utilizando BIND9 para resolver su propio dominio, podés hacer una prueba directa sin modificar el DNS del servidor:

```
curl -k -I \
  --resolve moodle.colegio.test:443:192.168.50.1 \
  https://moodle.colegio.test
```

## 8.7. Abrir Moodle desde Linux Mint

En Firefox:

```
https://moodle.colegio.test
```

Como el certificado es autofirmado, Firefox puede mostrar una advertencia de confianza. Esto no significa necesariamente que HTTPS esté mal configurado.

Para el laboratorio, pueden importar ese certificado como una autoridad de confianza solamente dentro del entorno de pruebas, o continuar mediante una excepción controlada en el navegador. No deben hacerlo con certificados desconocidos de sitios reales.

Para comprobar la conexión cifrada desde Mint:

```
openssl s_client \
  -connect 192.168.50.1:443 \
  -servername moodle.colegio.test \
  </dev/null
```

Buscá información del certificado y el protocolo TLS negociado.

Evidencia 5: Moodle funcionando bajo `https://moodle.colegio.test`, más la configuración del VirtualHost y la validación `nginx -t`.

# PASO 9. Instalar y configurar FTP

Este es otro requisito independiente de Moodle.

El profesor exige cuentas FTP separadas, de modo que un usuario no pueda modificar o borrar archivos de otro.

Configuraremos vsftpd con directorios independientes.

## 9.1. Instalar el servicio

En Ubuntu:

```
sudo apt install -y vsftpd
```

Comprobá:

```
vsftpd -v
```

## 9.2. Crear usuarios FTP

Para la demostración utilizaremos cinco cuentas:

```
sudo adduser ftpadmin
sudo adduser ftpdocencia
sudo adduser ftpinformatica
sudo adduser ftpgrupo4
sudo adduser ftpgrupo5
```

Cada comando solicitará la contraseña correspondiente.

No hace falta colocar información personal en los campos adicionales del asistente.

Para impedir que estas cuentas puedan utilizar una consola interactiva del servidor:

```
for u in ftpadmin ftpdocencia ftpinformatica ftpgrupo4 ftpgrupo5; do
    sudo usermod -s /usr/sbin/nologin "$u"
done
```

Comprobá:

```
getent passwd ftpadmin
```

## 9.3. Crear los directorios separados

Para mantenerlos organizados:

```
sudo mkdir -p /srv/ftp
```

Creá los directorios principales y una carpeta de trabajo por usuario:

```
for u in ftpadmin ftpdocencia ftpinformatica ftpgrupo4 ftpgrupo5; do
    sudo mkdir -p "/srv/ftp/$u/archivos"
    sudo chown root:root "/srv/ftp/$u"
    sudo chmod 755 "/srv/ftp/$u"
    sudo chown "$u:$u" "/srv/ftp/$u/archivos"
    sudo chmod 700 "/srv/ftp/$u/archivos"
    sudo usermod -d "/srv/ftp/$u" "$u"
done
```

Los directorios principales son propiedad de `root` para permitir un aislamiento mediante `chroot`.

La carpeta `archivos` es el único espacio donde cada cuenta puede subir y modificar su contenido.

## 9.4. Crear una lista de usuarios permitidos

```
sudo nano /etc/vsftpd.user_list
```

Agregá:

```
ftpadmin
ftpdocencia
ftpinformatica
ftpgrupo4
ftpgrupo5
```

Guardá.

Asegurate de que el sistema reconozca `/usr/sbin/nologin` como shell válido para autenticación PAM, sin habilitar acceso interactivo:

```
grep -Fxq /usr/sbin/nologin /etc/shells || \
  echo /usr/sbin/nologin | sudo tee -a /etc/shells
```

## 9.5. Configurar vsftpd

Primero respaldá el archivo original:

```
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
```

Abrí:

```
sudo nano /etc/vsftpd.conf
```

Para este laboratorio, reemplazá el contenido por:

```
listen=YES
listen_ipv6=NO
listen_address=192.168.50.1

anonymous_enable=NO
local_enable=YES
write_enable=YES

local_umask=077

chroot_local_user=YES
allow_writeable_chroot=NO

userlist_enable=YES
userlist_deny=NO
userlist_file=/etc/vsftpd.user_list

local_root=/srv/ftp/$USER

pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40010
pasv_address=192.168.50.1

ssl_enable=YES
rsa_cert_file=/etc/nginx/certs/colegio.crt
rsa_private_key_file=/etc/nginx/certs/colegio.key

force_local_logins_ssl=YES
force_local_data_ssl=YES

ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO

require_ssl_reuse=NO

xferlog_enable=YES
```

Utilizamos FTPS explícito para proteger las credenciales y las transferencias mediante TLS. El certificado es el mismo que creamos para el laboratorio HTTPS.

No estamos configurando SFTP: ese es otro protocolo diferente que funciona sobre SSH.

## 9.6. Reiniciar FTP

```
sudo systemctl restart vsftpd
```

Comprobá:

```
sudo systemctl status vsftpd --no-pager
```

Si el servicio falla, consultá:

```
sudo journalctl -u vsftpd -n 50 --no-pager
```

## 9.7. Probar un usuario FTP

En Ubuntu, creá un archivo de prueba:

```
echo "Documento de prueba de Administración" > /tmp/administracion.txt
```

Podés utilizar un cliente compatible con FTPS, como `curl`, para comprobar la autenticación y subir archivos.

Ejemplo para `ftpadmin`:

```
curl --ssl-reqd --insecure \
  --user ftpadmin \
  --upload-file /tmp/administracion.txt \
  ftp://192.168.50.1/archivos/administracion.txt
```

Curl solicitará la contraseña del usuario.

Luego listá la carpeta:

```
curl --ssl-reqd --insecure \
  --user ftpadmin \
  ftp://192.168.50.1/archivos/
```

La opción `--insecure` se usa aquí únicamente porque el certificado es autofirmado.

## 9.8. Comprobar que los permisos funcionan

Iniciá sesión como `ftpdocencia` e intentá acceder a un archivo de `ftpadmin`.

Una ruta que podés intentar consultar es:

```
/../ftpadmin/archivos/administracion.txt
```

El acceso debe fallar o quedar restringido al directorio raíz del usuario autenticado.

También podés comprobar los permisos desde Ubuntu:

```
ls -ld /srv/ftp/*
```

Y:

```
ls -ld /srv/ftp/*/archivos
```

Los archivos departamentales no deben quedar disponibles para modificación por cualquier usuario del servidor.

Evidencia 6: captura de las cinco cuentas, sus directorios y una prueba en la que un usuario intenta acceder a los archivos de otro y recibe una denegación.

# PASO 10. Automatizar respaldos con Cron

Este requisito incluye dos partes obligatorias: generar respaldos automáticamente y demostrar que se puede restaurar la base de datos.

Haremos una copia comprimida de MariaDB todos los días.

## 10.1. Crear el directorio de respaldos

En Ubuntu:

```
sudo mkdir -p /var/backups/moodle
```

Protegé el directorio:

```
sudo chmod 700 /var/backups/moodle
```

## 10.2. Crear el script de respaldo

Primero:

```
cd ~/proyecto-moodle
```

Creá:

```
nano respaldo.sh
```

Pegá:

```
#!/bin/bash

set -euo pipefail

umask 077

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="/var/backups/moodle"
FECHA=$(date +%Y-%m-%d_%H-%M-%S)

cd "$PROJECT_DIR"

# Cargar las credenciales de la base de datos
set -a
source .env
set +a

mkdir -p "$BACKUP_DIR"

# Crear una copia de seguridad comprimida
docker compose exec -T \
    -e MYSQL_PWD="$DB_ROOT_PASSWORD" \
    db mariadb-dump \
    -u root \
    --single-transaction \
    --quick \
    --routines \
    --events \
    moodle \
    | gzip > "$BACKUP_DIR/moodle_$FECHA.sql.gz"

# Comprobar que el archivo no esté vacío
test -s "$BACKUP_DIR/moodle_$FECHA.sql.gz"

# Comprobar la integridad del archivo comprimido
gzip -t "$BACKUP_DIR/moodle_$FECHA.sql.gz"

# Conservar solamente los últimos 7 días de copias
find "$BACKUP_DIR" \
    -type f \
    -name "moodle_*.sql.gz" \
    -mtime +7 \
    -delete

echo "Respaldo completado: $FECHA"
```

Guardá.

El script utiliza una ruta relativa a su propia ubicación, así que funciona dentro del directorio del proyecto sin depender de que alguien esté ubicado manualmente allí.

## 10.3. Dar permisos de ejecución

```
chmod 700 respaldo.sh
```

Comprobá que no tiene errores de sintaxis:

```
bash -n respaldo.sh
```

Si no muestra errores, continuá.

## 10.4. Ejecutar un respaldo manual

```
sudo ./respaldo.sh
```

Resultado esperado:

```
Respaldo completado: 2026-10-21_...
```

La fecha y hora corresponderán al momento de la ejecución.

Verificá los archivos:

```
sudo ls -lh /var/backups/moodle
```

Y la integridad:

```
sudo gzip -t /var/backups/moodle/*.sql.gz
```

Si el último comando no muestra errores, el archivo comprimido es válido. Esto todavía no garantiza que la base de datos se pueda restaurar; lo probaremos a continuación.

## 10.5. Programar Cron

Abrí el Cron de `root`:

```
sudo crontab -e
```

Al final agregá:

```
0 2 * * * /home/angelica/proyecto-moodle/respaldo.sh >> /var/log/moodle-backup.log 2>&1
```

Con esta configuración se ejecuta todos los días a las 2:00 a. m., según la zona horaria de Ubuntu Server.

Si otro integrante tiene un usuario diferente a `angelica`, deberá reemplazar esa parte de la ruta.

Comprobá la zona horaria:

```
timedatectl
```

Si necesitás configurar Costa Rica:

```
sudo timedatectl set-timezone America/Costa_Rica
```

Verificá Cron:

```
sudo systemctl enable --now cron
```

```
sudo systemctl is-active cron
```

Y la programación:

```
sudo crontab -l
```

Importante: la tarea solo se ejecutará si la VM está encendida a la hora programada. Para la demostración, también podemos ejecutarla manualmente.

## 10.6. Probar una restauración sin dañar Moodle

No vamos a borrar ni sobrescribir la base de datos real.

Crearemos una segunda base de datos, llamada `moodle_restore_test`, e importaremos allí la copia.

Primero entrá:

```
cd ~/proyecto-moodle
```

Cargá las variables:

```
set -a
source .env
set +a
```

Creá la base de prueba:

```
sudo docker compose exec -T \
  -e MYSQL_PWD="$DB_ROOT_PASSWORD" \
  db mariadb -u root \
  -e "CREATE DATABASE IF NOT EXISTS moodle_restore_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

Ahora recuperá la ruta del respaldo más reciente:

```
BACKUP=$(sudo find /var/backups/moodle \
  -name 'moodle_*.sql.gz' \
  -type f \
  -printf '%T@ %p\n' \
  | sort -nr \
  | head -1 \
  | cut -d' ' -f2-)
```

Comprobá:

```
echo "$BACKUP"
```

Debe mostrar la ruta de un archivo `.sql.gz`.

Restaurá:

```
sudo gzip -dc "$BACKUP" | \
sudo docker compose exec -T \
  -e MYSQL_PWD="$DB_ROOT_PASSWORD" \
  db mariadb -u root moodle_restore_test
```

Si el comando termina correctamente, verificá que se hayan recuperado las tablas:

```
sudo docker compose exec -T \
  -e MYSQL_PWD="$DB_ROOT_PASSWORD" \
  db mariadb -u root \
  -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'moodle_restore_test';"
```

El resultado debe ser un número mayor que cero.

Eso demuestra que el archivo SQL se importó en una base independiente. Para una validación más completa, compará el número de tablas de la base original y el de la restaurada.

Después de guardar la evidencia, podés eliminar únicamente la base de prueba:

```
sudo docker compose exec -T \
  -e MYSQL_PWD="$DB_ROOT_PASSWORD" \
  db mariadb -u root \
  -e "DROP DATABASE moodle_restore_test;"
```

Nunca utilicés `DROP DATABASE moodle` para este procedimiento.

## 10.7. ¿Qué respaldamos y qué no?

El respaldo obligatorio que acabamos de crear contiene la base de datos.

Pero Moodle también almacena archivos fuera de MariaDB, en sus volúmenes. Para una recuperación completa conviene respaldarlos.

Podemos guardar los archivos de Moodle con los siguientes comandos, deteniendo primero la aplicación para obtener una copia consistente:

```
cd ~/proyecto-moodle
```

```
sudo docker compose stop moodle
```

Localizá el volumen de datos:

```
sudo docker volume ls
```

Si el proyecto se llama `proyecto-moodle`, el volumen normalmente será `proyecto-moodle_moodle_data`.

Creá una copia de ese volumen:

```
sudo docker run --rm \
  -v proyecto-moodle_moodle_data:/datos:ro \
  -v /var/backups/moodle:/respaldos \
  alpine:3.22 \
  tar -czf /respaldos/moodledata_manual.tar.gz -C /datos .
```

Reiniciá Moodle:

```
sudo docker compose start moodle
```

Esta copia de archivos complementa la base de datos, pero no sustituye la prueba de restauración SQL del requisito del profesor.

Evidencia 7

Guardá capturas del archivo creado, la programación de Cron y la restauración de `moodle_restore_test` mostrando las tablas recuperadas.

# PASO 11. Realizar las pruebas finales

Ya tenemos los componentes necesarios. Ahora hay que demostrar que trabajan correctamente y cumplen los requisitos del escenario.

## 11.1. Comprobar los contenedores

En Ubuntu:

```
cd ~/proyecto-moodle
sudo docker compose ps
```

Deben aparecer dos servicios operativos:

- Moodle.
- MariaDB.

## 11.2. Comprobar los servicios de Ubuntu

```
sudo systemctl is-active named
```

```
sudo systemctl is-active nginx
```

```
sudo systemctl is-active vsftpd
```

```
sudo systemctl is-active cron
```

Los cuatro deberían responder `active`.

## 11.3. Comprobar los puertos

```
sudo ss -lntup
```

Verificá los siguientes:

| Puerto       | Servicio                          |
| ------------ | --------------------------------- |
| 21/TCP       | FTP/FTPS                          |
| 53/TCP y UDP | BIND9                             |
| 80/TCP       | Nginx, redirección a HTTPS        |
| 443/TCP      | Nginx HTTPS                       |
| 8080/TCP     | Moodle, accesible solo localmente |

MariaDB utiliza internamente el puerto 3306, pero no debe estar publicado por el contenedor hacia la red del laboratorio.

Como ya tenías MariaDB instalada directamente en Ubuntu, comprobá si también está escuchando en el puerto 3306:

```
sudo ss -lntp | grep ':3306'
```

Si aparece el servicio del host y no lo necesitás para otros laboratorios, podés detenerlo:

```
sudo systemctl stop mariadb
```

Esto no detiene MariaDB dentro de Docker. No desinstalés ni eliminés bases existentes del host sin revisar antes si contienen información importante.

## 11.4. Comprobar los accesos desde Mint

Desde Linux Mint realizá estas pruebas:

| Prueba                              | Resultado esperado      |
| ----------------------------------- | ----------------------- |
| `ping -c 4 192.168.50.1`            | Comunicación correcta   |
| `getent hosts moodle.colegio.test`  | Resuelve `192.168.50.1` |
| Abrir `http://moodle.colegio.test`  | Redirige a HTTPS        |
| Abrir `https://moodle.colegio.test` | Muestra Moodle          |
| Ingresar con usuario autorizado     | Accede a su curso       |
| Abrir enlace directo de curso ajeno | Acceso denegado         |
| Probar FTP con diferentes cuentas   | Directorios aislados    |

## 11.5. Verificar el firewall

Antes de la presentación:

```
sudo ufw status verbose
```

Si UFW está activo, deben permitir los servicios necesarios desde la red interna, sin abrirlos indiscriminadamente hacia otras redes.

Ejemplo:

```
sudo ufw allow from 192.168.50.0/24 to any port 53 proto tcp
sudo ufw allow from 192.168.50.0/24 to any port 53 proto udp

sudo ufw allow from 192.168.50.0/24 to any port 80 proto tcp
sudo ufw allow from 192.168.50.0/24 to any port 443 proto tcp

sudo ufw allow from 192.168.50.0/24 to any port 21 proto tcp
sudo ufw allow from 192.168.50.0/24 to any port 40000:40010 proto tcp
```

No actives UFW automáticamente si ya existen reglas importantes. Revisá primero el estado y las reglas actuales. Si administrás Ubuntu mediante SSH, asegurate de conservar ese acceso antes de modificar el firewall.

# PASO 12. Documentación técnica y presentación

El documento técnico debe permitir que otra persona reproduzca el laboratorio desde cero.

Te recomiendo organizarlo de esta forma:

| Sección         | Qué deben incluir                                                 |
| --------------- | ----------------------------------------------------------------- |
| 1. Introducción | Problema del Colegio Técnico y objetivo del proyecto              |
| 2. Arquitectura | Diagrama de Ubuntu, Mint, Docker, Moodle, MariaDB y los servicios |
| 3. Tecnologías  | Versiones utilizadas y justificación del software libre           |
| 4. Instalación  | Comandos y configuraciones de cada servicio                       |
| 5. Moodle       | Cursos, categorías, contenido, cohortes y permisos                |
| 6. Seguridad    | HTTPS, aislamiento FTP y pruebas de acceso denegado               |
| 7. Respaldos    | Script, Cron, retención y restauración                            |
| 8. Resultados   | Capturas y explicación de las pruebas                             |
| 9. Conclusiones | Resultados, limitaciones y mejoras posibles                       |

Conviene guardar también las versiones exactas utilizadas.

En Ubuntu ejecutá:

```
docker --version
```

```
docker compose version
```

```
cd ~/proyecto-moodle
sudo docker compose images
```

```
sudo docker image inspect oksigenia/moodle:4.5.15 \
  --format '{{json .RepoDigests}}'
```

```
sudo docker image inspect mariadb:11.4.13 \
  --format '{{json .RepoDigests}}'
```

Guardá esas referencias en la documentación técnica.

## Lista final de requisitos

Control de cumplimiento

0/10

DNS propio con BIND9

Zona colegio.test y consultas exitosas desde Mint

VirtualHost con HTTPS

Dominio funcionando con certificado y redirección

Docker con persistencia

Moodle y MariaDB versionados, con volúmenes

FTP con permisos independientes

Cinco cuentas y pruebas de acceso denegado

Respaldo automático con Cron

Copia programada y restauración comprobada

Documentación técnica

Diagrama, comandos, justificaciones y capturas

Tres cursos reales

Dos recursos y una actividad evaluable por curso

Tres grupos departamentales

Matrículas y acceso exclusivo a su curso

Prueba de control de acceso

Enlace directo a recurso ajeno rechazado

Demostración en vivo

Servicios y controles funcionando ante el profesor

&#x20;Copiar lista de cumplimiento

## Recomendaciones para evitar problemas

1\. No mezclen MariaDB del host con MariaDB de Docker. Moodle debe utilizar exclusivamente la base de datos configurada dentro del contenedor `db`.

2\. No eliminen los volúmenes Docker cuando reinicien los servicios. `docker compose down` normalmente los conserva; `docker compose down -v` los elimina.

3\. Cuando cambien la URL de Moodle a HTTPS, utilicen siempre el dominio definitivo. Eviten alternar después entre la IP con HTTP y el dominio HTTPS, porque Moodle utiliza una URL principal en su configuración.

4\. No confundan las restricciones de Moodle con los permisos FTP. Son dos pruebas independientes que el grupo debe demostrar.

5\. Hagan una instantánea de Ubuntu y Mint cuando terminen cada etapa importante. También guarden el archivo Compose, las configuraciones de Nginx y BIND9, y los respaldos de datos fuera de la VM cuando sea posible.

6\. Mantengan las versiones fijas y documentadas. No utilicen `latest` ni ejecuten actualizaciones de imágenes justo antes de la presentación. Los contenedores con etiquetas exactas cumplen el mínimo solicitado; los digests registrados les proporcionan una referencia todavía más precisa.

Con esta guía tienen el procedimiento completo previsto para cumplir el escenario 3. Los resultados esperados son objetivos de verificación, no confirmaciones de que esos servicios ya están funcionando: deberán ejecutar cada fase y corregir cualquier error específico del entorno antes de marcarla como completada.

La entrega será el 7 de noviembre de 2026. La prioridad es que los cinco consigan primero Moodle y MariaDB funcionando, luego implementen los tres cursos y los permisos, y finalmente completen la seguridad, los respaldos y la evidencia de cada requisito.

---
**Nota del equipo:** la guía anterior queda conservada por trazabilidad; algunas instrucciones deben ajustarse a las correcciones que están en `docs/procedimientos/` y `infra/`. **No ejecutar la guía histórica de principio a fin sobre una VM ya configurada.**
