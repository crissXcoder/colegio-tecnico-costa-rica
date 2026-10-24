# BIND9: dominio interno del Colegio Técnico

**Objetivo:** que Mint resuelva `aulavirtual.ctcr` hacia la IP interna de Ubuntu, sin salir a un DNS público ni agregar una tarjeta NAT al cliente. El servidor será a la vez autoritativo para `ctcr` y, cuando esté permitido, recursivo **solo para la red del laboratorio**.

## Significado de los tres archivos

- [`named.conf.options.fragment`](named.conf.options.fragment): representa el **único** bloque global `options`. Define interfaces donde escucha BIND, ámbito de consulta/recursión y resolutores externos. **No concatenarlo literalmente** si el host ya tiene un bloque `options`.
- [`named.conf.local.fragment`](named.conf.local.fragment): declaración de la zona `ctcr` tipo primario, ligada a `/etc/bind/db.ctcr`, con transferencias deshabilitadas para el laboratorio. Se integra sin eliminar zonas anteriores.
- [`db.ctcr`](db.ctcr): contenido autoritativo de la zona; `ns1` y `moodle` apuntan a `192.168.50.1`. Cambiar registro A si el servidor usa otra IP; incrementar el serial SOA al modificarla.

## Aplicación controlada en Ubuntu (solo después de inventario)

```bash
sudo ss -lntup | grep ':53 ' || true
sudo cp -a /etc/bind/named.conf.options "/etc/bind/named.conf.options.pre-elevaquitas-$(date +%Y%m%d%H%M%S)"
sudo nano /etc/bind/named.conf.options  # integrar el UNICO options de la plantilla
sudo nano /etc/bind/named.conf.local    # integrar la declaración de zona, sin borrar las existentes
sudo install -m 644 infra/bind9/db.ctcr /etc/bind/db.ctcr
sudo named-checkconf
sudo named-checkzone ctcr /etc/bind/db.ctcr
# Solo si pasan validaciones: sudo systemctl restart named
```

Ejecutar desde la raíz del repositorio cuando se indica `infra/...`. Después de reiniciar, verificar `dig @192.168.50.1 aulavirtual.ctcr A +short` **desde Mint**, no solamente desde Ubuntu. El [paso 07-07](../../docs/procedimientos/07-dns-bind9/07-07.md) documenta NetworkManager y la evidencia pendiente.

**Sin pruebas históricas adjuntas** a esta fase: los resultados esperados no equivalen a un servicio DNS ya construido.
