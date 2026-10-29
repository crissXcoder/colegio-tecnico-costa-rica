# INC-007 — Rechazo de adduser por Expresión Regular de Nombres de Usuario con Punto

- INC-ID: INC-007
- Fecha / VM / paso: 2026-10-28 20:26 CST / VM #1 Ubuntu Server / Paso 9 (FTPS vsftpd)
- Estado: resuelto y verificado

## Síntoma y contexto
Al intentar crear las cuentas nominales departamentales con el comando sugerido en la guía básica:
```bash
sudo adduser marta.jimenez
```
El comando abortó inmediatamente con el mensaje de error:
```text
adduser: Please enter a username matching the regular expression configured
via the NAME_REGEX configuration variable.  Use the `--allow-bad-names'
option to relax this check or re-configure NAME_REGEX.
```

## Impacto, severidad y riesgo
- Severidad: Media (bloqueo en la creación de las 6 cuentas institucionales).
- Riesgo: Alterar globalmente `/etc/adduser.conf` podría comprometer estándares de nombres del sistema o causar incompatibilidades.

## Diagnóstico con comandos y salida saneada
En Ubuntu 26.04 LTS, la utilidad interactiva `adduser` aplica por defecto una política restrictiva que no admite puntos (`.`) en el nombre de usuario sin flags adicionales. En contraste, el comando estándar de bajo nivel POSIX `useradd` admite la convención `nombre.apellido` sin restricciones.

## Solución y por qué
Se automatizó la creación de las 6 cuentas institucionales utilizando `useradd` con flag `-m` (crear home), `-s /usr/sbin/nologin` (asignar shell restrictiva) y asignación no interactiva de contraseña con `chpasswd`:
```bash
for u in marta.jimenez carlos.mendez sofia.hernandez jose.ramirez valeria.sanchez diego.fernandez; do
  sudo useradd -m -s /usr/sbin/nologin "$u"
  echo "$u:Ctcr2026!Segura#" | sudo chpasswd
done
```

## Verificación y recuperación
Se verificó la existencia y atributos de las 6 cuentas en `/etc/passwd`:
```bash
getent passwd | grep -E '(marta|carlos|sofia|jose|valeria|diego)'
```
Confirmando UIDs consecutivos 1006 a 1011 con shell `/usr/sbin/nologin`.

## Evidencia de resolución

### EV-071 — Cuentas Nominales Creadas y Verificadas en el Sistema

![EV-071](../../docs/procedimientos/09-ftps-vsftpd/09-03/evidencias/EV-071.webp)

- **Ficha descriptiva:** [EV-071.md](../../docs/procedimientos/09-ftps-vsftpd/09-03/evidencias/EV-071.md)
- **Validación:** Comprueba la creación de las 6 cuentas departamentales mediante `useradd` con formato `nombre.apellido` y shell `/usr/sbin/nologin`.

## Prevención y documentación asociada
- Documentado en la sesión de trabajo [`bitacora/sesiones/2026-10-28-sesion-paso9-ftps-vsftpd.md`](../sesiones/2026-10-28-sesion-paso9-ftps-vsftpd.md) y en el procedimiento [`docs/procedimientos/09-ftps-vsftpd/09-02.md`](../../docs/procedimientos/09-ftps-vsftpd/09-02.md).
- Regla persistida: En scripts de aprovisionamiento en Ubuntu, utilizar `useradd` para usuarios nominales con punto.
