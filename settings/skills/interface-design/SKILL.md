---
name: interface-design
description: Public API, schema, command, event, file-format contracts
---

# API and Interface Design

Design stable observable contracts as spec content before implementation.

Use for public APIs, schemas, commands, events, file formats, plugin hooks, environment variables, and cross-module boundaries.

## Principles
- Define input, output, error, versioning, and compatibility first
- Every observable behavior can become a contract; avoid leaking internals
- One-version rule: extend instead of maintaining competing versions
- Validate only at boundaries: API routes, forms, env, external responses
- Treat external responses as untrusted data
- Prefer additive optional fields; avoid removing fields or changing existing types
- Use one structured error format and stable status mapping
- Separate input and output types
- Use discriminated unions for variants and branded IDs when mixups matter
- Document breaking changes, migration, and deprecation path

## REST Defaults
Follow existing project/API conventions first. Use these defaults when there is no stronger local convention.
- Resource nouns, no verbs
- Query params for filters/sort/page
- Paginate every list endpoint
- `PATCH` means partial update
- Status mapping: `400` invalid request, `401` unauthenticated, `403` unauthorized, `404` missing, `409` conflict, `422` validation, `500` generic server error

## Naming
- Endpoints plural nouns; no verb URLs like `/createTask`
- Query/response fields `camelCase`
- Booleans `is*`, `has*`, `can*`
- Enum values `UPPER_SNAKE`

## Output
- Contract section/spec in `docs/specs/`
- Request, response, event, command, or file shape
- Error shape and status/exit mapping
- Validation boundary and trust assumptions
- Compatibility, migration, and versioning notes

## Verification
- Typed schemas for inputs/outputs
- Single error format
- Boundary validation only
- List contracts paginate or justify no pagination
- Additive/backward-compatible changes preferred
- Naming consistent
- Contract is documented in the relevant `docs/specs/` file
- Types/docs kept with implementation
