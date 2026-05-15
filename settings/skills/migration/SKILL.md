---
name: migration
description: Migrate or remove legacy systems, APIs, and features
---

# Deprecation and Migration

Remove code that no longer earns its maintenance cost, but migrate users safely.

## Principles
- Code is a liability: tests, docs, security, dependencies, onboarding, mental load
- Hyrum's Law: observable behavior may be depended on, including quirks
- Deprecation planning starts during design
- Do not deprecate without a working replacement
- If you own the infrastructure, own the migration or provide tooling

## Decision Questions
Ask whether it still has unique value, who depends on it, whether the replacement is proven, migration cost per consumer, and maintenance/security/opportunity cost of keeping it.

## Deprecation Types
- Advisory: stable old system, optional migration, warnings/docs
- Compulsory: security/progress/maintenance risk; hard deadline plus tooling/docs/support

Default to advisory unless risk justifies forcing migration.

## Process
1. Build replacement covering critical use cases
2. Announce status, reason, replacement, removal date if any, migration guide
3. Migrate consumers incrementally
4. Verify behavior with tests/integration checks
5. Confirm zero active usage through metrics/logs/dependency analysis
6. Remove old code, tests, docs, config, and notices

## Migration Patterns
- Strangler: route traffic old -> new gradually, remove old at 0%
- Adapter: old interface delegates to new implementation during transition
- Feature flag: switch cohorts/consumers one at a time

## Zombie Code
If code has no owner, stale maintenance/docs, active consumers, failing tests, or vulnerable deps, assign an owner or deprecate with a concrete migration plan.

## Verification
- Replacement is production-proven
- Migration guide exists
- Consumers migrated and verified
- No old references remain
- Notices removed after completion
