#!/usr/bin/python3 -I
"""PreToolUse hook (Bash): keeps sites that belong to an extra browser out of Claude Chrome.

For each id:port in BROWSER_EXTRA, the sites listed in $PROFILE_DIR/browser/<id>-sites.txt
(one domain or text match per line, # comments allowed) are denied in any chrome-devtools-axi
command that is not aimed at that browser, with a pointer to the chrome-<id> command.
"""
import json
import os
import subprocess
import sys

try:
    cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
except Exception:
    sys.exit(0)
if "chrome-devtools-axi" not in cmd:
    sys.exit(0)   # fast path: most Bash calls end here

lib = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "..", "lib", "env.sh")
out = subprocess.run(["/bin/zsh", "-c", 'source "$1"; print -r -- "$PROFILE_DIR"; print -r -- "$BROWSER_EXTRA"',
                      "zsh", lib], capture_output=True, text=True).stdout.split("\n")
profile, extra = (out + ["", ""])[:2]

for entry in extra.split():
    bid, _, port = entry.partition(":")
    if f"SESSION={bid}" in cmd or (port and port in cmd):
        continue
    try:
        sites = [l.split("#")[0].strip().lower() for l in open(os.path.join(profile, "browser", f"{bid}-sites.txt"))]
    except OSError:
        continue
    hit = next((s for s in sites if s and s in cmd.lower()), None)
    if hit:
        print(json.dumps({"hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": f"'{hit}' belongs to the {bid} browser. Use `chrome-{bid} ...` "
                                        f"(port {port}), not Claude Chrome.",
        }}))
        sys.exit(0)
