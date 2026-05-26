---
name: delivery
description: Configure delivery gates, deployments, and rollback
---

# Delivery

Ship only with quality gates, observability, and a rollback path.

Use for CI/CD, required checks, deployment automation, launch readiness, rollout, monitoring, and rollback planning.

## Gates
- Use existing project gates first
- Prefer lint/format, typecheck, unit tests, build, integration tests, critical e2e, security audit, and performance budget for production code
- Required gates and reviews must block merge or deployment
- Do not skip gates to pass CI; fix the cause

## CI/CD
- Run on PRs and main/default pushes
- Use clean install and official dependency caching
- Upload failure artifacts for e2e/test reports
- Store secrets in platform secrets or vault, never workflow YAML
- Keep production, CI, and staging secrets separate
- Keep CI feedback actionable; copy the specific failure, not full noisy logs
- If CI exceeds about 10 minutes, cache, split jobs, shard long suites, or use path filters before larger runners

## Release
- Deploy to staging before production when available
- Use preview deployments for PRs when practical
- Use feature flags for risky or incomplete features
- Flags need owner, expiration, cleanup date, and on/off tests
- Roll out gradually and advance only while metrics pass
- Roll back immediately for data integrity issues, security vulnerabilities, error rate above 2x baseline, p95 latency above 50% baseline, or major user-report spikes

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

## Verification
- Required gates block merge or deploy
- Pipeline runs on PR and main/default push
- Secrets are outside code
- Rollback plan exists
- Monitoring covers errors, latency, traffic, client health, and critical business metrics
- Post-launch checks are recorded
