# Delegation and review

Delegate to reduce elapsed time or add independent judgment, not to manufacture process.

## Delegate when

- two or more tasks are independent and can run without shared mutable state;
- one bounded investigation would otherwise block useful local work;
- a specialized domain or large search space benefits from focused context;
- a high-risk or materially uncertain change needs a fresh review.

Keep dependent work with one owner or sequence it. Give each agent a concrete deliverable, scope, constraints, and expected evidence. After parallel work, synthesize conflicts and decide before editing.

Do not delegate a trivial mechanical step, duplicate the same investigation without a reason, or create implementer, spec reviewer, and quality reviewer agents for every task.

## Review level

- Low risk: self-review the final diff.
- Medium risk: review the coherent feature once when uncertainty or blast radius warrants it.
- High risk with material uncertainty, blast radius, a security boundary, or a release gate: obtain an independent review focused on correctness, security, compatibility, and missing validation.

Review findings are evidence to evaluate, not commands. Check each suggestion against current code, user decisions, project rules, and backward compatibility. Group clear independent fixes; ask only when an unresolved point materially changes the result.

## Reviewer brief

Provide:

- intended outcome and non-goals;
- exact diff or files in scope;
- known risks and decisions;
- validation already run;
- questions that require independent judgment.

Ask for actionable findings with severity and file evidence. A clean review does not replace testing, and testing does not replace review of product or security assumptions.
