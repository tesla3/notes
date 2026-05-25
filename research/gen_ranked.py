#!/usr/bin/env python3
"""Generate ranked college decisions markdown from merged JSON."""

import json
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).parent

with open(ROOT / "cca-class-2026-merged.json") as f:
    data = json.load(f)

# ── US News 2026 rankings ───────────────────────────────────────────────
NAT_RANK = {
    "Princeton University": 1, "Harvard University": 3, "MIT": 3,
    "Stanford University": 4, "Yale University": 4,
    "University of Chicago": 6, "Johns Hopkins": 7, "Northwestern University": 7,
    "Caltech": 11, "Cornell University": 12,
    "Columbia University": 15, "UC Berkeley": 15, "Rice University": 17,
    "UCLA": 17, "Vanderbilt University": 17, "Carnegie Mellon University": 20,
    "University of Michigan": 20, "University of Notre Dame": 20,
    "Washington University in St. Louis": 20, "Emory University": 24,
    "Georgetown": 24, "USC": 28, "UCSD": 29,
    "University of Texas at Austin": 30, "Georgia Tech": 32,
    "New York University": 32, "UC Davis": 32, "UC Irvine": 32,
    "Boston College": 36, "Tufts University": 36,
    "University of Illinois Urbana-Champaign": 36,
    "University of Wisconsin-Madison": 36, "UCSB": 40,
    "Ohio State University": 41, "Boston University": 42,
    "Brandeis University": 42, "Rutgers University": 42,
    "University of Maryland": 44, "Northeastern University": 46,
    "Purdue University": 46, "University of Rochester": 46,
    "University of Washington": 46, "Case Western Reserve University": 51,
    "Texas A&M University": 51, "Virginia Tech": 51, "William & Mary": 51,
    "George Washington University": 59, "Santa Clara University": 64,
    "UMass Amherst": 64, "University of Miami": 64,
    "Indiana University Bloomington": 73, "Syracuse": 75,
    "UC Riverside": 75, "Colorado School of Mines": 80,
    "Marquette": 88, "UC Santa Cruz": 88,
    "University of Colorado Boulder": 97, "Loyola Marymount University": 102,
    "University of Tennessee": 102, "Brigham Young University": 110,
    "Chapman": 110, "University of San Diego": 110,
    "Arizona State University": 117, "San Diego State University": 117,
    "University of Oregon": 117, "University of Arizona": 127,
    "UMBC": 127, "University of Utah": 134,
    "Colorado State University": 151, "Seattle University": 151,
    "University of Hawai'i": 192, "Washington State University": 192,
    "Grand Valley State University": 242, "Northern Arizona University": 242,
    "Pace": 273, "Montana State University": 318,
    "Stanbridge University": 400,
}

LAC_RANK = {
    "US Naval Academy": 3, "Bowdoin College": 5,
    "Claremont McKenna": 7, "Pomona College": 7,
    "Harvey Mudd College": 10, "Smith College": 13,
    "Wesleyan": 13, "Denison": 34, "Scripps College": 37,
    "Oberlin College": 58,
}

REG_RANK = {
    "Cal Poly SLO": 1, "Rhode Island School of Design": 3,
    "Embry-Riddle Aeronautical University": 4, "San Jose State University": 4,
    "Cal Poly Pomona": 5, "Parsons School of Design": 7,
    "Saint Mary's College": 7, "CSU Long Beach": 8,
    "California Institute of the Arts": 28,
}

INTL = {
    "American University of Paris", "RCSI University of Medicine and Health Sciences",
    "University of Bath", "University of Edinburgh", "University of Hong Kong",
    "University of Toronto", "University of Victoria",
}

CC = {"Mira Costa College", "San Diego Mesa College"}

OTHER = {"Startup Business"}

# ── Group ───────────────────────────────────────────────────────────────
schools: dict[str, list[dict]] = defaultdict(list)
for r in data:
    schools[r["university"]].append(r)

all_cats = set(NAT_RANK) | set(LAC_RANK) | set(REG_RANK) | INTL | CC | OTHER
uncategorized = {u for u in schools if u not in all_cats}
if uncategorized:
    print(f"WARNING uncategorized: {uncategorized}", file=sys.stderr)


# ── Helpers ─────────────────────────────────────────────────────────────
def fmt_name(r: dict) -> str:
    name = r["name"]
    major = r.get("major", "")
    if major:
        return f"{name} — {major}"
    return name


def render(title: str, rank_map: dict, show_rank: bool = True) -> list[str]:
    lines = [f"\n## {title}\n"]
    if show_rank:
        lines.append("| # | School | Rank | Count | Students |")
        lines.append("|--:|--------|-----:|:-----:|----------|")
    else:
        lines.append("| # | School | Count | Students |")
        lines.append("|--:|--------|:-----:|----------|")

    entries = []
    for uni in rank_map:
        if uni in schools:
            entries.append((rank_map[uni], uni, schools[uni]))
    entries.sort(key=lambda x: (x[0], x[1]))

    for i, (rank, uni, students) in enumerate(entries, 1):
        names = sorted(students, key=lambda r: r["name"].lower())
        name_str = ", ".join(fmt_name(r) for r in names)
        if show_rank:
            lines.append(f"| {i} | {uni} | {rank} | {len(students)} | {name_str} |")
        else:
            lines.append(f"| {i} | {uni} | {len(students)} | {name_str} |")
    return lines


# ── Build markdown ──────────────────────────────────────────────────────
md: list[str] = []
md.append("# CCA Class of 2026 — College Decisions (Merged)")
md.append(
    f"*Ranked by US News 2026 Best Colleges. {len(data)} students, {len(schools)} schools.*\n"
)
md.append(
    "Sources: [@ccadecisions2026](https://www.instagram.com/ccadecisions2026/) "
    "Instagram + CCA yearbook college map.\n"
)
both_n = sum(1 for r in data if r["source"] == "both")
ig_n = sum(1 for r in data if r["source"] == "instagram")
yb_n = sum(1 for r in data if r["source"] == "yearbook")
md.append(f"- **both** sources: {both_n}")
md.append(f"- **instagram** only: {ig_n}")
md.append(f"- **yearbook** only: {yb_n}")

md.extend(render("National Universities", NAT_RANK))
md.extend(render("National Liberal Arts Colleges", LAC_RANK))
md.extend(render("Regional / Specialty", REG_RANK))

intl_sorted = sorted(s for s in INTL if s in schools)
md.extend(render("International", {u: i for i, u in enumerate(intl_sorted, 1)}, show_rank=False))

cc_sorted = sorted(s for s in CC if s in schools)
md.extend(render("Community Colleges", {u: i for i, u in enumerate(cc_sorted, 1)}, show_rank=False))

other_sorted = sorted(s for s in OTHER if s in schools)
if other_sorted:
    md.extend(render("Other", {u: i for i, u in enumerate(other_sorted, 1)}, show_rank=False))

md.append("\n---")
md.append(
    f"*Generated from {len(data)} merged entries (Instagram + yearbook). "
    f"Rankings: US News & World Report 2026.*"
)

out = ROOT / "cca-2026-college-decisions-ranked.md"
out.write_text("\n".join(md))
print(f"Wrote {out} ({len(schools)} schools, {len(data)} students)")

# category stats
for label, cat_set in [("National", NAT_RANK), ("LAC", LAC_RANK), ("Regional", REG_RANK)]:
    n_sch = sum(1 for u in cat_set if u in schools)
    n_stu = sum(len(schools[u]) for u in cat_set if u in schools)
    print(f"  {label}: {n_sch} schools, {n_stu} students")
