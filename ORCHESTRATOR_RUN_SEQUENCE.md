# PWG STLC Orchestrator — Full Run Sequence

> Every time you type `"Run STLC"`, the Orchestrator executes the following steps in this exact order.

---

## Step 0 — Parse Input & Set Scope

- Reads what you typed (e.g. `"Run STLC"`, `"run from phase 5"`, `"run @security only"`)
- Sets the start phase (default: Phase 4) and any tag filters (default: all)
- Builds the todo list for this run so progress is visible

---

## Step 1 — Pre-flight Checks *(4 checks, all must pass)*

| Check | How it verifies |
|-------|----------------|
| Jira is reachable | Calls Jira API with a test JQL query |
| Maven is installed | Runs `mvn --version` in terminal |
| Node.js is installed | Runs `node --version` in terminal |
| msedgedriver exists | Checks the configured driver file path |

**If any single check fails → STOP. Nothing else runs. Reports exactly what is missing.**

---

## Step 2 — Phase 4: Environment Setup *(skipped if already done)*

- Hands off to the `Jira EnvSetup` agent
- Creates Jira tasks KAN-30 through KAN-37 if they do not already exist
- Waits for confirmation that all tasks are created before continuing
- Gate: if the agent reports failure → STOP and report

---

## Step 3 — Phase 5: Test Execution

- Hands off to the `PWG Test Executor` agent
- Executor checks if the app is running at `http://localhost:3000` — starts it if not
- Runs the full Maven / Cucumber test suite against the live app
- Waits for the `EXECUTION_COMPLETE` signal with Total / Passed / Failed / Skipped counts
- **Gate: if `cucumber.json` is not produced after the run → STOP. Reports `EXECUTION_FAILED`.**

---

## Step 3a — Auto-Close Check *(runs inside Executor, every single run)*

- Queries Jira for all open `[PWG][BUG]` tickets (status ≠ Done)
- For each open ticket, checks whether that scenario now **passes** in this run
- If a match is found (previously failing, now passing):
  - Adds an audit comment to the Jira ticket: `✅ AUTO-CLOSED — scenario now passing`
  - Moves the ticket status to **Done**
- Returns the list of auto-closed tickets to the Orchestrator
- If no open tickets exist → logs `AUTO_CLOSE_CHECK: no open defect tickets found` and continues

---

## Step 3.5 — App Session Cleanup *(always runs, even if Step 3 failed)*

- Checks whether the Node.js server is still running
- Stops it if the Executor did not already stop it
- Logs either:
  - `APP_SESSION_CLOSED` — Orchestrator had to stop it
  - `APP_SESSION_WAS_CLEAN` — Executor already stopped it cleanly
- **This step is mandatory. It runs even if all tests failed.**

---

## Step 4 — ⚠️ HITL Gate: Human Review *(only if failures > 0)*

**The pipeline fully pauses here. Nothing happens until you respond.**

- Orchestrator reads `cucumber.json`
- Filters failures into two groups:
  - **Genuine failures** — new, unexpected, need a bug ticket
  - **Known spec gaps** — expected failures (already documented), auto-skipped silently
- Displays the HITL checkpoint box in chat:

```
╔══════════════════════════════════════════════════════════════╗
║   ⚠️  HITL CHECKPOINT — HUMAN APPROVAL REQUIRED             ║
╠══════════════════════════════════════════════════════════════╣
║  Phase 5 found <N> failure(s) that may need Jira bug tickets ║
╠══════════════════════════════════════════════════════════════╣
║  GENUINE FAILURES (after filtering known spec gaps):         ║
║    [scenario name | failing step | first error line]         ║
║                                                              ║
║  KNOWN SPEC GAPS (will be SKIPPED — not real bugs):          ║
║    [scenario name — reason]                                  ║
╠══════════════════════════════════════════════════════════════╣
║  What would you like to do?                                  ║
║   YES          → File Jira bug tickets for genuine failures  ║
║   NO           → Skip bug filing, proceed to Phase 6 report  ║
║   SHOW DETAILS → Show full error + stack trace per failure   ║
║   READ         → Reprint this summary (resets your 15 min)  ║
╠══════════════════════════════════════════════════════════════╣
║  ⏳ Take your time — the pipeline is paused.                 ║
║     You have 15 minutes to respond before timeout.           ║
║     Timeout default action: NO (triage skipped).             ║
╚══════════════════════════════════════════════════════════════╝
```

### Your Response Options

| You type | What happens |
|----------|-------------|
| `YES` | Logs `HITL_DECISION: YES` → moves to Step 4b (Defect Triage) |
| `NO` | Logs `HITL_DECISION: NO — triage skipped by human` → jumps to Step 5 |
| `SHOW DETAILS` | Prints full stack trace per genuine failure → re-shows full box → resets 15 min timer |
| `READ` | Reprints the full box cleanly → resets 15 min timer |
| Anything else | Re-prompts: `⚠️ Unrecognised response — please reply: YES / NO / SHOW DETAILS / READ` |
| No response (15 min) | Logs `HITL_TIMEOUT` → defaults to NO → flags in report as "human did not respond" |

