---
name: ue5-dev
description: UE5 code, assets, builds, logs, and editor validation
---

# UE5 Development

Use for UE5-specific file checks, API guardrails, build commands, log triage, and asset validation. This is a domain skill, not a replacement for workflow skills.

## Inspect These First
- C++ or module work: `.uproject`, `Source/*.Target.cs`, `Source/**/*.Build.cs`, touched `Public/` and `Private/` headers
- Reflected types: export macro, `GENERATED_BODY()`, module ownership, Blueprint class references, asset redirect risk
- Blueprint work: target `/Game/...` asset path, target graph, input system path, compile errors in `Saved/Logs/*.log`
- UI work: `UUserWidget` subclass, Widget Blueprint path, input mode calls, focus target, delegate/timer cleanup site
- Save/replication: `USaveGame` class, slot names, schema version, `GetLifetimeReplicatedProps`, `OnRep_*`, RPC entry points
- Packaging/perf: default map, maps-to-cook, enabled plugins, target RHI/platform, `Saved/Logs`, packaged-run log

## Load References
- Read `references/module-routing.md` before changing `*.Build.cs`, public headers, module dependencies, or runtime/editor boundaries
- Read `references/ue5-checklists.md` before implementing or debugging C++, Blueprint, UI, SaveGame, replication, interaction, packaging, or UE logs

## Command Patterns
Discover `.uproject` and local build command first. Prefer repo scripts and repo-relative project paths. If the UE path or build command is unknown, ask the user.

```powershell
& "<UE>\Engine\Build\BatchFiles\Build.bat" <ProjectName>Editor Win64 Development -Project="<Project>.uproject" -WaitMutex
& "<UE>\Engine\Binaries\Win64\UnrealEditor-Cmd.exe" "<Project>.uproject" -run=Automation -TestExit="Automation Test Queue Empty" -unattended -nop4
& "<UE>\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -project="<Project>.uproject" -noP4 -platform=Win64 -clientconfig=Development -build -cook -stage -pak
```

## Build
- After work, run the smallest affected build: the repo script for one touched project area, or an aggregate task/build script for multiple areas.
- Live Coding/editor-lock failure: if the editor is open, trigger Live Coding once through an existing local command or hook, then retry the same build once. If unavailable or the retry fails, stop and report.
- Memory exhaustion: retry once with `-MaxParallelActions=4` through the build invocation or supported local override. Do not edit build scripts to set it; do not reduce it to 1.
- Do not bypass build failures with alternate UE path, copied workspace, deleting `Binaries` or `Intermediate`, packaging command, IDE build, or generated project refresh.

## Editor Coordination
- Multiple agent sessions may share one Unreal project; never open an additional editor instance. Open, close, restart, or relaunch the shared editor only with explicit user permission.
- Before an approved shutdown, compile and save unsaved assets. If `Unsaved Changes` appears, save; if `Restore Unsaved Changes` appears on relaunch, ignore it.
- During approved editor automation, if the editor exits unexpectedly, wait 3 seconds and check for another agent-requested build. If none is running, run the affected build, then relaunch.

## Widget Boundary
- Prefer Widget Blueprint for design: layout, hover/focus responses, and animations.
- Put C++ only in non-design logic or required C++ API; skip a C++ widget class when Widget Blueprint is enough.
- Put application logic in Subsystem, ActorComponent, or ViewModel; prefer `UMVVMViewModelBase` for ViewModel state.

## Blueprint Boundary
- Asset edits: write with commandlet first, then verify touched assets with UE_MCP_Bridge/MCP readback. MCP may also be used earlier for inspection or authoring.
- Commandlet OK: asset creation, parent class assignment, default property edits, compile/save operations
- EventGraph edits: do not attempt direct graph authoring unless project automation explicitly targets the exact graph change
- Manual handoff: write exact editor steps, expected nodes/events, property values, and verification for EventGraph work
- Context guard: avoid spending tokens reverse-engineering Blueprint graph internals when a manual path is clearer

## Verify
- Blueprint: compile result and duplicate event/input nodes
- Packaging: packaged log separate from PIE log

## Helper Scripts
- `scripts/scan_output_log.py --log Saved/Logs/<Project>.log --top 20`: count UE `Warning`, `Error`, and `Fatal` lines by category with samples
- `scripts/quick_asset_check.py --root . --asset /Game/UI/WBP_HUD`: map `/Game/...` or `Blueprint'/Game/...'` paths to local `.uasset` files

## Do Not Spend Context On
- Generic planning, review, testing, or debugging advice
- PCG building graph design, shape grammar, lot/facade generation, or procedural-building runtime validation
- Unreal basics unrelated to touched files, APIs, commands, logs, assets, or packaging settings
