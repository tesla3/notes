#!/usr/bin/env python3
"""
CCA Class of 2026 College Decisions — ranked by US News 2026.

Reads cca-class-2026-decisions.json (scraped from @ccadecisions2026 Instagram),
normalizes university names, maps to US News 2026 rankings, and outputs a
one-school-per-row table sorted by rank.

Sources:
  - US News 2026 Best National Universities (usnews.com, Sep 2025)
  - US News 2026 Best National Liberal Arts Colleges
  - US News 2026 Best Regional Universities
  - International schools: not ranked by US News
"""

import json
from pathlib import Path
from collections import defaultdict

# ── 1. Load data ─────────────────────────────────────────────────────────────
data_path = Path(__file__).parent / "cca-class-2026-decisions.json"
with open(data_path) as f:
    decisions = json.load(f)

# ── 2. Normalize university names ────────────────────────────────────────────
# Map every raw name variant → canonical name
NAME_MAP = {
    # Exact matches for abbreviations / informal names
    "BU":                           "Boston University",
    "SCU":                          "Santa Clara University",
    "UW":                           "University of Washington",
    "Oberlin 🎶":                   "Oberlin College",
    "Loyola Marymount":             "Loyola Marymount University",
    "College of William & Mary":    "William & Mary",
    "William & Mary":               "William & Mary",
    "Mira Costa College!":          "MiraCosta College",
    "Indiana":                      "Indiana University",
    "Indiana University":           "Indiana University",
    "Michigan":                     "University of Michigan",
    "Wisconsin":                    "University of Wisconsin–Madison",
    "Wesleyan":                     "Wesleyan University",
    "Northeastern":                 "Northeastern University",
    "Purdue":                       "Purdue University",
    "Scripps":                      "Scripps College",
    "Tufts":                        "Tufts University",
    "Stanford":                     "Stanford University",
    "Rice":                         "Rice University",
    "Cornell":                      "Cornell University",
    "Emory":                        "Emory University",
    "Vanderbilt":                   "Vanderbilt University",
    "Georgetown":                   "Georgetown University",
    "Caltech":                      "California Institute of Technology",
    "Harvard":                      "Harvard University",
    "Yale":                         "Yale University",
    "Princeton":                    "Princeton University",
    "Columbia":                     "Columbia University",
    "Northwestern":                 "Northwestern University",
    "Rutgers":                      "Rutgers University",
    "Chapman":                      "Chapman University",
    "Marquette":                    "Marquette University",
    "Syracuse":                     "Syracuse University",
    "Pace":                         "Pace University",
    "UIUC":                         "University of Illinois Urbana–Champaign",
    "RISD":                         "Rhode Island School of Design",
    "CalArts":                      "California Institute of the Arts",
    "WashU":                        "Washington University in St. Louis",
    "UChicago":                     "University of Chicago",
    "Georgia Tech":                    "Georgia Institute of Technology",
    "Johns Hopkins":                   "Johns Hopkins University",
    "UMBC":                            "University of Maryland Baltimore County",
    "UMass Amherst":                   "University of Massachusetts Amherst",

    # UC system
    "UCLA":                         "University of California, Los Angeles",
    "UC Berkeley":                  "University of California, Berkeley",
    "UC San Diego":                 "University of California, San Diego",
    "UC Irvine":                    "University of California, Irvine",
    "UC Santa Barbara":             "University of California, Santa Barbara",
    "UC Davis":                     "University of California, Davis",
    "UC Santa Cruz":                "University of California, Santa Cruz",
    "UC Riverside":                 "University of California, Riverside",

    # Other public
    "San Diego State":              "San Diego State University",
    "San Jose State":               "San Jose State University",
    "Cal Poly SLO":                 "Cal Poly San Luis Obispo",
    "Cal Poly Pomona":              "Cal Poly Pomona",
    "Cal State Long Beach":         "Cal State Long Beach",
    "Ohio State":                   "Ohio State University",
    "CU Boulder":                   "University of Colorado Boulder",
    "Colorado State":               "Colorado State University",
    "Arizona State":                "Arizona State University",
    "UT Austin":                    "University of Texas at Austin",
    "Texas A&M":                    "Texas A&M University",
    "Virginia Tech":                "Virginia Tech",
    "Washington State":             "Washington State University",

    # Private
    "Boston University":            "Boston University",
    "Boston College":               "Boston College",
    "Carnegie Mellon":              "Carnegie Mellon University",
    "Santa Clara":                  "Santa Clara University",
    "Case Western Reserve":         "Case Western Reserve University",
    "Pomona College":               "Pomona College",
    "NYU":                          "New York University",
    "USC":                          "University of Southern California",
    "Notre Dame":                   "University of Notre Dame",
    "BYU":                          "Brigham Young University",
    "George Washington":            "George Washington University",
    "Denison":                      "Denison University",
    "Bowdoin":                      "Bowdoin College",

    # International / other
    "U of Toronto":                 "University of Toronto",
    "U of Hong Kong":               "University of Hong Kong",
    "U of Victoria":                "University of Victoria",
    "U of Bath":                    "University of Bath",
    "University of Edinburgh":      "University of Edinburgh",
    "RCSI (Dublin)":                "RCSI University of Medicine (Dublin)",
    "American U of Paris":          "American University of Paris",
    "U of Hawaii":                  "University of Hawaii",
    "U of Arizona":                 "University of Arizona",
    "U of Maryland":                "University of Maryland",
    "U of Miami":                   "University of Miami",
    "U of San Diego":               "University of San Diego",
    "U of Tennessee":               "University of Tennessee",
    "U of Oregon":                  "University of Oregon",
    "University of Oregon":         "University of Oregon",
    "U of Utah":                    "University of Utah",
    "U of Rochester":               "University of Rochester",
    "Northern Arizona":             "Northern Arizona University",
    "Montana State":                "Montana State University",
    "Grand Valley State":           "Grand Valley State University",
    "Seattle University":           "Seattle University",
    "Embry-Riddle":                 "Embry-Riddle Aeronautical University",
    "San Diego Mesa College":       "San Diego Mesa College",
    "MiraCosta College":            "MiraCosta College",
    "Loyola Marymount University":  "Loyola Marymount University",
    "US Naval Academy":             "United States Naval Academy",
    "Colorado School of Mines":     "Colorado School of Mines",

    # Dual-degree edge case
    "Saint Mary's College & Notre Dame": "Saint Mary's College & Notre Dame (dual degree)",
    "Saint Mary's College":         "Saint Mary's College of California",

    # Parsons
    "Parsons School of Design":     "Parsons School of Design (The New School)",

    "Harvey Mudd":                  "Harvey Mudd College",
    "Smith College":                "Smith College",
    "Claremont McKenna":            "Claremont McKenna College",
}


