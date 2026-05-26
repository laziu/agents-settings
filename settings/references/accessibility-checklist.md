# Accessibility Reference

Use with `ui-design` or `browser-verification` for browser-rendered UI.

## Keyboard And Focus
- Interactive elements reachable by keyboard
- Logical focus order and visible focus
- No keyboard traps
- Modals trap focus and restore it on close

## Semantics
- Native controls for actions, navigation, inputs, and selects when practical
- Images have descriptive `alt` or decorative `alt=""`
- Inputs have visible labels or accessible names
- Buttons and links have descriptive names; icon buttons have accessible names
- One `h1`; heading levels do not skip
- Tables use headers when presenting tabular data

## Visual And Forms
- WCAG 2.1 AA contrast
- Color is not the only state signal
- Text resizes to 200% without breaking layout
- Touch targets are large enough on mobile
- Errors are specific, associated with fields, and announced or focusable when needed

## Evidence
- Browser accessibility tree or Lighthouse/axe check
- Keyboard path verified
- Relevant viewport captured for layout-sensitive issues
