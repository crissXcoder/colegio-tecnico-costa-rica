# INC-015 — Nginx devuelve 502 Bad Gateway durante la transición a HTTPS

- INC-ID: INC-015
- Fecha / VM / paso: durante el paso 8 (fecha exacta no registrada) / Ubuntu Server de la VM descrita en el anexo técnico del 31/10/2026 / Paso 8.5 (cambio de URL de Moodle y puerto `127.0.0.1:8080`)
- Estado: resuelto. **Sin captura en el repositorio**; procedencia: anexo técnico del grupo, sección F.

## Síntoma y contexto

Después de cambiar el puerto publicado de Moodle de `192.168.50.1:8080` a `127.0.0.1:8080` y la URL a `https://aulavirtual.ctcr`, el navegador mostró **502 Bad Gateway** de Nginx. Nginx estaba bien configurado, pero la conexión a `127.0.0.1:8080` era rechazada.

## Impacto, severidad y riesgo

- Severidad: media. El sitio no estaba disponible para nadie mientras duró.
- Riesgo en la demo: si se muestra el sitio justo después de reiniciar los contenedores, aparece el mismo 502 hasta que Moodle termina de arrancar.

## Diagnóstico con comandos y salida saneada

Un 502 significa que Nginx sí recibió la petición, pero no pudo obtener respuesta del servidor al que reenvía (`proxy_pass http://127.0.0.1:8080`). Se revisó en este orden:

```bash
sudo docker compose ps                 # ¿moodle está Up (healthy) o todavía starting?
sudo docker compose port moodle 8080   # ¿el puerto quedó publicado en 127.0.0.1:8080?
sudo ss -lntp | grep 8080              # ¿algo escucha en 127.0.0.1:8080?
sudo grep proxy_pass /etc/nginx/sites-available/aulavirtual.ctcr
curl -sI http://127.0.0.1:8080         # prueba directa, sin pasar por Nginx
```

Según el anexo, la causa fue la transición: el contenedor de Moodle se estaba recreando con la nueva configuración y todavía no aceptaba conexiones en `127.0.0.1:8080`.

## Solución y por qué

Con el contenedor `healthy` y el nuevo mapeo de puertos activo, Nginx volvió a responder. No hizo falta cambiar Nginx: el `proxy_pass` ya apuntaba al destino correcto. (El anexo resume la revisión; no detalla el tiempo de espera ni si hubo otro ajuste.)

## Verificación y recuperación

`curl -k -I --resolve aulavirtual.ctcr:443:192.168.50.1 https://aulavirtual.ctcr` devolvió `HTTP/1.1 200 OK` con `Server: nginx/1.28.3` (documento del grupo, pág. 41; paso 8, EV-069 y EV-070).

## Prevención y documentación asociada

- Antes de concluir que Nginx está mal, probar `curl -sI http://127.0.0.1:8080` desde el servidor.
- En la demo, después de `docker compose restart`, esperar `healthy` antes de recargar el navegador ([GUIA-DEMO](../../docs/entrega/GUIA-DEMO.md)).
- `scripts/verificar-servicios.sh` marca el 502 explícitamente.
- Relacionado: [INC-005](INC-005-moodle-cli-script-constant.md) (comprobación de `wwwroot` por CLI en el mismo paso).
