# PCG Runtime Validation

## Replay Checks
- Run same lot, style, and seed twice
- Compare output count, module IDs, transforms, and bounds
- Move one source lot; unchanged lots must keep module choices
- Shrink bounds; removed slots/actors/instances must disappear

## Runtime/Cook Checks
- Packaged build loads the PCG graph, mesh set, materials, data tables, and plugin modules
- Runtime path does not call editor-only generation helpers
- `LogCook`, `LogPackageName`, `LogLinker`, and `LogPCG` contain no missing asset errors
- World Partition or streaming unload removes or detaches generated output correctly

## Collision and Nav Checks
- Generated building collision matches intended blocker/overlap behavior
- Nav mesh policy is explicit: no nav, dynamic rebuild, or precomputed/static placement
- Entrances and streets remain traversable after facade/lot changes
- Dense facade meshes do not use unnecessarily expensive collision

## Cost Checks
- Record instance count, spawned actor count, generation duration, and frame spike
- Compare HISM/ISM output against actor output before accepting dense actors
- Cap per-update spawned actor count when runtime generation hitches
- Avoid per-frame regeneration; generation should be event-triggered

## Multiplayer/Save Checks
- Replicate seed/input/result state, not every static facade piece
- Authority owns gameplay-relevant generated actors
- Save stable lot/generator state, not transient instance handles
- Rebuild after load from saved seed/style/bounds and then restore interactable state
