# Where my secrets live

This file lists locations only. NEVER put a secret value here or anywhere else in this repo; the pre-commit hook blocks commits that look like they contain one.

| Secret | Where it lives | How to load it |
|---|---|---|
| GitHub auth | `gh` CLI token in macOS Keychain | `gh auth token` |

## Adding a new secret
1. Prefer Keychain. Run it yourself, never through the chat: `security add-generic-password -a "$USER" -s <service-name> -w` (it prompts for the value).
2. Load it at runtime: `security find-generic-password -a "$USER" -s <service-name> -w`.
3. Add a row above with the service name, not the value.
