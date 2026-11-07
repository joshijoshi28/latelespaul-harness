---
description: Save this session's findings and reusable knowledge to the profile now
---

Record what this session has produced so far in the `knowledge/` folder of my profile (the profile path is under "Paths" in my global CLAUDE.md, or `PROFILE_DIR` in the harness's `harness.env`):

1. Append an entry to `knowledge/sessions/<YYYY-MM>.md` (create it with a `# Sessions <YYYY-MM>` heading if missing):
   `## <YYYY-MM-DD HH:MM> · <working folder> · <title, max 8 words>` followed by 1-5 short bullets of what was done, decided or discovered.
2. If there is reusable, non-obvious knowledge (gotchas, commands, how things work), append 0-3 bullets to `knowledge/learnings.md`, each ending with ` _(<YYYY-MM-DD>)_`. Skip anything already there.
3. If something is really a preference about how I want you to work, put it in memory or ABOUT.md instead.
4. Never write secret values. Then run the harness's `scripts/sync.sh`.

$ARGUMENTS
