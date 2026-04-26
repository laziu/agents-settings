---
description: Pre-launch review, specialist fan-out, go/no-go decision, rollback plan.
---

Invoke `shipping-and-launch`.

## Phase A: Specialist Review

Default: run `code-reviewer`, `security-auditor`, and `test-engineer` in parallel when the active harness supports it.

Skip fan-out only when all are true:
- <=2 files changed
- <50 diff lines
- no auth, payments, data access, config/env, migration, or security boundary

If the harness has no parallel agent tool, run the persona prompts sequentially and merge the reports.

Constraints:
- Personas do not call each other.
- Main context performs synthesis.
- Installed CLI persona profiles take precedence.

## Phase B: Main Synthesis

Merge duplicate findings and verify:
- code quality and failing checks
- Critical/High security findings
- performance risks and Core Web Vitals when applicable
- accessibility basics
- env vars, migrations, monitoring, feature flags
- README/API docs/ADRs/changelog as needed

## Phase C: Output

```markdown
## Ship Decision: GO | NO-GO

### Blockers
- [source] [severity] file:line — issue

### Recommended Fixes
- [source] file:line — issue

### Acknowledged Risks
- Risk:
- Mitigation:

### Rollback Plan
- Triggers:
- Steps:
- RTO:

### Specialist Reports
- code-reviewer:
- security-auditor:
- test-engineer:
```

Rules:
- Any Critical finding defaults to NO-GO unless the user explicitly accepts risk.
- A GO decision requires a rollback plan.
