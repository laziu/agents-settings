---
name: api-and-interface-design
description: Guides stable API and interface design. Use for REST/GraphQL endpoints, public module contracts, component props, or frontend/backend boundaries.
---

# API and Interface Design

Design contracts that are stable, typed, documented, and hard to misuse.

## Use When
- New or changed API endpoint, schema, module boundary, component prop interface, or public contract.
- Existing public behavior may change.

## Principles
- Contract first: define input/output/error shape before implementation.
- Hyrum's Law: every observable behavior can become a contract; avoid leaking implementation details.
- One-version rule: extend instead of maintaining competing versions.
- Validate only at system boundaries: API routes, forms, env, external service responses.
- Treat third-party API responses as untrusted data.
- Prefer additive optional fields; avoid removing fields or changing existing types.
- Keep error semantics consistent: one structured error format and stable status mapping.
- Separate input types from output types; outputs include server-generated fields.
- Use discriminated unions for variants and branded IDs when ID mixups matter.

## REST Defaults
- Resource nouns, no verbs: `GET /api/tasks`, `POST /api/tasks`, `PATCH /api/tasks/:id`.
- Query params for filters/sort/page.
- Paginate every list endpoint.
- `PATCH` means partial update; only provided fields change.
- Status mapping: `400` invalid request, `401` unauthenticated, `403` unauthorized, `404` missing, `409` conflict, `422` validation, `500` generic server error.

## Naming
- Endpoints: plural nouns.
- Query/response fields: `camelCase`.
- Booleans: `is*`, `has*`, `can*`.
- Enum values: `UPPER_SNAKE`.

## Red Flags
- Same endpoint returns multiple incompatible shapes.
- Mixed error formats.
- Validation scattered through internal helpers.
- Breaking field removals/type changes.
- List endpoint without pagination.
- Verb URLs like `/createTask`.
- External data used without validation.

## Verification
- Typed schemas for every endpoint input/output.
- Single error format.
- Boundary validation only.
- Paginated lists.
- Backward-compatible additions.
- Naming consistent.
- Types/docs committed with implementation.
