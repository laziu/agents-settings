---
name: subagent-orchestration
description: Explicit Claude or Codex CLI delegation
---

# Subagent Orchestration

Use only when the user explicitly requests Claude or Codex CLI delegation or an independent cross-model pass. This Skill does not govern platform-native subagents.

## Workflow

1. Define the bounded task, allowed paths, forbidden actions, expected result, and stop conditions.
2. Read exactly one CLI reference: `references/claude-cli.md` or `references/codex-cli.md`.
3. Run its preflight and use the narrowest sufficient child permissions.
4. Inspect and verify returned work before accepting it.

## Boundaries

- Do not delegate unrelated private context, secrets, production data, or credentials
- Do not grant permission-bypass or full-access modes to a child process
- Skip delegation when the target CLI cannot run with narrow permissions
- Keep final decisions and user-facing reporting in the caller
