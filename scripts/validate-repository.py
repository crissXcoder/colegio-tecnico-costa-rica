#!/usr/bin/env python3
"""Comprobación estática: documentación, vínculos e integridad de evidencias.

No ejecuta Docker, no accede a la red y no toca ninguna VM.
"""
from __future__ import annotations

import csv
import hashlib
import re
import sys
from pathlib import Path
from urllib.parse import unquote

root = Path(__file__).resolve().parents[1]
errors: list[str] = []
required = [
    'README.md', 'AGENTS.md', 'CONTRIBUTING.md',
    'docs/00-proyecto/ESTADO.md', 'docs/00-proyecto/INVENTARIO-DE-ARTEFACTOS.md',
    'docs/procedimientos/README.md', 'docs/00-proyecto/matriz-requisitos.md',
    'infra/compose/compose.yaml', 'infra/compose/.env.example',
    'evidencias/manifiesto.csv', 'evidencias/manifiesto-detallado.csv',
    'evidencias/CATALOGO-CAPTURAS.md', 'pruebas/README.md',
]
for name in required:
    if not (root / name).is_file():
        errors.append(f'Falta archivo obligatorio: {name}')

# Tanto vínculos de texto como imágenes. Soporta anclas y títulos opcionales.
link_pattern = re.compile(r'!?(?:\[[^\]]*\])\(([^)]+)\)')
for path in root.rglob('*.md'):
    doc = path.read_text(encoding='utf-8')
    for raw in link_pattern.findall(doc):
        dest = raw.strip().split(' "')[0].strip('<>')
        if re.match(r'^(?:https?://|mailto:|data:|#)', dest):
            continue
        relative = unquote(dest.split('#')[0].split('?')[0])
        if relative and not (path.parent / relative).exists():
            errors.append(f'Enlace/imagen roto {path.relative_to(root)}: {dest}')

# No subir archivos secretos: sí permitir plantillas explícitas sin credenciales.
allowed_env = ('.env.example', '.env.https.example')
for path in root.rglob('*'):
    if path.is_file() and (path.name == '.env' or path.name.startswith('.env.')) and path.name not in allowed_env:
        errors.append(f'Archivo secreto encontrado: {path.relative_to(root)}')

manifest = root / 'evidencias/manifiesto-detallado.csv'
if manifest.is_file():
    with manifest.open(encoding='utf-8', newline='') as f:
        records = list(csv.DictReader(f))
    seen = set()
    for row in records:
        ident, p, step = row['id'], root / row['archivo'], row['paso']
        if ident in seen:
            errors.append(f'Identificador de evidencia duplicado: {ident}')
        seen.add(ident)
        if not p.is_file():
            errors.append(f'Evidencia no encontrada: {ident} -> {row["archivo"]}')
            continue
        digest = hashlib.sha256(p.read_bytes()).hexdigest()
        if digest != row['sha256']:
            errors.append(f'Checksum SHA-256 distinto: {ident}')
        if not re.match(r'EV-\d{3}$', ident):
            errors.append(f'ID de evidencia inválido: {ident}')
        folder = p.parent.parent.name
        if folder != step:
            errors.append(f'Evidencia {ident} en carpeta {folder}, pero manifiesto indica paso {step}')
        note = p.with_suffix('.md')
        if not note.is_file():
            errors.append(f'No existe ficha contextual para {ident}: {note.relative_to(root)}')
        else:
            note_content = note.read_text(encoding='utf-8')
            for required_part in ('Qué ocurre en esta captura', 'Interpretación y límite', 'SHA-256', row['sha256']):
                if required_part not in note_content:
                    errors.append(f'Ficha EV incompleta {ident}: falta {required_part}')
        step_path = p.parent.parent.parent / f'{step}.md'
        if not step_path.is_file():
            errors.append(f'El paso de {ident} no existe: {step_path.relative_to(root)}')
        elif ident not in step_path.read_text(encoding='utf-8'):
            errors.append(f'Captura {ident} no citada en su paso {step}')
    actual = {p.stem for p in root.glob('docs/procedimientos/*/*/evidencias/EV-*.webp')}
    missing = actual - seen
    if missing:
        errors.append(f'Existen capturas sin registro en el manifiesto: {sorted(missing)}')
    if len(records) != len(actual):
        errors.append(f'Manifiesto contiene {len(records)} registros; fotos en pasos: {len(actual)}')
    compat = root / 'evidencias/manifiesto.csv'
    if compat.is_file() and compat.read_bytes() != manifest.read_bytes():
        errors.append('manifiesto.csv y manifiesto-detallado.csv están desincronizados')

if errors:
    print(f'FALLO: {len(errors)} problemas de documentación/integridad')
    for e in errors:
        print('- ' + e)
    sys.exit(1)

print('OK — vínculos Markdown, imágenes, estructura, secretos y manifiesto EV-001..050 con SHA-256 verificados.')
