# Firstmate module: setup steps for the agent

[Firstmate](https://github.com/kunchenguid/firstmate) is an agent distro: you talk to one agent (the first mate) and it runs a crew of agents, each in its own git worktree, and hands back PRs or reports. With this module on, everyday sessions delegate code work to it through its inbox (`bin/fm-inbox.sh note`) instead of doing it themselves.

```
 this session --fm-inbox note--> firstmate (tmux "firstmate") --spawns--> crewmates (worktrees) --> PRs / reports
      ^                                   |
      +---------- fm-inbox status --------+          approvals: the user, in firstmate's own session
```

`H` = HARNESS_DIR. Ask before cloning, installing or starting anything.

1. **Prerequisites.** Firstmate needs tmux and an authenticated GitHub CLI.
   Verify: `command -v tmux && gh auth status`
2. **Upstream or fork.** Ask whether they want upstream (default) or their own fork. For a fork: `gh repo fork kunchenguid/firstmate --clone=false` (ask first: it creates a repo), then `H/install.sh --env-only FIRSTMATE_REPO=https://github.com/<user>/firstmate.git FIRSTMATE_UPSTREAM=https://github.com/kunchenguid/firstmate.git`.
   Verify: `grep FIRSTMATE_ H/harness.env`
3. **Own Telegram bot (optional).** If the telegram module is on and they want to approve firstmate from the phone, firstmate can have a second bot: do the telegram SETUP steps 3-4 for it with the state folder `~/.claude/channels/telegram-firstmate` instead, and set `FIRSTMATE_TELEGRAM=1`. Otherwise approvals go through Claude Remote Control (`/remote-control` in the session, then the Claude app).
4. **Install.** `H/modules/firstmate/install.sh` (the main `install.sh` runs it when `firstmate` is in MODULES). It clones into `FIRSTMATE_DIR` if missing and writes the `firstmate` skill into `~/.claude/skills/firstmate/`.
   Verify: `test -x $FIRSTMATE_DIR/bin/fm-inbox.sh && test -f ~/.claude/skills/firstmate/SKILL.md && echo ok`
5. **Start it.** `H/modules/firstmate/install.sh --start` starts the tmux session. It does not survive a reboot; start it again after one.
   Verify: `H/modules/firstmate/install.sh --status`
6. **First run (needs the user).** Firstmate checks its own toolchain on the first start and asks the user before installing anything, plus Claude's one-time "trust this folder" prompt. Tell them: run `! tmux attach -t firstmate`, answer the prompts there, then detach with Ctrl-B then D. Never answer firstmate's prompts for them.
7. **Test a delegation.** With the user's OK, send a harmless note: `$FIRSTMATE_DIR/bin/fm-inbox.sh note --request-id setup-test - <<<"Setup test from the harness: reply that you received this; no work needed."`
   Verify: exit code 0, then `$FIRSTMATE_DIR/bin/fm-inbox.sh receipts` shows it picked up.
