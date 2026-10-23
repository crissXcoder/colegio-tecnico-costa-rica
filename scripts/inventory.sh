#!/usr/bin/env bash
set -euo pipefail
printf '# Fecha y host (sanitizar antes de compartir)\n'
date -Is
hostname
printf '\n# SO y Kernel\n'
cat /etc/os-release | grep -E '^(NAME|VERSION)=' || true
uname -r
printf '\n# Red\n'
ip -br address || true
printf '\n# Almacenamiento\n'
df -h
printf '\n# Docker\n'
docker --version || true
docker compose version || true
docker image ls --digests || true
docker volume ls || true
printf '\n# Puertos\n'
ss -lntup || true
printf '\n# No se incluyen variables de entorno ni docker inspect (pueden filtrar secretos).\n'
