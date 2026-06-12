# Skill Routing Relationships

Default: load named skills and skills whose `description` metadata matches the task. Use this reference only when multiple skills match or a relationship affects order.

## Ownership

- `SKILL.md` frontmatter: normal trigger wording
- Skill body: conditional workflow, domain guardrails, artifact shape, verification
- `AGENTS.md` or `CLAUDE.md`: bootstrap and hard boundaries
- This file: cross-skill relationships and ordering exceptions

## Ambiguity Map

| Need | Use | Relationship |
| --- | --- | --- |
| Requirements vs design vs task list | `specification`, `planning`, `task-breakdown` | Requirements first when current truth is missing; plans after stable requirements; tasks after stable plans |
| Specs, numbered Plans, tasks, or promoted decisions | `define-design-workflow.md` plus matching workflow skill | Use the workflow reference for artifact type, naming, status, and plan classification |
| Public contract changes | `interface-design` plus `specification` or `planning` | Define user-visible contract before implementation details |
| Hard-to-reverse technical choices | `architecture-decision` plus `planning` | Record only decisions that outlive cheap local rationale |
| Current API or framework facts decide the design | `source-check` plus active workflow skill | Verify official sources before locking the decision |
| Project docs vs agent context | `documentation`, `context-engineering`, `context-improvement` | Docs own user/project knowledge; context skills own agent behavior, placement, and approved corrections |
| Behavior proof vs rendered UI proof | `testing`, `browser-verification` | Use browser proof only when DOM, layout, console, responsive, or screenshot evidence matters |
| Review vs security hardening | `code-review`, `code-security` | Add security review when trust boundaries or sensitive data are touched |
| VCS state affects the task | `version-control` | Use when diffs, branches, merges, commits, or history risk change the work |
| Domain-specific work | `ui-design`, `ue5-dev`, `ue5-pcg` | Domain overlays add guardrails; combine them with workflow and verification skills |
