# Decision and escalation model

## Classify every exact detail

- **Provided:** stated by the user or an approved authority. Preserve it unless current evidence contradicts it.
- **Observed:** verified from code, configuration, runtime behavior, tests, documentation, or Git state. Record the source.
- **Proposed:** a reversible implementation choice supported by criteria. Mark it as a proposal until adopted.
- **Unresolved:** missing evidence or a decision required before safe progress. Name who or what can resolve it.

## Decide locally or escalate

Proceed with a stated assumption when the choice is low-cost, reversible, within scope, and does not alter user-visible semantics. Escalate when the choice changes product behavior, compatibility, irreversible data, money, credentials, permissions, privacy, publication, destructive migration, or the agreed acceptance path.

When escalating, provide:

1. the exact unresolved choice;
2. the evidence already inspected;
3. the plausible options and decisive tradeoff;
4. the recommended option when evidence supports one;
5. the work that can continue independently.

## Handle failure without looping

For a failed attempt, record the hypothesis, action, evidence, and what changed. A retry counts as the same approach when it keeps the same causal hypothesis and intervention.

After two failures with the same approach:

- change the hypothesis, tool, boundary, or implementation strategy;
- repair a defective Spec, Plan, or task brief;
- move tightly coupled work back to the controller; or
- report the genuinely missing fact or authority.

Do not add mocks, gates, isolation, broad reruns, extra reviewers, or repeated environment probes merely because progress is difficult. Add a control only when it protects a named outcome from an observed risk that existing controls do not cover, and it is the cheapest effective response.

## Stop conditions

Stop and report rather than guessing when:

- required authority is missing;
- repository evidence contradicts the accepted direction;
- ownership overlap makes concurrent writes unsafe;
- a real-path acceptance environment is unavailable and cannot be substituted honestly;
- the remaining action is destructive, external, or outside the granted scope.
