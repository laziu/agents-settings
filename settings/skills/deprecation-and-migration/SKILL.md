---
name: deprecation-and-migration
description: Manages removal, replacement, and migration of old systems, APIs, features, or libraries.
---

# Deprecation and Migration

Remove code that no longer earns its maintenance cost, but migrate users safely.

## Use When
- Replacing an old API/system/library.
- Sunsetting a feature.
- Consolidating duplicate implementations.
- Removing dead or unowned code.
- Planning lifecycle/removal of a new system.

## Principles
- Code is a liability: tests, docs, security, dependencies, onboarding, mental load.
- Hyrum's Law: observable behavior may be depended on, including quirks.
- Deprecation planning starts during design.
- Do not deprecate without a working replacement.
- If you own the infrastructure, own the migration or provide tooling.

## Decision Questions
1. Does it still provide unique value?
2. Who depends on it and how many?
3. Is the replacement production-proven?
4. What is migration cost per consumer?
5. What is the maintenance/security/opportunity cost of keeping it?

## Deprecation Types
- Advisory: stable old system, optional migration, warnings/docs.
- Compulsory: security/progress/maintenance risk; hard deadline plus tooling/docs/support.

Default to advisory unless risk justifies forcing migration.

## Process
1. Build replacement covering critical use cases.
2. Announce status, reason, replacement, removal date if any, migration guide.
3. Migrate consumers incrementally.
4. Verify behavior with tests/integration checks.
5. Confirm zero active usage through metrics/logs/dependency analysis.
6. Remove old code, tests, docs, config, and notices.

## Migration Patterns
- Strangler: route traffic old -> new gradually, remove old at 0%.
- Adapter: old interface delegates to new implementation during transition.
- Feature flag: switch cohorts/consumers one at a time.

## Zombie Code
Signs: no owner, no recent maintenance, active consumers, failing tests, vulnerable deps, stale docs.
Decision: assign owner and maintain, or deprecate with a concrete migration plan.

## Red Flags
- No replacement.
- No migration guide/tooling.
- Advisory deprecation with no progress for years.
- New features added to deprecated systems.
- Removal without usage verification.

## Verification
- Replacement is production-proven.
- Migration guide exists.
- Consumers migrated and verified.
- No old references remain.
- Notices removed after completion.
