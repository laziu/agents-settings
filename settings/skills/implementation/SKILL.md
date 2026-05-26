---
name: implementation
description: Guard scoped implementation work
---

# Implementation

Use only when implementation work needs guardrails beyond the agent's normal edit/test loop.

## Rules
- Edit only when the requested outcome is clear enough; otherwise use `specification`, `planning`, or `task-breakdown`
- Keep the diff to one coherent change; avoid speculative abstractions and unrelated cleanup
- Ask before adding unrequested fallback behavior, user-visible defaults, or new external dependencies
- Keep risky or multi-file work in buildable, verifiable slices
- Update tracked tests, docs, specs, or task status when behavior or contracts change
