---
name: agentic-superpowers
description: Coordinate requests that require two or more material decision domains whose ordering or synthesis affects success. Use direct reasoning first and add planning, delegation, review, or other process only when it changes the outcome. Exclude routine diagnose-change-check loops, one clear edit, and standalone narrow tasks.
---

# Agentic Superpowers

Use one accountable controller to maintain the contract, make coherent cross-domain decisions, and own synthesis and completion. Add process only to prevent a specific likely failure.

## Establish the contract

Resolve these from the request and available evidence before acting:

- **Goal:** user-visible result.
- **Success:** observable completion conditions.
- **Constraints:** project rules, scope, compatibility, and explicit values.
- **Evidence:** artifacts or checks needed to support important decisions and claims.
- **Permission:** authorized local and external actions.
- **Stop:** completion, escalation, fallback, or blocker condition.

Inspect context before asking. Infer low-cost, reversible choices and proceed. Ask only when a missing choice would materially change the result and cannot be inferred safely.

## Use the controller's capability directly

- Execute bounded, reversible work directly. Do not manufacture phases, reviews, or agents for a simple task.
- Express plans through outcomes, dependencies, and closing evidence rather than tiny actions or prescribed reasoning.
- Preserve user-provided values and established project behavior. For implicit choices, apply explicit decision criteria instead of universal defaults.
- Keep the current layer clear: research, design, implementation, review, or external coordination. Move layers intentionally when the contract requires it.
- Continue authorized in-scope local work until success or a real stop condition. Do not pause merely to narrate routine progress.
- Treat the selected reasoning effort as the baseline. Tighten goals, constraints, tool routing, or verification before escalating effort; never require `max` or `ultra` globally.

## Route by dependency

1. Identify the material decision domains and their dependencies. Ordinary implementation and its routine check are not separate domains.
2. Keep dependent work sequential. Parallelize only genuinely independent outcomes where saved time or independent judgment exceeds coordination cost.
3. Load only sibling Skills whose instructions can change a material decision. A typical task needs no more than one or two alongside this core.
4. Keep ambiguity, tightly coupled work, shared mutable state, and final synthesis with the controller. When model routing is available, use a lower-cost worker only for bounded work whose evidence can be checked independently.
5. Ground choices in project evidence, preserve unrelated user changes, and implement the smallest coherent result.
6. Synthesize outcomes across phases before claiming completion.

The sibling Skills own material design ambiguity, implementation-ready plans, justified worktree isolation, suitable plan execution through subagents, non-obvious debugging, proportionate verification, focused delegation or review, and Git delivery. Use `agentic-writing-plans` after requirements settle; use `agentic-subagent-driven-development` only when that plan contains independently ownable outcomes. A narrow task can invoke one sibling directly without this core.

## Permission and completion

Read-only requests authorize inspection and reporting. Change requests authorize in-scope local edits and relevant non-destructive checks. Obtain specific authority for external writes, destructive operations, purchases, force pushes, permanent discard, or material scope expansion unless the current request already grants it.

Finish when success conditions have matching evidence. Commit each acceptable repository outcome at its approved atomic boundary; exclude read-only, proposed, incomplete, failed, blocked, empty, or unsafe work. Use `agentic-git-delivery` for feature-branch push, PR evidence, independent approval, required checks, and merge. The implementer cannot approve; explicit local-only instructions stop before remote delivery.

Report the outcome first, then decisive evidence, material gaps, the commit result, and a next action only when one remains.
