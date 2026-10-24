# Reinicio tras apagar las computadoras — operaciones diarias

La bitácora registra que después de reiniciar las máquinas deben confirmar los dos servicios de Docker. NO crear imágenes ni borrar volúmenes.

**Ubuntu Server — VM ya existente:**

```bash
cd ~/proyecto-moodle
sudo docker compose ps
```

Si se confirma que es el mismo proyecto y los servicios no están ejecutándose:

```bash
sudo docker compose up -d
sudo docker compose ps
sudo docker compose logs --tail=50 moodle
```

**Mint — cliente:** Firefox → `http://192.168.50.1:8080` solo en etapa inicial; cuando HTTPS esté implementado → `https://moodle.ctcr.test`. No usar ambos indistintamente una vez establecida la URL canónica.

Si el servicio no aparece, revisar `docker compose ls`, espacio libre (`df -hT`), `docker volume ls`, interfaz IP, y crear incidencia. No aplicar `down -v` ni `prune -a`.
