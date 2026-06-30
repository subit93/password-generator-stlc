---
name: pwg-defect-filter
description: >
  Filters PWG test failures into genuine defects vs known spec gaps.
  Use before filing Jira tickets to avoid creating noise tickets for
  documented mismatches between the spec and the application's current
  implementation. Referenced by both the HITL Gate and Defect Triage.
---

# Skill: PWG Defect Filter (Known Gap Detection)

Separates real failures from expected failures (known spec-vs-implementation mismatches) so only genuine defects reach Jira.

---

## When to Use
- Inside the HITL Gate (before presenting failures to the human)
- Inside the Defect Triage agent (before creating Jira tickets)
- When reviewing cucumber.json results to understand failure categories

---

## Known Gaps Registry

These failures are **expected** — do NOT create Jira tickets for them:

| Test ID | Feature | Scenario | Root Cause |
|---|---|---|---|
| TC-HIST-03 | History | History persists after page reload | App uses in-memory store, not `localStorage` — reload clears state |
| TC-HIST-06 | History | localStorage contains history key | Same root cause — no localStorage persistence |
| TC-PRE-01 | Presets | Banking preset sets length to 16 | App sets length to 20; spec says 16 |
| TC-PRE-02 | Presets | Banking preset matches spec | Same Banking length mismatch |
| TC-PRE-05 | Presets | Super Secure preset sets excludeAmbiguous ON | App sets it OFF; spec says ON |

---

## Filtering Logic

For each failed scenario received from the Executor:

```
for each failure:
  if failure.scenarioName matches any Known Gap entry:
    → classify as KNOWN_GAP
    → do NOT create Jira ticket
    → include in "Known Gaps" section of report only
  else:
    → classify as GENUINE_DEFECT
    → proceed to duplicate check then Jira creation
```

---

## Output Format

Return two lists to the caller:

```
FILTER_RESULT
  Genuine_Defects:
    - <Feature> > <Scenario> (TC-XXX)
  Known_Gaps:
    - <Scenario> (TC-HIST-03) — in-memory store gap
    - <Scenario> (TC-PRE-01)  — Banking length mismatch
```

---

## Adding New Known Gaps

When a new spec gap is discovered (agreed not to fix immediately):
1. Add it to the Known Gaps Registry table above
2. Record the reason clearly
3. Also update the Known Gaps table in `pwg-defect-triage.agent.md` and `pwg-reporter.agent.md`
4. Commit the update so future runs filter it automatically

---

## Constraints
- Never suppress a genuine defect by classifying it as a gap without evidence
- Match on scenario name (case-insensitive, partial match acceptable)
- If unsure whether a failure is a gap → treat as GENUINE_DEFECT and let the HITL human decide
