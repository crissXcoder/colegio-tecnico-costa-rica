# INC-006 — Ausencia del Comando CLI zip en Ubuntu Server para Empaquetado

- INC-ID: INC-006
- Fecha / VM / paso: 2026-10-28 20:06 CST / VM #1 Ubuntu Server / Entregables de Pasos 7, 8 y 9
- Estado: resuelto y verificado

## Síntoma y contexto
Al intentar compilar el archivo entregable comprimido `.zip` mediante el comando del sistema operativo:
```bash
zip -r Entregable_Paso8_HTTPS_NGINX.zip doc_paso8/
```
La terminal devolvió el error:
```text
bash: zip: command not found
```

## Impacto, severidad y riesgo
- Severidad: Baja (bloqueo momentáneo de empaquetado de entregables).
- Riesgo: Depender de paquetes externos o modificar repositorios apt solo para comprimir archivos.

## Diagnóstico con comandos y salida saneada
Ubuntu Server en su instalación base mínima no incluye el paquete `zip` por defecto (solo `tar` y `gzip`). Sin embargo, el entorno cuenta con Python 3 estándar instalado.

## Solución y por qué
Se implementó un script en línea utilizando el módulo estándar de Python `zipfile`, el cual comprime de forma determinista con algoritmo `ZIP_DEFLATED` sin requerir instalar paquetes adicionales en el sistema:
```python
python3 -c '
import zipfile, os
base_dir = "/home/criss/agente/doc_paso8"
zip_path = "/home/criss/agente/doc_paso8/Entregable_Paso8_HTTPS_NGINX.zip"
with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
    for root, dirs, files in os.walk(base_dir):
        for f in files:
            if f.endswith(".zip"): continue
            fp = os.path.join(root, f)
            zipf.write(fp, os.path.relpath(fp, base_dir))
'
```

## Verificación y recuperación
1. Archivo generado exitosamente con tamaño óptimo: `1.57 MB`.
2. Verificación de integridad en Linux Mint:
   ```bash
   ssh criss@192.168.50.101 "unzip -t /home/criss/Escritorio/Entregable_Paso8_HTTPS_NGINX.zip"
   # Salida: No errors detected in compressed data of ...
   ```

## Prevención y documentación asociada
- Documentado en la sesión de trabajo [`bitacora/sesiones/2026-10-28-sesion-paso8-https-nginx.md`](../sesiones/2026-10-28-sesion-paso8-https-nginx.md).
- Estandarizado en el runbook operativo de entrega para empaquetado autónomo mediante la biblioteca estándar de Python sin dependencias externas.
