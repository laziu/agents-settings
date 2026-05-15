---
name: implementation
description: Implement scoped changes with verification
---

# Implementation

Implement the requested change with the smallest coherent diff.

Start after `planning` or when requirements are clear enough to edit. Skip spec-only, plan-only, review-only, explanation-only, or outcome-changing ambiguous work.

## Workflow
1. Inspect relevant files and local patterns
2. Identify scope, dependencies, and verification path
3. Ask only when ambiguity affects outcome
4. Make one coherent change; keep unrelated cleanup separate
5. Test targeted behavior and relevant build/type/lint/runtime checks
6. Repeat in slices when risk or size requires it

## Slicing
- Obvious single edit: one pass
- Multi-file, risky, staged, or dependency-ordered work: thin verified slices
- Shared contract change: define interface/types first
- Uncertain part: prove early
- Incomplete user-visible work: feature flag or safe default

## Rules
- Simplicity first; avoid speculative abstractions
- Do not add unrequested fallback behavior; propose it and ask first
- Make unexpected errors visible through errors, user feedback, or explicit logs
- Preserve unrelated dirty work
- Keep the project buildable between slices
- Update tests, docs, or task status when behavior, contracts, or tracked plans change
- Report out-of-scope issues separately

## Verification
- Changed files reviewed
- Each slice tested when sliced
- Full relevant checks pass at the end
- Feature works end-to-end when applicable
- No unrelated changes or large unverified pile
