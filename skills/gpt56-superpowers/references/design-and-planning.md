# Design and planning

Use this reference only when choices about product behavior, UX, architecture, scope, or sequencing could materially change the result.

## Decide whether design is needed

Skip a design phase when the desired behavior is explicit, the change is local and reversible, and existing project patterns determine the implementation.

Do a short design pass when at least one condition holds:

- multiple plausible choices have meaningful user or technical tradeoffs;
- a public interface, persistent data, permissions, or cross-module flow changes;
- the task is too ambiguous to define completion safely;
- the work needs a durable handoff to another person or session.

Inspect project context before asking questions. Ask for the smallest missing decision. Offer alternatives only when there is a real tradeoff; recommend one and explain the decisive reason.

## Compact design record

Capture only what changes implementation:

- Outcome and non-goals
- Current constraints and relevant existing patterns
- Chosen direction and rejected alternative when consequential
- Data flow, state transitions, interfaces, or failure behavior
- Security, privacy, migration, and compatibility concerns when applicable
- Acceptance checks and genuinely open questions

Do not require a design document, user approval ceremony, or commit for a straightforward change. Persist a record when the decision will matter later, the project requires it, or handoff value exceeds its maintenance cost.

## Planning rule

Plan by coherent deliverable, not by two-minute actions. Each item should name:

- the result and affected resources;
- dependencies or ordering;
- the proof of completion;
- a fallback or stop condition when failure is material.

Keep implementation details at the level needed to prevent ambiguity. Do not paste complete code into a plan unless the interface or algorithm itself is the decision.
