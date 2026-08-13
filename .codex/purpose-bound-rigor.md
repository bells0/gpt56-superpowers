## Purpose-bound rigor

- For local, reversible work, default to direct implementation, the cheapest relevant check, and a scoped commit.
- Before adding a hash, gate, isolation layer, fixture, mock, freeze, repeated review, broad rerun, environment re-probe, or extra agent, briefly name the exact outcome protected, current evidence that the risk exists, why existing controls are insufficient, and why the proposal is the cheapest effective measure. If any answer is missing, do not add it.
- Preserve strong controls for concrete irreversible, production, money, credential, permission, privacy, publication, destructive-migration, or demonstrated consistency risks.
- Treat explicit user statements about the environment, tools, and acceptance path as authoritative unless current evidence contradicts them. Cancel work based on a corrected assumption.
- Mocks may supplement regression coverage but never replace a requested real-path acceptance test. After two failed attempts with the same approach, change the approach or surface the genuinely missing fact.
