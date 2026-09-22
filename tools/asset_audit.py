#!/usr/bin/env python3
import json, pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
BAD = {
    "art/actual/final_deduction.jpg",
    "art/actual/investigation_desk.jpg",
    "art/actual/character_atlas.jpg",
    "art/actual/season2_teaser.jpg",
    "art/actual/optimized/manhwa_main.jpg",
    "art/actual/optimized/generated_story_ui_board.jpg",
    "art/actual/optimized/coffee_receipt.jpg",
    "art/actual/optimized/case01_suspect_keyart.jpg",
}
errors=[]

def check_ref(ref, source):
    if not isinstance(ref,str) or not ref.startswith("res://"):
        return
    rel=ref[6:]
    if rel in BAD:
        errors.append(f"{source}: references known-bad asset {ref}")
    if not (ROOT/rel).exists():
        errors.append(f"{source}: missing asset {ref}")

for p in sorted((ROOT/"data").glob("case_*.json")):
    data=json.loads(p.read_text())
    def walk(x):
        if isinstance(x,dict):
            for v in x.values(): walk(v)
        elif isinstance(x,list):
            for v in x: walk(v)
        elif isinstance(x,str):
            check_ref(x,p.name)
    walk(data)

main=(ROOT/"scripts/main.gd").read_text()
for ref in re.findall(r'res://art/[^"\s]+', main):
    check_ref(ref,"scripts/main.gd")

if errors:
    print("\n".join(errors))
    sys.exit(1)
print("ASSET AUDIT PASSED")
