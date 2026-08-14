# Implementer prompt

Use this template for a bounded implementation assignment. Replace every bracketed field.

```text
You own [TASK / OUTCOME].

Read first:
- Task brief: [BRIEF_FILE]
- Repository instructions: [INSTRUCTION_FILES]

Ownership:
- You may edit: [OWNED_PATHS OR RESPONSIBILITY]
- You may inspect: [RELEVANT_SCOPE]
- You are not alone in the codebase. Do not revert, overwrite, stage, or
  reorganize work owned by others. Adapt to concurrent changes and stop if
  an interface or file-ownership conflict appears.

Context and interfaces:
[ONLY THE CONTEXT, INPUTS, OUTPUTS, AND GLOBAL CONSTRAINTS THIS TASK NEEDS]

Required evidence:
[FOCUSED COMMANDS, OBSERVATIONS, OR ARTIFACTS]

Do not broaden scope or make a consequential architecture, product, migration,
or compatibility decision. Ask for the missing decision or return
NEEDS_CONTEXT. Follow existing project patterns. Do not commit unless commit
ownership is explicitly assigned. This worker rule is not a global delivery
opt-out: after integration and completion, the controller uses
gpt56-git-delivery for the approved atomic completion commit at each accepted
task boundary.

Write the detailed report to [REPORT_FILE]:
- status: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
- files changed and behavior implemented
- commands run and relevant results
- assumptions, concerns, conflicts, and remaining work

Return only the status, one-line outcome, one-line evidence summary, concerns,
and report path. Keep the detailed trace in the report file.
```
