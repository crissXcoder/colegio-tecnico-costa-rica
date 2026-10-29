# INC-008 — Denegación de Autenticación PAM en vsftpd para Cuentas con nologin

- INC-ID: INC-008
- Fecha / VM / paso: 2026-10-28 20:27 CST / VM #1 Ubuntu Server / Paso 9 (FTPS vsftpd)
- Estado: resuelto y verificado

## Síntoma y contexto
Al asignar la shell restrictiva `/usr/sbin/nologin` a las cuentas de funcionarios para impedir que inicien sesiones por consola o SSH, el demonio `vsftpd` rechazaba la autenticación con error `530 Login incorrect` a pesar de que el usuario y la contraseña eran correctos.

## Impacto, severidad y riesgo
- Severidad: Alta (bloqueo total del servicio FTPS para todos los funcionarios institucionales).
- Riesgo: Para "arreglar" el login, se podría caer en la tentación insegura de asignar `/bin/bash` a los usuarios FTP, otorgándoles acceso interactivo no deseado por SSH a Ubuntu Server.

## Diagnóstico con comandos y salida saneada
Se inspeccionó la pila de autenticación PAM de vsftpd en `/etc/pam.d/vsftpd`:
```text
auth required pam_shells.so
```
El módulo `pam_shells.so` exige obligatoriamente que la shell asignada al usuario figure dentro del archivo del sistema `/etc/shells`. Al consultar dicho archivo:
```bash
grep nologin /etc/shells
```
El comando no retornó ningún resultado; por defecto en Ubuntu Server `/usr/sbin/nologin` no está listada como shell válida en `/etc/shells`.

## Solución y por qué
Se registró formalmente la ruta de la shell restrictiva en `/etc/shells`:
```bash
grep -Fxq /usr/sbin/nologin /etc/shells || echo /usr/sbin/nologin | sudo tee -a /etc/shells
```
Esto satisface la comprobación de `pam_shells.so`, permitiendo la autenticación FTPS de las cuentas del CTCR y manteniendo al mismo tiempo el bloqueo estricto contra inicios de sesión interactivos por SSH o terminal.

## Verificación y recuperación
1. Verificación en `/etc/shells`:
   ```bash
   tail -n 2 /etc/shells # Muestra /usr/sbin/nologin
   ```
2. Verificación de login FTPS con `curl --ssl-reqd --insecure`:
   ```text
   > USER marta.jimenez
   < 331 Please specify the password.
   > PASS ********
   < 230 Login successful.
   ```
3. Verificación de bloqueo SSH:
   ```bash
   ssh marta.jimenez@192.168.50.1 # Responde: "This account is currently not available" y cierra inmediatamente la conexión.
   ```

## Prevención y documentación asociada
- Documentado en `GEMINI.md` (Sección 10.2) y `doc_paso9/INFORME_PASO9_FTPS_VSFTPD.md`.
