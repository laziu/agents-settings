---
name: code-security
description: Harden code at security-sensitive boundaries
---

# Security and Hardening

Treat external input as hostile, secrets as sacred, and authorization as mandatory.

## Baseline
- Validate external input at system boundaries; never trust client-side validation alone
- Parameterize DB queries and avoid command/string concatenation with user data
- Encode/sanitize browser output; avoid unsafe HTML and `eval`
- Check ownership/role on every protected resource
- Use TLS, secure password hashing, secure session cookies, security headers, restrictive CORS, and least privilege
- Verify webhooks/OAuth with signatures, state, and PKCE
- Allowlist outbound URLs and redirects to prevent SSRF/open redirects
- Sanitize API responses, logs, and errors

## Ask First
Ask before changing auth, authorization policy, sensitive data handling, external services, trust boundaries, CORS broadening, uploads/storage, rate limits, or elevated permissions.

## Never
- Commit secrets
- Log passwords, tokens, full card numbers, or sensitive PII
- Disable security headers for convenience
- Store auth sessions in client-accessible storage
- Expose stack traces/internal errors to users
- Fail open at auth/authz, validation, upload, payment, or data-access boundaries

## Dependency Audit Triage
- Critical/high reachable in production: fix or block release
- Critical/high not reachable or dev-only: fix soon, document rationale
- Moderate reachable: fix next cycle; low: track normally
- No fix: workaround, replace, or time-boxed allowlist with review date

## Secret Diff Check
`.gitignore` should cover `.env`, `.env.local`, `.env.*.local`, `*.pem`, `*.key`.

Check staged/open diffs for `password|secret|api_key|token`.

## Verification
- No critical/high reachable vulnerabilities
- No secrets in source/diff/history
- Boundary validation exists
- Authn/authz on protected endpoints
- Headers/CORS/rate limits configured
- Error responses generic
