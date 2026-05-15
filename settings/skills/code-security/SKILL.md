---
name: code-security
description: Harden code at security-sensitive boundaries
---

# Security and Hardening

Treat external input as hostile, secrets as sacred, and authorization as mandatory.

## Use When
- Security-sensitive boundary changes: user input, authn/authz, sessions, PII, payments, file uploads, webhooks, external APIs, data storage, secrets, or privileged operations
- Reviewing trust boundaries, permissions, validation, dependency exposure, logging, or error handling

## Baseline
- Validate external input at system boundaries
- Parameterize DB queries
- Encode browser output; do not bypass framework escaping
- Use TLS for production network traffic
- Hash stored passwords with bcrypt/scrypt/argon2
- Set web security headers: CSP, HSTS, frame/content-type/referrer policies
- Use `httpOnly`, `secure`, `sameSite` cookies for sessions
- Audit dependencies before release

## Ask First
Ask before changing security boundaries or policy. When proposing an assumption, explain why, tradeoffs, and limits.
- New/changing auth flows or authorization policy
- New sensitive data categories
- New external services or trust boundaries
- CORS policy broadening
- File upload policy or storage behavior
- Rate limit policy changes
- Elevated roles/permissions

## Never
- Commit secrets
- Log passwords, tokens, full card numbers, or sensitive PII
- Trust client-side validation as a security boundary
- Disable security headers for convenience
- Use `eval` or unsafe HTML with user data
- Store auth sessions in client-accessible storage
- Expose stack traces/internal errors to users

## OWASP Baseline
- Injection: parameterized queries, no command/string concatenation with user data
- Auth failures: strong hashing, secure sessions, reset-token expiry, rate limits
- XSS: encode/sanitize; avoid unsafe HTML
- Access control: check ownership/role on every protected resource
- Misconfiguration: restrictive CORS, security headers, least privilege
- Sensitive data: sanitize API responses and logs
- Vulnerable components: audit and patch reachable runtime risk
- Webhooks/OAuth: verify signatures, use state/PKCE
- SSRF/open redirects: allowlist outbound URLs and redirect targets

## Dependency Audit Triage
- Critical/High reachable in production: fix/block release
- Critical/High not reachable/dev-only: fix soon, document rationale
- Moderate reachable: fix next cycle
- Low: track in normal updates
- If no fix exists: workaround, replace, or time-boxed allowlist with review date

## Secret Diff Check
`.gitignore` should cover `.env`, `.env.local`, `.env.*.local`, `*.pem`, `*.key`.

Check staged and unstaged diffs when secrets are in scope:
```bash
git diff | grep -Ei "password|secret|api_key|token"
git diff --cached | grep -Ei "password|secret|api_key|token"
```

## Verification
- No critical/high reachable vulnerabilities
- No secrets in source/diff/history
- Boundary validation exists
- Authn/authz on protected endpoints
- Headers/CORS/rate limits configured
- Error responses generic
