---
name: gpt56-delegation-review
description: Coordinate genuinely independent workstreams, or focused review requested by the user or likely to change a specific unresolved high-impact judgment. Use only when parallelism saves time or fresh judgment can change the result; risk labels alone are insufficient.
---

# GPT-5.6 Delegation & Review

Use additional agents or reviewers where independence creates real speed or decision value.

## Delegate independent outcomes

1. Split work by independent deliverables or read-only investigations with minimal shared mutable state.
2. Keep dependency chains and overlapping edits with one owner or sequence them explicitly.
3. Give each assignment only the outcome, scope, constraints, relevant context, expected evidence, and return format.
4. Continue useful local work while parallel tasks run.
5. Synthesize results, resolve contradictions against project evidence, and make one coherent final decision.

Avoid duplicating the same exploration unless independent comparison is the purpose. Do not delegate trivial work whose coordination cost exceeds its benefit.

## Request focused review

Use an independent review when the user requests it or a named unresolved high-impact judgment is likely to benefit from a second perspective. A security boundary, broad blast radius, or release gate is context, not sufficient justification by itself. Name the risk or questions to inspect. Ask for evidence-backed findings with severity, location, impact, and a concrete correction.

Evaluate every finding against current code, requirements, and project rules. Apply supported corrections; explain why unsupported or out-of-scope suggestions were not adopted.

## Completion

Report the integrated outcome rather than a transcript of agent activity. Include only decisions changed by delegation or review, unresolved conflicts, decisive evidence, and remaining risk.
