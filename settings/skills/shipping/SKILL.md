---
name: shipping
description: Prepare production launches and rollback plans
---

# Shipping and Launch

Deploy only with quality gates, observability, and a rollback plan.

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
Staging smoke test -> production with risky flags off -> internal -> 5% -> 25% -> 50% -> 100%, advancing only if metrics pass. Monitor after full rollout and clean up flags.

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

## Output

```markdown
## Ship Decision: GO | NO-GO
## Blockers
## Recommended Fixes
## Acknowledged Risks
Risk:
Mitigation:
## Rollback Plan
Triggers:
Steps:
Database:
RTO:
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
