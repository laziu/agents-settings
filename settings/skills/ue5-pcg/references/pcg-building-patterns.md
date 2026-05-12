# PCG Building Patterns

## Building Input Fields
- `LotId`: stable key for replay/debug
- `Bounds`: world or local AABB; record coordinate space
- `Seed`: integer; use for every selector
- `Style`: facade/roof/module set
- `EntranceSide`: explicit side or derived once from road/frontage
- `FloorHeight`, `MinFloors`, `MaxFloors`
- `ExclusionTags`: road, nav corridor, gameplay arena, streaming edge

## Deterministic Grammar Order
1. Sort lots by stable key before random selection
2. Reserve entrance and corners
3. Compute floor count from seed/style/bounds
4. Split facade into slots using module dimensions
5. Resolve required modules: base, corner, entrance, roof/top
6. Fill repeat modules with seeded weighted choices
7. Write debug metadata: lot ID, seed, style, rule path, chosen module IDs

## Output Strategy
| Output | Use | Avoid when |
|---|---|---|
| HISM/ISM | Dense static wall/window/trim modules | Each piece needs authority, overlap, or unique state |
| Spawned actors | Doors, pickups, destructibles, interactables | Dense facade repetition |
| Owned components | One generator owns all output | Streaming ownership crosses level boundaries |
| Metadata | Another system spawns/render later | Debug visualization is absent |

## Pivot and Scale Checks
- Module pivot must match slot origin convention
- Mesh dimensions must divide facade slot width/height or have explicit remainder rule
- Corner modules must consume width on both adjacent facades consistently
- Roof/top modules must close height without floating/overlap
- Use one unit convention for source lot, grammar dimensions, and mesh bounds

## Runtime Generation Triggers
- Rebuild only on seed/style/bounds/source changes
- Debounce editor handle movement and runtime source movement
- Batch actor spawning or large instance updates across frames if hitching
- Store handles for every spawned actor and instance range
- Cleanup stale output before applying new grammar result

## PCG-Specific Failure Fixes
- Same seed differs: sort inputs, remove unseeded random calls, store seed at graph boundary
- Facade overlaps: inspect slot width, mesh bounds, pivot, and corner reservation order
- Gaps at roof/top: inspect floor count rounding and top-module closure rule
- Generated pieces survive rebuild: missing handle/range ownership; fix cleanup before adding rules
- Actor count too high: convert repeated static modules to HISM/ISM and keep actors only for interactables
