---
name: pwg-audit-logger
description: >
  Writes append-only audit entries to the two PWG pipeline log files:
  run-history.log (one line per test run) and hitl-audit.log (one line
  per HITL decision). Never overwrites existing entries. Use after every
  pipeline run and every HITL gate decision.
---

# Skill: PWG Audit Logger

Maintains the two append-only audit trails that provide a cumulative record of every pipeline run and every human decision made at the HITL gate.

---

## When to Use
- After every test execution → write to `run-history.log`
- After every HITL gate decision (YES / NO / TIMEOUT / AUTO_SKIP) → write to `hitl-audit.log`
- When verifying logs are up to date (STEP 7a and 7b of Orchestrator)

---

## Log File 1 — run-history.log

**Path:** `c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports\run-history.log`

This file is written automatically by `run-tests.ps1` Step 9. After Phase 5 completes, verify it was written:

```powershell
$historyLog = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports\run-history.log"
if (Test-Path $historyLog) {
    $lines = (Get-Content $historyLog | Measure-Object -Line).Lines
    Write-Host "RUN_HISTORY_EXISTS: $lines run(s) recorded"
    Get-Content $historyLog | Select-Object -Last 3
} else {
    Write-Host "RUN_HISTORY_MISSING: run-tests.ps1 Step 9 may not have completed"
}
```

**Entry format (one line per run):**
```
[2026-06-29 14:25:40] Run#6 | FAIL | Total:69 Passed:68 Failed:1 Skipped:0 | Failed scenarios: TC-SEC-03 | Report:run_29-06-2026_14-19
[2026-06-29 15:10:00] Run#7 | PASS | Total:69 Passed:69 Failed:0 Skipped:0 | No failures | Report:run_29-06-2026_15-10
```

If the file is missing after a run, write the entry manually:
```powershell
$historyLog = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports\run-history.log"
$runNumber  = "<Run#N>"
$status     = "<PASS|FAIL>"
$total      = "<total>"; $passed = "<passed>"; $failed = "<failed>"; $skipped = "<skipped>"
$failures   = "<TC-IDs or 'No failures'>"
$reportDir  = "<run_DD-MM-YYYY_HH-mm>"
$timestamp  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$entry = "[$timestamp] $runNumber | $status | Total:$total Passed:$passed Failed:$failed Skipped:$skipped | Failed scenarios: $failures | Report:$reportDir"
Add-Content -Path $historyLog -Value $entry -Encoding UTF8
Write-Host "RUN_HISTORY_WRITTEN: $entry"
```

---

## Log File 2 — hitl-audit.log

**Path:** `c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports\hitl-audit.log`

Write immediately after every HITL gate decision. Replace all `<placeholders>` with actual values:

```powershell
$auditLog  = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports\hitl-audit.log"
$runId     = (Get-ChildItem "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1).Name
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$decision  = "<YES|NO|TIMEOUT|AUTO_SKIP>"
$genuine   = "<comma-separated TC IDs or NONE>"
$gaps      = "<comma-separated TC IDs or NONE>"
$tickets   = "<comma-separated KAN IDs or NONE>"
$mode      = "interactive"
$entry = "[$timestamp] Run: $runId | Decision: $decision | Genuine: $genuine | Gaps skipped: $gaps | Tickets filed: $tickets | Mode: $mode"
Add-Content -Path $auditLog -Value $entry -Encoding UTF8
Write-Host "HITL_AUDIT_WRITTEN: $entry"
```

Verify after writing:
```powershell
$auditLog = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports\hitl-audit.log"
if (Test-Path $auditLog) {
    Write-Host "HITL_AUDIT_EXISTS: $((Get-Content $auditLog | Measure-Object -Line).Lines) decision(s) recorded"
    Get-Content $auditLog | Select-Object -Last 3
} else {
    Write-Host "HITL_AUDIT_MISSING"
}
```

---

## Constraints
- Both files are **append-only** — NEVER overwrite or truncate
- `Add-Content` creates the file automatically if it does not exist — no need to create it first
- Replace all `<placeholders>` with real values before writing — never write template text to the log
- If writing fails, report the error in the final summary but do not halt the pipeline
