---
name: pwg-living-walkthrough
description: >
  Updates the POC_STLC_Walkthrough.feature file with the latest test
  run statistics after every pipeline execution. This keeps the feature
  file as a living document that always reflects the most recent run.
  Used by the Orchestrator in STEP 7c.
---

# Skill: PWG Living Walkthrough Updater

Injects the latest run statistics into `POC_STLC_Walkthrough.feature` so it acts as a self-updating living record of the project's test health.

---

## When to Use
- After every pipeline run, as part of STEP 7 (Orchestrator log updates)
- When the walkthrough has gone stale and needs to be refreshed manually
- When `run-tests.ps1` Step 8 did not complete and the file was not auto-updated

---

## File Location
`c:\Users\subit_mishra\Documents\AITask\Copilot_POC\POC_STLC_Walkthrough.feature`

---

## Step 1 — Check If Already Updated

```powershell
$walkthroughFile = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\POC_STLC_Walkthrough.feature"
if (Select-String -Path $walkthroughFile -Pattern "<<LAST_RUN_START>>" -Quiet) {
    Write-Host "WALKTHROUGH_UPDATED: Last run block found — auto-update by run-tests.ps1 succeeded."
} else {
    Write-Host "WALKTHROUGH_NOT_UPDATED: Block not found — proceed to Step 2."
}
```

If `WALKTHROUGH_UPDATED` → skip to verification. If not → proceed to Step 2.

---

## Step 2 — Read Run Stats

Collect the following values (from `cucumber.json` or `EXECUTOR_RESULT`):
- `<run_count>` — run number (e.g. `Run#7`)
- `<dd-MM-yyyy HH:mm>` — timestamp of the run
- `<total>`, `<passed>`, `<failed>`, `<skipped>` — scenario counts
- `<report_path>` — relative path to PWGTestReport.html

---

## Step 3 — Inject / Replace the Stats Block

The stats block sits between the `<<LAST_RUN_START>>` and `<<LAST_RUN_END>>` markers.
Replace the entire block with fresh values:

```
# <<LAST_RUN_START>>
# ┌──────────────────────────────────────────────────────────────────────────────┐
# │  LAST RUN STATS (auto-updated after every pipeline execution)                │
# │  Run #   : <run_count>                                                       │
# │  Date    : <dd-MM-yyyy HH:mm>                                                │
# │  Total   : <total>    Passed : <passed>    Failed : <failed>    Skipped : <skipped> │
# │  Report  : <report_path>                                                     │
# └──────────────────────────────────────────────────────────────────────────────┘
# <<LAST_RUN_END>>
```

Use `replace_string_in_file` to swap the old block for the new one — do NOT rewrite the whole file.

---

## Step 4 — Verify

After writing, confirm the marker is present:
```powershell
Select-String -Path "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\POC_STLC_Walkthrough.feature" -Pattern "LAST_RUN_START"
```
- ✅ Found → log `WALKTHROUGH_INJECTED`
- ❌ Not found → log `WALKTHROUGH_INJECT_FAILED` and include in final summary

---

## Constraints
- Only update the block between the two markers — never alter the rest of the feature file
- Use `replace_string_in_file` (not full file rewrite)
- Log `WALKTHROUGH_INJECTED` or `WALKTHROUGH_INJECT_FAILED` in the Orchestrator Final Summary
- This step is mandatory — run it even when all tests pass
