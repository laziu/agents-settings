# UE5 Project Context Candidates

Select only rules supported by the target project.

## Build And Verification

- Exact editor target, platform, configuration, project path, and repo build command
- Exact automation, cook, package, or focused test command that the project uses
- Project log path and any project-owned log scanner
- A retry or concurrency rule only when the project has an observed failure and approved recovery

## Editor Coordination

- Whether sessions share one Editor instance
- Actions requiring approval: open, close, restart, relaunch, save, or compile
- Required handling for unsaved assets or Live Coding

## Asset And Blueprint Automation

- Exact commandlet, MCP, or project automation tool and its supported write scope
- Asset paths or content roots the automation owns
- Graph types that require manual handoff because project automation cannot edit them safely
- Required compile, save, and readback checks

## Module And Runtime Boundaries

- Project-specific runtime/editor module ownership
- Export macros, public dependency rules, redirects, or packaging constraints that have caused project failures
- Save, replication, input, UI, or interaction rules only when they are project contracts rather than general UE knowledge

## PCG Building Generation

Include only for projects that generate buildings with PCG:

- Graph, generator, input, mesh-set, and output ownership paths
- Seed determinism and regeneration cleanup requirements
- ISM/HISM versus actor ownership required by gameplay behavior
- Runtime and cook availability, collision, navigation, streaming, multiplayer, and save requirements
- Project-specific measurements or acceptance checks
