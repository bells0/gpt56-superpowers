---
name: gpt56-delegation-review
description: Coordinate genuinely independent workstreams, or focused review requested by the user or likely to change a specific unresolved high-impact judgment. Use only when parallelism saves time or fresh judgment can change the result; risk labels alone are insufficient. Optimize GPT-5.6 Sol as controller and use cheaper workers only for bounded, independently checkable work.
---

# GPT-5.6 Sol Delegation & Review

Use additional agents or reviewers where independence creates real speed or decision value. Keep Sol accountable for decomposition, conflicts, consequential judgment, and final synthesis.

## Choose the execution owner

- Keep ambiguous, tightly coupled, write-heavy, high-impact, or cross-domain work with Sol.
- When model routing is supported, prefer Terra for bounded read-heavy exploration, code mapping, log analysis, routine test execution, or supporting-document synthesis.
- Keep shared mutable state and overlapping edits with one owner. Parallelize writes only across clearly isolated artifacts with stable interfaces.
- Do not override a user-pinned model or reasoning effort. If routing controls are unavailable, delegate without inventing a configuration.
- Do not increase reasoning effort by default. Use stronger effort only when the assigned judgment actually requires it.

## Delegate independent outcomes

1. Split work by independent deliverables or read-only investigations with minimal shared mutable state.
2. Keep dependency chains and overlapping edits with one owner or sequence them explicitly.
3. Give each assignment only the outcome, scope, constraints, relevant context, expected evidence, and return format.
4. Prefer fresh, task-local context. Do not leak the desired conclusion into an investigation or review.
5. Continue useful controller work while parallel tasks run.
6. Synthesize results, resolve contradictions against project evidence, and make one coherent final decision.

Avoid duplicating the same exploration unless independent comparison is the purpose. Do not delegate trivial work whose coordination cost exceeds its benefit.

## Request focused review

Use an independent review when the user requests it or a named unresolved high-impact judgment is likely to benefit from a second perspective. A security boundary, broad blast radius, or release gate is context, not sufficient justification by itself. Name the risk or questions to inspect. Ask for evidence-backed findings with severity, location, impact, and a concrete correction.

Keep the reviewer independent from the implementer's rationale. Evaluate every finding against current code, requirements, and project rules. Apply supported corrections; explain why unsupported or out-of-scope suggestions were not adopted.

## Completion

Report the integrated outcome rather than a transcript of agent activity. Include only decisions changed by delegation or review, unresolved conflicts, decisive evidence, and remaining risk.
