#!/usr/bin/env python3
"""Comprobación estática mínima. No ejecuta Docker ni cambia archivos."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
required = [
    'README.md', 'ANALISIS-FUENTES.md', 'CONTRIBUTING.md',
    'docs/00-proyecto/ESTADO.md', 'docs/00-proyecto/matriz-requisitos.md',
    'infra/compose/compose.yaml', 'infra/compose/.env.example',
    'evidencias/manifiesto.csv', 'pruebas/README.md',
]
errors = []
for name in required:
    if not (root / name).is_file():
        errors.append(f'Falta {name}')
for path in root.rglob('*.md'):
    text = path.read_text(encoding='utf-8')
    for dest in re.findall(r'(?<!!)\[[^\]]+\]\(([^)]+)\)', text):
        if re.match(r'^(https?://|mailto:|#)', dest):
            continue
        relative = dest.split('#')[0].split('?')[0]
        if relative and not (path.parent / relative).exists():
            errors.append(f'Enlace roto en {path.relative_to(root)}: {dest}')
for path in root.rglob('*'):
    if path.is_file() and path.name in ('.env', '.env.local'):
        errors.append(f'ARCHIVO SECRETO PRESENTE: {path.relative_to(root)}')
print('OK: estructura y enlaces principales revisados.' if not errors else '\n'.join(errors))
raise SystemExit(bool(errors))
