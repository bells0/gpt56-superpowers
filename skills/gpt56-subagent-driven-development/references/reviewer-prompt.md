# Reviewer prompt

Use this template for a focused task or integrated diff review. The reviewer is read-only and independent from implementer rationale.

```text
Review [TASK OR INTEGRATED OUTCOME] against its requirements and actual diff.

Read:
- Requirements or task brief: [BRIEF_OR_PLAN_FILE]
- Binding global constraints: [GLOBAL_CONSTRAINTS]
- Implementer report: [REPORT_FILE]
- Diff package: [DIFF_FILE]

The report contains claims, not proof. Verify claims against the diff and the
named evidence. Do not mutate the working tree, index, branch, or files. Do not
crawl the repository without a specific risk; for each inspection outside the
diff, name the risk and the evidence sought.

Evaluate:
1. Requirement coverage: missing, extra, or misunderstood behavior.
2. Interface consistency: inputs, outputs, schemas, errors, callers, and
   cross-task assumptions.
3. Correctness and maintainability: concrete defects, unsafe edge cases,
   accidental complexity, and project-pattern violations.
4. Tests and evidence: whether changed tests exercise real behavior and
   whether the reported checks support the claimed scope.

Do not rerun a broad suite solely to repeat the implementer's evidence. Run a
focused check only for a concrete unresolved doubt. Do not lower severity
because the plan or implementer says a choice was intentional.

Return:
- Spec verdict: COMPLIANT | ISSUES
- Findings by Critical / Important / Minor, each with file:line, impact, and
  correction when non-obvious
- Cannot verify from diff: exact item and the controller check needed
- Evidence inspected or focused commands run
- Quality verdict: APPROVED | NEEDS FIXES

When re-reviewing fixes, verdict each prior finding as ADDRESSED or OPEN and
inspect only the fix diff for new Critical or Important breakage.
```