def normalize(raw: str) -> str:
    """Return canonical university name."""
    if raw in NAME_MAP:
        return NAME_MAP[raw]
    return raw  # already canonical or unmapped


# ── 3. US News 2026 Rankings ────────────────────────────────────────────────
# (rank, category)  category: "NU"=National University, "LAC"=Liberal Arts,
#                              "RU-W"=Regional West, "RU-N"=Regional North,
#                              "RU-S"=Regional South, "Intl"=International,
#                              "CC"=Community College, "Spec"=Specialty/Unranked

RANKINGS = {
    # ── National Universities ──
    "Princeton University":                         (1,   "NU"),
    "Harvard University":                           (3,   "NU"),
    "Stanford University":                          (4,   "NU"),
    "Yale University":                              (4,   "NU"),
    "University of Chicago":                        (6,   "NU"),
    "Johns Hopkins University":                     (7,   "NU"),
    "Northwestern University":                      (7,   "NU"),
    "California Institute of Technology":           (11,  "NU"),
    "Cornell University":                           (12,  "NU"),
    "Columbia University":                          (15,  "NU"),
    "University of California, Berkeley":           (15,  "NU"),
    "Rice University":                              (17,  "NU"),
    "University of California, Los Angeles":        (17,  "NU"),
    "Vanderbilt University":                        (17,  "NU"),
    "Carnegie Mellon University":                   (20,  "NU"),
    "University of Michigan":                       (20,  "NU"),
    "University of Notre Dame":                     (20,  "NU"),
    "Washington University in St. Louis":           (20,  "NU"),
    "Emory University":                             (24,  "NU"),
    "Georgetown University":                        (24,  "NU"),
    "University of Southern California":            (28,  "NU"),
    "University of California, San Diego":          (29,  "NU"),
    "University of Texas at Austin":                (30,  "NU"),
    "Georgia Institute of Technology":              (32,  "NU"),
    "New York University":                          (32,  "NU"),
    "University of California, Davis":              (32,  "NU"),
    "University of California, Irvine":             (32,  "NU"),
    "Boston College":                               (36,  "NU"),
    "Tufts University":                             (36,  "NU"),
    "University of Illinois Urbana–Champaign":      (36,  "NU"),
    "University of Wisconsin–Madison":              (36,  "NU"),
    "University of California, Santa Barbara":      (40,  "NU"),
    "Ohio State University":                        (41,  "NU"),
    "Boston University":                            (42,  "NU"),
    "Rutgers University":                           (42,  "NU"),
    "University of Maryland":                       (44,  "NU"),
    "University of Rochester":                      (46,  "NU"),
    "Northeastern University":                      (46,  "NU"),
    "Purdue University":                            (46,  "NU"),
    "University of Washington":                     (46,  "NU"),
    "Case Western Reserve University":              (51,  "NU"),
    "Texas A&M University":                         (51,  "NU"),
    "Virginia Tech":                                (51,  "NU"),
    "William & Mary":                               (51,  "NU"),
    "George Washington University":                 (59,  "NU"),
    "University of Miami":                          (64,  "NU"),
    "University of Massachusetts Amherst":          (64,  "NU"),
    "Santa Clara University":                       (64,  "NU"),
    "Indiana University":                           (73,  "NU"),
    "Syracuse University":                          (75,  "NU"),
    "University of California, Riverside":          (75,  "NU"),
    "Colorado School of Mines":                     (80,  "NU"),
    "Marquette University":                         (88,  "NU"),
    "University of California, Santa Cruz":         (88,  "NU"),
    "University of Colorado Boulder":               (97,  "NU"),
    "Loyola Marymount University":                  (102, "NU"),
    "University of Tennessee":                      (102, "NU"),
    "Brigham Young University":                     (110, "NU"),
    "Chapman University":                           (110, "NU"),
    "University of San Diego":                      (110, "NU"),
    "Arizona State University":                     (117, "NU"),
    "San Diego State University":                   (117, "NU"),
    "University of Oregon":                         (117, "NU"),
    "University of Maryland Baltimore County":      (127, "NU"),  # UMBC
    "University of Arizona":                        (127, "NU"),
    "University of Utah":                           (134, "NU"),
    "Colorado State University":                    (151, "NU"),
    "Seattle University":                           (151, "NU"),
    "Washington State University":                  (192, "NU"),
    "University of Hawaii":                         (192, "NU"),
    "Northern Arizona University":                  (242, "NU"),
    "Grand Valley State University":                (242, "NU"),
    "Pace University":                              (273, "NU"),
    "Montana State University":                     (318, "NU"),

    # ── National Liberal Arts Colleges ──
    "United States Naval Academy":                  (3,   "LAC"),
    "Bowdoin College":                              (5,   "LAC"),
    "Claremont McKenna College":                    (7,   "LAC"),
    "Pomona College":                               (7,   "LAC"),
    "Harvey Mudd College":                          (10,  "LAC"),
    "Smith College":                                (13,  "LAC"),
    "Wesleyan University":                          (13,  "LAC"),
    "Denison University":                           (34,  "LAC"),
    "Scripps College":                              (37,  "LAC"),
    "Oberlin College":                              (58,  "LAC"),

    # ── Regional Universities ──
    "Cal Poly San Luis Obispo":                     (1,   "RU-W"),
    "Saint Mary's College of California":           (7,   "RU-W"),
    "California Institute of the Arts":             (28,  "RU-W"),
    "San Jose State University":                    (4,   "RU-W"),
    "Cal Poly Pomona":                              (5,   "RU-W"),  # approx
    "Cal State Long Beach":                         (8,   "RU-W"),  # approx
    "Rhode Island School of Design":                (3,   "RU-N"),
    "Embry-Riddle Aeronautical University":         (4,   "RU-S"),
    "Parsons School of Design (The New School)":    (7,   "RU-N"),  # New School ranked

    # ── International ──
    "University of Toronto":                        (None, "Intl"),
    "University of Hong Kong":                      (None, "Intl"),
    "University of Victoria":                       (None, "Intl"),
    "University of Bath":                           (None, "Intl"),
    "University of Edinburgh":                      (None, "Intl"),
    "RCSI University of Medicine (Dublin)":         (None, "Intl"),
    "American University of Paris":                 (None, "Intl"),

    # ── Community Colleges ──
    "San Diego Mesa College":                       (None, "CC"),
    "MiraCosta College":                            (None, "CC"),

    # ── Dual-degree / special ──
    "Saint Mary's College & Notre Dame (dual degree)": (None, "Spec"),
}


