---
name: pwg-test-runner
description: >
  Runs the PWG Cucumber/Maven test suite via run-tests.ps1 and parses
  the results from cucumber.json. Handles app startup, test execution,
  result extraction, and returns a structured EXECUTOR_RESULT block.
  Used by the PWG Test Executor agent (Phase 5).
---

# Skill: PWG Test Runner

Executes the full PWG automation test suite and returns structured pass/fail results.

---

## When to Use
- Phase 5 of the STLC pipeline (triggered by Orchestrator STEP 3)
- When manually re-running the test suite after a fix
- When running a filtered subset of tests (by tag)

---

## Inputs

| Parameter | Default | Description |
|---|---|---|
| `BaseUrl` | `http://localhost:3000` | URL of the app under test |
| `Browser` | `edge-headless` | Browser driver to use |
| `Tags` | *(empty — run all)* | Cucumber tag expression to filter scenarios |

---

## Step 1 — Execute run-tests.ps1

```powershell
cd "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation"
powershell -ExecutionPolicy Bypass -File "scripts\run-tests.ps1" -BaseUrl "http://localhost:3000" -Browser "edge-headless"
```

- The script handles: app startup check, Maven execution, ExtentReport generation, run-history.log update, walkthrough update
- Wait for `EXECUTION_COMPLETE` or `EXECUTION_FAILED` marker in output
- Timeout: allow up to 10 minutes for a full suite run

---

## Step 2 — Read and Parse cucumber.json

**File path:**
`c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\target\cucumber-reports\cucumber.json`

For each feature → for each scenario, extract:
- Feature name
- Scenario name
- Status: `passed` | `failed` | `skipped`
- For failed: `result.error_message` (first 3 lines only)

If the file does not exist after the run → return `Status: FAILED` with reason `cucumber.json not produced`.

---

## Step 3 — Count Results

```
Total   = passed + failed + skipped
Passed  = count of scenarios where all steps passed
Failed  = count of scenarios where any step failed
Skipped = count of scenarios with pending/skipped steps
```

---

## Step 4 — Locate Report

Find the latest report directory:
```powershell
$reportsBase = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports"
$latestReport = (Get-ChildItem $reportsBase -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
$reportHtml = "$latestReport\PWGTestReport.html"
```

---

## Step 5 — Return EXECUTOR_RESULT

```
EXECUTOR_RESULT
  Status  : COMPLETE | FAILED
  Total   : <number>
  Passed  : <number>
  Failed  : <number>
  Skipped : <number>
  Report  : <path to PWGTestReport.html>
  Failed_Scenarios:
    - <Feature> > <Scenario> : <first error line>
  Auto_Closed_Tickets:
    - KAN-XX : <scenario name> → status set to Done
    (or: NONE)
```

---

## Constraints
- Do NOT interpret or analyse results — return raw counts and names only
- Do NOT file new Jira tickets — that is the Defect Triage agent's job
- Do NOT modify any source files, feature files, or test code
- Auto-close check (STEP 4 of Executor agent) runs via the `pwg-auto-close-tickets` skill
- If `cucumber.json` is missing → return `FAILED` immediately, do not guess counts
- Pass all Failed_Scenarios back to Orchestrator exactly as read — do not filter gaps here
