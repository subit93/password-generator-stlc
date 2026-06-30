---
name: pwg-auto-close-tickets
description: >
  Detects previously-filed Jira defect tickets whose scenarios are now
  passing in the current test run, and auto-transitions them to Done.
  Adds an explanatory comment before closing. Prevents stale open
  tickets after a bug is silently fixed. Used by the PWG Test Executor.
---

# Skill: PWG Auto-Close Healed Jira Tickets

After each test run, identifies open Jira bug tickets that correspond to scenarios that are now passing, and automatically closes them with an audit comment.

---

## When to Use
- After `cucumber.json` is parsed and passing scenarios are known (Executor STEP 4)
- Any time you want to check whether previously-reported defects have been resolved
- During pipeline runs to keep the Jira board clean

---

## Step 1 — Find Open Defect Tickets

Call `mcp_jira_execute_jql`:
```jql
project = KAN AND summary ~ "[PWG][BUG]" AND status != Done ORDER BY created DESC
```

- If no tickets returned → log `AUTO_CLOSE_CHECK: no open defect tickets found` and skip
- If tickets returned → proceed to Step 2

---

## Step 2 — Match Against Passing Scenarios

For each open ticket returned:
1. Extract the scenario name from the ticket summary (strip the `[PWG][BUG]` prefix)
2. Check if that scenario name appears in the **PASSED** list from the current `cucumber.json`
3. Match is case-insensitive, partial match acceptable

- Match found → mark ticket as `HEALED`, proceed to Step 3
- No match → ticket still failing or not run — leave open, skip

---

## Step 3 — Add Comment and Close

For each healed ticket:

**Add comment via `mcp_jira_edit_ticket`:**
```
✅ AUTO-CLOSED by PWG Automation Suite
Run ID  : <run_id>
Date    : <date>
Result  : Scenario now PASSING — defect appears to be resolved.
Action  : Moving ticket to Done. Manual verification recommended before sprint sign-off.
```

Then transition the ticket status to `Done`.

Log: `AUTO_CLOSE: <KAN-XX> — <scenario name> now passing`

---

## Step 4 — Return Results

Include in `EXECUTOR_RESULT`:
```
Auto_Closed_Tickets:
  - KAN-XX : <scenario name> → status set to Done
  - KAN-XY : <scenario name> → status set to Done
```

If none were closed:
```
Auto_Closed_Tickets: NONE
```

---

## Constraints
- Only close tickets where the scenario is **fully passing** — not skipped or pending
- Do NOT close tickets for Known Gap scenarios — gaps closing is a deliberate product decision
- Do NOT create new tickets in this skill — that is the Defect Triage agent's job
- Maximum 10 auto-closures per run — if more, report and ask for confirmation
- If `mcp_jira_execute_jql` fails (API error), log the error and skip auto-close without failing the pipeline
