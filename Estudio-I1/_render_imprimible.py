#!/usr/bin/env python3
"""Genera Estudio-I1-imprimible.html a partir de los .md de la carpeta."""
import markdown

BASE = "/home/sasanmartin/Desktop/DDS/Estudio-I1"

SECTIONS = [
    ("README.md", "Índice"),
    ("cheatsheet-1-representacion.md", "Cheatsheet 1 · Representación de números (P1)"),
    ("cheatsheet-2-circuitos.md", "Cheatsheet 2 · Circuitos digitales (P2)"),
    ("cheatsheet-3-almacenamiento.md", "Cheatsheet 3 · Almacenamiento de datos (P2)"),
    ("cheatsheet-4-assembly-saltos.md", "Cheatsheet 4 · Assembly y saltos (P3)"),
    ("cheatsheet-5-microarquitectura.md", "Cheatsheet 5 · Microarquitectura (P3, bonus)"),
    ("hoja-apuntes.md", "Hoja de apuntes · guía para copiar a mano"),
    ("plan-de-estudio.md", "Plan de estudio · 2 días"),
]

CSS = """
:root { --accent: #1a5276; --light: #eaf2f8; }
* { box-sizing: border-box; }
body { font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
       color: #222; max-width: 900px; margin: 0 auto; padding: 24px;
       line-height: 1.45; font-size: 14px; }
h1 { color: var(--accent); font-size: 1.6em; border-bottom: 3px solid var(--accent);
     padding-bottom: 6px; }
h2 { color: var(--accent); font-size: 1.3em; margin-top: 28px;
     border-bottom: 1px solid #bbb; padding-bottom: 3px; }
h3 { font-size: 1.1em; margin-top: 20px; }
table { border-collapse: collapse; width: 100%; margin: 10px 0; font-size: 13px; }
th, td { border: 1px solid #999; padding: 4px 8px; text-align: left; vertical-align: top; }
th { background: var(--light); }
tr:nth-child(even) td { background: #fafafa; }
code { background: #f4f4f4; padding: 1px 4px; border-radius: 3px; font-size: 0.9em;
       font-family: Consolas, Menlo, monospace; }
pre { background: #f4f4f4; padding: 10px; border-radius: 4px; overflow-x: auto; }
blockquote { border-left: 4px solid var(--accent); margin: 8px 0;
             padding: 4px 12px; background: var(--light); }
ul, ol { margin: 6px 0; }
hr { border: none; border-top: 2px dashed #bbb; margin: 18px 0; }
section { margin-bottom: 10px; }
.page-break { break-before: page; }
@media print {
  body { max-width: 100%; padding: 0; font-size: 11px; }
  section { break-inside: avoid-page; }
}
"""

md = markdown.Markdown(extensions=["tables", "fenced_code", "nl2br"])
parts = []
for fname, title in SECTIONS:
    with open(f"{BASE}/{fname}", encoding="utf-8") as f:
        md.reset()
        body = md.convert(f.read())
    parts.append(
        f'<section>\n<h1 style="font-size:1.15em;color:#666;">{title}</h1>\n{body}\n</section>'
    )

html = f"""<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>Estudio I1 — Arquitectura de Computadores (2026-2)</title>
<style>{CSS}</style>
</head>
<body>
<header style="text-align:center;border-bottom:3px solid #1a5276;padding-bottom:10px;margin-bottom:16px;">
  <h1 style="border:none;font-size:1.8em;color:#1a5276;">Estudio I1 — Arquitectura de Computadores 2026-2</h1>
  <p style="color:#555;">Generado desde <code>Estudio-I1/</code> · imprime o guarda como PDF (Ctrl+P)</p>
</header>
{''.join(parts)}
<footer style="margin-top:30px;border-top:1px solid #bbb;padding-top:8px;color:#888;font-size:11px;">
  Material de estudio personal — no distribuir. Basado en clases S1 (F. Valenzuela) e I1 históricas.
</footer>
</body>
</html>
"""

out = f"{BASE}/Estudio-I1-imprimible.html"
with open(out, "w", encoding="utf-8") as f:
    f.write(html)
print(f"OK: {out} ({len(html)} bytes)")
