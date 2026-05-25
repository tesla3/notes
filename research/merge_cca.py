#!/usr/bin/env python3
"""Merge CCA 2026 yearbook (CSV) + Instagram (JSON) into a single dataset.

Match strategy:
  1. Exact full-name match
  2. First-name + university match (for IG first-name-only entries)
  3. Remaining go in as yearbook-only or instagram-only

Preferences:
  - IG spellings for names (self-reported > OCR)
  - Yearbook provides full names for first-name-only IG entries
"""

import csv
import json
from pathlib import Path

ROOT = Path(__file__).parent.parent

# ── Canonical university names ──────────────────────────────────────────
CANONICAL = {
    # Instagram abbreviations
    "American U of Paris": "American University of Paris",
    "Arizona State": "Arizona State University",
    "BU": "Boston University",
    "BYU": "Brigham Young University",
    "Bowdoin": "Bowdoin College",
    "CU Boulder": "University of Colorado Boulder",
    "Cal State Long Beach": "CSU Long Beach",
    "CalArts": "California Institute of the Arts",
    "Carnegie Mellon": "Carnegie Mellon University",
    "Case Western Reserve": "Case Western Reserve University",
    "Colorado State": "Colorado State University",
    "Columbia": "Columbia University",
    "Cornell": "Cornell University",
    "Embry-Riddle": "Embry-Riddle Aeronautical University",
    "Emory": "Emory University",
    "George Washington": "George Washington University",
    "Grand Valley State": "Grand Valley State University",
    "Harvard": "Harvard University",
    "Harvey Mudd": "Harvey Mudd College",
    "Indiana": "Indiana University Bloomington",
    "Indiana University": "Indiana University Bloomington",
    "Loyola Marymount": "Loyola Marymount University",
    "Michigan": "University of Michigan",
    "Mira Costa College!": "Mira Costa College",
    "MiraCosta College": "Mira Costa College",
    "Montana State": "Montana State University",
    "NYU": "New York University",
    "Northeastern": "Northeastern University",
    "Northern Arizona": "Northern Arizona University",
    "Northwestern": "Northwestern University",
    "Notre Dame": "University of Notre Dame",
    "Oberlin 🎶": "Oberlin College",
    "Ohio State": "Ohio State University",
    "Princeton": "Princeton University",
    "Purdue": "Purdue University",
    "RCSI (Dublin)": "RCSI University of Medicine and Health Sciences",
    "RISD": "Rhode Island School of Design",
    "Rice": "Rice University",
    "Rutgers": "Rutgers University",
    "SCU": "Santa Clara University",
    "Saint Mary's College & Notre Dame": "Saint Mary's College",
    "San Diego State": "San Diego State University",
    "San Jose State": "San Jose State University",
    "Santa Clara": "Santa Clara University",
    "Scripps": "Scripps College",
    "Stanford": "Stanford University",
    "Texas A&M": "Texas A&M University",
    "Tufts": "Tufts University",
    "U of Arizona": "University of Arizona",
    "U of Bath": "University of Bath",
    "U of Hawaii": "University of Hawai'i",
    "U of Hong Kong": "University of Hong Kong",
    "U of Maryland": "University of Maryland",
    "U of Miami": "University of Miami",
    "U of Oregon": "University of Oregon",
    "U of Rochester": "University of Rochester",
    "U of San Diego": "University of San Diego",
    "U of Tennessee": "University of Tennessee",
    "U of Toronto": "University of Toronto",
    "U of Utah": "University of Utah",
    "U of Victoria": "University of Victoria",
    "UC San Diego": "UCSD",
    "UC Santa Barbara": "UCSB",
    "UChicago": "University of Chicago",
    "UIUC": "University of Illinois Urbana-Champaign",
    "UT Austin": "University of Texas at Austin",
    "UW": "University of Washington",
    "Vanderbilt": "Vanderbilt University",
    "Virginia Tech": "Virginia Tech",
    "WashU": "Washington University in St. Louis",
    "Washington State": "Washington State University",
    "College of William & Mary": "William & Mary",
    "William & Mary": "William & Mary",
    "Wisconsin": "University of Wisconsin-Madison",
    "Yale": "Yale University",
    # Yearbook variations
    "Embry-Riddle Daytona Beach": "Embry-Riddle Aeronautical University",
    "Rochester University": "University of Rochester",
    "SDSU": "San Diego State University",
    "University of Illinois": "University of Illinois Urbana-Champaign",
    "University of Texas": "University of Texas at Austin",
}

