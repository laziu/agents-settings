---
name: ui-design
description: Build production user-facing UI
---

# Frontend UI Engineering

Build UI that follows the product's design system, works accessibly, and behaves correctly in real browsers.

## Architecture
- Colocate component, tests, stories, hooks, and local types when useful
- Keep components focused
- Prefer composition over over-configured props
- Separate data fetching/container logic from presentation
- Use the simplest state model: local, lifted, context, URL, server-state library, then global store
- Avoid prop drilling deeper than 3 levels

## Design System
- Use existing spacing, color, typography, radius, and component tokens
- Avoid generic AI defaults: purple gradients, oversized cards, excessive shadows, stock hero/card grids, unrealistic placeholder copy
- Use semantic colors; do not rely on color alone
- Respect heading hierarchy: one `h1`, no skipped levels
- Mobile-first responsive layout; check 320, 768, 1024, 1440px when relevant

## Accessibility
- Native controls first: `button` for actions, `a` for navigation
- All interactive elements keyboard reachable and visibly focused
- Icon-only controls have accessible names
- Inputs have labels and associated errors
- Modals manage/trap focus; dynamic changes use `aria-live` when needed
- Contrast meets WCAG 2.1 AA; mobile touch targets >=44x44px

## States and Motion
- Provide loading, error, and empty states
- Prefer skeletons for content loading
- Optimistic updates must roll back on error
- Animations should not block input; respect reduced-motion preferences

## Verification
- Component renders without console errors
- Keyboard path works
- Screen reader structure/names are usable
- Responsive breakpoints checked
- Loading/error/empty states covered
- Design system followed
- Axe/Lighthouse/DevTools show no relevant a11y issues
