---
name: implementation
description: Implement scoped changes with verification
---

# Implementation

Implement the requested change with the smallest coherent diff.

Start after `planning` or when requirements are clear enough to edit. Use when the user asks to add, change, refactor, wire, migrate, fix, or otherwise edit project source.

## Skip When
- Spec-only, plan-only, review-only, or explanation-only work
- Requirements are outcome-changing and still ambiguous

## Before Editing
- Inspect relevant files and local patterns
- Identify scope, dependencies, and verification path
- Ask only when ambiguity affects outcome
- Load domain or workflow skills when their triggers apply

## Cycle
1. Make one coherent change
2. Keep unrelated cleanup separate
3. Test targeted behavior
4. Verify build/type/lint/runtime as relevant
5. Repeat in slices when risk or size requires it

## Slicing
- Obvious single edit: one pass
- Multi-file, risky, staged, or dependency-ordered work: thin verified slices
- Shared contract change: define interface/types first
- Uncertain part: prove early
- Incomplete user-visible work: feature flag or safe default

## Rules
- Simplicity first; avoid speculative abstractions
- Preserve unrelated dirty work
- Keep the project buildable between slices
- Separate deletes from replacements when useful
- Update tests, docs, or task status when behavior, contracts, or tracked plans change
- Report out-of-scope issues separately

## Verification
- Changed files reviewed
- Each slice tested when sliced
- Full relevant checks pass at the end
- Feature works end-to-end when applicable
- No unrelated changes or large unverified pile
