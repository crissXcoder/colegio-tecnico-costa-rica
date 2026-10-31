# Lineamientos del profesor — resumen y cómo los cumplimos

> **Fuente:** «Lineamientos de presentación y entrega», EIF431O, proyecto de curso, sesión 16. Este archivo resume el documento original para tenerlo junto al repositorio; ante cualquier duda manda el original.
> **Estado al 31/10/2026.** Cada fila enlaza al archivo o evidencia que la respalda. Lo que no tiene evidencia figura como **PENDIENTE**.

## 1. Datos clave

| Tema | Qué dice el profesor |
|---|---|
| Fecha | **Sábado 07/11/2026**, sesión 16. Seis grupos en tres horas. |
| Entrega de archivos | Una sola carpeta comprimida por grupo, en el aula virtual, **hasta las 7:59 a. m.** del 07/11. |
| Valor | Presentación 10 % de la nota. Los archivos entregados respaldan el 15 % de Investigación e Implementación. |
| Tiempo | **25 minutos exactos** por grupo; al llegar a 25 se termina aunque falte algo. |
| Participación | Cinco integrantes. **Cualquiera** puede recibir una pregunta técnica, y responde solo la persona elegida. |
| Regla principal | «Lo que se evalúa es lo que se entrega.» En la demo se comprueba que lo que corre en el servidor es lo mismo que se entregó (`hashes.txt`). |
| Infraestructura | Encendida y funcionando **antes** del turno. No se instala nada en pantalla. Si algo falla, se explica y se continúa. |

## 2. Qué se entrega y dónde está en nuestro proyecto

| Archivo pedido | Qué es | De dónde sale | Estado |
|---|---|---|---|
| `docker-compose.yml` | Los dos servicios, volúmenes y puertos. | Copia **sin editar** del `compose.yaml` del servidor, hecha por [`armar-entrega.sh`](../../scripts/armar-entrega.sh). El de [`infra/compose/`](../../infra/compose/compose.yaml) es un modelo y **no** se entrega. | PENDIENTE de exportar |
| `Dockerfile` | Solo si hay imagen propia. | No aplica: usamos imágenes públicas `oksigenia/moodle:4.5.15` y `mariadb:11.4.13`. Se indica en el documento técnico. | No aplica |
| Configuraciones propias | Zona BIND, VirtualHost/proxy, servidor FTP. | `/etc/bind/named.conf.local`, `named.conf.options`, `db.ctcr`; `/etc/nginx/sites-available/aulavirtual.ctcr`; `/etc/vsftpd.conf`. Las exporta el script. | PENDIENTE de exportar |
| `crontab.txt` y scripts | Tarea de respaldo, script de respaldo y de restauración. | `crontab -l -u root`; `respaldo.sh` (existe en el servidor, EV-096); [`restauracion-prueba.sh`](../../scripts/restauracion-prueba.sh) (**nuevo**, hay que instalarlo en el servidor). | PENDIENTE: instalar restauración y exportar |
| `ufw.txt` | Reglas del firewall, si se usa. | En la VM #1 UFW **no está instalado** (EV-102); se entrega `ufw.txt` explicándolo y `firewall-iptables.txt`. Ver [ADR-0003](../decisiones/ADR-0003-firewall-iptables-sin-ufw.md). | PENDIENTE de exportar |
| Documento técnico | Decisiones, diagramas e instrucciones para reproducir. | Plantilla del curso + [`docs/entrega/README.md`](README.md). | PENDIENTE de redactar |
| Evidencia de pruebas | Restauración del respaldo y prueba propia del escenario, **con fecha**. | Restauración: EV-099. Denegación: EV-060, EV-092..EV-095, EV-104. | Hay evidencia; falta seleccionar y fechar en el paquete |

Procedimiento completo para armar la carpeta: [PAQUETE-ENTREGA.md](PAQUETE-ENTREGA.md).

## 3. Los 25 minutos

