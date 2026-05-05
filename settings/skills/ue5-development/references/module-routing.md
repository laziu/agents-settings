# UE5 Module Boundaries

## Build.cs Dependency Rules
- Put a module in `PublicDependencyModuleNames` only when a public header includes or exposes one of its types
- Put implementation-only modules in `PrivateDependencyModuleNames`
- Runtime modules must not depend on editor modules
- After adding a dependency, compile the smallest editor target and remove unused entries

Common baseline:

```csharp
PublicDependencyModuleNames.AddRange(new string[] { "Core", "CoreUObject", "Engine" });
PrivateDependencyModuleNames.AddRange(new string[] { "InputCore", "EnhancedInput" });
```

## Header Rules
- Public headers: forward declarations first; concrete includes only when the type is embedded by value or base class
- `.cpp`: include concrete engine/project headers
- Reflected properties using `TObjectPtr<UType>` still need a known reflected type; do not forward declare generated structs used by value
- Moving a reflected class across modules can break Blueprint class paths; require redirect/migration handling

## Runtime vs Editor
- Runtime module: actors, components, data assets, save data, subsystems used in game
- Editor module: asset actions, detail customizations, factories, validation utilities, editor-only UI
- If runtime code needs editor-only validation, expose data through a runtime contract and implement the validator in the editor module

## Common Module Clusters
| Need | Add/check modules |
|---|---|
| UObject/Actor basics | `Core`, `CoreUObject`, `Engine` |
| Enhanced Input | `EnhancedInput`, `InputCore` |
| GameplayTags | `GameplayTags` |
| UMG widget code | `UMG`, plus `Slate`, `SlateCore` only when using Slate types |
| Replication helpers | `NetCore` only when code directly uses NetCore APIs; always include `Net/UnrealNetwork.h` for `DOREPLIFETIME` |
| Asset queries | `AssetRegistry` |
| Packaging/cook tools | keep in editor/developer tooling modules, not runtime |
| Online/network services | `OnlineSubsystem`, `OnlineSubsystemUtils`, `HTTP`, `WebSockets` only where directly used |

## Circular Include Fix Order
1. Move engine/project includes from public headers to `.cpp`
2. Replace public concrete members with pointers/references when ownership allows
3. Move shared `USTRUCT`/`UENUM` contracts to a lower runtime module
4. Add only the dependency required by public exposure or private implementation
5. Rebuild the smallest affected editor target
