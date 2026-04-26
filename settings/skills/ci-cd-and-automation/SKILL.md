---
name: ci-cd-and-automation
description: Automates CI/CD pipelines, quality gates, test runners, and deployment workflows.
---

# CI/CD and Automation

Automate checks so broken code cannot merge or deploy silently.

## Use When
- Setting up or changing CI/CD
- Adding quality gates
- Debugging CI failures
- Configuring deployment, previews, rollbacks, or dependency automation

## Quality Gates
Every PR should run, in this order where practical:
1. lint/format
2. typecheck
3. unit tests
4. build
5. integration tests
6. e2e tests for critical flows
7. security audit
8. bundle/performance budget where applicable

Do not skip gates to pass CI; fix the cause.

## CI Defaults
- Run on PRs and pushes to main/default branch
- Use clean install (`npm ci`, equivalent)
- Cache dependencies through official setup actions
- Upload artifacts on failure for e2e/test reports
- Keep production secrets out of CI; use separate CI/staging secrets
- Store secrets in platform secrets/vault, never in workflow YAML

## Deployment
- Prefer preview deployments for PRs
- Deploy to staging before production
- Use feature flags for risky/incomplete features
- Roll out gradually and monitor error rate/latency
- Every deployment needs a rollback path
- Flags need owner, expiration, and cleanup date

## CI Failure Loop
- Copy the specific failure, not full noisy logs
- Lint -> run fixer if safe
- Type/build -> fix cited location/config/dependency
- Test -> use `debugging-and-error-recovery`
- Verify locally before pushing

## Optimization
If CI exceeds ~10 minutes:
- Cache dependencies
- Split independent jobs in parallel
- Use path filters for docs-only/unrelated changes
- Shard long test suites
- Move slow non-critical tests to scheduled jobs
- Use larger runners only after pipeline fixes

## Branch Protection
- Require passing status checks
- Require review before merge
- Block force-pushes to protected branches
- Allow auto-merge only after checks and approvals

## Verification
- Required gates exist and block merge
- Pipeline runs on PR and main/default push
- Secrets are stored outside code
- Deployment rollback exists
- CI feedback is actionable
- Pipeline duration is acceptable
