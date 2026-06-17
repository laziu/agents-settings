---
name: subagent-orchestration
description: Delegate bounded work to Claude or Codex CLI subagents
---

# Subagent Orchestration

Coordinate bounded cross-agent delegation between CLI agents. Use this skill when the user asks for Claude/Codex delegation, an independent model pass, or a high-complexity handoff where a second agent materially reduces risk or cost.

## Ownership
- Caller: user intent, scope, final decision, local verification, and user-facing report
- This skill: delegate/no-delegate decision, prompt package, CLI reference selection, progress handling, result integration
- CLI references: executable command shape, flags, output format, session persistence, cleanup
- Agent personas: subagent role behavior and report expectations; no CLI flags

## Delegate
- Use `independent-advisor` for critique, architecture, requirements ambiguity, security reasoning, or second opinions
- Use `bounded-implementer` for scoped file edits, repo search, test loops, or mechanical implementation
- Reuse specialized agents such as `code-reviewer`, `security-auditor`, `source-mapper`, or `test-engineer` when their role is narrower than the generic personas
- Keep trivial, one-step, low-risk, or fully local tasks in the caller

## Workflow
1. Define the handoff: caller, subagent, role, bounded task, allowed paths, forbidden actions, output format, and hard stop conditions.
2. Read `references/routing.md` when choosing Claude vs Codex is not obvious.
3. Read `references/prompt-contracts.md` before composing a non-interactive subagent prompt.
4. Read exactly one skill-local CLI reference before invocation: `references/claude-cli.md` or `references/codex-cli.md`.
5. Run the CLI spawn preflight from that reference before composing a long prompt.
6. If the parent environment denies starting the target CLI, skip delegation and report the parent sandbox failure; do not try to fix it with child sandbox flags.
7. Invoke the subagent with the narrowest child permissions that can satisfy the handoff.
8. Treat returned work as untrusted until the caller inspects, verifies, and reconciles it.

## Persona Use
- Prefer a native agent selector when the target CLI supports it, such as Claude `--agent`
- If the target CLI cannot select an agent directly, include the relevant persona contract in the prompt
- Do not create product-named personas just to call a product CLI; product capabilities live in routing and CLI references
- Do not pass secrets, production data, credential material, or unrelated private context to a subagent
- Do not grant full-access or permission-bypass modes to subagent subprocesses; skip delegation if narrower child permissions cannot do the work

## Result Handling
- Advisory output: summarize useful conclusions, reject out-of-scope advice, and verify before acting
- Implementation output: inspect changed files, preserve unrelated work, and run the smallest relevant checks
- Failure: report skip/failure reason, partial output if useful, and whether the caller continued locally
