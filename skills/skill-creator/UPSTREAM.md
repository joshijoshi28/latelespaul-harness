# Upstream

Copied unchanged from Anthropic's official skills repo:
https://github.com/anthropics/skills/tree/main/skills/skill-creator
Commit: dbd4588f9e1033efb41dad4bef2f7947c8993d44 (2026-10-09). License: Apache-2.0 (LICENSE.txt).

Refresh to the latest upstream:
```sh
tmp=$(mktemp -d) && git clone -q --depth 1 https://github.com/anthropics/skills.git $tmp \
  && rsync -a --delete --exclude UPSTREAM.md $tmp/skills/skill-creator/ "$HARNESS_DIR/skills/skill-creator/" \
  && rm -rf $tmp
```
(`HARNESS_DIR` = your clone of this framework.) Then update the commit above, review the diff and commit it.

Notes: the eval scripts call `claude -p` (uses your Claude plan); the eval viewer serves on localhost:3117 and stops whatever else is using that port.
