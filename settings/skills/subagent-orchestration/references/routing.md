# Subagent Routing

Choose the subagent by job shape, not by brand preference. The caller remains accountable for final behavior.

## Product Fit

| Need | Prefer | Role | Reason |
| --- | --- | --- | --- |
| Ambiguous requirements, architecture tradeoff, strategic review | Claude | `independent-advisor` | Strong second-pass reasoning and critique |
| Security, correctness, or release-risk second opinion | Claude | `independent-advisor` or `security-auditor` | High-signal skeptical review |
| File-heavy implementation or repo-wide mechanical edits | Codex | `bounded-implementer` | Strong local code editing and verification loops |
| Test planning or regression proof over an existing diff | Codex | `test-engineer` | Repo-aware test selection and command discovery |
| Focused code review from a VCS diff | Codex review surface or Claude advisor | `code-reviewer` | Use Codex for local diff mechanics, Claude for independent critique |
| Quick lookup, one command, or low-risk local change | No subagent | Caller | Delegation overhead exceeds value |

## Direction
- Codex -> Claude: advisory by default; use read-only or plan-mode permissions
- Claude -> Codex: implementation or repo-work by default; bound writable paths and verification commands
- Codex -> Codex or Claude -> Claude: prefer native agent tools before CLI recursion

## Cost And Risk
- Ask or state intent before expensive, slow, or broad delegation unless the user explicitly requested it
- Prefer cheaper sufficient model/effort settings; escalate only for ambiguity, blast radius, repeated search/tool work, or hard-to-reverse decisions
- Never delegate secrets, auth flows, payment data, production data, or destructive operations without an explicit user-approved boundary
