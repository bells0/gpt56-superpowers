---
name: agentic-purpose-bound-rigor
description: Prevent unjustified workflow defenses during software delivery. Use when an implementation, review, or plan proposes hashes, gates, isolation, fixtures, mocks, freezes, repeated reviews, broad reruns, environment re-probing, or extra coordination whose necessity is not already established. Do not invoke for ordinary direct work with no proposed process expansion.
---

# Agentic Purpose-Bound Rigor

Keep rigor proportional to observed risk. Do not weaken real safety boundaries; stop workflow ceremony from becoming a substitute for delivery.

## Default to the direct path

For local, reversible work, use:

```text
implement directly -> run the cheapest relevant check -> create the scoped commit -> continue
```

Treat explicit user facts about the environment, tools, and acceptance path as authoritative unless current evidence contradicts them.

Classify risk once:

- **Critical:** irreversible production data, money, credentials, permissions, privacy, external publication, or destructive migration. Apply strong controls matched to the concrete harm.
- **Material engineering:** shared contracts, concurrency, persistence, or user-state loss. Add only the focused protection justified by the affected boundary.
- **Local and reversible:** ordinary code, UI, tests, and local acceptance. Do not add special defenses by default.

## Require a necessity case

Before adding a non-default defense, state briefly:

1. **Measure:** What is being added?
2. **Protected outcome:** What exact result must it protect?
3. **Observed risk:** What current evidence shows the risk exists?
4. **Existing gap:** Why do current tests, Git history, permissions, recovery, or direct checks fail to protect it?
5. **Minimality:** Why is this the cheapest effective measure, and when does it stop?

Reject the measure if any answer is missing or merely says “for safety,” “best practice,” “possibly,” “future-proof,” or “for auditing.” Return to the direct path. Do not create a document or approval workflow merely to record this decision.

## Apply specific limits

- Use hashes to prove identity, not correctness. Prefer an existing commit when it already supplies traceability.
- Use mocks as regression support, never as a replacement for a requested real-path acceptance test.
- Add isolation only when the actual environment risks unacceptable contamination or destruction.
- Add a gate only when a concrete high-loss failure cannot be caught cheaply by an existing check.
- Run one focused check after a small change. Broaden only when the final claim, observed failure, dependency boundary, or project rule requires it.
- Use independent review for a named high-impact judgment or integrated multi-owner change, not every micro-commit.
- After two failed attempts with the same approach, change the approach or escalate the missing fact.
- When the user corrects an assumption, cancel work based on the stale assumption immediately.

Count user-visible behavior, verified fixes, real-path evidence, and scoped commits as progress. Do not count preflights, hashes, reports, agent dispatches, or repeated checks by themselves.