# Known yearbook OCR errors → IG self-reported spelling
YB_NAME_FIXES = {
    "anika jaetteberg": "Anika Gamburg",
    "mattan borouetsky": "Mattan Borovietzky",
    "shea salei": "Shea Salel",
    "savannah lenack": "Savannah Levack",
    "tegan innis": "Tegan Inns",
    "maya katell": "Maya Katsell",
    "chris cast": "Chris Cao",
    "audrey zhang": "Audrey Zheng",
    "alan medeiros": "Alani Medeiros",
    "ethan bernfield": "Ethan Renfield",
}

# Yearbook full names → IG first-name-only (nickname/abbreviation matches)
# These bypass the automatic first-name+university matching
YB_TO_IG_FIRST = {
    "catherine ji": "Cathy",          # UCLA
    "ebenezer chan": "Eben",           # UT Austin
    "lohan chen": "Lohen",             # Purdue
    "haikal chrisman": "HaliKai",      # Washington State
    "gabriella proto": "Gabby",        # Purdue
}


def canon(uni: str) -> str:
    return CANONICAL.get(uni, uni)


def norm(s: str) -> str:
    return s.strip().lower().replace(".", "").replace("-", " ")


def first_name(s: str) -> str:
    return norm(s).split()[0]


def is_first_only(name: str) -> bool:
    return " " not in name.strip()


# ── Load sources ────────────────────────────────────────────────────────
with open(ROOT / "research" / "cca-class-2026-decisions.json") as f:
    ig_raw = json.load(f)

with open(ROOT / "cca_2026_college_map" / "college_map.csv") as f:
    yb_raw = list(csv.DictReader(f))


def make_entry(
    name: str,
    university: str,
    major: str = "",
    date: str = "",
    tag: str = "",
    href: str = "",
    source: str = "",
    note: str = "",
) -> dict:
    d: dict = {
        "name": name,
        "university": university,
        "major": major,
        "date": date,
        "tag": tag,
        "href": href,
        "source": source,
    }
    if note:
        d["note"] = note
    return d


# ── Index IG data ───────────────────────────────────────────────────────
# Full-name IG entries indexed by normalized name
ig_fullname: dict[str, list[dict]] = {}
# First-name-only IG entries indexed by (first_name, canon_university)
ig_firstonly: dict[tuple[str, str], list[dict]] = {}

for r in ig_raw:
    r["_canon"] = canon(r["university"])
    if is_first_only(r["name"]):
        key = (norm(r["name"]), norm(r["_canon"]))
        ig_firstonly.setdefault(key, []).append(r)
    else:
        ig_fullname.setdefault(norm(r["name"]), []).append(r)

# ── Track which IG entries get matched ──────────────────────────────────
ig_matched_full: set[str] = set()  # normalized full names matched
ig_matched_first: set[int] = set()  # id() of first-only entries matched

# ── Pass 1: Match yearbook to IG by exact full name ─────────────────────
yb_matched: list[int] = []  # indices of matched yb entries

for i, yr in enumerate(yb_raw):
    yb_name = yr["Student"]
    nk = norm(yb_name)
    # Apply name fix
    if nk in YB_NAME_FIXES:
        nk = norm(YB_NAME_FIXES[nk])

    if nk in ig_fullname and nk not in ig_matched_full:
        ig_matched_full.add(nk)
        yb_matched.append(i)

# ── Pass 2: Match yearbook to first-name-only IG by first+university ────
yb_first_matched: dict[int, dict] = {}  # yb index → matched IG record