| Min | Segmento | Qué ocurre | Rúbrica | Nuestra guía |
|---:|---|---|---|---|
| 3 | Contexto y solución | Problema, solución y decisiones (máx. 4 diapositivas). | Claridad de decisiones 3 % | [GUIA-DEMO.md §1](GUIA-DEMO.md#1-contexto-y-solución--3-minutos) |
| 11 | Demostración en vivo | Guion común para todos los grupos. | Demostración 5 % | [GUIA-DEMO.md §2](GUIA-DEMO.md#2-demostración-en-vivo--11-minutos) |
| 5 | Preguntas de conocimiento | El profesor pide mostrar algo con un comando a un integrante elegido en el momento. | Manejo de preguntas 2 % | [PREGUNTAS-TECNICAS.md](PREGUNTAS-TECNICAS.md) |
| 4 | Preguntas del curso | Preguntas de otros grupos y del profesor. | Manejo de preguntas 2 % | [PREGUNTAS-TECNICAS.md](PREGUNTAS-TECNICAS.md) |
| 2 | Cambio de grupo | El siguiente grupo conecta su equipo. | — | Tener la VM lista y salir rápido. |

## 4. Guion obligatorio de la demostración

| Qué se muestra | Cómo lo pide el profesor | Escenario 3 |
|---|---|---|
| Lo que corre es lo entregado | `docker-compose.yml` | |
| HTTPS con certificado propio | El sitio en el navegador y `curl -vk https://dominio` | |
| Los dos contenedores y versiones | `docker compose ps` y `docker images` | |
| Persistencia | `docker volume ls` y que el dato sigue tras `docker compose restart`. **No usar `down -v`.** | |
| Respaldo y restauración | `crontab -l`, lista de respaldos, evidencia de restauración | |
| Lo propio del escenario | | **Un intento de acceso de un departamento al curso de otro, denegado. Cada grupo de usuarios entra solo al suyo.** |

## 5. Rúbrica y dónde la respaldamos

| Criterio | Peso | Qué observa | Dónde lo respaldamos | Estado |
|---|---:|---|---|---|
| Justificación del software libre | 3 % | Comparación con al menos una alternativa, con criterios técnicos **y de costo**. | [comparativa-software.md](comparativa-software.md) | Borrador ampliado; faltan fuentes citadas |
| Requisitos comunes y específicos | 7 % | Los seis comunes y los del escenario; contenido real; roles de la organización. | [matriz-requisitos.md](../00-proyecto/matriz-requisitos.md), [COBERTURA-Y-TRAZABILIDAD.md](../00-proyecto/COBERTURA-Y-TRAZABILIDAD.md) | Verificado en VM #1 |
| Evidencia de pruebas reales | 3 % | Restauración y prueba del escenario, con salidas reales y fecha. | EV-099, EV-104, EV-105, [MATRIZ-QA-FINAL](../../pruebas/MATRIZ-QA-FINAL.md) | Verificado en VM #1 |
| Documentación técnica | 2 % | Decisiones, diagramas e instrucciones reproducibles. | Este repositorio + documento técnico | Documento final PENDIENTE |
| Demostración en vivo | 5 % | Sigue el guion, funciona y coincide con lo entregado (`hashes.txt`). | [GUIA-DEMO.md](GUIA-DEMO.md), [`verificar-servicios.sh`](../../scripts/verificar-servicios.sh) | Ensayo PENDIENTE |
| Claridad de decisiones | 3 % | Por qué cada opción, qué se ganó y qué se perdió. | [ADR](../decisiones/README.md), [GUIA-DEMO.md §1](GUIA-DEMO.md) | Listo para ensayar |
| Manejo de preguntas | 2 % | Comandos con fundamento; todos pueden; reconoce lo que no sabe. | [PREGUNTAS-TECNICAS.md](PREGUNTAS-TECNICAS.md) | Práctica PENDIENTE |

Pendientes consolidados: [PENDIENTES.md](../00-proyecto/PENDIENTES.md).