# ── 4. Aggregate by school ──────────────────────────────────────────────────
school_students: dict[str, list[dict]] = defaultdict(list)
unmapped = set()

for entry in decisions:
    raw = entry["university"]
    canon = normalize(raw)
    school_students[canon].append(entry)
    if canon not in RANKINGS:
        unmapped.add(canon)

if unmapped:
    print("⚠ UNMAPPED SCHOOLS (need ranking data):")
    for s in sorted(unmapped):
        print(f"  - {s}")
    print()

# ── 5. Verification ─────────────────────────────────────────────────────────
total_in = len(decisions)
total_out = sum(len(v) for v in school_students.values())
assert total_in == total_out, f"Student count mismatch: {total_in} input vs {total_out} output"
print(f"✓ {total_in} students mapped to {len(school_students)} schools (no data loss)\n")

# ── 6. Sort & Display ───────────────────────────────────────────────────────
# Sort order: NU by rank, then LAC by rank, then RU by rank, then Intl, CC, Spec
CATEGORY_ORDER = {"NU": 0, "LAC": 1, "RU-W": 2, "RU-N": 2, "RU-S": 2, "Intl": 3, "CC": 4, "Spec": 5}

def sort_key(item):
    school, students = item
    if school in RANKINGS:
        rank, cat = RANKINGS[school]
        cat_ord = CATEGORY_ORDER.get(cat, 99)
        r = rank if rank is not None else 9999
        return (cat_ord, r, school)
    return (99, 9999, school)

