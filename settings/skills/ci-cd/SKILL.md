---
name: ci-cd
description: Configure CI/CD, quality gates, and deployments
---

# CI/CD and Automation

Automate checks so broken code cannot merge or deploy silently.

## Quality Gates
Use existing gates first. For production code, prefer:
1. lint/format
2. typecheck
3. unit tests
4. build
5. integration tests
6. e2e tests for critical flows
7. security audit
8. bundle/performance budget where applicable

Do not skip gates to pass CI; fix the cause.

## Defaults
- Run on PRs and main/default pushes
- Use clean install and official dependency caching
- Upload failure artifacts for e2e/test reports
- Store secrets in platform secrets/vault, never workflow YAML
- Keep production, CI, and staging secrets separate

## Deployment
- Prefer preview deployments for PRs
- Deploy to staging before production
- Use feature flags for risky/incomplete features
- Roll out gradually, monitor errors/latency, and define rollback
- Give flags an owner, expiration, and cleanup date

## CI Failure Loop
- Copy the specific failure, not full noisy logs
- Lint -> run fixer if safe
- Type/build -> fix cited location/config/dependency
- Test -> use `debugging`
- Verify locally before pushing

## Optimization
If CI exceeds ~10 minutes:
- Cache dependencies; split independent jobs; shard long suites
- Use path filters for docs-only/unrelated changes
- Move slow non-critical tests to scheduled jobs
- Use larger runners only after pipeline fixes

## Verification
- Required gates and reviews block merge
- Pipeline runs on PR and main/default push
- Secrets are stored outside code
- Deployment rollback exists
- CI feedback is actionable
- Protected branches block force-pushes and unsafe auto-merge
