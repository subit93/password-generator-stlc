# AI & STLC Features Applied in This Project

**Project:** PWG Password Generator — Full STLC with AI Agents  
**Date:** June 29, 2026  
**Jira Epic:** KAN-9 (`subit93.atlassian.net`)

---

## Part 1 — AI Features

### 1. Multi-Agent Orchestration

A **Master Orchestrator** (`pwg-orchestrator.agent.md`) coordinates 5 specialist agents, each owning a distinct STLC phase. No agent proceeds without explicit gate clearance from the Orchestrator.

| Agent File | Role |
|---|---|
| `pwg-orchestrator.agent.md` | Head coordinator — manages phase gates, hand-offs, and final summary |
| `jira-EnvSetup.agent.md` | Creates Phase 4 environment setup tasks in Jira |
| `pwg-executor.agent.md` | Runs the Maven/Cucumber suite and manages app lifecycle |
| `pwg-defect-triage.agent.md` | Filters genuine bugs vs spec gaps, files Jira tickets |
| `pwg-reporter.agent.md` | Generates Phase 6 narrative report from live cucumber.json data |

The agents form a directed pipeline:

```
Orchestrator
     │
     ├─► Jira EnvSetup  (Phase 4)
     │
     ├─► PWG Test Executor  (Phase 5)
     │        │
     │        ▼
     │   HITL Gate ← Human Decision Required
     │        │
     │        ├── YES ──► PWG Defect Triage  (Phase 5b)
     │        │                │
     │        └── NO ──────────┤
     │                         ▼
     └─────────────────► PWG Report Agent  (Phase 6)
```

---

### 2. Human-in-the-Loop (HITL) Gate

The pipeline **deliberately pauses** after test execution and waits for an explicit human decision before filing any Jira bug. This is the core AI governance mechanism.

**Commands supported:**

| Command | Action |
|---|---|
| `YES` | File Jira tickets for all genuine failures |
| `NO` | Skip triage, proceed directly to Phase 6 report |
| `SHOW DETAILS` | Print full stack trace per failure, re-present checkpoint, reset timer |
| `READ` | Reprint the checkpoint box cleanly (useful if scrolled away), reset timer |

**Safety rules:**
- Invalid input is **never treated as NO** — always re-prompted
- Timeout after **15 minutes** defaults to NO (safe fallback)
- Every decision is written to an append-only `hitl-audit.log`

**HITL Checkpoint box shown to human:**

```
╔══════════════════════════════════════════════════════════════╗
║   ⚠️  HITL CHECKPOINT — HUMAN APPROVAL REQUIRED             ║
╠══════════════════════════════════════════════════════════════╣
║  Phase 5 found <N> failure(s) that may need Jira bug tickets ║
╠══════════════════════════════════════════════════════════════╣
║  GENUINE FAILURES (after filtering known spec gaps)          ║
║  KNOWN SPEC GAPS  (will be SKIPPED — not real bugs)          ║
╠══════════════════════════════════════════════════════════════╣
║  YES | NO | SHOW DETAILS | READ                              ║
║  ⏳ 15 minutes to respond — Timeout defaults to NO           ║
╚══════════════════════════════════════════════════════════════╝
```

---

### 3. Intelligent Defect Filtering

The Defect Triage agent distinguishes **genuine bugs** from **documented spec gaps** — known mismatches between the spec and the app's actual behaviour are never filed as Jira tickets.

| Test ID | Gap Description | Action |
|---|---|---|
| TC-HIST-03 | History persists after reload (app uses in-memory, not localStorage) | Auto-skipped |
| TC-HIST-06 | localStorage contains history key (same root cause) | Auto-skipped |
| TC-PRE-01/02 | Banking preset length = 16 (app sets 20, spec says 16) | Auto-skipped |
| TC-PRE-05 | Super Secure excludeAmbiguous ON (app sets OFF) | Auto-skipped |

Only genuine, previously unknown defects trigger Jira ticket creation.

---

### 4. Auto-Close Defect Loop

The Executor agent queries all open `[PWG][BUG]` Jira tickets before each run and **auto-transitions them to Done** when the corresponding scenario passes in the current run. This closes the defect lifecycle without manual intervention — a complete fix-verify-close loop driven by AI.

---

### 5. Sprint Assignment Automation

After filing a Jira ticket, the Defect Triage agent queries for the currently active sprint using JQL (`openSprints()`) and assigns the new ticket to it automatically — no manual sprint assignment required.

---

### 6. Append-Only Audit Logs

Two immutable audit files are maintained across all pipeline runs — they can never be overwritten, only appended:

