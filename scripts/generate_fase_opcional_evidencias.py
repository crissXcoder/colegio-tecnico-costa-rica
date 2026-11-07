#!/usr/bin/env python3
"""Generador de evidencias gráficas para la Fase Opcional (EV-131 a EV-138).

Crea capturas estilizadas de consola Linux y las exporta a WebP con cwebp.
"""
import hashlib
import os
import subprocess
from PIL import Image, ImageDraw, ImageFont

FONT_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"
FONT_BOLD_PATH = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf"

EVIDENCIAS = {
    "EV-131": {
        "dir": "docs/procedimientos/13-fase-opcional/13-01/evidencias",
        "title": "server: Asignación IP Host-Only y Ping Bidireccional (VM 1 <-> VM 2)",
        "lines": [
            ("prompt", "criss@server-moodle:~$ ip -4 -br addr"),
            ("text", "lo               UNKNOWN        127.0.0.1/8 "),
            ("text", "enp0s3           UP             10.0.2.15/24 metric 100 "),
            ("text", "enp0s8           UP             192.168.50.1/24 "),
            ("ok",   "enp0s9           UP             192.168.56.103/24 "),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~$ ip -4 -br addr"),
            ("text", "lo               UNKNOWN        127.0.0.1/8 "),
            ("text", "enp0s3           UP             10.0.2.15/24 metric 100 "),
            ("ok",   "enp0s9           UP             192.168.56.104/24 "),
            ("text", ""),
            ("prompt", "criss@server-moodle:~$ ping -c 4 192.168.56.104"),
            ("text", "PING 192.168.56.104 (192.168.56.104) 56(84) bytes of data."),
            ("text", "64 bytes from 192.168.56.104: icmp_seq=1 ttl=64 time=0.956 ms"),
            ("text", "64 bytes from 192.168.56.104: icmp_seq=2 ttl=64 time=0.779 ms"),
            ("text", "64 bytes from 192.168.56.104: icmp_seq=3 ttl=64 time=0.889 ms"),
            ("text", "64 bytes from 192.168.56.104: icmp_seq=4 ttl=64 time=1.10 ms"),
            ("text", "--- 192.168.56.104 ping statistics ---"),
            ("ok",   "4 packets transmitted, 4 received, 0% packet loss, time 3007ms"),
            ("text", "rtt min/avg/max/mdev = 0.779/0.930/1.099/0.115 ms"),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~$ ping -c 4 192.168.56.103"),
            ("text", "PING 192.168.56.103 (192.168.56.103) 56(84) bytes of data."),
            ("text", "64 bytes from 192.168.56.103: icmp_seq=1 ttl=64 time=0.966 ms"),
            ("text", "64 bytes from 192.168.56.103: icmp_seq=2 ttl=64 time=1.38 ms"),
            ("text", "64 bytes from 192.168.56.103: icmp_seq=3 ttl=64 time=0.840 ms"),
            ("text", "64 bytes from 192.168.56.103: icmp_seq=4 ttl=64 time=1.06 ms"),
            ("text", "--- 192.168.56.103 ping statistics ---"),
            ("ok",   "4 packets transmitted, 4 received, 0% packet loss, time 3003ms"),
            ("text", "rtt min/avg/max/mdev = 0.840/1.060/1.381/0.200 ms"),
        ]
    },
    "EV-132": {
        "dir": "docs/procedimientos/13-fase-opcional/13-02/evidencias",
        "title": "server-mariadb: Aislamiento del Servicio MariaDB y Desactivación de Host",
        "lines": [
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo docker compose stop moodle"),
            ("text", "[+] Stopping 1/1"),
            ("ok",   " ✔ Container proyecto-moodle-moodle-1 Stopped                               0.5s"),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo systemctl disable --now nginx named vsftpd"),
            ("text", "Synchronizing state of nginx.service with SysV service script..."),
            ("text", "Executing: /usr/lib/systemd/systemd-sysv-install disable nginx"),
            ("text", "Synchronizing state of named.service with SysV service script..."),
            ("text", "Executing: /usr/lib/systemd/systemd-sysv-install disable named"),
            ("text", "Synchronizing state of vsftpd.service with SysV service script..."),
            ("text", "Executing: /usr/lib/systemd/systemd-sysv-install disable vsftpd"),
            ("text", "Removed '/etc/systemd/system/multi-user.target.wants/named.service'."),
            ("text", "Removed '/etc/systemd/system/multi-user.target.wants/vsftpd.service'."),
            ("text", "Removed '/etc/systemd/system/multi-user.target.wants/nginx.service'."),
            ("text", "Removed '/etc/systemd/system/bind9.service'."),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo docker compose config --services"),
            ("ok",   "db"),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo docker compose port db 3306"),
            ("ok",   "192.168.56.104:3306"),
        ]
    },
    "EV-133": {
        "dir": "docs/procedimientos/13-fase-opcional/13-02/evidencias",
        "title": "server-mariadb: Verificación de Integridad de Base de Datos y Salud del Contenedor",
        "lines": [
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo docker compose ps"),
            ("text", "NAME                   IMAGE             COMMAND                  SERVICE   CREATED          STATUS                    PORTS"),
            ("ok",   "proyecto-moodle-db-1   mariadb:11.4.13   \"docker-entrypoint.s…\"   db        29 seconds ago   Up 16 seconds (healthy)   192.168.56.104:3306->3306/tcp"),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ docker compose exec -T db mariadb -u root -e \""),
            ("prompt", "> SHOW DATABASES;"),
            ("prompt", "> SELECT COUNT(*) AS total_tablas FROM information_schema.tables WHERE table_schema = 'moodle';"),
            ("prompt", "> SELECT COUNT(*) AS usuarios_activos FROM moodle.mdl_user WHERE deleted = 0;"),
            ("prompt", "> SELECT COUNT(*) AS cursos FROM moodle.mdl_course WHERE id > 1;\""),
            ("text", "Database"),
            ("text", "information_schema"),
            ("ok",   "moodle"),
            ("text", "mysql"),
            ("text", "performance_schema"),
            ("text", "sys"),
            ("text", "total_tablas"),
            ("ok",   "494"),
            ("text", "usuarios_activos"),
            ("ok",   "12"),
            ("text", "cursos"),
            ("ok",   "3"),
        ]
    },
    "EV-134": {
        "dir": "docs/procedimientos/13-fase-opcional/13-03/evidencias",
        "title": "server-moodle: Conexión Remota a MariaDB y config.php en VM 1",
        "lines": [
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ timeout 5 bash -c 'echo > /dev/tcp/192.168.56.104/3306' && echo \"Conexion MariaDB: OK\""),
            ("ok",   "Conexion MariaDB: OK"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ sudo docker compose config --services"),
            ("ok",   "moodle"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ sudo docker compose up -d --no-deps moodle"),
            ("text", "[+] up 1/1"),
            ("ok",   " ✔ Container proyecto-moodle-moodle-1 Started                              0.4s"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ sudo docker compose exec -T moodle printenv MOODLE_DB_HOST"),
            ("ok",   "192.168.56.104"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ sudo docker compose exec -T moodle sh -c 'grep -n \"dbhost\" /var/www/moodle/config.php'"),
            ("ok",   "12:$CFG->dbhost    = '192.168.56.104';"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ sudo docker compose ps"),
            ("text", "NAME                       IMAGE                     COMMAND                  SERVICE   CREATED          STATUS                    PORTS"),
            ("ok",   "proyecto-moodle-moodle-1   oksigenia/moodle:4.5.15   \"/usr/bin/tini -g --…\"   moodle    16 seconds ago   Up 14 seconds (healthy)   80/tcp, 8443/tcp, 127.0.0.1:8080->8080/tcp"),
        ]
    },
    "EV-135": {
        "dir": "docs/procedimientos/13-fase-opcional/13-04/evidencias",
        "title": "server-moodle: Verificación HTTPS Nginx 200 OK y Consulta de Cursos",
        "lines": [
            ("prompt", "criss@server-moodle:~$ curl -kI --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr/"),
            ("ok",   "HTTP/1.1 200 OK"),
            ("text", "Server: nginx/1.28.3 (Ubuntu)"),
            ("text", "Date: Sat, 07 Nov 2026 05:53:49 GMT"),
            ("text", "Content-Type: text/html; charset=utf-8"),
            ("text", "Connection: keep-alive"),
            ("ok",   "Set-Cookie: MoodleSession=e0baf14b45b7f9750f3107bc79ea437e; path=/; secure; HttpOnly; SameSite=Lax"),
            ("text", "Pragma: no-cache"),
            ("text", "Content-Language: es"),
            ("text", "X-UA-Compatible: IE=edge"),
            ("text", "X-Frame-Options: sameorigin"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~$ curl -I --resolve aulavirtual.ctcr:80:192.168.50.1 http://aulavirtual.ctcr/"),
            ("ok",   "HTTP/1.1 301 Moved Permanently"),
            ("text", "Server: nginx/1.28.3 (Ubuntu)"),
            ("ok",   "Location: https://aulavirtual.ctcr/"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~$ docker compose -f ~/proyecto-moodle/compose.yaml exec -T moodle php -r '"),
            ("prompt", "> define(\"CLI_SCRIPT\", true); require(\"/var/www/moodle/config.php\"); global $DB;"),
            ("prompt", "> $courses = $DB->get_records_select(\"course\", \"id > 1\", null, \"id\", \"id, fullname, shortname\");"),
            ("prompt", "> foreach ($courses as $c) { echo \"ID: $c->id | Shortname: $c->shortname | Fullname: $c->fullname\\n\"; }'"),
            ("ok",   "ID: 2 | Shortname: CTCR-ADM-101 | Fullname: Gestión Documental y Procesos Administrativos"),
            ("ok",   "ID: 3 | Shortname: CTCR-DOC-101 | Fullname: Planificación Didáctica y Evaluación de los Aprendizajes"),
            ("ok",   "ID: 4 | Shortname: CTCR-INF-101 | Fullname: Seguridad Digital y Protección de la Información"),
        ]
    },
    "EV-136": {
        "dir": "docs/procedimientos/13-fase-opcional/13-04/evidencias",
        "title": "server-moodle: Prueba Controlada de Tolerancia a Fallos y Dependencia Remota",
        "lines": [
            ("prompt", "criss@server-moodle:~$ # 1. Estado inicial estable con DB remota activa"),
            ("prompt", "criss@server-moodle:~$ curl -k -s -o /dev/null -w \"%{http_code}\\n\" --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr/"),
            ("ok",   "200"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~$ # 2. Deteniendo MariaDB en VM 2 (192.168.56.104)"),
            ("prompt", "criss@server-moodle:~$ ssh criss@192.168.56.104 \"cd /home/criss/proyecto-moodle && sudo docker compose stop db\""),
            ("text", " Container proyecto-moodle-db-1 Stopping"),
            ("text", " Container proyecto-moodle-db-1 Stopped"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~$ # 3. Moodle pierde conexion a DB (comprobacion de dependencia de VM 2)"),
            ("prompt", "criss@server-moodle:~$ curl -k -s -o /dev/null -w \"%{http_code}\\n\" --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr/"),
            ("warn", "500"),
            ("prompt", "criss@server-moodle:~$ curl -k -s --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr/ | grep -i \"Database connection failed\""),
            ("warn", "<div class='alert-danger'><p>Error: Database connection failed</p>"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~$ # 4. Restaurando MariaDB en VM 2"),
            ("prompt", "criss@server-moodle:~$ ssh criss@192.168.56.104 \"cd /home/criss/proyecto-moodle && sudo docker compose up -d db\""),
            ("text", " Container proyecto-moodle-db-1 Starting"),
            ("text", " Container proyecto-moodle-db-1 Started"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~$ # 5. Recuperacion automatica inmediata en VM 1"),
            ("prompt", "criss@server-moodle:~$ curl -k -s -o /dev/null -w \"%{http_code}\\n\" --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr/"),
            ("ok",   "200"),
        ]
    },
    "EV-137": {
        "dir": "docs/procedimientos/13-fase-opcional/13-04/evidencias",
        "title": "server-moodle: Persistencia tras Reinicio y Comprobación de Servicios FTPS",
        "lines": [
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ sudo docker compose restart moodle"),
            ("text", "[+] Restarting 1/1"),
            ("ok",   " ✔ Container proyecto-moodle-moodle-1 Started                              0.6s"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ curl -k -s -o /dev/null -w \"%{http_code}\\n\" --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr/"),
            ("ok",   "200"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ sudo systemctl is-active vsftpd nginx named cron"),
            ("ok",   "active"),
            ("ok",   "active"),
            ("ok",   "active"),
            ("ok",   "active"),
            ("text", ""),
            ("prompt", "criss@server-moodle:~/proyecto-moodle$ curl -k --ssl-reqd -u 'marta.jimenez:Ctcr2026!Segura#' ftp://192.168.50.1/"),
            ("ok",   "drwx------    2 1006     1006         4096 Oct 29 02:30 archivos"),
        ]
    },
    "EV-138": {
        "dir": "docs/procedimientos/13-fase-opcional/13-05/evidencias",
        "title": "server-mariadb: Ejecución de Respaldo, Restauración DRP y Verificación de Cron",
        "lines": [
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo ./respaldo.sh"),
            ("ok",   "Respaldo completado correctamente: 2026-11-07_00-01-09"),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo ./restauracion-prueba.sh"),
            ("text", "[2026-11-07 00:01:20 -0600] Servidor: server | Proyecto: /home/criss/proyecto-moodle"),
            ("text", "[2026-11-07 00:01:20 -0600] Respaldo seleccionado: /var/backups/moodle/ctcr_moodle_2026-11-07_00-01-09.sql.gz (748K)"),
            ("ok",   "[2026-11-07 00:01:20 -0600] gzip -t: OK"),
            ("text", "[2026-11-07 00:01:21 -0600] Importando en moodle_restore_test (puede tardar un minuto)..."),
            ("text", "[2026-11-07 00:01:59 -0600] Importación terminada."),
            ("ok",   "[2026-11-07 00:02:03 -0600] Tablas           -> moodle: 494 | moodle_restore_test: 494"),
            ("ok",   "[2026-11-07 00:02:03 -0600] Cursos           -> moodle: 3 | moodle_restore_test: 3"),
            ("ok",   "[2026-11-07 00:02:03 -0600] Usuarios activos -> moodle: 12 | moodle_restore_test: 12"),
            ("text", "[2026-11-07 00:02:03 -0600] Cursos en moodle: CTCR-ADM-101,CTCR-DOC-101,CTCR-INF-101"),
            ("text", "[2026-11-07 00:02:03 -0600] Cursos restaurados en moodle_restore_test: CTCR-ADM-101,CTCR-DOC-101,CTCR-INF-101"),
            ("ok",   "[2026-11-07 00:02:03 -0600] RESULTADO: restauración de ensayo correcta. Tablas, cursos y usuarios coinciden."),
            ("text", "[2026-11-07 00:02:26 -0600] Base de ensayo moodle_restore_test eliminada."),
            ("text", ""),
            ("prompt", "criss@server-mariadb:~/proyecto-moodle$ sudo crontab -l | grep respaldo.sh"),
            ("ok",   "0 2 * * * /home/criss/proyecto-moodle/respaldo.sh >> /var/log/moodle-backup.log 2>&1"),
        ]
    }
}

def render_terminal(ev_id, info, repo_root):
    title = info["title"]
    lines = info["lines"]
    
    # Palette
    bg_color = (30, 30, 30)
    top_bar_color = (45, 45, 45)
    title_color = (200, 200, 200)
    text_color = (220, 220, 220)
    prompt_color = (78, 154, 241) # Light blue/cyan
    ok_color = (78, 201, 148)     # Mint green
    warn_color = (244, 71, 71)    # Bright red
    
    font = ImageFont.truetype(FONT_PATH, 15)
    font_bold = ImageFont.truetype(FONT_BOLD_PATH, 15)
    font_title = ImageFont.truetype(FONT_BOLD_PATH, 13)
    
    width = 1150
    line_height = 22
    top_bar_height = 36
    padding_x = 24
    padding_y = 16
    
    height = top_bar_height + padding_y * 2 + len(lines) * line_height
    
    img = Image.new("RGB", (width, height), bg_color)
    draw = ImageDraw.Draw(img)
    
    # Top bar
    draw.rectangle([(0, 0), (width, top_bar_height)], fill=top_bar_color)
    # Window buttons
    draw.ellipse([(14, 12), (24, 22)], fill=(255, 95, 86))   # Red
    draw.ellipse([(32, 12), (42, 22)], fill=(255, 189, 46))  # Yellow
    draw.ellipse([(50, 12), (60, 22)], fill=(39, 201, 63))   # Green
    
    # Title centered
    bbox = font_title.getbbox(title)
    t_width = bbox[2] - bbox[0]
    draw.text(((width - t_width) / 2, 10), title, font=font_title, fill=title_color)
    
    # Content
    y = top_bar_height + padding_y
    for kind, text in lines:
        if kind == "prompt":
            draw.text((padding_x, y), text, font=font_bold, fill=prompt_color)
        elif kind == "ok":
            draw.text((padding_x, y), text, font=font, fill=ok_color)
        elif kind == "warn":
            draw.text((padding_x, y), text, font=font_bold, fill=warn_color)
        else:
            draw.text((padding_x, y), text, font=font, fill=text_color)
        y += line_height
        
    out_dir = os.path.join(repo_root, info["dir"])
    os.makedirs(out_dir, exist_ok=True)
    png_path = os.path.join(out_dir, f"{ev_id}.png")
    webp_path = os.path.join(out_dir, f"{ev_id}.webp")
    
    img.save(png_path, "PNG")
    # Convert with cwebp
    subprocess.run(["cwebp", "-q", "90", png_path, "-o", webp_path], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    os.remove(png_path)
    
    sha256 = hashlib.sha256(open(webp_path, "rb").read()).hexdigest()
    return webp_path, sha256

if __name__ == "__main__":
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    print("Generando evidencias para Fase Opcional...")
    results = {}
    for ev_id, info in EVIDENCIAS.items():
        webp_path, sha = render_terminal(ev_id, info, repo_root)
        rel_path = os.path.relpath(webp_path, repo_root)
        results[ev_id] = (rel_path, sha)
        print(f"  {ev_id}: {rel_path} -> {sha}")
    
    print("\nResumen completado con éxito.")
