---
name: gpt56-design-planning
description: Resolve material ambiguity in product behavior, UX, scope, architecture, interfaces, data flow, migrations, permissions, or sequencing. Use when plausible choices have consequential tradeoffs or completion cannot be defined safely from available context.
---

# GPT-5.6 Design & Planning

Turn consequential ambiguity into an implementable direction. Clear local edits do not need this Skill.

## Resolve the decision

1. Inspect the project patterns, artifacts, user intent, and hard constraints.
2. Separate fixed requirements from choices that materially affect behavior, compatibility, cost, or reversibility.
3. Compare only plausible options. Recommend one when evidence supports it; ask the user only when the missing preference would change the outcome.
4. Define the chosen direction at the level implementation needs:
   - outcome and non-goals;
   - interfaces, state, data flow, and failure behavior when relevant;
   - migration or compatibility boundaries;
   - acceptance evidence.
5. Check that the direction fits existing conventions and does not silently expand scope.

## Plan only useful dependencies

Create a compact plan when work spans dependent deliverables, multiple owners, or a risky transition. Organize it by outcomes and dependencies, not tiny actions. Each step should identify the artifact or behavior it produces and the evidence that closes it.

For low-cost and reversible choices, state a reasonable assumption and proceed. Record durable decisions where the project expects them.

## Completion

Deliver the recommendation or decision, its decisive tradeoff, affected boundaries, acceptance conditions, and any unresolved choice that genuinely blocks implementation.
