---
name: shipping
description: Prepare production launches and rollback plans
---

# Shipping and Launch

Deploy only with quality gates, observability, and a rollback plan.

## Use When
- Production release
- Significant user-facing change
- Data/infrastructure migration
- Beta/early access
- Any risky deployment
- User asks for a go/no-go launch decision

## Pre-Launch Checklist
- Code: tests/build/lint/typecheck pass; review done; no debug logs/TODO blockers; error handling covers expected failures
- Security: no secrets; audit clean for critical/high reachable vulns; input validation; auth/authz; headers; rate limits; restrictive CORS
- Performance: Core Web Vitals good; no N+1; optimized images; bundle within budget; DB indexes/caching as needed
- Accessibility: keyboard, screen reader structure, contrast, focus, form errors, axe/Lighthouse
- Infrastructure: env vars, migrations, DNS/SSL/CDN, logging/error reporting, health check
- Docs: README/API docs/ADRs/changelog/user docs current when affected

## Feature Flags
- Deploy with flag off, enable for internal/beta, roll out gradually, monitor, then remove flag/dead path
- Each flag needs owner, expiration date, and tests for on/off states
- Avoid nested flags

## Rollout
1. Staging deploy and smoke test
2. Production deploy with risky flags off
3. Enable for team
4. Canary 5%
5. Increase 25% -> 50% -> 100% only if metrics pass
6. Monitor after full rollout and clean up flags

## Rollback Thresholds
Rollback immediately for:
- Error rate >2x baseline
- p95 latency >50% above baseline
- Spike in user reports
- Data integrity issue
- Security vulnerability

Hold/investigate for smaller but material regressions.

## Monitor
- App: error rate, p50/p95/p99 latency, request volume, business metrics
- Infra: CPU, memory, DB pool, disk, queue depth, network
- Client: Core Web Vitals, JS errors, API errors, load time

## Ship Decision Output

```markdown
## Ship Decision: GO | NO-GO

### Blockers
- [source] [severity] file:line — issue

### Recommended Fixes
- [source] file:line — issue

### Acknowledged Risks
- Risk:
- Mitigation:

### Rollback Plan
- Triggers:
- Steps:
- RTO:

### Specialist Reports
- code-reviewer:
- security-auditor:
- test-engineer:
```

Include Specialist Reports only when specialist passes were actually requested or available.

## Rollback Plan
Document before GO:

```markdown
## Rollback Plan
Triggers:
- [metric/condition]
Steps:
1. Disable flag or revert/deploy previous version.
2. Verify health/errors/latency.
3. Communicate status.
Database:
- rollback/forward-fix plan and data handling.
RTO:
- [target]
```

## Post-Launch First Hour
- Health 200
- No new error types
- Latency normal
- Critical flow works
- Logs flowing
- Rollback path ready or dry-run verified

## Verification
- Checklist complete
- Rollback plan exists
- Monitoring dashboards exist
- Team notified
- Post-launch checks recorded
