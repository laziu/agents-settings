# Source Index Reference

Use when project-context-bootstrap creates or refreshes project-level source navigation context.

Generated project context must not depend on this user-level harness path. Inline only the rules the target project needs.

## Ownership

- Project-level `AGENTS.md`, `CLAUDE.md`, or `.agents/index/` owns the active source index format
- Existing project format wins unless the user explicitly requests migration or redesign
- The source index is a navigation aid; source, contracts, specs, tests, and build files remain authoritative
- Do not create a source index for trivial single-file projects unless requested

## Default Shape

Use this shape only when creating a new index with no project convention, or when the user explicitly requests this target.

```text
.agents/index/
  README.md
  cards/
    <area>.yaml
```

The index root owns:

- Purpose
- Reading algorithm
- Active card format
- Maintenance rules
- Legacy migration notes when needed

Cards own structured navigation data only.

Keep long explanation in project docs/specs/plans and link to it.

## Card Fields

Use fields in this order:

```yaml
id: client-simulation
owner: Client
description: Scenario/Episode runtime, project-mode scenario generation, and run outputs.

paths:
  - Client/Source/OdiroSim/Public/Scenario/**
  - Client/Source/OdiroSim/Private/Scenario/**

workflows:
  - scenario parsing
  - episode artifact writing

entry:
  - id: contract
    description: Public scenario, episode, and run file shapes.
    read:
      - contracts/specs

  - id: runtime
    description: Project/run loading and episode scenario generation.
    needs:
      - contract
    read:
      - ProjectRuntimeTypes.h / .cpp

guardrails:
  - Final user project contract uses one editable `<UserProject>/scenario.json`.

verify:
  - when: parser or runtime changes
    run:
      - focused Scenario/Episode automation tests

links:
  - docs/specs/simulation-interface.md
```

Field meanings:

- `id`: stable kebab-case identifier matching the filename stem
- `owner`: project, package, team, or responsibility owner
- `description`: concise routing hint
- `paths`: explicit glob triggers; prefer repeated simple globs over brace syntax
- `workflows`: natural-language triggers not captured by paths
- `entry`: ordered read groups with `id`, `description`, optional `needs`, and `read`
- `guardrails`: local ownership boundaries, migration traps, and non-obvious constraints
- `verify`: focused checks; group by `when` when broad
- `links`: canonical docs only; do not duplicate linked content

## Maintenance Text For Projects

When creating project-level rules, include only applicable bullets.

```markdown
## Source Index
- Read `.agents/index/` before broad source navigation.
- Treat the source index as a navigation aid; source, contracts, specs, and tests remain authoritative.
- Update `.agents/index` when paths, entry points, ownership, guardrails, or verification flow change.
- Preserve the project-defined index format unless migration is explicit.
```

## Legacy

Mention legacy source-index paths only inside a project that actually has them.

Do not add user-level fallback paths to generated project context.
