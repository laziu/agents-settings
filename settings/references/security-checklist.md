# Security Checklist

Use with `security-and-hardening`.

## Pre-Commit
- [ ] No secrets in staged diff.
  ```bash
  git diff --cached | grep -i "password\|secret\|api_key\|token"
  ```
- [ ] `.gitignore` covers `.env`, `.env.local`, `*.pem`, `*.key`.
- [ ] `.env.example` contains placeholders only.

## Authentication
- [ ] Passwords hashed with bcrypt >=12 rounds, scrypt, or argon2.
- [ ] Cookies: `httpOnly`, `secure`, `sameSite`.
- [ ] Session expiration set.
- [ ] Login rate limit <=10 attempts/15 min.
- [ ] Reset tokens expire and are single-use.
- [ ] MFA for sensitive operations when appropriate.

## Authorization
- [ ] Protected endpoints require auth.
- [ ] Resource access checks ownership/role.
- [ ] Admin endpoints verify admin role.
- [ ] API keys scoped minimally.
- [ ] JWTs validate signature, expiration, issuer.

## Input and Output
- [ ] User input validated at boundaries.
- [ ] Allowlists over denylists.
- [ ] String lengths and numeric ranges constrained.
- [ ] Email/URL/date validated with libraries.
- [ ] Uploads restrict type, size, and content.
- [ ] SQL parameterized.
- [ ] HTML output encoded.
- [ ] Redirect URLs allowlisted.

## Headers
```text
Content-Security-Policy: default-src 'self'; script-src 'self'
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 0
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

## CORS
- [ ] Specific origins only.
- [ ] Credentials allowed only when required.
- [ ] Methods/headers constrained.
- [ ] Never use `origin: '*'` in production with sensitive APIs.

## Data Protection
- [ ] Sensitive fields excluded from responses.
- [ ] Sensitive data not logged.
- [ ] HTTPS for external communication.
- [ ] PII encrypted at rest when required.
- [ ] Backups encrypted.

## Dependencies
```bash
npm audit
npm audit --audit-level=critical
npm audit fix
npx npm-check-updates
```

## Error Handling
- [ ] Production errors are generic.
- [ ] No stack traces, SQL, internals, or secrets returned.

## OWASP Quick Reference
| Risk | Prevention |
|---|---|
| Broken access control | auth + ownership checks |
| Cryptographic failures | HTTPS, strong hashing, no secrets |
| Injection | parameterized queries, validation |
| Insecure design | threat modeling, specs |
| Misconfiguration | headers, least privilege |
| Vulnerable components | audit, minimal deps |
| Auth failures | rate limits, secure sessions |
| Integrity failures | signed/verified artifacts |
| Logging failures | security events, no secrets |
| SSRF | URL allowlists, outbound restrictions |