for i, yr in enumerate(yb_raw):
    if i in yb_matched:
        continue
    yb_name = yr["Student"]
    yb_uni = norm(canon(yr["College"]))
    nk_pass2 = norm(yb_name)
    fn = first_name(yb_name)

    # Check nickname/abbreviation mapping first
    if nk_pass2 in YB_TO_IG_FIRST:
        ig_first = norm(YB_TO_IG_FIRST[nk_pass2])
        key = (ig_first, yb_uni)
    else:
        key = (fn, yb_uni)

    if key in ig_firstonly:
        candidates = ig_firstonly[key]
        # Pick first unmatched candidate
        for ig_r in candidates:
            if id(ig_r) not in ig_matched_first:
                ig_matched_first.add(id(ig_r))
                yb_first_matched[i] = ig_r
                yb_matched.append(i)
                break

# ── Build merged output ─────────────────────────────────────────────────
merged: list[dict] = []

# 1) IG full-name entries
for nk, records in ig_fullname.items():
    for r in records:
        if nk in ig_matched_full:
            source = "both"
        else:
            source = "instagram"
        merged.append(
            make_entry(
                name=r["name"],
                university=r["_canon"],
                major=r.get("major", ""),
                date=r.get("date", ""),
                tag=r.get("tag", ""),
                href=r.get("href", ""),
                source=source,
            )
        )

# 2) IG first-name-only entries
for key, records in ig_firstonly.items():
    for r in records:
        if id(r) in ig_matched_first:
            # Find the yearbook entry that matched
            for yi, ig_r in yb_first_matched.items():
                if id(ig_r) == id(r):
                    yb_entry = yb_raw[yi]
                    yb_name = yb_entry["Student"]
                    nk = norm(yb_name)
                    if nk in YB_NAME_FIXES:
                        yb_name = YB_NAME_FIXES[nk]
                    merged.append(
                        make_entry(
                            name=yb_name,  # full name from yearbook
                            university=r["_canon"],
                            major=r.get("major", ""),
                            date=r.get("date", ""),
                            tag=r.get("tag", ""),
                            href=r.get("href", ""),
                            source="both",
                        )
                    )
                    break
        else:
            # Unmatched first-name-only IG entry
            merged.append(
                make_entry(
                    name=r["name"],
                    university=r["_canon"],
                    major=r.get("major", ""),
                    date=r.get("date", ""),
                    tag=r.get("tag", ""),
                    href=r.get("href", ""),
                    source="instagram",
                )
            )

# 3) Yearbook-only entries (not matched in pass 1 or 2)
yb_matched_set = set(yb_matched)
for i, yr in enumerate(yb_raw):
    if i not in yb_matched_set:
        yb_name = yr["Student"]
        nk = norm(yb_name)
        if nk in YB_NAME_FIXES:
            yb_name = YB_NAME_FIXES[nk]
        merged.append(
            make_entry(
                name=yb_name,
                university=canon(yr["College"]),
                source="yearbook",
            )
        )

# ── Remove internal fields, sort ────────────────────────────────────────
for r in merged:
    r.pop("_canon", None)

# Sort: both first, then instagram, then yearbook; alpha by name within
source_order = {"both": 0, "instagram": 1, "yearbook": 2}
merged.sort(key=lambda r: (source_order.get(r["source"], 9), r["name"].lower()))

# ── Stats ───────────────────────────────────────────────────────────────
counts = {"both": 0, "instagram": 0, "yearbook": 0}
for r in merged:
    counts[r["source"]] += 1

print(f"Total merged: {len(merged)}")
print(f"  both:           {counts['both']}")
print(f"  instagram-only: {counts['instagram']}")
print(f"  yearbook-only:  {counts['yearbook']}")
print(f"Unique universities: {len(set(r['university'] for r in merged))}")

# Sanity checks
both_with_major = sum(1 for r in merged if r["source"] == "both" and r["major"])
both_without = sum(1 for r in merged if r["source"] == "both" and not r["major"])
print(f"\n'both' entries with major: {both_with_major}")
print(f"'both' entries without major: {both_without}")

# ── Write ───────────────────────────────────────────────────────────────
out = ROOT / "research" / "cca-class-2026-merged.json"
with open(out, "w") as f:
    json.dump(merged, f, indent=2, ensure_ascii=False)
print(f"\nWrote {out}")
