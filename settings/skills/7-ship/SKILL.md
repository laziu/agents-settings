---
name: 7-ship
description: Wrapper workflow for explicit invocation. Use when the user calls 7-ship or wants step 7 of the agent workflow to prepare a go/no-go release decision, launch checks, and rollback plan.
---

# 7 Ship

Invoke `shipping-and-launch`.

Perform a pre-launch synthesis:
- Code quality and failing checks
- Critical/High security findings
- Performance risks and Core Web Vitals when applicable
- Accessibility basics
- Env vars, migrations, monitoring, feature flags
- README/API docs/ADRs/changelog as needed

Run specialist fan-out only when the user explicitly asks for delegation, parallel work, or a specialist pass and the active harness supports it.

Use the Ship Decision template from `skills/shipping-and-launch/SKILL.md`.
