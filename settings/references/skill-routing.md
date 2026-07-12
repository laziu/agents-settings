# Skill Routing Relationships

Use only when multiple Skill descriptions match.

| Need | Order or owner |
| --- | --- |
| Requirements, design, tasks | `specification` -> `planning` -> `task-breakdown`; skip stages already stable |
| Hard-to-reverse Plan choice | `architecture-decision` owns the record and ADR promotion |
| Agent context update | `context-engineering` owns placement; `context-improvement` owns the approval gate |
| Repo context bootstrap or refresh | `project-context-bootstrap` owns target files; `context-engineering` owns policy design |
| Explicit CLI delegation | Active workflow Skill owns scope; `subagent-orchestration` owns the handoff |
| UE5 PCG building work | `ue5-pcg` owns generation rules; add `ue5-dev` for code, assets, build, logs, or editor validation |
