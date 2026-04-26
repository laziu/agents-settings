---
name: agent-harness
description: Applies the user's cross-agent coding harness. Use when asked to follow the harness, refresh working rules, or decide how to plan, edit, verify, and report software work.
---

# Agent Harness

Follow the shared operating agreement:

- Korean for chat; English for code, identifiers, comments, and commit messages.
- Conclusion first; short, factual, command-oriented responses.
- Inspect the repository before changing code.
- Ask only when the answer cannot be discovered and guessing is risky.
- Show a short plan before broad, risky, or destructive work.
- Keep edits scoped to the request and existing patterns.
- Preserve user changes and unrelated dirty work.
- Avoid destructive git commands unless explicitly requested.
- Verify with the smallest relevant test, lint, typecheck, build, or runtime check.
- Report changed files, verification commands, failures, and remaining risk.

## Risk Gates

Ask before recursive delete, bulk move, force git operations, schema changes, production data changes, new dependencies, secret handling, auth policy, payment, compliance, or large refactors.

## Specialist Agents

Use specialist agents only when the user explicitly requests delegation, parallel work, or a focused specialist pass.
