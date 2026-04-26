# Ideation Examples

Use these as rhythm references, not scripts.

## Example Pattern: Product Idea

Input: "Help small restaurants compete with delivery platforms."

Reframe:
> How might we help independent restaurants keep direct relationships with their best customers without paying marketplace commissions?

Questions:
1. Which pain matters most: acquisition, ordering, delivery, loyalty, margin?
2. Is the user owner, diner, or both?
3. What constraints: software only, budget, operations?

Useful variations:
- direct ordering toolkit
- pickup-first, no delivery
- regular-customer reorder loop
- restaurant collective
- SMS "your usual?" flow

Converged recommendation:
- Focus on repeat customers ordering direct.
- SMS-first, pickup-only MVP.
- Avoid delivery, marketplace discovery, POS integration, dashboards.

## Example Pattern: Existing Product Feature

Input: "Add real-time collaboration to our editor."

Reframe:
> How might we let multiple users work in one document without chaos?

Codebase-aware questions:
1. Same paragraph or separate sections?
2. 2-5 users or larger teams?
3. Competitive checkbox or differentiator?

Useful variations:
- presence only
- block-level locking
- async suggestions/comments
- branch-and-merge
- CRDT-based co-editing

Converged recommendation depends on context:
- Competitive checkbox: block-level locking or presence first.
- Differentiator: async suggestions or branch-and-merge.
- Avoid character-level CRDT unless the use case requires it.

## Example Pattern: Process Idea

Input: "Retrospectives are stale."

Reframe:
> How might we make retros produce visible change instead of recurring theater?

Questions:
1. Same topics, same voices, or no follow-through?
2. Team size and speaking dynamics?
3. What did the last useful retro do differently?

Useful variations:
- one action item max
- next retro starts by reviewing previous action
- async written retro
- anonymous topic collection
- one-question retro
- experiment-based retro

Converged recommendation:
- Fix output first: one action item, owner, deadline, review next retro.
- Add anonymous input if quiet voices are missing.
- Avoid new tools or elaborate facilitation until follow-through works.

## What Good Sessions Do
- Reframe the problem, not just the solution.
- Ask diagnostic questions before variations.
- Explain why each variation exists.
- Offer an opinion with rationale.
- Pressure-test value, feasibility, differentiation.
- Produce a concrete one-pager.
- Make the Not Doing list explicit.
- Adapt to product, codebase, or process context.
