# UE5 Gameplay C++ Checks

## API Surface

- `UCLASS`, `USTRUCT`, `UENUM`, `UINTERFACE`, `GENERATED_BODY()`
- `UPROPERTY(...)`, `UFUNCTION(...)`, and the module export macro
- `TObjectPtr<>` for reflected object references in headers
- The lifecycle hook actually used: `BeginPlay`, `InitializeComponent`, `EndPlay`, `Deinitialize`, or subsystem lifecycle
- `Net/UnrealNetwork.h`, `GetLifetimeReplicatedProps`, and `DOREPLIFETIME` for replicated fields
- Validated `FGameplayTag` values before match or use

## Failure Checks

- Class missing from Blueprint: check `BlueprintType`, `Blueprintable`, callable metadata, category, export macro, and editor-target rebuild
- Include cycle: move concrete includes from `.h` to `.cpp`; keep valid forward declarations in public headers
- Link error after adding a module type: use `PrivateDependencyModuleNames` unless the type is exposed from public headers
- Replicated field not updating: check `bReplicates`, `DOREPLIFETIME`, server-side writes, and whether the value changes
- RPC ignored: check direction specifier, ownership, and authority
