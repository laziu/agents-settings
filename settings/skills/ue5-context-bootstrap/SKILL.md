---
name: ue5-context-bootstrap
description: Install or refresh UE5 rules in project AGENTS or CLAUDE context
---

# UE5 Context Bootstrap

Install verified UE5 workflow context into a target repository. Edit Agent context only; do not change product code or assets.

## Inspect

- Existing project `AGENTS.md`, `CLAUDE.md`, and nested Agent context
- `.uproject`, engine association, plugins, `Source/*.Target.cs`, `Source/**/*.Build.cs`, and module layout
- Repo build, test, cook, package, editor automation, and log tooling
- Blueprint or asset automation capabilities actually present
- PCG plugin, graphs, generators, runtime use, and project requirements when applicable

## Build The Context

1. Read `references/context-candidates.md`.
2. Use `assets/project-ue5-context.md` as a section outline.
3. Default to the nearest applicable `AGENTS.md`; update `CLAUDE.md` only when it already exists or the user requests it.
4. Fill only rules supported by project files, commands, tools, explicit user requirements, or the user defaults in `references/context-candidates.md`.
5. Remove unused headings and placeholders before writing.
6. Merge with existing context without duplicating or replacing unrelated rules.

## Boundaries

- Copy exact repo commands and paths; do not install placeholder UE commands
- Do not name this user-level Skill or its local paths in generated project context
- Keep generic Unreal API knowledge out of project context
- Add PCG building rules only when the project uses that workflow
- Do not install helper scripts or hooks unless requested

## Verification

- Referenced paths, commands, modules, plugins, and tools exist or are explicitly user-supplied
- The resulting section is self-contained and contains no unresolved placeholders
- Every retained rule is project-specific, a listed user default, or prevents an observed project failure
