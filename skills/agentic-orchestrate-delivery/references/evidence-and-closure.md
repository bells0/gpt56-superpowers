# Evidence, acceptance, and closure

## Match evidence to the claim

| Claim | Minimum useful evidence |
|---|---|
| Current implementation fact | Exact code, configuration, documentation, or runtime observation |
| Static artifact is valid | Diff plus relevant format, schema, or link check |
| Bug is fixed | Original symptom or stable reproduction path no longer fails |
| Behavior works | Focused automated check or smoke path covering changed behavior |
| Visual result is correct | Rendered inspection of affected states and dimensions |
| Integration is healthy | Affected type, build, contract, integration, or service-path check |
| Release is ready | Project-required gates plus checks justified by the release claim |

Start with the cheapest evidence capable of disproving the claim. Broaden only when the claim is broad, dependency impact is uncertain, a failure exposes adjacent risk, or project rules require it.

## Preserve real-path integrity

- Prefer observable user or service behavior over implementation ritual.
- Use mocks and fixtures for stable regression coverage, not as replacements for requested real-path acceptance.
- Record unavailable checks as gaps; do not silently substitute a weaker path.
- Treat worker and reviewer reports as pointers to evidence, not evidence by themselves.

## Keep two acceptance gates

Engineering verification answers: “Does the implementation support the technical claim?”

User acceptance answers: “Does the delivered behavior satisfy the agreed need in the intended workflow?”

Record the two independently. Tests passing does not imply user acceptance, and pending user acceptance does not erase valid engineering evidence.

## Close Git boundaries

- Map each independently acceptable and revertible outcome to one local commit.
- Verify and commit an accepted boundary before dependent work consumes it.
- Stage only owned paths or hunks and inspect the staged diff.
- Commit child repositories before updating and committing parent gitlinks or pointers.
- Preserve unrelated dirty state and report it.
- Leave proposed, incomplete, failed, blocked, rejected, explicitly opted-out, or unsafe-to-isolate work uncommitted.
- Never infer push, pull request, merge, tag, or force authority from local commit authority.

## Completion record

Report:

1. integrated outcome;
2. decisive commands, observations, and artifacts;
3. review findings and disposition;
4. engineering verification state;
5. user acceptance state;
6. documentation updated;
7. commit hashes by repository and boundary;
8. preserved user changes;
9. remaining gaps, owner, and next safe action.
