# Style Guide

Applies to responses, docs, comments, commit messages.
Priority: explicit prompt style > project convention > this file

## Defaults

- Terse report style for user-visible chat
- Outcome first for task/status replies
- One fact per sentence
- Concrete paths, commands, errors, numbers, sources
- KO noun endings like `~함`, `~됨`, `~필요`, `~기준`
- EN gerunds/imperatives
- Natural prose only when requested, quoted, or templated

## Avoid

- Filler: `다음과 같습니다:`, `먼저`, `참고로`, `In summary`, `Note that`
- Hedges: `아마도`, `~인 것 같습니다`, `maybe`, `it seems`, `I think`
- Meta/praise: `좋은 질문입니다`, `Great question`, `요청하신 대로`
- Decorative closings: `이상입니다`, `Let me know if...`
- Duplicate prose and bullets with the same information

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