| File | Purpose | Sample Entry |
|---|---|---|
| `pwg-automation/reports/run-history.log` | Every test run's counts and outcome | `[2026-06-29 14:25] Run#6 \| FAIL \| Total:69 Passed:68 Failed:1` |
| `pwg-automation/reports/hitl-audit.log` | Every human HITL decision with timestamp and ticket IDs | `[2026-06-29 14:23] Run: run_29-06-2026_14-19 \| Decision: YES \| Genuine: TC-SEC-03 \| Tickets filed: KAN-43` |

As of 29-Jun-2026: **6 runs recorded** in run-history.log, **3 HITL decisions** recorded in hitl-audit.log.

---

### 7. Living Documentation

**`POC_STLC_Walkthrough.feature`** is auto-updated after every pipeline run. A `<<LAST_RUN_START>>` / `<<LAST_RUN_END>>` block is injected or replaced with the latest run stats — the file is always a current snapshot of the project's test health.

```
# <<LAST_RUN_START>>
# │  Run #   : 6
# │  Date    : 29-06-2026 14:19
# │  Total   : 69    Passed : 68    Failed : 1    Skipped : 0
# │  Failed  : TC-SEC-03
# │  Report  : pwg-automation/reports/run_29-06-2026_14-19/PWGTestReport.html
# <<LAST_RUN_END>>
```

---

### 8. AI-Generated Narrative Report

The Report Agent reads live data from `cucumber.json` and fetches live Jira ticket status (`mcp_jira_get_ticket`) to produce a human-readable narrative — not a data dump, but a contextual assessment with recommended next actions. The report includes:

- Per-defect live status, sprint, and assignee fetched from Jira at report time
- `AUTO-CLOSED THIS RUN` section for bugs resolved by the current run
- `HITL GATE DECISION` section showing the human's choice and timestamp

---

### 9. Deliberate Failure Injection for Demo

`SecuritySteps.java` has a controlled `Assert.fail()` injected into `TC-SEC-03` simulating a real-world password exfiltration scenario (password POSTed to `https://analytics.pwg-app.io/track`). This allows a live end-to-end demo of the full HITL → Triage → Jira flow in front of an audience.

> **Note:** Revert `SecuritySteps.noXhrWithPasswordPayload()` back to `noExternalNetworkRequests()` to demonstrate a clean all-green run.

---

### 10. Pre-flight Dependency Verification

Before any test run the AI verifies all 4 dependencies and **refuses to proceed** if any check fails:

| Check | Command | Expected |
|---|---|---|
| Maven | `mvn --version` | Apache Maven 3.9.x |
| Node.js | `node --version` | v24.x.x |
| msedgedriver | `Test-Path ...msedgedriver.exe` | `True` |
| Jira | `mcp_jira_get_ticket KAN-9` | Ticket found |

---

## Part 2 — STLC Features

### Full 6-Phase STLC Coverage

| Phase | Description | Jira Evidence |
|---|---|---|
| **Phase 1** — Requirement Analysis | User stories created from app features across 7 modules | KAN-10 to KAN-16 |
| **Phase 2** — Test Planning | Test strategy, scope, entry/exit criteria, risk assessment | KAN-17 to KAN-23 |
| **Phase 3** — Test Case Design | BDD scenarios in Gherkin for all 7 modules (69 scenarios) | KAN-24 to KAN-29 |
| **Phase 4** — Environment Setup | Maven project scaffold, Selenium, Cucumber, ExtentReports, Edge driver | KAN-30 to KAN-37 |
| **Phase 5** — Test Execution | Automated run via Maven + Edge Headless; cucumber.json produced | This run: 68/69 passed |
| **Phase 5b** — Defect Triage | TC-SEC-03 identified as genuine, filed as KAN-43 | KAN-43 |
| **Phase 6** — Test Cycle Closure | HTML Extent report + AI narrative summary | `run_29-06-2026_14-19` |

---

### BDD with Cucumber + Gherkin

All 69 test scenarios are written in **Given / When / Then** format across 7 feature files. This makes tests readable by non-technical stakeholders and directly traceable to requirements.

| Feature File | Module | Scenarios |
|---|---|---|
| `generator.feature` | Password Generator (length, charset, ambiguous) | ~12 |
| `bulk.feature` | Bulk Generation (count slider, output list) | ~8 |
| `passphrase.feature` | Passphrase (word count, known list, copy) | ~8 |
| `history.feature` | History Tab (localStorage persistence) | ~7 |
| `presets.feature` | Presets (Social, Banking, Work, Super Secure) | ~8 |
| `strength.feature` | Strength Meter (Weak/Medium/Strong/Very Strong) | ~10 |
| `security.feature` | Security (crypto-only, no network calls, auto-clear) | ~8 |

