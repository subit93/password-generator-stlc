# How to Run the PWG STLC Orchestrator

## Prerequisites — Make Sure These Are Running First

Before triggering the Orchestrator, check:

| Item | How to verify |
|------|--------------|
| VS Code is open with this workspace | — |
| Password Generator app is NOT already running on port 3000 (Orchestrator starts it automatically) | Check terminals — no `node server.js` running |
| Jira is reachable | Open https://subit93.atlassian.net in a browser |
| EdgeDriver exists | `C:\Users\subit_mishra\Documents\Tools\driver\msedgedriver.exe` |

---

## Option 1 — VS Code Chat (Recommended for Demo)

### Step 1 — Open VS Code Chat
Press `Ctrl + Alt + I` to open the Chat panel.

### Step 2 — Select the Agent
Click the **agent selector** (the dropdown at the top of the chat input box) and choose:
```
PWG STLC Orchestrator
```

### Step 3 — Type the Trigger Command
Type any one of these and press Enter:

```
Run STLC
```
```
run full pipeline
```
```
run end to end
```
```
start the pipeline
```

The Orchestrator will take over immediately and begin executing the full STLC workflow.

---

## Option 2 — Partial Runs (Start from a Specific Phase)

To skip Phases 1–4 (already done) and go straight to test execution:
```
run stlc from phase 5
```

To run only one specific test module (e.g. security tests only):
```
run stlc @security
```

To run only the report (if tests already ran):
```
generate test report summary
```

---

## Option 3 — PowerShell Terminal (Tests Only, No AI Agents)

Use this when you want to run the Maven test suite directly without Jira integration or agent orchestration:

```powershell
cd "C:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation"
powershell -ExecutionPolicy Bypass -File "scripts\run-tests.ps1" -BaseUrl "http://localhost:3000" -Browser "edge-headless"
```

To run a specific tag only:
```powershell
powershell -ExecutionPolicy Bypass -File "scripts\run-tests.ps1" -BaseUrl "http://localhost:3000" -Browser "edge-headless" -Tags "@security"
```

---

## What Happens After You Trigger It

The Orchestrator runs through these steps automatically — you only need to act at the HITL gate:

```
Step 0  — Reads your input and sets scope
Step 1  — Pre-flight: checks Jira, Maven, Node, EdgeDriver          [automatic]
Step 2  — Creates Phase 4 Jira tasks if not already done            [automatic]
Step 3  — Runs all test scenarios via Maven/Cucumber                 [automatic]
Step 3a — Checks open Jira bugs — auto-closes any that now pass     [automatic]
Step 3.5— Stops the app server cleanly                              [automatic]
Step 4  — ⚠️ HITL Gate — YOU decide YES / NO / SHOW DETAILS / READ  [YOU ACT HERE]
Step 4b — Creates Jira defect tickets + sprint assignment           [automatic, only if YES]
Step 5  — Generates Phase 6 report with live Jira status            [automatic]
Step 6  — Prints final summary box in chat                          [automatic]
Step 7  — Updates run-history.log, hitl-audit.log, walkthrough      [automatic]
```

---

## At the HITL Gate — Your 4 Responses

When failures are found, you will see a checkpoint box in the chat. Reply with:

| Response | What it does |
|----------|-------------|
| `YES` | Files Jira bug tickets for all genuine failures, adds them to the active sprint |
| `NO` | Skips bug filing entirely, goes straight to the report |
| `SHOW DETAILS` | Prints full error + stack trace for each failure, then shows the box again. Resets the 15-minute timer. |
| `READ` | Reprints the checkpoint box cleanly (useful if it scrolled away). Resets the 15-minute timer. |

**You have 15 minutes to respond. If no response, the gate defaults to NO.**

---

## Where to Find the Outputs After a Run

| Output | Location |
|--------|----------|
| ExtentReports HTML | `pwg-automation/reports/run_<date>/PWGTestReport.html` |
| Raw test results (JSON) | `pwg-automation/target/cucumber-reports/cucumber.json` |
| Cumulative run history | `pwg-automation/reports/run-history.log` |
| HITL decision audit trail | `pwg-automation/reports/hitl-audit.log` |
| Jira defect tickets | https://subit93.atlassian.net — project KAN |
| Living test walkthrough | `POC_STLC_Walkthrough.feature` (root of project) |

---

## Quick Cheat Sheet for the Demo

```
1. Press Ctrl+Alt+I
2. Select agent: PWG STLC Orchestrator
3. Type:  Run STLC
4. Watch the pipeline run automatically
5. When the HITL box appears → type YES or NO
6. See the Jira ticket created + report generated
7. Show the audience: run-history.log and hitl-audit.log as proof
```
