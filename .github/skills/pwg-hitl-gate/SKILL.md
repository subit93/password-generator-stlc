---
name: pwg-hitl-gate
description: >
  Human-in-the-Loop checkpoint for the PWG STLC pipeline.
  Pauses execution after Phase 5 when failures are found, presents a
  structured decision prompt, handles YES / NO / SHOW DETAILS / READ
  responses, enforces a 15-minute timeout, and writes the decision to
  hitl-audit.log. Never proceeds to Defect Triage without explicit YES.
---

# Skill: PWG HITL Gate

Manages the Human-in-the-Loop checkpoint between Phase 5 (Test Execution) and Phase 5b (Defect Triage).

---

## When to Use
- After `EXECUTOR_RESULT` is received with `Failed > 0`
- When the Orchestrator reaches STEP 4 of the pipeline
- Any time a human must approve Jira bug filing before it proceeds

## Skip Condition
If `Failed == 0` → skip this skill entirely, jump directly to Phase 6.

---

## Step 1 — Filter Genuine Failures vs Known Gaps

Before presenting the prompt, split failures into two groups:

**Known Gaps (DO NOT file tickets):**
| Test ID | Scenario |
|---|---|
| TC-HIST-03 | History persists after reload |
| TC-HIST-06 | localStorage stores history |
| TC-PRE-01/02 | Banking preset length = 16 |
| TC-PRE-05 | Super Secure excludeAmbiguous ON |

- Any failure matching a Known Gap → mark `KNOWN_GAP`
- All others → mark `GENUINE_DEFECT`
- If **all** failures are Known Gaps → auto-skip: log `HITL_AUTO_SKIP` and proceed to Phase 6 without prompting

---

## Step 2 — Display HITL Checkpoint

Present this box and **PAUSE — wait for human response**:

```
╔══════════════════════════════════════════════════════════════╗
║   ⚠️  HITL CHECKPOINT — HUMAN APPROVAL REQUIRED             ║
╠══════════════════════════════════════════════════════════════╣
║  Phase 5 found <N> failure(s) that may need Jira bug tickets ║
╠══════════════════════════════════════════════════════════════╣
║  GENUINE FAILURES (after filtering known spec gaps):         ║
║    [list each: Feature > Scenario > first error line]        ║
║                                                              ║
║  KNOWN SPEC GAPS (will be SKIPPED — not real bugs):          ║
║    [list any known gaps found]                               ║
╠══════════════════════════════════════════════════════════════╣
║  What would you like to do?                                  ║
║   YES          → File Jira bug tickets for genuine failures  ║
║   NO           → Skip bug filing, proceed to Phase 6 report  ║
║   SHOW DETAILS → Show full error + stack trace per failure   ║
║   READ         → Reprint this summary (resets your 15 min)   ║
╠══════════════════════════════════════════════════════════════╣
║  ⏳ Take your time — the pipeline is paused.                 ║
║     You have 15 minutes to respond before timeout.           ║
║     Timeout default action: NO (triage skipped).             ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Step 3 — Handle Response

| User Input | Action |
|---|---|
| `YES` | Log `HITL_DECISION: YES`, hand off to Defect Triage agent |
| `NO` | Log `HITL_DECISION: NO`, skip triage, proceed to Phase 6 |
| `SHOW DETAILS` | Read `cucumber.json`, print full `error_message` per genuine failure, re-display checkpoint. Reset 15-min timer. |
| `READ` | Reprint the checkpoint box unchanged. Log `HITL_READ_REQUESTED`. Reset 15-min timer. |
| *(unrecognised)* | Reply: `⚠️ Unrecognised response: "<input>". Please reply with: YES \| NO \| SHOW DETAILS \| READ`. Log `HITL_INVALID_INPUT: <input>`. Re-display checkpoint. Do NOT default to NO. |
| *(15 min timeout)* | Apply NO. Log `HITL_TIMEOUT: 15 min elapsed — defaulted to NO`. Add to final summary. |

---

## Step 4 — Write Audit Entry

Immediately after any decision (YES / NO / TIMEOUT / AUTO_SKIP), run:

```powershell
$auditLog  = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports\hitl-audit.log"
$runId     = (Get-ChildItem "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports" -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1).Name
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$decision  = "<YES|NO|TIMEOUT|AUTO_SKIP>"
$genuine   = "<comma-separated TC IDs or NONE>"
$gaps      = "<comma-separated TC IDs or NONE>"
$tickets   = "<comma-separated KAN IDs or PENDING if YES not yet triaged>"
$mode      = "interactive"
$entry = "[$timestamp] Run: $runId | Decision: $decision | Genuine: $genuine | Gaps skipped: $gaps | Tickets filed: $tickets | Mode: $mode"
Add-Content -Path $auditLog -Value $entry -Encoding UTF8
Write-Host "HITL_AUDIT_WRITTEN: $entry"
```

- File is **append-only** — never overwrite
- `Add-Content` creates the file automatically if it does not exist

---

## Constraints
- **NEVER call Defect Triage without explicit human YES**
- **NEVER proceed past this gate automatically** when failures exist
- **NEVER treat unrecognised input as NO** — always re-prompt
- Only timeout (15 min) may default to NO
- If user does not respond in this turn, re-surface the prompt at the start of the next response
