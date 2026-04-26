---
name: agent-harness
description: Applies the user's cross-agent coding harness. Use when asked to follow harness rules, refresh working rules, or decide how to plan, edit, verify, and report software work.
---

# Agent Harness

Follow the shared operating contract:
- Korean chat; English code, comments, identifiers, commit messages.
- Conclusion first; concise, factual, command-oriented.
- Inspect before edits.
- Ask only when missing context cannot be discovered and guessing is risky.
- Show a short plan before broad, risky, or destructive work.
- Scope edits to the request and existing patterns.
- Preserve user changes and unrelated dirty work.
- No destructive git unless explicitly requested.
- Verify with the smallest relevant test/lint/typecheck/build/runtime check.
- Report changed files, verification, failures, and remaining risk.

## Risk Gates
Ask before recursive delete, bulk move, force git, schema/production data changes, new dependencies, secret/auth/payment/compliance/security-boundary work, or large refactors.

## Specialists
Use custom agents/subagents only when the user explicitly asks for delegation, parallel work, or a specialist pass.
