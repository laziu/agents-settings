---
name: context-improvement
description: Approved or repeated agent context fixes
---

# Context Improvement

Use when repeated friction or an explicit request suggests agent context should change. Use `context-engineering` for edit hygiene.

## Signals
- Repeated workflow friction, user correction, costly recovered failure, missed verification, wrong Skill routing, or explicit context-update request
- Ignore one-off low-impact mistakes
- Prefer the current conversation as evidence; create durable logs only when the user asks for tracking

## Target

| Signal | Target |
| --- | --- |
| User-wide agent behavior, hard boundary, or install-owned rule | `settings/AGENTS.md` or user `AGENTS.md` |
| Project-only facts, commands, structure, or conventions | Project `AGENTS.md`, README, specs, plans, or references |
| Conditional workflow, domain guardrail, or non-obvious verification | `settings/skills/<skill>/SKILL.md` |
| Longer examples, checklists, schemas, or decision references | `settings/skills/<skill>/references/*` or project references |
| Repeated deterministic operation | `settings/skills/<skill>/scripts/*` |
| Skill trigger mismatch | Affected skill `description` first; `settings/references/skill-routing.md` only for cross-skill relationships |

## Gate
- For inferred updates, propose observation, target, behavior change, non-inferable reason, and verification
- On approval, edit immediately unless a higher-priority risk gate applies
- Treat direct context-update requests as approval for that scope
- No silent edits from speculative preference or low-impact one-off failure

## Verification
- Validate changed Skills when practical
