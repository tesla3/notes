#!/usr/bin/env python3
"""Categorize and rank majors from CCA Class of 2026 decisions."""

import json
import re
from collections import Counter
from pathlib import Path

DATA = Path(__file__).parent / "cca-class-2026-decisions.json"

# Broad category rules - order matters (first match wins)
CATEGORY_RULES = [
    # CS / Data Science / Informatics
    ("CS / Data Science", [
        r"computer science", r"\bcs\b", r"data science", r"informatics",
        r"computation", r"math.* computation", r"symbolic systems",
        r"information science",
    ]),
    # Engineering (not CS)
    ("Engineering", [
        r"engineer", r"eecs",
    ]),
    # Business / Econ / Finance
    ("Business / Econ / Finance", [
        r"business", r"economics", r"econ", r"finance", r"marketing",
        r"accounting", r"management",
    ]),
    # Bio / Health / Pre-Med / Nursing
    ("Bio / Health / Pre-Med", [
        r"bio", r"pre.?med", r"medicine", r"medical", r"nursing",
        r"health", r"physiology", r"nutrition", r"neuroscience",
        r"cognitive", r"brain", r"pre.?vet", r"sonography",
        r"kinesiology", r"equine", r"pre.?dental", r"genetics",
        r"cell biology", r"anesthesia", r"human biology",
        r"pharmaceutical", r"pre sciences", r"pre-sciences",
        r"preprofessional sciences",
    ]),
    # Psychology
    ("Psychology", [
        r"psychology", r"psych",
    ]),
    # Math / Physics / Chemistry / Env Science
    ("STEM (Math/Phys/Chem/Env)", [
        r"math", r"physics", r"chemistry", r"environmental",
        r"earth", r"forestry", r"geology", r"astrophysics",
        r"astronomy", r"statistics", r"applied math",
        r"food science", r"animal science", r"equine science",
    ]),
    # Social Science / Policy / Pre-Law / PoliSci
    ("Social Science / Policy / Pre-Law", [
        r"political", r"pre.?law", r"government", r"international relations",
        r"public", r"policy", r"anthropology", r"sociology",
        r"urban", r"community", r"global communication",
    ]),
    # Arts / Media / Design / Music / Film
    ("Arts / Media / Design", [
        r"art", r"design", r"music", r"film", r"media", r"theater",
        r"theatre", r"illustration", r"animation", r"fashion",
        r"dance", r"architecture", r"creative", r"commun",
    ]),
    # Humanities / Education / History / Philosophy / English / Religion
    ("Humanities / Education", [
        r"history", r"philosophy", r"english", r"education",
        r"liberal studies", r"religion", r"liberal arts",
        r"language", r"culture", r"american studies",
        r"child development", r"game design",
    ]),
    # Undeclared / Athlete / Unknown
    ("Undeclared / Other", [
        r"undecided", r"undeclared", r"recruit", r"track",
        r"cross country", r"exploratory",
    ]),
]


def categorize(major: str) -> str:
    """Assign a major string to a broad category."""
    if not major or not major.strip():
        return "Undeclared / Other"
    low = major.lower()
    for category, patterns in CATEGORY_RULES:
        for pat in patterns:
            if re.search(pat, low):
                return category
    return "Other"


def normalize_major(major: str) -> str:
    """Light normalization for grouping similar exact majors."""
    if not major or not major.strip():
        return "(Undeclared)"
    # Strip common qualifiers for grouping
    m = major.strip()
    # Remove parenthetical track info for grouping
    m = re.sub(r"\s*\(.*?\)\s*", " ", m).strip()
    # Remove leading "Pre " or "Pre-" for grouping
    m = re.sub(r"^Pre[- ]", "", m).strip()
    # Collapse whitespace
    m = re.sub(r"\s+", " ", m)
    return m


def main():
    with open(DATA) as f:
        records = json.load(f)

    print(f"Total records: {len(records)}\n")

    # --- Broad category analysis ---
    cat_counter = Counter()
    for r in records:
        cat = categorize(r.get("major", ""))
        cat_counter[cat] += 1

    print("=" * 60)
    print("BROAD CATEGORY BREAKDOWN (ranked)")
    print("=" * 60)
    print(f"{'Rank':<5} {'Category':<30} {'Count':>5} {'%':>6}")
    print("-" * 60)
    for rank, (cat, count) in enumerate(cat_counter.most_common(), 1):
        pct = count / len(records) * 100
        bar = "█" * (count // 2)
        print(f"{rank:<5} {cat:<30} {count:>5} {pct:>5.1f}%  {bar}")
    print(f"\n{'Total':<36} {sum(cat_counter.values()):>5}")

    # --- Exact major analysis (normalized) ---
    major_counter = Counter()
    for r in records:
        nm = normalize_major(r.get("major", ""))
        major_counter[nm] += 1

    print("\n")
    print("=" * 70)
    print("TOP 40 SPECIFIC MAJORS (normalized, ranked)")
    print("=" * 70)
    print(f"{'Rank':<5} {'Major':<50} {'Count':>5}")
    print("-" * 70)
    for rank, (major, count) in enumerate(major_counter.most_common(40), 1):
        print(f"{rank:<5} {major:<50} {count:>5}")

    # --- Full table sorted ---
    print("\n")
    print("=" * 70)
    print("ALL MAJORS (normalized, ranked)")
    print("=" * 70)
    print(f"{'Rank':<5} {'Major':<55} {'Count':>5} {'Category':<30}")
    print("-" * 100)
    for rank, (major, count) in enumerate(major_counter.most_common(), 1):
        # Find category for this normalized major by finding one original
        for r in records:
            if normalize_major(r.get("major", "")) == major:
                cat = categorize(r.get("major", ""))
                break
        print(f"{rank:<5} {major:<55} {count:>5}  {cat}")

    # --- Markdown table output ---
    md_path = Path(__file__).parent / "cca-majors-ranked.md"
    with open(md_path, "w") as f:
        f.write("# CCA Class of 2026 — Majors Ranked\n\n")
        f.write(f"Source: 305 decisions from @ccadecisions2026\n\n")

        f.write("## Broad Categories\n\n")
        f.write("| Rank | Category | Count | % |\n")
        f.write("|-----:|----------|------:|---:|\n")
        for rank, (cat, count) in enumerate(cat_counter.most_common(), 1):
            pct = count / len(records) * 100
            f.write(f"| {rank} | {cat} | {count} | {pct:.1f}% |\n")
        f.write(f"| | **Total** | **{sum(cat_counter.values())}** | **100%** |\n")

        f.write("\n## All Majors (Specific, Ranked)\n\n")
        f.write("| Rank | Major | Count | Category |\n")
        f.write("|-----:|-------|------:|----------|\n")
        for rank, (major, count) in enumerate(major_counter.most_common(), 1):
            for r in records:
                if normalize_major(r.get("major", "")) == major:
                    cat = categorize(r.get("major", ""))
                    break
            f.write(f"| {rank} | {major} | {count} | {cat} |\n")

    print(f"\n\n✅ Markdown table written to: {md_path}")


if __name__ == "__main__":
    main()
