#!/usr/bin/env python3
"""
Generate a PDF resume from _data/cv.yml.

Reads the structured YAML CV data and produces a professionally formatted PDF
at assets/pdf/Mark K Tinega's_Resume.pdf.

Usage:
    python3 _scripts/generate_cv_pdf.py

Dependencies:
    pip install pyyaml reportlab
"""

import os
import yaml
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.lib.colors import HexColor
from reportlab.lib.styles import ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable
)
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_JUSTIFY

# ── Paths ──────────────────────────────────────────────────────────────────────
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(SCRIPT_DIR)
CV_YAML = os.path.join(ROOT_DIR, "_data", "cv.yml")
OUTPUT_PDF = os.path.join(ROOT_DIR, "assets", "pdf", "Mark K Tinega's_Resume.pdf")

# ── Colors ─────────────────────────────────────────────────────────────────────
PRIMARY = HexColor("#1a1a2e")
ACCENT = HexColor("#16213e")
SUBTLE = HexColor("#555555")
DIVIDER = HexColor("#cccccc")

# ── Styles ─────────────────────────────────────────────────────────────────────
STYLE_NAME = ParagraphStyle(
    "Name", fontSize=18, leading=22, textColor=PRIMARY,
    alignment=TA_CENTER, fontName="Helvetica-Bold", spaceAfter=2 * mm,
)
STYLE_CONTACT = ParagraphStyle(
    "Contact", fontSize=9, leading=12, textColor=SUBTLE,
    alignment=TA_CENTER, spaceAfter=4 * mm,
)
STYLE_SECTION = ParagraphStyle(
    "SectionTitle", fontSize=12, leading=15, textColor=PRIMARY,
    fontName="Helvetica-Bold", spaceBefore=5 * mm, spaceAfter=2 * mm,
)
STYLE_ENTRY_TITLE = ParagraphStyle(
    "EntryTitle", fontSize=10, leading=13, textColor=PRIMARY,
    fontName="Helvetica-Bold",
)
STYLE_ENTRY_SUB = ParagraphStyle(
    "EntrySub", fontSize=9, leading=12, textColor=SUBTLE,
    fontName="Helvetica-Oblique",
)
STYLE_BODY = ParagraphStyle(
    "Body", fontSize=9, leading=12, textColor=HexColor("#333333"),
    alignment=TA_JUSTIFY,
)
STYLE_BULLET = ParagraphStyle(
    "Bullet", fontSize=9, leading=12, textColor=HexColor("#333333"),
    leftIndent=10 * mm, bulletIndent=5 * mm, alignment=TA_JUSTIFY,
)
STYLE_SUB_BULLET = ParagraphStyle(
    "SubBullet", fontSize=9, leading=12, textColor=HexColor("#333333"),
    leftIndent=16 * mm, bulletIndent=11 * mm,
)
STYLE_SKILL_TITLE = ParagraphStyle(
    "SkillTitle", fontSize=9, leading=12, textColor=PRIMARY,
    fontName="Helvetica-Bold",
)
STYLE_SUMMARY = ParagraphStyle(
    "Summary", fontSize=9, leading=13, textColor=HexColor("#333333"),
    alignment=TA_JUSTIFY, spaceAfter=2 * mm,
)


