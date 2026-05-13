---
name: ue5-pcg
description: Unreal Engine 5 PCG building generation workflow
---

# UE5 PCG Building

Use this skill for PCG-specific building generation choices: seed determinism, facade grammar, instance output, runtime cleanup, cook safety, collision, and nav.

## Inspect These First
- PCG asset path, generator actor/component, graph inputs, seed source, and output type
- Lot/spline/volume coordinate space and mesh pivot/unit assumptions
- Runtime generation trigger: source moved, bounds changed, seed changed, style changed, or manual rebuild
- Generated ownership: HISM/ISM component, spawned actor list, instance ranges, cleanup path
- Cook/runtime assets: meshes, materials, graph assets, data tables, and plugin availability

## Load References
- Read `references/pcg-building-patterns.md` for lot/facade grammar and output strategy
- Read `references/runtime-generation-validation.md` when generation runs in PIE, standalone, packaged builds, streaming, or multiplayer

## Required PCG Gates
- Same seed + same input must produce same module choices, transforms, and counts
- High-count static pieces should use ISM/HISM unless per-piece gameplay behavior is required
- Regeneration must remove stale instances/actors before or during replacement
- Runtime generation must avoid editor-only APIs and cooked-missing assets
- Generated collision/nav must be checked when buildings block or route gameplay

## Do Not Spend Context On
- General UE C++/Blueprint/UI advice unless it changes generated building output
- Non-building scatter, foliage, loot, or terrain PCG patterns
- Generic performance advice without PCG counts, instance strategy, or regeneration trigger
