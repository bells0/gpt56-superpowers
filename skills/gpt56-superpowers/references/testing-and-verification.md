# Testing and verification

Match evidence to the claim and the risk. Verification protects the outcome; it is not a fixed ceremony.

## Claim to evidence

| Claim | Minimum useful evidence |
|---|---|
| A file or document was updated | Inspect the final diff and relevant format, schema, or links |
| A bug was fixed | Reproduce the original symptom or run a targeted regression check |
| Changed behavior works | Run the narrowest reliable test or smoke path that exercises it |
| A package still integrates | Run affected type, lint, build, or integration checks |
| A visual change is correct | Render the affected viewport or artifact and inspect layout, clipping, spacing, responsive states, and missing content |
| The branch is release-ready | Run the project-required suite and broader checks justified by release risk |

Never convert “could not run” into “passed.” State the gap and the next best check.

## Select validation

- Low risk: diff plus deterministic static checks; add a smoke test only when it can catch a plausible error.
- Medium risk: targeted regression or reproduction first, then checks for affected packages.
- High risk: targeted regression plus relevant integration, build, security, migration, or compatibility checks. Use the full suite when project rules or release impact require it.
- Visual work: render and inspect the affected states; visual evidence is the targeted check, not a reason to run every unrelated test.

Prefer the narrow check that directly tests the changed behavior. Broaden after a relevant failure, an unclear dependency boundary, or a release-readiness claim.

## TDD decision

Use fail-first TDD when behavior has meaningful regression risk, a reliable automated test is practical, and observing the failure improves confidence that the test detects the issue.

Do not require TDD for documentation, prompt text, static metadata, visual-only adjustments, generated artifacts, exploratory prototypes, or systems without a viable harness. Do not delete sound implementation merely because the test was written later.

For a bug, preserve a regression test when it is stable and valuable. Otherwise record a deterministic reproduction or smoke check. Avoid testing private implementation details, every helper method, or behavior already guaranteed by a lower layer.

## Finish

Run each expensive check once after the relevant change set is coherent. Repeat only when subsequent edits can invalidate it. Summarize commands and outcomes; include full logs only when needed to diagnose a failure.
