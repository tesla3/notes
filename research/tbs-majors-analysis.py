#!/usr/bin/env python3
"""Categorize and rank majors from The Bishop's School Class of 2026 decisions."""

import re
from collections import Counter
from pathlib import Path

DATA = Path(__file__).parent / "tbs-class-2026-decisions.md"

# Broad category rules - order matters (first match wins)
CATEGORY_RULES = [
    ("CS / Data Science", [
        r"computer science", r"\bcs\b", r"data science", r"informatics",
        r"computation", r"math.* computation", r"symbolic systems",
        r"information science", r"artificial intelligence", r"cognitive science",
    ]),
    ("Engineering", [
        r"engineer", r"eecs",
    ]),
    ("Business / Econ / Finance", [
        r"business", r"economics", r"econ", r"finance", r"marketing",
        r"accounting", r"management", r"real estate", r"international business",
        r"industrial and labor relations",
    ]),
    ("Bio / Health / Pre-Med", [
        r"bio", r"pre.?med", r"medicine", r"medical", r"nursing",
        r"health", r"physiology", r"nutrition", r"neuroscience",
        r"brain", r"pre.?vet", r"sonography", r"kinesiology",
        r"equine", r"pre.?dental", r"genetics", r"neurobio",
        r"behavioral decision",
    ]),
    ("Psychology", [
        r"psychology", r"psych",
    ]),
    ("STEM (Math/Phys/Chem/Env)", [
        r"math", r"physics", r"chemistry", r"environmental",
        r"earth", r"forestry", r"geology", r"astrophysics",
        r"astronomy", r"statistics", r"applied math",
    ]),
    ("Social Science / Policy / Pre-Law", [
        r"political", r"pre.?law", r"government", r"international relations",
        r"public policy", r"policy", r"anthropology", r"sociology",
        r"urban", r"community", r"ethnicity", r"migration",
    ]),
    ("Arts / Media / Design", [
        r"art", r"design", r"music", r"film", r"media", r"theater",
        r"theatre", r"illustration", r"animation", r"fashion",
        r"dance", r"architecture", r"creative", r"photography",
        r"journal", r"commun",
    ]),
    ("Humanities / Education", [
        r"history", r"philosophy", r"english", r"education",
        r"liberal studies", r"religion", r"liberal arts",
        r"language", r"culture", r"literature", r"spanish",
        r"linguistics",
    ]),
    ("Undeclared / Other", [
        r"undecided", r"undeclared", r"recruit", r"exploratory",
    ]),
]


def categorize(major: str) -> str:
    if not major or not major.strip():
        return "Undeclared / Other"
    low = major.lower()
    for category, patterns in CATEGORY_RULES:
        for pat in patterns:
            if re.search(pat, low):
                return category
    return "Other"


def normalize_major(major: str) -> str:
    if not major or not major.strip():
        return "(Undeclared)"
    m = major.strip()
    # Remove parenthetical track info
    m = re.sub(r"\s*\(.*?\)\s*", " ", m).strip()
    # Remove leading "Pre " or "Pre-"
    m = re.sub(r"^Pre[- ]", "", m).strip()
    # Collapse whitespace
    m = re.sub(r"\s+", " ", m)
    return m


def parse_md_table(path: Path) -> list[dict]:
    """Parse the markdown table from the TBS decisions file."""
    records = []
    with open(path) as f:
        lines = f.readlines()

    in_table = False
    for line in lines:
        line = line.strip()
        # Detect table rows (starts with |, has student/university/major columns)
        if line.startswith("|") and "|" in line:
            cols = [c.strip() for c in line.split("|")]
            # cols[0] is empty (before first |), cols[-1] is empty (after last |)
            cols = cols[1:-1]
            # Skip header/separator rows
            if len(cols) >= 4 and cols[0] not in ("", "#", "---", "—"):
                if cols[0].startswith("---") or cols[0] == "#":
                    continue
                # Entry number, Student, University, Major, Date, Notes
                num = cols[0].strip()
                if num == "—":
                    # Special row (Diego Mireles)
                    student = cols[1].strip()
                    university = cols[2].strip()
                    major = cols[3].strip()
                    records.append({
                        "name": student,
                        "university": university,
                        "major": major,
                    })
                elif re.match(r"\d+[a-z]?$", num):
                    student = cols[1].strip()
                    university = cols[2].strip()
                    major = cols[3].strip()
                    records.append({
                        "name": student,
                        "university": university,
                        "major": major,
                    })
    return records


