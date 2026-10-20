#!/usr/bin/env python3
"""Genera Estudio-I2-imprimible.html a partir de los .md de la carpeta.

No requiere `markdown` ni `pandoc`: incluye un parser mínimo para los elementos
que usamos en estos apuntes (títulos, tablas, listas, código, citas y links).
"""
import html
import os
import re
import sys

BASE = os.path.dirname(os.path.abspath(__file__))

SECTIONS = [
    ("README.md", "Índice"),
    ("cheatsheet-1-subrutinas.md", "Cheatsheet 1 · Subrutinas (P1)"),
    ("cheatsheet-2-floats.md", "Cheatsheet 2 · Floats IEEE754 (P2)"),
    ("cheatsheet-3-io.md", "Cheatsheet 3 · I/O (P3)"),
    ("cheatsheet-4-riscv.md", "Cheatsheet 4 · RISC-V (P3)"),
    ("hoja-apuntes.md", "Hoja de apuntes · 2 caras"),
    ("plan-de-estudio.md", "Plan de estudio · 2 días"),
]

CSS = """
:root { --accent: #1a5276; --light: #eaf2f8; --border: #999; }
* { box-sizing: border-box; }
html { background: #fff; -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body { background: #fff; font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
       color: #222; max-width: 900px; margin: 0 auto; padding: 24px;
       line-height: 1.42; font-size: 14px; }
h1 { color: var(--accent); font-size: 1.6em; border-bottom: 3px solid var(--accent);
     padding-bottom: 6px; margin: 0 0 12px; }
h2 { color: var(--accent); font-size: 1.25em; margin-top: 26px;
     border-bottom: 1px solid #bbb; padding-bottom: 3px; break-after: avoid; }
h3 { font-size: 1.08em; margin-top: 18px; break-after: avoid; }
p { margin: 7px 0; }
table { border-collapse: collapse; width: 100%; margin: 10px 0; font-size: 12.5px; }
th, td { border: 1px solid var(--border); padding: 4px 7px; text-align: left;
         vertical-align: top; }
th { background: var(--light); }
td { background: #fff; }
tr:nth-child(even) td { background: #fafafa; }
tr { break-inside: avoid; }
code { background: #f4f4f4; padding: 1px 4px; border-radius: 3px; font-size: 0.9em;
       font-family: Consolas, Menlo, monospace; }
pre { background: #f4f4f4; padding: 10px; border-radius: 4px; overflow-x: auto;
      border: 1px solid #ddd; break-inside: avoid; }
pre code { background: none; padding: 0; font-size: 0.88em; }
blockquote { border-left: 4px solid var(--accent); margin: 8px 0;
             padding: 4px 12px; background: var(--light); }
ul, ol { margin: 6px 0; padding-left: 24px; }
li { margin: 2px 0; }
hr { border: none; border-top: 2px dashed #bbb; margin: 18px 0; }
a { color: #1a5276; }
.section-title { font-size: 1.05em; color: #666; border: none; margin: 0 0 8px;
                 padding: 0; text-transform: uppercase; letter-spacing: .04em; }
section { margin-bottom: 10px; }
section.page-break { break-before: page; margin-top: 28px; }
header { text-align: center; border-bottom: 3px solid var(--accent);
         padding-bottom: 10px; margin-bottom: 16px; }
header h1 { border: none; font-size: 1.8em; margin-bottom: 4px; }
header p { color: #555; margin: 4px 0; }
footer { margin-top: 30px; border-top: 1px solid #bbb; padding-top: 8px;
         color: #888; font-size: 11px; }
.check { font-family: "Segoe UI Symbol", sans-serif; }
@media print {
  body { max-width: 100%; padding: 0; font-size: 10.5px; line-height: 1.3; }
  header { margin-bottom: 8px; }
  header h1 { font-size: 1.5em; }
  section.page-break { break-before: page; margin-top: 0; }
  h1 { font-size: 1.3em; }
  h2 { font-size: 1.1em; margin-top: 14px; }
  h3 { font-size: 1em; margin-top: 10px; }
  table { font-size: 9.5px; }
  th, td { padding: 2px 4px; }
  pre { font-size: 9px; padding: 6px; }
  a { color: #000; text-decoration: none; }
  @page { margin: 12mm; }
}
"""


def esc(text: str) -> str:
    return html.escape(text, quote=False)


def inline(text: str) -> str:
    """Convierte inline Markdown a HTML, protegiendo code spans."""
    code_tokens: list[str] = []

    def save_code(m: re.Match) -> str:
        code_tokens.append(esc(m.group(1)))
        return f"\x00CODE{len(code_tokens) - 1}\x00"

    text = re.sub(r"`([^`]+)`", save_code, text)
    text = esc(text)

    # Links [texto](url) — antes de emphasis para no romper corchetes.
    def link_repl(m: re.Match) -> str:
        label = m.group(1)
        url = m.group(2)
        if url.endswith(".md"):
            # En el HTML imprimible no tiene sentido abrir el .md crudo.
            return f'<span class="xref" title="{html.escape(url, quote=True)}">{label}</span>'
        return (
            f'<a href="{html.escape(url, quote=True)}" target="_blank" '
            f'rel="noopener">{label}</a>'
        )

    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", link_repl, text)
    text = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", text)
    text = re.sub(r"(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)", r"<em>\1</em>", text)

    for idx, code in enumerate(code_tokens):
        text = text.replace(f"\x00CODE{idx}\x00", f"<code>{code}</code>")
    return text


def split_row(row: str) -> list[str]:
    row = row.strip()
    if row.startswith("|"):
        row = row[1:]
    if row.endswith("|") and not row.endswith("\\|"):
        row = row[:-1]
    cells = re.split(r"(?<!\\)\|", row)
    return [c.replace("\\|", "|").strip() for c in cells]


