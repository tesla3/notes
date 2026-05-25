#!/usr/bin/env python3
"""
TBS class of 2026 decisions by school, ranked by US News 2026 Best Graduate
Engineering Schools — the single most authoritative engineering school ranking.

Source: US News 2026 Best Graduate Engineering Schools
        (via VnExpress, US News slideshow, GT/Penn State press releases)
        Top 31 verified. Full list is paywalled.
"""

import re
from collections import defaultdict

# US News 2026 Best Graduate Engineering Schools — verified top 31
# Ties share a rank; next rank skips appropriately
USN_GRAD_ENG = {
    # 1. MIT (not TBS)
    "Stanford": 2,
    "UC Berkeley": 3,
    # 4. Georgia Tech (tie), Purdue (tie)
    "Purdue University": 4,
    "Caltech": 6,            # (tie)
    "University of Illinois": 6,  # UIUC (tie)
    # 6. UT Austin (tie) — not TBS
    "UC San Diego": 9,
    "Carnegie Mellon": 10,
    "Cornell University": 11,
    "University of Michigan": 12,
    "Johns Hopkins": 13,
    # 14. Texas A&M (tie) — not TBS
    "UCLA": 14,              # (tie)
    "Northwestern University": 16, # (tie)
    "UPenn": 16,              # (tie)
    "Columbia": 18,           # (tie)
    "CU Boulder": 18,        # (tie)
    # 18. Maryland (tie) — not TBS
    "USC": 21,
    "Duke": 22,               # (tie)
    "Harvard": 22,            # (tie)
    # 22. UW (tie) — not TBS
    # 25. Princeton (tie), Rice (tie) — not TBS
    # 27. Wisconsin — not TBS
    # 28. NC State (tie), Ohio State (tie) — not TBS
    "Penn State": 28,         # (tie)
    "UCSB": 28,               # (tie)
}

# Additional verified data from school press releases / known positions
# (These schools have ABET-accredited engineering but aren't in the verified top 31)
# Marked with approximate range from prior-year USN data + known positions
# We'll place them as "31+" to be honest
KNOWN_HAS_ENGINEERING = {
    "Brown University", "Dartmouth College", "Yale",
    "NYU", "Northeastern University", "Tufts University",
    "Rutgers University", "University of Florida", "UC Irvine",
    "UC Riverside", "University of Utah", "University of Tennessee Knoxville",
    "University of Alabama", "Lehigh University", "WashU (St. Louis)",
    "Wake Forest University", "George Washington University",
    "University of Miami", "University of Hawaii at Manoa",
    "University of Rochester", "Santa Clara University", "BYU",
    "University of Toronto",  # International
    "Cal Poly SLO",  # Non-doctorate (separate US News list: #1-2)
}

NO_ENGINEERING = {
    "UChicago",       # No engineering school
    "Boston College",  # No engineering school
    "Emory University", # No engineering school
    "Georgetown University", # No engineering school
    "Babson College",  # Business specialty
    "Chapman University", # No ABET-accredited engineering
    "Tulane University", # No traditional engineering school
    "TCU",             # No ABET-accredited engineering
    # LACs
    "Williams College", "Claremont McKenna College", "Davidson College",
    "Grinnell College", "Scripps College", "Occidental College",
}

# ── Parse the markdown table ──
with open("tbs-class-2026-decisions.md") as f:
    text = f.read()

rows = re.findall(r"^\|\s*\d+\S*\s*\|(.+)$", text, re.MULTILINE)

entries = []
for row in rows:
    cols = [c.strip() for c in row.split("|")]
    if len(cols) < 4:
        continue
    entries.append({
        "student": cols[0],
        "university": cols[1],
        "major": cols[2],
        "date": cols[3],
        "notes": cols[4] if len(cols) > 4 else "",
    })

diego = re.search(r"^\|\s*—\s*\|(.+)$", text, re.MULTILINE)
if diego:
    cols = [c.strip() for c in diego.group(1).split("|")]
    entries.append({
        "student": cols[0], "university": cols[1],
        "major": cols[2], "date": cols[3],
        "notes": cols[4] if len(cols) > 4 else "",
    })

NORMALIZE = {"Duke University": "Duke", "Tufts University (SMFA)": "Tufts University"}
for e in entries:
    e["university"] = NORMALIZE.get(e["university"], e["university"])

superseded = {(e["student"], e["university"]) for e in entries if "superseded" in e["notes"].lower()}
final_entries = [e for e in entries if (e["student"], e["university"]) not in superseded]

school_data = defaultdict(list)
for e in final_entries:
    school_data[e["university"]].append(e)

# ── Classify ──
top31 = []
has_eng_unranked = []
no_eng = []

for school, students in school_data.items():
    if school in USN_GRAD_ENG:
        top31.append((USN_GRAD_ENG[school], school, students))
    elif school in KNOWN_HAS_ENGINEERING:
        has_eng_unranked.append((school, students))
    else:
        no_eng.append((school, students))

top31.sort(key=lambda x: (x[0], x[1]))
has_eng_unranked.sort(key=lambda x: x[0])
no_eng.sort(key=lambda x: x[0])

# ── Print ──
print("## TBS Class of 2026 — Decisions by School")
print("### Ranked by US News 2026 Best Engineering Schools\n")
print("Single source: **US News 2026 Best Graduate Engineering Schools**")
print("(peer assessment + research + selectivity + faculty resources)")
print("Verified top 31 from public data. Full list is paywalled.\n")

print("#### Tier 1: Schools in the US News Top 31\n")
print(f"| Rank | School | # | Students |")
print(f"| ---: | ------ | -: | -------- |")

t1_total = 0
for rank, school, students in top31:
    names = sorted(s["student"] for s in students)
    t1_total += len(names)
    print(f"| {rank} | {school} | {len(names)} | {', '.join(names)} |")

print(f"\n**{t1_total} students → {len(top31)} schools (US News Top 31)**\n")

print("#### Tier 2: Has Engineering School, Beyond Top 31\n")
print("These schools have ABET-accredited engineering programs but fall outside")
print("the verified US News top 31. Paywalled ranks are not estimated.\n")
print(f"| School | # | Students | Note |")
print(f"| ------ | -: | -------- | ---- |")

t2_total = 0
for school, students in has_eng_unranked:
    names = sorted(s["student"] for s in students)
    t2_total += len(names)
    note = ""
    if school == "Cal Poly SLO":
        note = "US News #1–2 non-doctorate eng"
    elif school == "University of Toronto":
        note = "International (QS Global Top 25 eng)"
    elif school == "Yale":
        note = "SEAS est. 2017; small but growing"
    elif school == "Dartmouth College":
        note = "Thayer School — oldest US eng school"
    elif school == "Brown University":
        note = "School of Engineering est. 2010"
    print(f"| {school} | {len(names)} | {', '.join(names)} | {note} |")

print(f"\n**{t2_total} students → {len(has_eng_unranked)} schools**\n")

print("#### Tier 3: No Engineering School\n")
print(f"| School | # | Students |")
print(f"| ------ | -: | -------- |")

t3_total = 0
for school, students in no_eng:
    names = sorted(s["student"] for s in students)
    t3_total += len(names)
    print(f"| {school} | {len(names)} | {', '.join(names)} |")

print(f"\n**{t3_total} students → {len(no_eng)} schools**\n")
print(f"---\n**Grand Total: {t1_total + t2_total + t3_total} students → "
      f"{len(top31) + len(has_eng_unranked) + len(no_eng)} schools**")
