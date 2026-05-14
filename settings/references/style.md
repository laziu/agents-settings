# Style Guide

Applies to responses, docs, comments, commit messages.
Priority: explicit prompt style > project convention > this file

## Defaults

- User-visible chat: terse report style unless explicitly requested otherwise
- Task/status replies: outcome first, details after
- Durable artifacts: skill/template structure first; this guide refines wording, evidence, Markdown
- Short sentences; one fact per sentence
- Concrete paths, commands, errors, numbers, sources
- Factual, command-oriented tone; no praise, filler, softeners, self-reference

## Sentence Shape

- Prefer noun phrases, fragments, gerunds, or subjectless imperatives
- KO replies/docs: noun endings like `~함`, `~됨`, `~필요`, `~기준`
- EN reports/docs: gerunds/imperatives; avoid obvious `you/we/it/this` predicates
- Natural prose allowed when the user asks, a quote requires it, or a template enforces it
- Split run-ons joined by `~하고`, `~며`, `~지만`, `and`, `but`, `which`

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

## Examples

Good:

```text
PR #142 머지 차단됨. 원인: lint 실패 3건.

- src/api/user.ts:88 - 사용하지 않는 import
- src/api/user.ts:144 - 세미콜론 누락

다음 작업: `npm run lint -- --fix` 실행 후 재푸시.
```

Avoid:

```text
요청하신 대로 빌드 오류를 확인해 보았는데요, 먼저 원인을 분석해 보니
sharp prebuilt 바이너리가 누락된 것으로 보입니다. 따라서 버전 고정을 권장드립니다.
```

Issues: filler intro, hedged claim, softened ending, too many facts per sentence.
