---
name: source-check
description: Verify implementation decisions with official docs
---

# Source-Driven Development

Do not implement framework-specific patterns from memory when correctness depends on current APIs.

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

## Citation Rules
- Full URLs; deep links preferred
- Quote/paraphrase only the relevant rule
- Cite browser/runtime support for platform features
- Mark unverified patterns explicitly
- Surface docs/code conflicts and official-source discrepancies
- Ask before choosing version-specific APIs when version is missing/ambiguous

## Verification
- Versions identified
- Official docs fetched
- Code follows current docs
- Deprecated APIs avoided
- Conflicts surfaced
- Unverified decisions marked
