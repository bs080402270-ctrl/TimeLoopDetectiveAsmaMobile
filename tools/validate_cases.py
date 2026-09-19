#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
case_files = sorted((ROOT / "data").glob("case_*.json"))
required_case = {"id","title","subtitle","start_location","max_actions","locations","suspects","clues","timeline","culprit","strong_clues","required_contradiction","truth"}
errors = []

for path in case_files:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"{path.name}: invalid JSON: {exc}")
        continue
    missing = required_case - set(data)
    if missing:
        errors.append(f"{path.name}: missing keys {sorted(missing)}")
        continue
    if data["start_location"] not in data["locations"]:
        errors.append(f"{path.name}: start_location not found")
    if data["culprit"] not in data["suspects"]:
        errors.append(f"{path.name}: culprit not found in suspects")
    for loc_id, loc in data["locations"].items():
        art = str(loc.get("art","")).replace("res://","")
        if art and not (ROOT / art).exists():
            errors.append(f"{path.name}: missing location art {art}")
        for person in loc.get("people",[]):
            if person not in data["suspects"]:
                errors.append(f"{path.name}: location {loc_id} references unknown suspect {person}")
    for sid, suspect in data["suspects"].items():
        art = str(suspect.get("art","")).replace("res://","")
        if art and not (ROOT / art).exists():
            errors.append(f"{path.name}: missing suspect art {art}")
        rule = suspect.get("contradiction",{})
        for clue in rule.get("needs",[]):
            if clue not in data["clues"]:
                errors.append(f"{path.name}: suspect {sid} contradiction references unknown clue {clue}")
    for clue_id, clue in data["clues"].items():
        if clue.get("location") not in data["locations"]:
            errors.append(f"{path.name}: clue {clue_id} has unknown location")
        art = str(clue.get("art","")).replace("res://","")
        if art and not (ROOT / art).exists():
            errors.append(f"{path.name}: missing clue art {art}")
    for clue in data["strong_clues"]:
        if clue not in data["clues"]:
            errors.append(f"{path.name}: strong_clues references unknown clue {clue}")
    if data["required_contradiction"]:
        ids = {s.get("contradiction",{}).get("id","") for s in data["suspects"].values()}
        if data["required_contradiction"] not in ids:
            errors.append(f"{path.name}: required contradiction is not defined")

if len(case_files) != 5:
    errors.append(f"Expected 5 case files, found {len(case_files)}")

if errors:
    print("\n".join("ERROR: " + e for e in errors))
    raise SystemExit(1)

print(f"Validated {len(case_files)} cases successfully.")
