# UE5 State and Interaction Checks

## SaveGame and Replicated State

- Save object derives from `USaveGame`
- Slot name and user index remain stable
- Save data includes a schema version
- Actor or component identity uses a stable key rather than an array index
- Authority restores gameplay state before replication updates clients

Failure checks:

- Old save crash: branch on schema version and migrate or reject before applying data
- Invalid restored references: restore owners before dependents and handle missing assets
- Client differs after load: restore on authority, then replicate
- `OnRep_*` spam: batch coarse state and derive fine UI state client-side

## World Interaction

- Confirm collision shape, enabled state, channel responses, and overlap generation
- Confirm overlap or trace API, ignored actors, and success lifecycle
- Missing overlap: both sides must generate overlaps with compatible responses
- Missed trace: check channel, response, start/end, and ignored self or owner
- Reusable pickup after success: disable collision immediately after server confirmation
- Spawner leak: retain handles and remove stale actors during reset