def load_cv():
    with open(CV_YAML, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def add_divider(story):
    story.append(HRFlowable(
        width="100%", thickness=0.5, color=DIVIDER,
        spaceBefore=1 * mm, spaceAfter=1 * mm,
    ))


def render_general_info(section, story):
    """Render name and contact line from the General Information section."""
    info = {item["name"]: item["value"] for item in section["contents"]}
    story.append(Paragraph(info.get("Full Name", ""), STYLE_NAME))
    contact_parts = []
    if "Contact" in info:
        contact_parts.append(info["Contact"])
    if "Location" in info:
        contact_parts.append(info["Location"])
    if "Languages" in info:
        contact_parts.append(info["Languages"])
    story.append(Paragraph(" | ".join(contact_parts), STYLE_CONTACT))


def render_professional_summary(section, story):
    """Render the professional summary paragraph."""
    add_divider(story)
    story.append(Paragraph("PROFESSIONAL SUMMARY", STYLE_SECTION))
    for item in section.get("contents", []):
        story.append(Paragraph(str(item.get("value", "")), STYLE_SUMMARY))


def render_skills_summary(section, story):
    """Render skills as a compact grouped list."""
    add_divider(story)
    story.append(Paragraph("SKILLS", STYLE_SECTION))
    for group in section.get("contents", []):
        title = group.get("title", "")
        items = group.get("items", [])
        text = f"<b>{title}:</b> {'; '.join(items)}"
        story.append(Paragraph(text, STYLE_BODY))
        story.append(Spacer(1, 1.5 * mm))


def render_time_table(section, story):
    """Render education or experience entries."""
    add_divider(story)
    story.append(Paragraph(section["title"].upper(), STYLE_SECTION))

    for entry in section.get("contents", []):
        title = entry.get("title", "")
        institution = entry.get("institution", "")
        year = str(entry.get("year", ""))

        # Title row with year right-aligned
        if title and year:
            data = [[
                Paragraph(title, STYLE_ENTRY_TITLE),
                Paragraph(year, ParagraphStyle(
                    "Year", fontSize=9, leading=12, textColor=SUBTLE,
                    fontName="Helvetica", alignment=2,  # TA_RIGHT
                )),
            ]]
            t = Table(data, colWidths=["75%", "25%"])
            t.setStyle(TableStyle([
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 0),
                ("RIGHTPADDING", (0, 0), (-1, -1), 0),
                ("TOPPADDING", (0, 0), (-1, -1), 0),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 0),
            ]))
            story.append(t)
        elif title:
            story.append(Paragraph(title, STYLE_ENTRY_TITLE))

        if institution:
            story.append(Paragraph(institution, STYLE_ENTRY_SUB))

        # Description bullets
        for desc in entry.get("description", []):
            if isinstance(desc, str):
                story.append(Paragraph(f"• {desc}", STYLE_BULLET))
            elif isinstance(desc, dict):
                # Sub-section like "Key Achievements", "Focus Areas", etc.
                sub_title = desc.get("title", "")
                if sub_title:
                    story.append(Paragraph(f"<b>{sub_title}:</b>", STYLE_BULLET))
                for sub_item in desc.get("contents", []):
                    story.append(Paragraph(f"– {sub_item}", STYLE_SUB_BULLET))

        story.append(Spacer(1, 3 * mm))


def render_nested_list(section, story):
    """Render academic interests or similar nested lists."""
    add_divider(story)
    story.append(Paragraph(section["title"].upper(), STYLE_SECTION))
    for group in section.get("contents", []):
        title = group.get("title", "")
        items = group.get("items", [])
        text = f"<b>{title}:</b> {', '.join(items)}"
        story.append(Paragraph(text, STYLE_BODY))
        story.append(Spacer(1, 1.5 * mm))


def build_pdf(cv_data):
    os.makedirs(os.path.dirname(OUTPUT_PDF), exist_ok=True)

    doc = SimpleDocTemplate(
        OUTPUT_PDF,
        pagesize=A4,
        leftMargin=15 * mm,
        rightMargin=15 * mm,
        topMargin=12 * mm,
        bottomMargin=12 * mm,
    )

    story = []

    for section in cv_data:
        title = section.get("title", "")
        stype = section.get("type", "")

        if title == "General Information":
            render_general_info(section, story)
        elif title == "Professional Summary":
            render_professional_summary(section, story)
        elif title == "Skills Summary":
            render_skills_summary(section, story)
        elif stype == "time_table":
            render_time_table(section, story)
        elif stype == "nested_list":
            render_nested_list(section, story)
        elif stype == "map" and title != "General Information":
            # Generic map sections
            add_divider(story)
            story.append(Paragraph(title.upper(), STYLE_SECTION))
            for item in section.get("contents", []):
                story.append(Paragraph(
                    f"<b>{item.get('name', '')}:</b> {item.get('value', '')}",
                    STYLE_BODY,
                ))

    doc.build(story)
    print(f"✓ PDF generated: {OUTPUT_PDF}")


def main():
    cv_data = load_cv()
    build_pdf(cv_data)


if __name__ == "__main__":
    main()