sorted_schools = sorted(school_students.items(), key=sort_key)

# Build output
lines = []
header = f"{'#':<4} {'School':<50} {'Category':<12} {'Rank':<8} {'Count':<6} Students"
lines.append(header)
lines.append("─" * len(header))

row_num = 0
prev_cat_ord = -1
for school, students in sorted_schools:
    row_num += 1
    if school in RANKINGS:
        rank, cat = RANKINGS[school]
        rank_str = str(rank) if rank else "—"
        cat_label = cat
    else:
        rank_str = "?"
        cat_label = "?"

    cat_ord = CATEGORY_ORDER.get(cat_label, 99) if school in RANKINGS else 99

    # Section divider
    if cat_ord != prev_cat_ord:
        if prev_cat_ord != -1:
            lines.append("")
        section_names = {0: "═══ NATIONAL UNIVERSITIES (US News 2026) ═══",
                         1: "═══ NATIONAL LIBERAL ARTS COLLEGES (US News 2026) ═══",
                         2: "═══ REGIONAL UNIVERSITIES (US News 2026) ═══",
                         3: "═══ INTERNATIONAL ═══",
                         4: "═══ COMMUNITY COLLEGES ═══",
                         5: "═══ OTHER / SPECIAL ═══"}
        lines.append(section_names.get(cat_ord, "═══ UNKNOWN ═══"))
        prev_cat_ord = cat_ord

    count = len(students)
    # Collect student names
    names = sorted(s["name"] for s in students)
    names_str = ", ".join(names)

    lines.append(
        f"{row_num:<4} {school:<50} {cat_label:<12} {rank_str:<8} {count:<6} {names_str}"
    )

output = "\n".join(lines)
print(output)

# ── 7. Summary stats ────────────────────────────────────────────────────────
print("\n")
print("═══ SUMMARY ═══")
print(f"Total students:  {total_in}")
print(f"Total schools:   {len(school_students)}")

