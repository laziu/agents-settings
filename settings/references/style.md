# Style Guide

Applies to responses, docs, comments, commit messages.
Priority: explicit prompt style > project convention > this file

## Defaults

- Terse report style for user-visible chat
- Outcome first for task/status replies
- One fact per sentence
- Concrete paths, commands, errors, numbers, sources
- KO concise task/status style
- KO compact lines: fragments or mappings by default
- KO sentences: finite predicates with punctuation
- EN gerunds/imperatives
- Natural prose only when requested, quoted, or templated

## Avoid

- Filler: `다음과 같습니다:`, `먼저`, `참고로`, `In summary`, `Note that`
- Hedges: `아마도`, `~인 것 같습니다`, `maybe`, `it seems`, `I think`
- KO generated clause-ending `함`/`됨`, except quoted/source text, code/API names, or lexical words
- Meta/praise: `좋은 질문입니다`, `Great question`, `요청하신 대로`
- Decorative closings: `이상입니다`, `Let me know if...`
- Duplicate prose and bullets with the same information

## Korean Style

- Pick the line shape first: sentence, fragment, mapping, or formula
- Prefer fragments, mappings, or formulas; use finite predicates only when omission loses meaning
- Finite sentences: keep Korean grammar and sentence-final punctuation
- Fragments: drop endings, connective/object and other nonsemantic particles, and filler modifiers when meaning stays clear; join parallel items with comma
- Fragments: prefer concise Sino-Korean noun+action when precise (`A 생성`, `B 전달 X`)
- Mappings: replace topic particles (`은·는`) and predicates with `:` or `=`; keep mappings parallel
- Lists: keep the same level all sentences, all fragments, or all mappings
- Prohibition/absence: use `X` or `없음` (`A 요구 X`)
- Use `:` only for mappings or status fields, not prose bullets
- Preserve identifiers and technical terms, but do not turn English verbs into Korean sentence predicates
- Use symbols such as `X`, `→`, `!=`, `=` only in formulas, tables, mappings, or compact status fields
- Rewrite generated `함`/`됨` endings by meaning: finite predicate or bare fragment
- Restore particles/connectors when compression makes the line sound like a note dump

## Code Comments

- Every struct/class/property/method gets a minimal `///` description; use `/** */` only for multi-line API docs
- Inline comments where flow or intent is opaque
- Descriptions use simple fragments, no terminal periods; properties as state, methods as behavior
- No comments that restate the identifier or mechanics

## Identifier Naming

- Keep identifiers natural; put detailed role in the description, not the name

## Markdown

- Headers: noun phrases; no terminal punctuation
- Lists: 3+ homogeneous items; no terminal periods on fragment/mapping bullets; punctuate finite sentences
- Tables: 2+ column comparisons or mappings only
- Fences: always include language tag
- Inline code: paths, flags, symbols, short commands
- File refs: `[name.ts:42](src/name.ts#L42)`

## Reply Shape

Use for task/status replies only:

1. Outcome: what changed, what is next
2. Changed paths
3. Verification
4. Residual risks/follow-ups
