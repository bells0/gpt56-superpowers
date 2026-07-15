# Debugging

Use the shortest evidence path that can distinguish cause from symptom.

## Fast path

For a local, deterministic, well-understood failure:

1. Reproduce or inspect the concrete error.
2. Trace the failing value or control path to its source.
3. Form one falsifiable cause.
4. Make the smallest fix.
5. Verify the original symptom and nearby regression risk.

Do not expand a direct typo, stale path, schema mismatch, or obvious boundary error into a mandatory four-phase investigation.

## Escalate the investigation

Use a fuller investigation when the failure is intermittent, multi-component, environment-dependent, security-sensitive, data-corrupting, or still unexplained after one evidence-backed attempt.

Collect facts at boundaries:

- exact inputs, outputs, state, and timing;
- the first layer where expected and actual behavior diverge;
- relevant configuration, versions, and recent changes;
- a known-good comparison when available.

Change one explanatory variable at a time. Prefer instrumentation at the suspected boundary over speculative fixes across multiple layers. If three coherent attempts fail, reassess the model of the system, hidden coupling, and architectural assumptions before adding another patch.

## Root cause and regression

Fix the earliest controllable cause, not only the downstream exception. Add defensive handling when invalid input is an expected runtime condition; fix the producer when the invalid state should be impossible.

Verify the original symptom after the fix. Add an automated regression test when it is reliable and proportionate; otherwise keep a deterministic reproduction. Report any environment or coverage gap plainly.
