# Paquete de entrega — cómo armar la carpeta comprimida

**Para quién:** la persona del grupo que arma la entrega del 07/11/2026 (límite 7:59 a. m.).
**Idea central:** el profesor compara lo entregado con lo que corre en el servidor. Por eso el paquete se arma **en el servidor de la demostración, copiando sin editar**, y no a partir de los archivos modelo de `infra/`.

## 1. Antes de empezar: decisiones que deben estar tomadas

- [ ] **Cuál VM es el servidor de la demostración.** Todo el paquete sale de esa VM y la demo se hace con esa VM. Ver [ADR-0004](../decisiones/ADR-0004-servidor-unico-de-demostracion.md). Hoy hay al menos dos VMs con diferencias reales (UFW, versión de Nginx, ruta del proyecto, servicios ajenos).
- [ ] La configuración está **congelada**: después de armar el paquete no se edita nada en el servidor. Si hay que corregir algo, se vuelve a armar el paquete.
- [ ] `restauracion-prueba.sh` y `verificar-servicios.sh` están copiados en la carpeta del proyecto del servidor y se probaron (sección 3).

## 2. Estructura final de la carpeta

```text
entrega-ctcr/
├── LEEME.txt                      # qué es cada cosa y de dónde salió
├── docker-compose.yml             # copia byte a byte del compose del servidor
├── .env.example                   # solo nombres de variables, sin valores
├── configuraciones/
│   ├── bind/named.conf.local
│   ├── bind/named.conf.options
│   ├── bind/db.ctcr
│   ├── nginx/aulavirtual.ctcr.conf
│   ├── nginx/sites-enabled.txt    # qué sitios están habilitados
│   └── vsftpd/vsftpd.conf
├── scripts/
│   ├── respaldo.sh
│   ├── restauracion-prueba.sh
│   └── verificar-servicios.sh
├── crontab.txt                    # crontab de root
├── ufw.txt                        # estado de UFW (o aviso de que no se usa)
├── firewall-iptables.txt          # reglas reales si el filtrado es con iptables
├── versiones.txt                  # SO, Docker, imágenes con digest, paquetes
├── documentacion/                 # documento técnico (PDF) y diagramas
├── evidencia/                     # capturas y salidas con fecha
├── mapa-origen.txt                # archivo del paquete → ruta en el servidor
└── hashes.txt                     # SHA-256 de todo lo anterior
```

No va: `Dockerfile` (no construimos imágenes propias), `.env`, claves `.key`, respaldos `.sql.gz`, contraseñas ni datos personales.

## 3. Instalar los scripts nuevos en el servidor

Los scripts viven en este repositorio en [`scripts/`](../../scripts/README.md). El profesor pide los scripts «tal como están en el servidor», así que primero se copian allí y desde allí se exportan.

```bash
# En Ubuntu Server, dentro de la carpeta del proyecto (en la VM #1: /home/criss/proyecto-moodle)
cd ~/proyecto-moodle
# Copiar restauracion-prueba.sh y verificar-servicios.sh (por FTP, USB o pegando el contenido con nano)
chmod 700 restauracion-prueba.sh verificar-servicios.sh
bash -n restauracion-prueba.sh && bash -n verificar-servicios.sh && echo "sintaxis OK"
```

Si se pegaron con `nano` desde Windows, revisar que no tengan finales de línea de Windows (error típico: `/bin/bash^M: bad interpreter`):

```bash
file restauracion-prueba.sh           # NO debe decir "with CRLF line terminators"
sed -i 's/\r$//' restauracion-prueba.sh verificar-servicios.sh   # solo si lo dice
```

Probarlos una vez y guardar la salida como evidencia con fecha:

```bash
sudo ./restauracion-prueba.sh 2>&1 | tee "restauracion_$(date +%F_%H-%M).log"
sudo ./verificar-servicios.sh "$PWD" 2>&1 | tee "verificacion_$(date +%F_%H-%M).log"
```

## 4. Armar el paquete

```bash
cd ~/proyecto-moodle
# Copiar también armar-entrega.sh a esta carpeta
chmod 700 armar-entrega.sh
sudo ./armar-entrega.sh "$PWD" ~
```

El script:

1. Copia `compose.yaml` como `docker-compose.yml`, comprueba con `cmp` que sea idéntico y lo valida con `docker compose -f docker-compose.yml config --quiet` usando el `.env` real.
2. Genera `.env.example` solo con los nombres de las variables.
3. Copia las configuraciones de BIND, Nginx y vsftpd, los scripts y el crontab de root.
4. Exporta `ufw.txt` (o el aviso de que UFW no está instalado), las reglas de iptables y las versiones.
5. Busca secretos (`.env`, `.key`, `.sql`, `PASSWORD=...`, `BEGIN PRIVATE KEY`). Si encuentra alguno, **no comprime** y avisa.
6. Calcula `hashes.txt` y escribe `mapa-origen.txt`.

