# UE5 Blueprint and UI Checks

## Blueprint

- Confirm the target package path under `/Game/...`
- Commandlet-safe work: asset creation, parent class, default properties, compile, and save
- Manual graph work: `EventGraph`, construction script, function, macro, or animation graph
- Identify legacy input, Enhanced Input `UInputAction`, or custom-event flow
- Record exact node names, pins, property values, wiring, compile result, and duplicate events

Failure checks:

- Silent key input: possession, input enabled, UI focus, mapping context, and duplicate events
- Silent Enhanced Input: mapping context registration and matching action asset
- Broken pins after a signature change: refresh node, then reconnect exec and data pins
- Repeated event: duplicate binding, duplicate entry node, or missing re-entry guard

## UMG and Slate

- Check `NativeConstruct`, `NativeDestruct`, viewport attach/remove, input mode, and focus APIs
- Store and clear delegate and timer handles on teardown
- Stale widget: verify binding time, event delivery, and unintended widget recreation
- Input stuck in UI: restore input mode and focus on close
- Tooltip off-screen: clamp against the viewport size
- Memory growth after reopen: clear delegates, timers, and object references
