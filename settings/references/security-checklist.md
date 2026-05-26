# Security Reference

Use with `code-security` when a change touches auth, secrets, external input, data exposure, uploads, redirects, dependencies, or infrastructure.

## Boundary Checks
- Authn/authz on protected endpoints
- Ownership/role checks for resource access
- Boundary validation for user input, uploads, redirects, and webhooks
- Parameterized DB queries and no command/string concatenation with user data
- Encoded browser output and no unsafe HTML/eval
- Generic production errors with no internals or stack traces

## Secret And Data Checks
- No secrets in source, diffs, logs, responses, or history
- `.gitignore` covers `.env`, `.env.local`, `*.pem`, and `*.key`
- Sensitive fields excluded from API responses
- HTTPS for external communication
- PII encrypted at rest when required

## Release Gates
- Critical/high reachable dependency vulnerabilities fixed or release-blocked
- Security headers/CORS/rate limits configured for production
- Secret scanning and dependency audit handled by hooks, CI, or release gates when possible