---

### Page Object Model (POM)

Selenium automation uses strict POM separation with dedicated page classes:

| Class | UI Layer Owned |
|---|---|
| `BasePage.java` | Shared wait utilities, common interactions |
| `GeneratorPage.java` | Generator tab — length slider, charset toggles, generate button |
| `BulkPage.java` | Bulk tab — count slider, bulk generate, output list |
| `PassphrasePage.java` | Passphrase tab — phrase slider, generate, copy |
| `HistoryPage.java` | History tab — list items, clear history |

Test logic (step definitions) never directly calls Selenium — it always goes through the page objects.

---

### Test Reporting — ExtentReports 5

HTML reports generated per run under `pwg-automation/reports/run_<date>/PWGTestReport.html` with:
- Step-level pass/fail evidence
- Screenshot capture on failure (via Hooks.java)
- Run timestamp and browser details
- Per-feature and per-scenario breakdown

**Reports produced so far:**

| Run Folder | Date | Result |
|---|---|---|
| `run_23-06-2026_11-28` | 23 Jun 2026 11:28 | — |
| `run_23-06-2026_13-28` | 23 Jun 2026 13:28 | — |
| `run_25-06-2026_11-17` | 25 Jun 2026 11:17 | — |
| `run_29-06-2026_14-19` | 29 Jun 2026 14:19 | 68/69 — 1 FAIL (TC-SEC-03) |

---

### Security Testing Module

`security.feature` covers 8 security-specific scenarios:

- No `Math.random()` usage — only `crypto.getRandomValues()` allowed
- No XHR or fetch calls triggered during Copy action
- No password value in any outbound request payload
- No network requests at all during password generation
- Auto-clear timer fires after 60 seconds
- No password persisted to localStorage
- No password visible in URL parameters
- DevTools Network panel shows zero requests

---

### App Lifecycle Management in Tests

The Executor owns the Node.js server lifecycle:
- **Before run**: checks if app is already running; starts it only if needed
- **After run**: stops the Node.js process it started
- **Orchestrator cleanup (Step 3.5)**: mandatory second check — kills any orphaned Node.js processes even if the Executor failed to stop them

This prevents port conflicts and dangling processes across consecutive runs.

---

### Jira Integration — Full Ticket Lifecycle

| Action | Tool Used | When |
|---|---|---|
| Create defect ticket | `mcp_jira_create_ticket` | After human YES at HITL gate |
| Assign to sprint | `mcp_jira_edit_ticket` | Immediately after creation |
| Assign to team member | `mcp_jira_assign_ticket` | Immediately after creation |
| Re-confirm existing defect | `mcp_jira_edit_ticket` | When same TC fails again |
| Auto-close on pass | `mcp_jira_edit_ticket` | When scenario passes in next run |
| Fetch live status for report | `mcp_jira_get_ticket` | During Phase 6 report generation |

---

### CI/CD-Ready Architecture

The pipeline supports a `CI/CD` mode (vs `interactive` mode) with a separate `HITL_CI_FALLBACK` policy — in CI/CD mode the HITL gate auto-applies a pre-configured default decision without waiting for human input. The `Mode` field in `hitl-audit.log` records which mode was active for every run.

---

## Summary Table

| Category | Feature | Status |
|---|---|---|
| AI | Multi-Agent Orchestration (5 agents) | ✅ Live |
| AI | Human-in-the-Loop (HITL) Gate | ✅ Live |
| AI | Intelligent Defect Filtering (4 known gaps) | ✅ Live |
| AI | Auto-Close Defect Loop | ✅ Live |
| AI | Sprint Assignment Automation | ✅ Live |
| AI | Append-Only Audit Logs | ✅ Live |
| AI | Living Documentation (Walkthrough) | ✅ Live |
| AI | AI-Generated Narrative Report | ✅ Live |
| AI | Deliberate Failure Injection (Demo) | ✅ Active (TC-SEC-03) |
| AI | Pre-flight Dependency Verification | ✅ Live |
| STLC | Full 6-Phase STLC (Phases 1–6) | ✅ Complete |
| STLC | BDD Gherkin Scenarios (69 total) | ✅ Complete |
| STLC | Page Object Model (POM) | ✅ Complete |
| STLC | ExtentReports 5 HTML Reports | ✅ Complete |
| STLC | Security Testing Module (8 scenarios) | ✅ Complete |
| STLC | App Lifecycle Management | ✅ Complete |
| STLC | Jira Full Ticket Lifecycle | ✅ Complete |
| STLC | CI/CD-Ready Architecture | ✅ Designed |
