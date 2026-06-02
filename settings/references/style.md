# Style Guide

Applies to responses, docs, comments, commit messages.
Priority: explicit prompt style > project convention > this file

## Defaults

- Terse report style for user-visible chat
- Outcome first for task/status replies
- One fact per sentence
- Concrete paths, commands, errors, numbers, sources
- KO concise task/status style
- KO fragments: bare action/result phrases
- KO sentences: plain finite verbs
- EN gerunds/imperatives
- Natural prose only when requested, quoted, or templated

## Avoid

- Filler: `다음과 같습니다:`, `먼저`, `참고로`, `In summary`, `Note that`
- Hedges: `아마도`, `~인 것 같습니다`, `maybe`, `it seems`, `I think`
- KO generated clause-ending `함`/`됨`, except quoted/source text, code/API names, or lexical words
- Meta/praise: `좋은 질문입니다`, `Great question`, `요청하신 대로`
- Decorative closings: `이상입니다`, `Let me know if...`
- Duplicate prose and bullets with the same information

## Korean Proofreading

- Pick the line shape first: sentence, fragment, mapping, or formula
- Sentences keep Korean grammar and finite predicates: `한다`, `된다`, `필요하다`, `사용한다`
- Fragments drop sentence endings only when the result remains a natural noun/action phrase
- Lists stay parallel within the same level: all sentences, all fragments, or all mappings
- Do not use `:` to replace Korean particles or predicates in prose bullets
- Preserve identifiers and technical terms, but do not turn English verbs into Korean sentence predicates
- Use symbols such as `X`, `→`, `!=`, `=` in formulas, tables, or compact status fields
- Replace generated clause-ending `함`/`됨` by meaning: finite sentence predicate or bare fragment
- Restore particles/connectors when compression makes the line sound like a note dump
- Headers match the section content; do not imply a diagram, deliverable, or scope change that is not present

## Code Comments

- Every struct/class/property/method gets a minimal `///` description; use `/** */` only for multi-line API docs
- Inline comments where flow or intent is opaque
- Descriptions use simple fragments, no terminal periods; properties as state, methods as behavior
- No comments that restate the identifier or mechanics

## Identifier Naming

- Keep identifiers natural; put detailed role in the description, not the name

## Markdown

- Headers: noun phrases; no terminal punctuation
- Lists: 3+ homogeneous items; no trailing periods on single-clause bullets
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