def main():
    records = parse_md_table(DATA)

    # Deduplicate: Riley Ross chose Duke, Sabrina Feldman chose Brown
    # Remove superseded entries
    final_records = []
    superseded = set()
    for r in records:
        notes_lower = r.get("notes", "").lower() if "notes" in r else ""
        # For Riley Ross: keep Duke (entry 72), skip UCLA (entry 49)
        # For Sabrina Feldman: keep Brown (entry 106), skip Amherst (entry 73)
        pass

    # Actually, from the data, let's just handle duplicates by name
    seen_names = {}
    for r in records:
        name = r["name"]
        # Keep the later entry (higher index = later decision = final choice)
        seen_names[name] = r

    final_records = list(seen_names.values())

    print(f"The Bishop's School — Class of 2026")
    print(f"Total unique students: {len(final_records)}\n")

    # --- Broad category analysis ---
    cat_counter = Counter()
    for r in final_records:
        cat = categorize(r.get("major", ""))
        cat_counter[cat] += 1

    print("=" * 60)
    print("BROAD CATEGORY BREAKDOWN (ranked)")
    print("=" * 60)
    print(f"{'Rank':<5} {'Category':<35} {'Count':>5} {'%':>6}")
    print("-" * 60)
    for rank, (cat, count) in enumerate(cat_counter.most_common(), 1):
        pct = count / len(final_records) * 100
        bar = "█" * round(count / 2)
        print(f"{rank:<5} {cat:<35} {count:>5} {pct:>5.1f}%  {bar}")
    print(f"\n{'Total':<41} {sum(cat_counter.values()):>5}")

    # --- Exact major analysis ---
    major_counter = Counter()
    for r in final_records:
        nm = normalize_major(r.get("major", ""))
        major_counter[nm] += 1

    print("\n")
    print("=" * 70)
    print("ALL MAJORS (normalized, ranked)")
    print("=" * 70)
    print(f"{'Rank':<5} {'Major':<50} {'Count':>5}")
    print("-" * 70)
    for rank, (major, count) in enumerate(major_counter.most_common(), 1):
        print(f"{rank:<5} {major:<50} {count:>5}")

    # --- Write markdown output ---
    md_path = Path(__file__).parent / "tbs-majors-ranked.md"
    with open(md_path, "w") as f:
        f.write("# The Bishop's School — Class of 2026 — Majors Ranked\n\n")
        f.write(f"> Source: {len(final_records)} unique students from [@tbs26decisions](https://www.instagram.com/tbs26decisions/)  \n")
        f.write("> Generated: 2026-05-16\n\n")
        f.write("---\n\n")

        f.write("## Broad Categories\n\n")
        f.write("| Rank | Category | Count | % | Distribution |\n")
        f.write("|-----:|----------|------:|---:|:-------------|\n")
        max_count = cat_counter.most_common(1)[0][1]
        for rank, (cat, count) in enumerate(cat_counter.most_common(), 1):
            pct = count / len(final_records) * 100
            bar_len = round(count / max_count * 20)
            bar = "█" * bar_len
            f.write(f"| {rank} | {cat} | {count} | {pct:.1f}% | {bar} |\n")
        f.write(f"| | **Total** | **{sum(cat_counter.values())}** | **100%** | |\n")

        f.write("\n---\n\n")
        f.write("## Top 20 Specific Majors\n\n")
        f.write("| Rank | Major | Count | Category |\n")
        f.write("|-----:|-------|------:|----------|\n")
        prev_count = None
        display_rank = 0
        for i, (major, count) in enumerate(major_counter.most_common(20), 1):
            if count != prev_count:
                display_rank = i
                prev_count = count
            for r in final_records:
                if normalize_major(r.get("major", "")) == major:
                    cat = categorize(r.get("major", ""))
                    break
            f.write(f"| {display_rank} | {major} | {count} | {cat} |\n")

        f.write("\n---\n\n")
        f.write("## All Specific Majors (complete list)\n\n")
        f.write("| Rank | Major | Count | Category |\n")
        f.write("|-----:|-------|------:|----------|\n")
        prev_count = None
        display_rank = 0
        singles = 0
        for i, (major, count) in enumerate(major_counter.most_common(), 1):
            if count != prev_count:
                display_rank = i
                prev_count = count
            for r in final_records:
                if normalize_major(r.get("major", "")) == major:
                    cat = categorize(r.get("major", ""))
                    break
            if count >= 2:
                f.write(f"| {display_rank} | {major} | {count} | {cat} |\n")
            else:
                singles += 1
        if singles:
            f.write(f"| — | *{singles} additional majors with 1 student each* | {singles} | *(various)* |\n")

        f.write("\n---\n\n")
        # Full list for reference
        f.write("### All single-count majors\n\n")
        f.write("| Major | Category |\n")
        f.write("|-------|----------|\n")
        for major, count in major_counter.most_common():
            if count == 1:
                for r in final_records:
                    if normalize_major(r.get("major", "")) == major:
                        cat = categorize(r.get("major", ""))
                        break
                f.write(f"| {major} | {cat} |\n")

        f.write("\n---\n\n")
        f.write("## Notes\n\n")
        f.write("- Majors normalized: parenthetical qualifiers (Pre-Med, Pre-Law, etc.) stripped for grouping.\n")
        f.write("- Dual majors kept as-is (e.g., \"Biology / Linguistics\" is one entry).\n")
        f.write("- Riley Ross counted at Duke (final choice over UCLA); Sabrina Feldman at Brown (final over Amherst).\n")
        f.write("- Diego Mireles included (special row in source data).\n")

    print(f"\n\n✅ Markdown table written to: {md_path}")


if __name__ == "__main__":
    main()
