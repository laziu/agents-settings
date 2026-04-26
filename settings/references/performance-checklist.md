# Performance Checklist

Use with `performance-optimization`.

## Targets
| Metric | Good | Needs Work | Poor |
|---|---|---|---|
| LCP | <=2.5s | <=4.0s | >4.0s |
| INP | <=200ms | <=500ms | >500ms |
| CLS | <=0.1 | <=0.25 | >0.25 |

## TTFB >800ms
- [ ] DNS slow -> `dns-prefetch` / `preconnect`.
- [ ] TCP/TLS slow -> HTTP/2/3, edge, keep-alive.
- [ ] Server slow -> profile backend, queries, caching.

## Frontend

Images:
- [ ] AVIF/WebP.
- [ ] `srcset` + `sizes`.
- [ ] explicit `width`/`height` on `img` and art-directed `source`.
- [ ] below fold: `loading="lazy"` + `decoding="async"`.
- [ ] LCP image: no lazy loading, `fetchpriority="high"`.

JavaScript:
- [ ] Initial JS within budget.
- [ ] Dynamic import for routes/heavy rarely used features.
- [ ] Tree shaking verified.
- [ ] No blocking JS in head.
- [ ] Long tasks >50ms chunked/yielded or moved to worker.
- [ ] `memo/useMemo/useCallback` only where profiling proves value.
- [ ] Third-party scripts async/defer and size-audited.

CSS/fonts:
- [ ] Critical CSS/preload strategy set.
- [ ] No production CSS-in-JS runtime unless accepted.
- [ ] Fonts limited, WOFF2, self-hosted when practical.
- [ ] LCP fonts preloaded; `font-display` set.
- [ ] Fallback metrics adjusted when CLS matters.

Network/rendering:
- [ ] Static assets cached with long max-age + content hash.
- [ ] API cache where safe.
- [ ] HTTP/2/3 enabled.
- [ ] No unnecessary redirects.
- [ ] Animations use transform/opacity.
- [ ] Long lists virtualized.
- [ ] Off-screen sections use `content-visibility` where useful.
- [ ] bfcache not blocked by `unload`/unnecessary `no-store`.

## Backend
- [ ] No N+1 queries.
- [ ] Indexes for filtered/sorted queries.
- [ ] List endpoints paginated.
- [ ] Connection pool configured.
- [ ] Slow query logging.
- [ ] API p95 within budget.
- [ ] No sync heavy computation in request handlers.
- [ ] Bulk operations instead of per-row loops.
- [ ] Compression/caching configured.
- [ ] CDN/static asset strategy.
- [ ] Health check endpoint.

## Measurement
```bash
npx lighthouse <url> --output json --output-path ./report.json
npx bundlesize
npx webpack-bundle-analyzer stats.json
npx vite-bundle-visualizer
```

```typescript
import { onLCP, onINP, onCLS } from 'web-vitals';
onLCP(console.log);
onINP(console.log);
onCLS(console.log);
```

INP:
- start with RUM/CrUX
- profile slow interactions in DevTools
- test CPU-throttled or mid-range Android

## Anti-Patterns
| Issue | Fix |
|---|---|
| N+1 | join/include/batch |
| unbounded query | paginate/add limit |
| missing index | add matching index |
| layout thrash | batch reads/writes |
| large bundle | split/audit/defer |
| main-thread block | chunk/yield/worker |
| memory leak | cleanup listeners/intervals/refs |
