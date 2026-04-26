# Testing Patterns

Use with `test-driven-development`.

## Arrange / Act / Assert
```typescript
it('creates a task with default pending status', () => {
  const input = { title: 'Test Task' };
  const result = createTask(input);
  expect(result).toMatchObject({ title: 'Test Task', status: 'pending' });
});
```

## Naming
Pattern: `[unit] [expected behavior] [condition]`.

```typescript
describe('TaskService.createTask', () => {
  it('throws ValidationError when title is empty', () => {});
  it('trims whitespace from title', () => {});
});
```

## Common Assertions
```typescript
expect(value).toBe(expected);
expect(value).toEqual(expected);
expect(value).toStrictEqual(expected);
expect(value).toBeDefined();
expect(value).toBeNull();
expect(value).toContain(item);
expect(value).toHaveLength(3);
expect(value).toHaveProperty('key', 'value');
expect(() => fn()).toThrow(ValidationError);
await expect(asyncFn()).resolves.toBe(value);
await expect(asyncFn()).rejects.toThrow(Error);
```

## Mocking
Mock boundaries:
- Database
- HTTP/external APIs
- Filesystem
- Email/queues
- Time/date when needed

Do not mock:
- Business logic
- Validation functions
- Pure transforms
- Internal helpers only to assert calls

## React / Component
- Use Testing Library queries by role/label/text, not test IDs by default
- Assert user-visible behavior and accessibility
- Use `findBy*`/`waitFor` for async UI

```tsx
render(<TaskForm onSubmit={onSubmit} />);
fireEvent.change(screen.getByRole('textbox', { name: /title/i }), {
  target: { value: 'New Task' },
});
fireEvent.click(screen.getByRole('button', { name: /create/i }));
await waitFor(() => expect(onSubmit).toHaveBeenCalledWith({ title: 'New Task' }));
```

## API / Integration
- Assert status, response shape, auth, validation errors
- Use test DB/fake services where practical

```typescript
await request(app)
  .post('/api/tasks')
  .send({ title: 'Test Task' })
  .set('Authorization', `Bearer ${testToken}`)
  .expect(201);
```

## E2E
- Reserve for critical flows
- Test through user-visible UI
- Avoid brittle selectors; prefer roles/labels
- Keep setup deterministic

## Anti-Patterns
| Issue | Fix |
|---|---|
| implementation-detail tests | assert behavior |
| snapshot everything | assert specific output |
| shared mutable state | setup/teardown per test |
| testing third-party code | mock boundary |
| skipped tests | fix or remove |
| broad assertions | make specific |
| missing async await | await promises/assertions |
