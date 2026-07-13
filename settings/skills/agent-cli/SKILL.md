---
name: agent-cli
description: Invoke Claude or Codex CLI subagents with bounded permissions
---

# Agent CLI

Provide the mechanics for invoking another AI Agent through its CLI.

## Invocation

1. Read exactly one target reference: `references/claude-cli.md` or `references/codex-cli.md`.
2. Run the documented version preflight.
3. Package the task, working root, allowed paths and tools, forbidden actions, expected result, and stop conditions.
4. Select the narrowest permission preset that can perform the requested task.
5. Invoke the CLI, consume progress or final output, and inspect any filesystem effects.
6. Verify returned claims and changes before using them.

## Boundaries

- Do not pass unrelated private context, secrets, credentials, or production data
- Do not use permission-bypass or unrestricted child modes
- Keep child write roots no broader than the requested task
- Preserve the caller's responsibility for final decisions and user-visible output
