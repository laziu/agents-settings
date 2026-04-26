---
name: performance-optimization
description: Optimizes application performance with measurement, profiling, budgets, and regression guards.
---

# Performance Optimization

Measure first. Optimize only proven bottlenecks. Measure again.

## Use When
- Performance requirements exist.
- Monitoring/users report slowness.
- Core Web Vitals are poor.
- A change may have regressed performance.
- Large data/high traffic features.

## Targets
| Metric | Good |
|---|---|
| LCP | <=2.5s |
| INP | <=200ms |
| CLS | <=0.1 |
| API p95 | project budget, often <=200ms |

## Workflow
1. Measure baseline with synthetic and/or real-user data.
2. Identify actual bottleneck.
3. Fix the specific cause.
4. Measure after.
5. Add monitoring/test/budget guard.

## Where to Look
- First load: bundle, render-blocking CSS/JS, images, fonts, TTFB.
- Interaction lag: long tasks >50ms, re-renders, controlled input overhead.
- Navigation/data load: API waterfalls, cache misses, N+1 fetches.
- Backend: slow queries, missing indexes, connection pool, CPU, GC, external services.

## Common Fixes
- N+1 -> join/include/batch.
- Unbounded list -> pagination and limits.
- Missing indexes -> add for filtered/sorted columns.
- Images -> AVIF/WebP, width/height, `srcset/sizes`, lazy below fold, `fetchpriority=high` for LCP.
- Bundles -> code split heavy/rare routes, remove unused deps, verify tree shaking.
- React renders -> stable props, memoization only where profiling proves benefit.
- Main thread -> chunk long work, yield, move heavy work to workers.
- Caching -> static long cache with content hash; API cache where safe.

## Budgets
Set and enforce:
- JS initial gzip budget.
- CSS/font/image budgets.
- API p95 latency.
- Lighthouse/Core Web Vitals threshold.

## Red Flags
- Optimization without numbers.
- N+1 or unbounded queries.
- Images without dimensions/responsive sources.
- Bundle growth without review.
- No production monitoring.
- Blanket `memo/useMemo` without profiling.

## Verification
- Before/after measurements recorded.
- Bottleneck addressed.
- Vitals/budgets pass.
- Bundle not materially worse.
- No behavior regression; tests pass.