Si algún archivo no existe en la ruta esperada (por ejemplo, el sitio Nginx tiene otro nombre), el script lo lista como **FALTA**: copiarlo a mano al lugar correcto del paquete y anotar la ruta real en `LEEME.txt`.

## 5. Agregar documentación y evidencia

1. Copiar el documento técnico en PDF a `entrega-ctcr/documentacion/`.
2. Copiar a `entrega-ctcr/evidencia/` las evidencias seleccionadas, **con fecha en el nombre o dentro del archivo**. Mínimo:
   - restauración: el `restauracion_<fecha>.log` de la sección 3 y EV-099;
   - prueba del escenario: EV-060, EV-095 y EV-104 (denegación), EV-087..EV-089 (participantes por curso);
   - verificación general: el `verificacion_<fecha>.log` y [MATRIZ-QA-FINAL](../../pruebas/MATRIZ-QA-FINAL.md).
3. Volver a calcular `hashes.txt` (el script imprime el comando exacto) y comprimir:

```bash
cd ~/entrega-ctcr
find . -type f ! -name hashes.txt ! -name mapa-origen.txt -print0 | sort -z | xargs -0 sha256sum > hashes.txt
cd ~ && tar -czf entrega-ctcr-$(date +%F).tar.gz entrega-ctcr
```

## 6. Comprobar antes de subir

```bash
# 1. El paquete coincide con lo que corre (debe terminar en "TODO OK")
sudo ~/proyecto-moodle/verificar-servicios.sh ~/proyecto-moodle ~/entrega-ctcr
# 2. Los hashes del paquete son consistentes consigo mismos
cd ~/entrega-ctcr && sha256sum -c hashes.txt
# 3. Nada secreto adentro
tar -tzf ~/entrega-ctcr-*.tar.gz | grep -E '\.env$|\.key$|\.sql' && echo "REVISAR" || echo "sin archivos prohibidos"
```

Abrir y leer **cada** archivo de `configuraciones/`, `crontab.txt` y `scripts/` antes de subir.

## 7. Errores que pueden pasar al armar la entrega

| Qué puede pasar | Por qué importa | Cómo evitarlo o corregirlo |
|---|---|---|
| Se entrega `infra/compose/compose.yaml` del repositorio. | Es un **modelo**, no el archivo del servidor: no coincide con el `hashes.txt` de la demo. | Usar siempre `armar-entrega.sh` en el servidor. |
| Quedan `compose.yaml` y `docker-compose.yml` juntos en la carpeta del proyecto con contenido distinto. | Compose usa `compose.yaml` y avisa «Found multiple config files»: lo que corre no es lo entregado. | No crear `docker-compose.yml` en la carpeta del proyecto; el script lo crea **solo dentro del paquete**. `verificar-servicios.sh` lo detecta. |
| Alguien copia el `docker-compose.yml` a otra carpeta y corre `docker compose up -d` allí. | El nombre del proyecto sale del nombre de la carpeta: Compose crea **volúmenes nuevos vacíos** y aparece un Moodle sin cursos. | No levantar nada desde la carpeta del paquete. Si hace falta, usar `-p proyecto-moodle` y la misma carpeta del proyecto. |
| Se edita una configuración en el servidor después de armar el paquete. | Los hashes ya no coinciden en la demo. | Congelar cambios. Si hay que cambiar algo, volver a armar el paquete. |
| El paquete pasa por Windows y Git convierte finales de línea (este repositorio tiene `core.autocrlf=true`). | Cambian los bytes y el SHA-256 de cada archivo de texto. | Subir el `.tar.gz` generado en el servidor tal cual. No descomprimir y volver a comprimir en Windows. Si se versiona una copia en Git, revisar `.gitattributes` (sección 8). |
| `zip: command not found`. | Ya ocurrió en este servidor (INC-006). | El `.tar.gz` es una carpeta comprimida válida; instalar `zip` solo si el aula virtual lo exige. |
| `crontab -l` sin `sudo` muestra «no crontab for criss». | El respaldo está en el crontab de **root**. | El script usa `crontab -l -u root`; en la demo usar `sudo crontab -l`. |
| El paquete incluye `.env`, la clave del certificado o un respaldo SQL. | Expone contraseñas y datos. | El script se detiene si los encuentra; revisar igual a mano. |
| `docker compose config` muestra contraseñas en pantalla. | Sin `--quiet` imprime el YAML resuelto con los valores del `.env`. | Usar siempre `config --quiet` frente al proyector. |
| Se deja el armado para la madrugada del 07/11. | Cualquier imprevisto deja al grupo sin entrega. | Armar el paquete el **06/11** después del ensayo y subirlo esa noche. |

## 8. Si se quiere guardar el paquete también en Git

Opcional. Si se versiona una copia de `entrega-ctcr/` en el repositorio, agregar antes a `.gitattributes`:

```text
entrega-ctcr/** -text
```

Así Git no cambia los finales de línea y los hashes siguen valiendo. El archivo comprimido (`*.tar.gz`, `*.zip`) ya está excluido por `.gitignore`.
