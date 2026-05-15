---
name: performance-optimization
description: Optimize performance with measurement and profiling
---

# Performance Optimization

Measure first. Optimize only proven bottlenecks. Measure again.

## Targets
| Metric | Good |
|---|---|
| LCP | <=2.5s |
| INP | <=200ms |
| CLS | <=0.1 |
| API p95 | project budget |

## Workflow
1. Measure baseline with synthetic and/or real-user data
2. Identify actual bottleneck
3. Fix the specific cause
4. Measure after
5. Add monitoring/test/budget guard

## Where to Look
- First load: bundle, render-blocking CSS/JS, images, fonts, TTFB
- Interaction lag: long tasks >50ms, re-renders, controlled input overhead
- Navigation/data load: API waterfalls, cache misses, N+1 fetches
- Backend: slow queries, missing indexes, connection pool, CPU, GC, external services

## Common Fixes
- Data: join/include/batch N+1, paginate unbounded lists, add measured indexes
- Assets: dimensions, responsive sources, modern formats, lazy below fold, LCP priority
- Bundles: code split heavy/rare routes, remove unused deps, verify tree shaking
- Rendering: stabilize props, memoize only with profiling proof
- Main thread: chunk/yield/move heavy work to workers
- Cache: content-hashed static cache; safe API cache

## Verification
- Before/after measurements recorded
- Bottleneck addressed
- Vitals/budgets pass
- Bundle not materially worse
- Monitoring or budget guard exists
- No behavior regression; tests pass