### Special Cases
- **0 genuine failures** (all were known gaps) → HITL gate is **never shown**. Logs `HITL_AUTO_SKIP` and continues.
- **0 failures total** → HITL gate is **never shown**. Pipeline flows through automatically.

---

## Step 4b — Defect Triage *(only runs if you said YES at Step 4)*

Hands off to the `PWG Defect Triage` agent. For **each genuine failure**:

1. **Duplicate check** — searches Jira for an existing ticket with the same scenario name. Skips creation if one already exists.
2. **Create Jira task** — creates `[PWG][BUG] <scenario name>` with:
   - Full steps to reproduce (from the Gherkin scenario)
   - Expected vs actual result
   - Error excerpt from `cucumber.json`
   - Links to the ExtentReport and feature file
3. **Assign** — assigns the ticket to the configured account
4. **Sprint assignment** — queries Jira for the current open sprint, adds the ticket to it. If no sprint is active, logs a comment on the ticket noting the sprint name for manual assignment.

Returns the complete list of Jira ticket IDs (e.g. KAN-43, KAN-44) to the Orchestrator.

---

## Step 5 — Phase 6: Report Generation

Hands off to the `PWG Report Agent`. The agent:

1. Reads `cucumber.json` — collects pass/fail/skip per scenario
2. Fetches **live Jira status** for every open bug ticket (`mcp_jira_get_ticket`)
3. Builds the module-level summary table (7 modules: Generator, Bulk, Passphrase, History, Presets, Strength, Security)
4. Shows new defects with: Jira key · live status · sprint name · assignee
5. Shows auto-closed tickets from this run
6. Flags known gaps separately (not counted as defects)
7. Shows the HITL decision made this run
8. Writes a 3–5 sentence AI narrative: overall health, green modules, failing modules, recommended next action

---

## Step 6 — Final Orchestrator Summary

Prints the complete summary box in chat:

```
╔══════════════════════════════════════════════════════════╗
║         PWG STLC — ORCHESTRATOR FINAL SUMMARY           ║
╠══════════════════════════════════════════════════════════╣
║  Phase 4 — Environment Setup  : COMPLETE / SKIPPED      ║
║  Phase 5 — Test Execution     : COMPLETE / FAILED       ║
║  HITL Gate                    : YES / NO / AUTO_SKIP /  ║
║                                 TIMEOUT                  ║
║  Phase 5b — Defect Triage     : X bugs filed / SKIPPED  ║
║  Phase 6 — Report Generated   : YES / NO                ║
║  App Session                  : CLOSED / WAS_CLEAN      ║
╠══════════════════════════════════════════════════════════╣
║  Total Scenarios : XX                                   ║
║  Passed          : XX  ✅                               ║
║  Failed          : XX  ❌                               ║
║  Skipped         : XX  ⏭                               ║
╠══════════════════════════════════════════════════════════╣
║  Jira Bugs Filed     : KAN-XX, KAN-XY, ...             ║
║  Auto-Closed Tickets : KAN-XX → Done                   ║
║  Extent Report       : pwg-automation/reports/run_.../  ║
╚══════════════════════════════════════════════════════════╝
[AI narrative: 2-3 sentences — what passed, what failed, next action]
```

---

## Step 7 — Update Living Walkthrough

- Updates `POC_STLC_Walkthrough.feature` with the latest run stats
- Injects the `LAST_RUN` block containing: run number, date, total/passed/failed/skipped, report path
- This keeps the walkthrough as a **living record** of test health across every run

---

## Total Run Time

| Scenario | Approximate time |
|----------|-----------------|
| Full suite (all 55+ scenarios) | 3–5 minutes |
| HITL gate (your decision time) | Up to 15 minutes |
| Report generation | < 1 minute |
| **End to end (excluding HITL wait)** | **~5–6 minutes** |

---

## What Requires Human Input vs What is Fully Automatic

| Step | Human needed? |
|------|--------------|
| Step 0 — Parse input | ✅ You type the trigger command |
| Step 1 — Pre-flight checks | ❌ Automatic |
| Step 2 — Env setup | ❌ Automatic |
| Step 3 — Test execution | ❌ Automatic |
| Step 3a — Auto-close resolved tickets | ❌ Automatic |
| Step 3.5 — App cleanup | ❌ Automatic |
| Step 4 — HITL Gate | ✅ **You decide: YES / NO** |
| Step 4b — Create + assign + sprint Jira tickets | ❌ Automatic (after your YES) |
| Step 5 — Report | ❌ Automatic |
| Step 6 — Final summary | ❌ Automatic |
| Step 7 — Walkthrough update | ❌ Automatic |
