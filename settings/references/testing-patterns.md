# Testing Reference

Use with `testing` only when a test strategy needs a quick risk checklist.

## Coverage Targets
- New behavior: expected path, boundary, invalid input, and error path
- Bug fix: failing reproduction that passes only after the fix
- Async behavior: awaited assertion or deterministic scheduler
- UI behavior: role/label based interaction plus `browser-verification` for rendered evidence
- External boundary: fake/mock database, network, filesystem, time, queues, or email

## Avoid
- Tests that pass before implementation
- Snapshot-only proof
- Mocked business logic
- Shared mutable state
- Skipped or disabled tests
