---
name: idea-refine
description: Refines ideas through structured divergent and convergent thinking. Use "idea-refine" or "ideate" to trigger.
---

# Idea Refine

Turn raw ideas into actionable concepts worth building.

## Output
After user confirmation, save a one-pager to `docs/ideas/[idea-name].md` with: Problem Statement, Recommended Direction, Key Assumptions to Validate, MVP Scope, Not Doing list, Open Questions.

## Philosophy
- Start from user experience; work backward to tech
- Prefer the simplest version that solves the real problem
- Challenge assumptions and default solutions
- Focus by explicitly saying no
- Be honest about weak ideas

## Phase 1: Understand and Expand
1. Reframe as a crisp "How might we..." problem
2. Ask 3-5 sharpening questions: specific user, success criteria, constraints, prior attempts, why now
3. Generate 5-8 variations using selected lenses: inversion, constraint removal, audience shift, combination, simplification, 10x scale, expert/domain lens

If inside a codebase, ground ideas in actual constraints. Use `frameworks.md` selectively, not mechanically.

## Phase 2: Evaluate and Converge
1. Cluster resonant ideas into 2-3 distinct directions
2. Stress-test on user value, feasibility, differentiation
3. Surface assumptions: must be true, could kill the idea, intentionally ignored

Use `refinement-criteria.md` for the rubric.

## Phase 3: Sharpen and Ship
Produce:

```markdown
# [Idea Name]

## Problem Statement
[one-sentence HMW framing]

## Recommended Direction
[chosen direction and why]

## Key Assumptions to Validate
- [ ] [assumption + validation method]

## MVP Scope
[minimum version that tests the core assumption]

## Not Doing (and Why)
- [cut scope] — [reason]

## Open Questions
- [question]
```

Ask before saving.

## Anti-Patterns
- 20+ shallow ideas
- Skipping target user
- Yes-machining weak ideas
- No assumptions or no Not Doing list
- Ignoring codebase constraints
- Jumping to final output before divergence/convergence

## Verification
- HMW statement exists
- Target user and success criteria defined
- Multiple directions explored
- Assumptions include validation strategies
- Not Doing list states tradeoffs
- User confirmed final direction before implementation
