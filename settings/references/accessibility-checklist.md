# Accessibility Checklist

WCAG 2.1 AA quick checks. Use with `frontend-ui-engineering`.

## Keyboard
- [ ] Interactive elements reachable by Tab
- [ ] Focus order is logical
- [ ] Focus is visible
- [ ] Custom widgets support Enter/Space/Escape as applicable
- [ ] No keyboard traps
- [ ] Skip-to-content link exists where useful
- [ ] Modals trap focus and restore it on close

## Screen Readers
- [ ] Images have descriptive `alt` or decorative `alt=""`
- [ ] Inputs have visible labels or accessible names
- [ ] Buttons/links are descriptive; icon buttons have `aria-label`
- [ ] One `h1`; heading levels do not skip
- [ ] Dynamic updates use `aria-live`, `role="status"`, or `role="alert"`
- [ ] Tables use `<th>` and `scope`

## Visual
- [ ] Text contrast >=4.5:1; large text >=3:1
- [ ] UI component contrast >=3:1
- [ ] Color is not the only state signal
- [ ] Text resizes to 200% without breaking layout
- [ ] No flashes >3 times/second
- [ ] Touch targets >=44x44px on mobile

## Forms
- [ ] Every input has a visible label
- [ ] Required state not indicated by color alone
- [ ] Errors are specific and associated with fields
- [ ] Submission errors are summarized and focusable
- [ ] Known fields use proper `type` and `autocomplete`

## Content
- [ ] `<html lang>` set
- [ ] Page `<title>` descriptive
- [ ] Links distinguishable beyond color
- [ ] Empty/error/loading states meaningful

## Native Pattern Defaults
- Use `<button>` for actions
- Use `<a href>` for navigation
- Avoid `div/span` buttons
- Prefer native `<select>` before custom dropdown
- Use `tabindex="0"` or `-1`; avoid `tabindex > 0`

## Live Regions
| Pattern | Use |
|---|---|
| `aria-live="polite"` / `role="status"` | save/status updates |
| `aria-live="assertive"` / `role="alert"` | errors/time-sensitive alerts |

## Tools
```bash
npx pa11y <url>
# Browser: Lighthouse, Accessibility tree
# Screen readers: VoiceOver, NVDA, JAWS, Orca
```

## Anti-Patterns
- Div as button
- Missing alt text
- Color-only state
- Autoplay without controls
- Custom controls without ARIA/keyboard support
- Removed focus outline
- Empty links/buttons
