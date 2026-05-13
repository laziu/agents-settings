---
name: source-check
description: Verify implementation decisions with official docs
---

# Source-Driven Development

Do not implement framework-specific patterns from memory when correctness depends on current APIs.

## Use When
- User asks for documented/verified/current implementation
- Correctness depends on current framework/library APIs
- Building reusable boilerplate or patterns
- Implementing routing, forms, data fetching, state, auth, config, or migrations
- Reviewing framework-specific code with version-sensitive behavior

## Skip When
- Pure language logic
- Renames/typos/moves
- User explicitly prioritizes speed over verification

## Process
1. Detect exact stack and versions from dependency files
2. Fetch specific official docs for the pattern
3. Implement the documented API/signature
4. Cite full URLs for non-trivial framework decisions
5. Flag anything not verified

## Source Priority
1. Official docs
2. Official blog/changelog/migration guide
3. Web standards docs: MDN, web.dev, WHATWG
4. Runtime/browser compatibility data

Do not use Stack Overflow, tutorials, random blogs, AI summaries, or memory as primary authority.

## Conflicts
- Docs vs existing code: surface the conflict and ask which to prioritize
- Official sources conflict: state discrepancy and verify against installed version
- Missing/ambiguous version: ask before choosing version-specific APIs

## Citation Rules
- Full URLs; deep links preferred
- Quote/paraphrase only the relevant rule
- Cite browser/runtime support for platform features
- Mark unverified patterns explicitly

## Red Flags
- Writing framework-specific code without checking docs/version
- "I think/believe" about API behavior
- Deprecated API used from memory
- Homepage fetched instead of relevant doc page
- No citation for non-trivial pattern

## Verification
- Versions identified
- Official docs fetched
- Code follows current docs
- Deprecated APIs avoided
- Conflicts surfaced
- Unverified decisions marked
