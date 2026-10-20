#!/usr/bin/env python3
"""Fusiona todos los PDFs de cada carpeta de tema en un único PDF con portada.

Genera <Temas>/<Tema>/tema-compilado.pdf a partir de los PDFs individuales.
El PDF fusionado NO se vuelve a incluir (se excluye por nombre).
"""
import glob
import io
import os
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(BASE, "_vendor"))

from pypdf import PdfReader, PdfWriter

FOLDER = os.path.join(BASE, "Temas")
OUT_NAME = "tema-compilado.pdf"

TITLES = {
    "01-Subrutinas": "Tema 01 — Subrutinas",
    "02-Floats": "Tema 02 — Floats",
    "03-IO": "Tema 03 — I/O",
    "04-RISCV": "Tema 04 — RISC-V",
}

RESOURCES = b"<< /Font << /F1 4 0 R >> >>"
RESOURCES_ENTRY = b"/Resources " + RESOURCES


def esc(s: str) -> str:
    """Escapa paréntesis y barras para un string literal de PDF."""
    return s.replace("\\", r"\\").replace("(", r"\(").replace(")", r"\)")


def make_cover(title: str, files: list[str]) -> bytes:
    """Construye un PDF de una página (612x792) con título e índice de archivos."""
    lines = [
        "BT",
        "0.05 0.15 0.35 rg",
        "/F1 24 Tf 60 700 Td (" + esc(title) + ") Tj",
        "0 0 0 rg",
        "/F1 11 Tf 60 670 Td (Contenido:) Tj",
    ]
    y = 640
    for f in files:
        if y < 60:
            break
        # Nombres largos: se cortan para que quepan en la portada.
        shown = f if len(f) <= 78 else f[:75] + "..."
        lines.append(f"/F1 10 Tf 60 {y} Td ({esc(shown)}) Tj")
        y -= 15
    lines.append("ET")
    content = "\n".join(lines).encode("cp1252", errors="replace")

    objs = [
        b"1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n",
        b"2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n",
        b"3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] "
        + RESOURCES_ENTRY
        + b" /Contents 5 0 R >>\nendobj\n",
        b"4 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica "
        b"/Encoding /WinAnsiEncoding >>\nendobj\n",
        b"5 0 obj\n<< /Length "
        + str(len(content)).encode()
        + b" >>\nstream\n"
        + content
        + b"\nendstream\nendobj\n",
    ]

    out = bytearray(b"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n")
    offsets = []
    for o in objs:
        offsets.append(len(out))
        out += o
    xref_pos = len(out)
    out += b"xref\n0 6\n0000000000 65535 f \n"
    for off in offsets:
        out += ("%010d 00000 n \n" % off).encode()
    out += b"trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n"
    out += str(xref_pos).encode() + b"\n%%EOF\n"
    return bytes(out)


def main() -> None:
    temas = sorted(glob.glob(os.path.join(FOLDER, "0*")))
    if not temas:
        print("No se encontraron carpetas de tema en", FOLDER)
        sys.exit(1)

    for t in temas:
        if not os.path.isdir(t):
            continue
        folder_name = os.path.basename(t)
        num, _, rest = folder_name.partition("-")
        title = TITLES.get(folder_name, f"Tema {num} — {rest.replace('-', ' ')}")
        files = sorted(
            f
            for f in glob.glob(os.path.join(t, "*.pdf"))
            if os.path.basename(f) != OUT_NAME
        )
        if not files:
            print(f"[skip] {folder_name}: sin PDFs")
            continue

        print(f"[merge] {folder_name}: {len(files)} archivos")
        writer = PdfWriter()
        cover = make_cover(title, [os.path.basename(f) for f in files])
        writer.append(PdfReader(io.BytesIO(cover)))
        for f in files:
            writer.append(f)
        out_path = os.path.join(t, OUT_NAME)
        with open(out_path, "wb") as fh:
            writer.write(fh)
        print(f"  -> {out_path} ({len(writer.pages)} páginas)")

    print("Listo.")


if __name__ == "__main__":
    main()
