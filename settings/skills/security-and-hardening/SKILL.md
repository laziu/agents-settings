---
name: security-and-hardening
description: Hardens code handling user input, auth, data, sessions, external services, files, payments, or PII.
---

# Security and Hardening

Treat external input as hostile, secrets as sacred, and authorization as mandatory.

## Use When
- User input, authn/authz, sessions, PII, payments, file uploads, webhooks, external APIs, or data storage are involved

## Always
- Validate external input at system boundaries
- Parameterize DB queries
- Encode output; do not bypass framework escaping
- Use HTTPS
- Hash passwords with bcrypt/scrypt/argon2
- Set security headers: CSP, HSTS, frame/content-type/referrer policies
- Use `httpOnly`, `secure`, `sameSite` cookies for sessions
- Audit dependencies before release

## Ask First
- New/changing auth flows
- New sensitive data categories
- External integrations
- CORS changes
- File uploads
- Rate limit changes
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

## Secrets
`.gitignore` should cover `.env`, `.env.local`, `.env.*.local`, `*.pem`, `*.key`.

Pre-commit check:
```bash
git diff --cached | grep -i "password\|secret\|api_key\|token"
```

## Verification
- No critical/high reachable vulnerabilities
- No secrets in source/diff/history
- Boundary validation exists
- Authn/authz on protected endpoints
- Headers/CORS/rate limits configured
- Error responses generic
