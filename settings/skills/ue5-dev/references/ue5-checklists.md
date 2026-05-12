# UE5 API and Failure Checks

## Gameplay C++
Check these before final output:
- `UCLASS`, `USTRUCT`, `UENUM`, `UINTERFACE`, `GENERATED_BODY()`
- `UPROPERTY(...)`, `UFUNCTION(...)`, module export macro such as `MYPROJECT_API`
- `TObjectPtr<>` for reflected object references in headers
- `BeginPlay`, `InitializeComponent`, `EndPlay`, `Deinitialize`, or subsystem lifecycle hook actually used
- `Net/UnrealNetwork.h`, `GetLifetimeReplicatedProps`, `DOREPLIFETIME` for replicated fields
- `FGameplayTag` values validated before match/use

Failure fixes:
- Class missing from Blueprint: add needed `BlueprintType`, `Blueprintable`, `BlueprintCallable`, category metadata, and module export macro; rebuild editor target
- Include cycle: move concrete includes from `.h` to `.cpp`; keep forward declarations in public headers
- Link error after adding module type: add the module to `PrivateDependencyModuleNames` unless exposed from public headers
- Replicated field not updating: check actor/component `bReplicates`, `DOREPLIFETIME`, server-side write path, and value actually changing
- RPC ignored: ensure call direction matches specifier (`Server`, `Client`, `NetMulticast`) and validate ownership/authority

## Blueprint
Check these before editing or describing graph wiring:
- Target Blueprint package path under `/Game/...`
- Graph name: `EventGraph`, construction script, function graph, macro graph, or animation graph
- Input path: legacy key event, Enhanced Input `UInputAction`, or custom event
- Pin names from the actual node variant before wiring automated connections
- Compile result and duplicate input/event nodes after edits

Failure fixes:
- Key press does not fire: check pawn possession, input enabled, UI focus, mapping context registration, and duplicate key/action events
- Enhanced Input event silent: verify `UInputMappingContext` is added to `UEnhancedInputLocalPlayerSubsystem` and action asset matches node
- Broken pins after function signature change: refresh node, reconnect exec pins first, then data pins
- Event fires repeatedly: check duplicate delegate binding, duplicate entry node, or missing re-entry guard

## UMG and Slate
Check these APIs and lifecycle points:
- `UUserWidget::NativeConstruct`, `NativeDestruct`, `AddToViewport`, `RemoveFromParent`
- `UWidgetBlueprintLibrary::SetInputMode_UIOnlyEx`, `SetInputMode_GameAndUIEx`, `SetInputMode_GameOnly`
- `SetKeyboardFocus`, `FSlateApplication::SetKeyboardFocus`, `UWidget::TakeWidget`
- Delegate/timer handle stored and cleared on teardown

Failure fixes:
- Widget does not refresh: bind after source object exists; verify delegate fires and widget instance is not recreated silently
- Input stays in UI after close: restore input mode and focus explicitly on close path
- Tooltip off-screen: use viewport size from `UGameViewportClient::GetViewportSize` and clamp final position
- Memory grows after reopen: clear delegates, timers, and object references in `NativeDestruct` or close handler

## SaveGame and Replication
Check these before changing state code:
- Save object derives from `USaveGame`
- Slot name and user index are stable
- Save data includes schema version
- Actor/component identity uses stable key, GUID, `FName`, or explicit ID, not array index
- Server writes replicated gameplay state before clients consume it

Failure fixes:
- Old save crashes load: branch on schema version and migrate or reject cleanly before applying data
- Restored actor references invalid: restore owners first, then components/dependents; handle missing assets
- Client value differs after load: restore on authority, then let replication update clients
- `OnRep_*` spam: batch coarse state; derive UI/fine state client-side

## World Interaction
Check these concrete settings:
- Collision component: `USphereComponent`, `UBoxComponent`, or trace shape
- `SetCollisionEnabled`, `SetCollisionResponseToChannel`, `SetGenerateOverlapEvents`
- `OnComponentBeginOverlap`, `OnComponentEndOverlap`, `LineTraceSingleByChannel`, `SweepSingleByChannel`
- Success lifecycle: `Destroy`, hide + disable collision, cooldown timer, or respawn

Failure fixes:
- Overlap never fires: enable overlap generation on both sides and verify collision responses are compatible
- Trace misses target: check channel, object response, start/end, self/owner ignored actors
- Pickup remains interactable: disable collision immediately after server-confirmed success
- Spawner leaks actors: store spawned actor handles and destroy/disable stale handles on reset

## Logs, Packaging, and Performance
Log checks:
- Use `Saved/Logs/<Project>.log`
- Scan `LogBlueprint`, `LogClass`, `LogLinker`, `LogUObjectGlobals`, `LogNet`, `LogCook`, `LogPackageName`, `LogInit`
- Treat first `Error` or `Fatal` as the likely blocker; later errors may cascade

Packaging checks:
- Default map and game mode set
- Maps-to-cook includes launch/test maps
- Required plugins enabled for target platform
- Redirectors fixed before release packaging
- Packaged log checked separately from PIE log

Performance checks:
- `stat unit`: game/render/RHI frame cost
- `stat gpu`: GPU pass cost
- `stat memory`: memory pressure
- Unreal Insights when attribution is unclear
- Compare PIE and packaged runtime before claiming a packaging/perf fix