def render_table(lines: list[str]) -> str:
    rows = [split_row(line) for line in lines]
    if len(rows) < 2:
        return ""
    header = rows[0]
    body = rows[2:]  # rows[1] es el separador |---|---|
    width = max([len(header)] + [len(r) for r in body])
    header += [""] * (width - len(header))
    out = ["<table>", "<thead><tr>"]
    out.extend(f"<th>{inline(c)}</th>" for c in header)
    out.append("</tr></thead><tbody>")
    for row in body:
        row += [""] * (width - len(row))
        out.append("<tr>" + "".join(f"<td>{inline(c)}</td>" for c in row) + "</tr>")
    out.append("</tbody></table>")
    return "\n".join(out)


def render_markdown(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if not line.strip():
            i += 1
            continue

        # Bloque de código
        if line.lstrip().startswith("```"):
            lang = line.strip()[3:].strip()
            i += 1
            code_lines = []
            while i < len(lines) and not lines[i].lstrip().startswith("```"):
                code_lines.append(lines[i])
                i += 1
            i += 1  # cierre
            cls = f' class="language-{esc(lang)}"' if lang else ""
            out.append(f"<pre><code{cls}>{esc(chr(10).join(code_lines))}</code></pre>")
            continue

        # Títulos
        m = re.match(r"^(#{1,6})\s+(.*)$", line)
        if m:
            level = len(m.group(1))
            out.append(f"<h{level}>{inline(m.group(2))}</h{level}>")
            i += 1
            continue

        # Regla horizontal
        if re.match(r"^\s*---+\s*$", line):
            out.append("<hr>")
            i += 1
            continue

        # Tabla: línea con | seguida de separador
        if (
            "|" in line
            and i + 1 < len(lines)
            and re.match(r"^\s*\|?\s*:?-{3,}", lines[i + 1])
        ):
            table_lines = []
            while i < len(lines) and "|" in lines[i] and lines[i].strip():
                table_lines.append(lines[i])
                i += 1
            out.append(render_table(table_lines))
            continue

        # Cita
        if line.lstrip().startswith(">"):
            quote = []
            while i < len(lines) and lines[i].lstrip().startswith(">"):
                quote.append(re.sub(r"^\s*>\s?", "", lines[i]))
                i += 1
            out.append("<blockquote>" + render_markdown("\n".join(quote)) + "</blockquote>")
            continue

        # Listas
        if re.match(r"^\s*([-*+]|\d+\.)\s+", line):
            ordered = bool(re.match(r"^\s*\d+\.\s+", line))
            items = []
            while i < len(lines) and re.match(r"^\s*([-*+]|\d+\.)\s+", lines[i]):
                item = re.sub(r"^\s*([-*+]|\d+\.)\s+", "", lines[i])
                i += 1
                # Líneas de continuación (hasta blanco, otra lista u otro bloque)
                cont = []
                while (
                    i < len(lines)
                    and lines[i].strip()
                    and not re.match(r"^\s*([-*+]|\d+\.)\s+", lines[i])
                    and not lines[i].lstrip().startswith(("#", ">", "```", "|"))
                    and not re.match(r"^\s*---+\s*$", lines[i])
                ):
                    cont.append(lines[i].strip())
                    i += 1
                if cont:
                    item += " " + " ".join(cont)
                # Checkboxes de Markdown (texto Unicode, no HTML, para que no se escape)
                item = re.sub(r"^\[ \]\s*", "☐ ", item)
                item = re.sub(r"^\[[xX]\]\s*", "☑ ", item)
                items.append(f"<li>{inline(item)}</li>")
            tag = "ol" if ordered else "ul"
            out.append(f"<{tag}>" + "".join(items) + f"</{tag}>")
            continue

        # Párrafo
        para = [line.strip()]
        i += 1
        while (
            i < len(lines)
            and lines[i].strip()
            and not lines[i].lstrip().startswith(("#", ">", "```", "|"))
            and not re.match(r"^\s*([-*+]|\d+\.)\s+", lines[i])
            and not re.match(r"^\s*---+\s*$", lines[i])
        ):
            para.append(lines[i].strip())
            i += 1
        out.append("<p>" + inline(" ".join(para)) + "</p>")

    return "\n".join(out)


def main() -> None:
    parts = []
    for idx, (fname, title) in enumerate(SECTIONS):
        path = os.path.join(BASE, fname)
        if not os.path.exists(path):
            print(f"[warn] falta {path}", file=sys.stderr)
            continue
        with open(path, encoding="utf-8") as fh:
            body = render_markdown(fh.read())
        cls = "page-break" if idx else ""
        parts.append(
            f'<section class="{cls}">\n'
            f'<h1 class="section-title">{esc(title)}</h1>\n{body}\n</section>'
        )

    html_doc = f"""<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Estudio I2 — Arquitectura de Computadores (2026-2)</title>
<style>{CSS}</style>
</head>
<body>
<header>
  <h1>Estudio I2 — Arquitectura de Computadores 2026-2</h1>
  <p>Subrutinas · Floats · I/O · RISC-V</p>
  <p>Generado desde <code>Estudio-I2/</code> · imprime o guarda como PDF (Ctrl+P)</p>
</header>
{''.join(parts)}
<footer>
  Material de estudio personal — no distribuir. Basado en la Clase 16 (Repaso I2),
  clases S2, guías 2026-1 y las I2 históricas.
</footer>
</body>
</html>
"""
    out = os.path.join(BASE, "Estudio-I2-imprimible.html")
    with open(out, "w", encoding="utf-8") as fh:
        fh.write(html_doc)
    print(f"OK: {out} ({len(html_doc)} bytes)")


if __name__ == "__main__":
    main()
