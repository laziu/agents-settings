# UE5 Project Context Candidates

Select only rules supported by the target project, plus the user defaults below unless the project already defines a conflicting rule.

## User Defaults

- Never launch an additional Editor instance; open, close, restart, or relaunch the shared Editor only with explicit user permission
- Before an approved Editor shutdown, compile and save unsaved assets
- Never bypass build failures with another engine path, a copied workspace, deleting `Binaries` or `Intermediate`, an IDE build, or project-file regeneration
- Live Coding or Editor lock failure: trigger Live Coding once through an existing command, then retry the same build once; stop and report if that fails
- Out-of-memory build failure: retry once with `-MaxParallelActions=4` through the invocation, not by editing build scripts
- Widgets: layout, hover/focus responses, and animation in Widget Blueprint; C++ only for non-design logic; application state in a Subsystem, ActorComponent, or `UMVVMViewModelBase` ViewModel
- Blueprint assets: write with a commandlet, then verify touched assets by MCP readback; hand off EventGraph edits as exact manual steps unless project automation targets that graph

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
