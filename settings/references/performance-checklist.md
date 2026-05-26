# Performance Reference

Use with `performance-optimization` when a measured bottleneck needs a checklist.

## Budgets
| Metric | Good |
|---|---|
| LCP | <=2.5s |
| INP | <=200ms |
| CLS | <=0.1 |
| TTFB | <=800ms |
| API p95 | project budget |

## Measurement
- Record baseline and after measurements
- Use RUM/CrUX when available; use Lighthouse or DevTools for local reproduction
- Profile the slow interaction, route, query, or render path before changing code
- Track bundle size when JS changes affect initial load

## Common Bottlenecks
- First load: LCP image, render-blocking CSS/JS, fonts, TTFB, bundle size
- Interaction: long tasks, excessive renders, controlled input overhead
- Data load: request waterfalls, cache misses, N+1 fetches, unbounded lists
- Backend: slow queries, missing indexes, pool saturation, sync heavy work

## Guard
- Budget, monitoring, or regression test exists for the optimized path
- Behavior tests still pass
