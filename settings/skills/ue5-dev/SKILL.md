---
name: ue5-dev
description: Unreal Engine 5 development workflow
---

# UE5 Development

Use this skill for UE5-specific file checks, API guardrails, build commands, log triage, and asset validation.

This is a domain skill, not a replacement for workflow skills. When this skill is loaded, check whether `vcs-workflow`, `incremental-implementation`, or `testing` also applies.

## VCS Guardrails
- Detect Git or Perforce before editing project files
- In Perforce workspaces, use `p4 edit`/checkout before modifying tracked files
- Do not clear read-only attributes, chmod/attrib files writable, or overwrite read-only files to bypass Perforce
- If Perforce checkout fails, stop and report the exact command/error

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
Discover the project `.uproject` and UE install path first. Prefer repo scripts if present.

```powershell
& "<UE>\Engine\Build\BatchFiles\Build.bat" <ProjectName>Editor Win64 Development -Project="<Project>.uproject" -WaitMutex
& "<UE>\Engine\Binaries\Win64\UnrealEditor-Cmd.exe" "<Project>.uproject" -run=Automation -TestExit="Automation Test Queue Empty" -unattended -nop4
& "<UE>\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun -project="<Project>.uproject" -noP4 -platform=Win64 -clientconfig=Development -build -cook -stage -pak
```

## Helper Scripts
- `scripts/scan_output_log.py --log Saved/Logs/<Project>.log --top 20`: count UE `Warning`, `Error`, and `Fatal` lines by category with samples
- `scripts/quick_asset_check.py --root . --asset /Game/UI/WBP_HUD`: map `/Game/...` or `Blueprint'/Game/...'` paths to local `.uasset` files

## Do Not Spend Context On
- Generic planning, review, testing, or debugging advice
- PCG building graph design, shape grammar, lot/facade generation, or procedural-building runtime validation
- Unreal basics unrelated to touched files, APIs, commands, logs, assets, or packaging settings
