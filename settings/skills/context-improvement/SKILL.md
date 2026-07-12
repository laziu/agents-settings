---
name: context-improvement
description: Explicit or repeated agent context behavior fixes
---

# Context Improvement

Use for explicit context-update requests or repeated high-impact agent failures. Use `context-engineering` for edit hygiene.

## Target

| Change | Owner |
| --- | --- |
| User-wide behavior or hard boundary | Profile `AGENTS.md` or `CLAUDE.md` |
| Repo-local agent command, structure, convention, or boundary | Project `AGENTS.md` or `CLAUDE.md` |
| Project fact or durable product knowledge | README, spec, or Plan |
| Reusable conditional workflow or domain guardrail | Affected Skill |
| Repeated deterministic operation | Skill script, hook, CI, or test |
| Trigger mismatch | Skill `description`; use `../../references/skill-routing.md` only for cross-Skill ordering |

## Gate

- A direct context-update request approves that scope
- For inferred changes, propose the observed repeated failure, target, behavior change, and verification before editing
- Do not create durable rules from speculative preferences or one-off low-impact mistakes

## Verification

- Validate changed metadata and references
- Confirm the new rule is not already owned elsewhere
