---
name: frontend-ui-engineering
description: Builds production-quality user-facing UI — components, layout, state, accessibility, responsiveness, and interaction.
---

# Frontend UI Engineering

Build UI that follows the product's design system, works accessibly, and behaves correctly in real browsers.

## Use When
- New or changed UI components/pages
- Responsive layout, visual polish, interaction, state, loading/error/empty states

## Architecture
- Colocate component, tests, stories, hooks, and local types when useful
- Keep components focused
- Prefer composition over over-configured props
- Separate data fetching/container logic from presentation
- Use the simplest state model:
  - Local state: component UI
  - Lifted state: 2-3 siblings
  - Context: read-heavy global concerns
  - URL state: shareable filters/pagination
  - Server state library: remote cached data
  - Global store: complex app-wide client state
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
- Modals manage focus and trap it while open
- Dynamic changes use `aria-live` where needed
- Contrast meets WCAG 2.1 AA
- Touch targets >=44x44px on mobile

## States and Motion
- Provide loading, error, and empty states
- Prefer skeletons for content loading
- Optimistic updates must roll back on error
- Animations should not block input; respect reduced-motion preferences

## Red Flags
- Component >200 lines without clear reason
- Inline arbitrary pixels/styles inconsistent with system
- Missing error/loading/empty states
- No keyboard testing
- Color-only status
- Console errors ignored

## Verification
- Component renders without console errors
- Keyboard path works
- Screen reader structure/names are usable
- Responsive breakpoints checked
- Loading/error/empty states covered
- Design system followed
- Axe/Lighthouse/DevTools show no relevant a11y issues
