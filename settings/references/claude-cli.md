# Claude CLI Review

Use only when the user explicitly asks for Claude review or delegation.

## Routing

Choose the cheapest sufficient pair. Escalate for ambiguity, blast radius, repeated tool/search work, or hard-to-reverse decisions.

| Case | Use |
| --- | --- |
| Smoke, connection, quick lookup | `haiku` without effort |
| Token/context optimization, narrow review, simple rewrite | `sonnet --effort medium` |
| Complex or correctness-sensitive review | `sonnet --effort high` |
| Bounded plan, architecture, unclear decision | `opus --effort high` |
| Exploratory planning, agentic coding, repeated tool/search work | `opus --effort xhigh` |
| Frontier problem | `opus --effort max` only on request or proven `xhigh` gap |

## Invocation

- Check `claude --version`; report skip on failure
- Generate a UUID; reuse it for the entire session
- Pipe prompts via stdin: `claude -p --session-id <uuid> --permission-mode plan --model <model> [--effort <level>]`
- Set effort explicitly for supported Sonnet/Opus work; omit it for `haiku` unless local support is confirmed
- Use scoped paths with `--add-dir`; do not place positional prompts after variadic options
- Prefer Claude `Read` over embedding file contents; raw embedding can fail silently and wastes tokens
- Avoid expandable PowerShell here-strings for markdown fences, backticks, or large text
- Delete `$HOME/.claude/projects/*/<uuid>.jsonl` after completion, failure, timeout, or abort

## Prompt

- State the call is non-interactive; ask for final text only
- Ask for skeptical critique within original scope
- Provide changed paths, user intent, Codex assumptions, verification run, and known residual risks

## After

- Apply actionable feedback within original scope; flag out-of-scope suggestions
- Report status, applied changes, skip/failure reason, and nonstandard details only
