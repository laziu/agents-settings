---
name: incremental-implementation
description: Delivers multi-file, risky, staged, dependency-ordered, or larger changes in small verified increments.
---

# Incremental Implementation

Build thin slices. Each increment leaves the system working, tested, and reversible.

## Use When
- Multi-file change
- New feature from a plan
- Refactor
- Risk or dependency order makes one large edit hard to verify

## Skip When
Single-file, single-function, obvious-scope change.

## Cycle
1. Implement the smallest complete piece
2. Test targeted behavior
3. Verify build/type/lint/runtime as relevant
4. Commit/save the increment when requested or appropriate
5. Move to the next slice

## Slicing
- Vertical: one end-to-end user path at a time
- Contract-first: define shared API/types, then parallel backend/frontend/mock work
- Risk-first: prove the uncertain/hard part early

## Rules
- Simplicity first; avoid speculative abstractions
- Scope discipline: no adjacent cleanup unless asked
- One logical change per increment
- Keep project buildable between slices
- Feature-flag incomplete user-visible work
- Safe defaults: conservative/off unless explicitly enabled
- Rollback-friendly: additive/minimal changes; separate deletes from replacements when useful
- Update task status or docs when the project tracks them

## When You Notice Out-of-Scope Issues
Report them separately; do not fix them during the current task.

## Verification
- Each increment is tested
- Full relevant checks pass at the end
- Feature works end-to-end
- No unrelated changes
- No large unverified pile