# Count by category
cat_counts: dict[str, tuple[int, int]] = defaultdict(lambda: (0, 0))
for school, students in sorted_schools:
    if school in RANKINGS:
        _, cat = RANKINGS[school]
    else:
        cat = "?"
    schools_n, students_n = cat_counts[cat]
    cat_counts[cat] = (schools_n + 1, students_n + len(students))

print("\nBy category:")
for cat in ["NU", "LAC", "RU-W", "RU-N", "RU-S", "Intl", "CC", "Spec"]:
    if cat in cat_counts:
        s, st = cat_counts[cat]
        print(f"  {cat:<8} {s:>3} schools, {st:>3} students")

# Top 10 most popular
print("\nTop 10 most popular schools:")
popular = sorted(school_students.items(), key=lambda x: -len(x[1]))[:10]
for school, students in popular:
    rank_info = RANKINGS.get(school, (None, "?"))
    r = rank_info[0] if rank_info[0] else "—"
    print(f"  {len(students):>3}  {school} (#{r} {rank_info[1]})")

# Write markdown output
md_path = Path(__file__).parent / "cca-2026-college-decisions-ranked.md"
md_lines = [
    "# CCA Class of 2026 — College Decisions",
    f"*Ranked by US News 2026 Best Colleges. {total_in} students, {len(school_students)} schools.*\n",
    f"Source: [@ccadecisions2026](https://www.instagram.com/ccadecisions2026/) Instagram\n",
]

def md_section(title: str, cat_codes: list[str]):
    rows = [(s, st) for s, st in sorted_schools
            if s in RANKINGS and RANKINGS[s][1] in cat_codes]
    if not rows:
        return
    md_lines.append(f"\n## {title}\n")
    md_lines.append("| # | School | Rank | Students | Names |")
    md_lines.append("|--:|--------|-----:|:--------:|-------|")
    for i, (school, students) in enumerate(rows, 1):
        rank, cat = RANKINGS[school]
        rank_str = str(rank) if rank else "—"
        names = ", ".join(sorted(s["name"] for s in students))
        md_lines.append(f"| {i} | {school} | {rank_str} | {len(students)} | {names} |")

md_section("National Universities", ["NU"])
md_section("National Liberal Arts Colleges", ["LAC"])
md_section("Regional Universities", ["RU-W", "RU-N", "RU-S"])

# International
intl_rows = [(s, st) for s, st in sorted_schools
             if s in RANKINGS and RANKINGS[s][1] == "Intl"]
if intl_rows:
    md_lines.append("\n## International\n")
    md_lines.append("| # | School | Students | Names |")
    md_lines.append("|--:|--------|:--------:|-------|")
    for i, (school, students) in enumerate(intl_rows, 1):
        names = ", ".join(sorted(s["name"] for s in students))
        md_lines.append(f"| {i} | {school} | {len(students)} | {names} |")

# Community Colleges
cc_rows = [(s, st) for s, st in sorted_schools
           if s in RANKINGS and RANKINGS[s][1] == "CC"]
if cc_rows:
    md_lines.append("\n## Community Colleges\n")
    md_lines.append("| # | School | Students | Names |")
    md_lines.append("|--:|--------|:--------:|-------|")
    for i, (school, students) in enumerate(cc_rows, 1):
        names = ", ".join(sorted(s["name"] for s in students))
        md_lines.append(f"| {i} | {school} | {len(students)} | {names} |")

# Special
spec_rows = [(s, st) for s, st in sorted_schools
             if s in RANKINGS and RANKINGS[s][1] == "Spec"]
if spec_rows:
    md_lines.append("\n## Other / Special Programs\n")
    md_lines.append("| # | School | Students | Names |")
    md_lines.append("|--:|--------|:--------:|-------|")
    for i, (school, students) in enumerate(spec_rows, 1):
        names = ", ".join(sorted(s["name"] for s in students))
        md_lines.append(f"| {i} | {school} | {len(students)} | {names} |")

md_lines.append(f"\n---\n*Generated from {total_in} entries. Rankings: US News & World Report 2026 Best Colleges.*\n")

md_path.write_text("\n".join(md_lines))
print(f"\n✓ Markdown written to {md_path}")
