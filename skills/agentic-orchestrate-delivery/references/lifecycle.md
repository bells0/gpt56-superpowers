# Delivery lifecycle and gates

Use this state model to keep long-running delivery coherent. The controller owns every transition.

## 1. Current truth

Produce a compact map of relevant repository structure, behavior, tests, documentation, Git topology, dirty state, and external constraints.

Exit when:

- important claims are sourced;
- the affected boundaries and unknowns are named;
- no proposed design is described as existing behavior.

## 2. Spec

Define user-visible goals, non-goals, domain semantics, interfaces, failure behavior, compatibility, and acceptance criteria. Reuse an already approved source instead of duplicating it.

Exit when implementation no longer requires a consequential product, architecture, migration, permission, or compatibility decision.

## 3. Plan

Split the result into independently acceptable outcomes. Record dependency order, mutable ownership, stable interfaces, focused evidence, acceptance gates, and atomic commit boundaries.

Exit when every implementer can work without making an upstream semantic decision and shared-file ownership is unambiguous.

## 4. Execution

Dispatch bounded work or implement coupled work in the controller thread. Integrate each accepted boundary before dependent work consumes it.

Exit when the planned behavior exists in the integrated working tree and every worker concern has an owner or disposition.

## 5. Independent review

Review actual requirements, diff, and evidence. Findings must identify location, impact, and correction. Re-review only the fix boundary and prior findings unless new high-impact evidence appears.

Exit when critical and important findings are addressed or explicitly accepted by the authorized decision owner.

## 6. Engineering verification

Match checks to claims, starting narrow and broadening only for affected dependency boundaries, project gates, observed failures, or a broad release claim.

Exit when each material claim has supporting evidence and every unverified claim is narrowed or disclosed.

## 7. User acceptance

Exercise or present the agreed user path. Record `ACCEPTED`, `PENDING`, `REJECTED`, or `NOT_REQUIRED`, plus the basis.

Exit when the user or authorized acceptance owner has decided, or when pending acceptance is explicitly carried as an open gate.

## 8. Documentation and Git closure

Update current-truth documentation and reconcile child and parent repositories. The Agent automatically creates or selects the isolated feature branch, protects or safely migrates dirty default-branch work, makes scoped commits, pushes, and creates or updates the evidence-bearing PR unless delivery is explicitly local-only. Do not ask the user to perform or separately approve these mechanics. Merge only with explicit authority after independent approval and required checks pass; clean branches automatically after confirmed merge only when no unmerged work or open dependency remains.

Exit when repository state, evidence, commits, PR, checks, approval, merge state, preserved changes, acceptance state, and remaining gaps are accurately reported.

## Backward transitions

- New requirement or changed intent -> Spec.
- Invalidated interface or ownership -> Plan.
- Implementation defect -> Execution.
- Unsupported completion claim -> Verification.
- User rejection caused by misunderstood behavior -> Spec, not cosmetic patching.

Do not keep progressing on stale authority after a backward transition.
