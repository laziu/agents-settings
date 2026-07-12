# UE5 Runtime, Packaging, and Performance Checks

## Logs

- Read `Saved/Logs/<Project>.log`
- Check `LogBlueprint`, `LogClass`, `LogLinker`, `LogUObjectGlobals`, `LogNet`, `LogCook`, `LogPackageName`, and `LogInit`
- Treat the first `Error` or `Fatal` as the likely root blocker; later failures may cascade

## Packaging

- Default map and game mode are set
- Maps-to-cook includes launch and test maps
- Required plugins are enabled for the target platform
- Redirectors are fixed before release packaging
- Packaged logs are checked separately from PIE logs

## Performance

- `stat unit` for game, render, and RHI frame cost
- `stat gpu` for GPU pass cost
- `stat memory` for memory pressure
- Unreal Insights when attribution remains unclear
- Compare PIE and packaged runtime before claiming a packaging or performance fix
