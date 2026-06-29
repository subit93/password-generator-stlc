# HITL — Human-in-the-Loop: Complete Guide

## What is HITL?

HITL (Human-in-the-Loop) is a design principle where an AI pipeline **deliberately pauses** and asks a human to make a decision before taking an irreversible action.

In this project, the HITL gate sits between **Phase 5 (test results)** and **Phase 5b (Jira bug filing)**. A human reviews the failures and decides whether real bugs should be logged.

---

## Where HITL Sits in the Pipeline

```
Phase 5 (Test Results)
        ↓
⚠️  HITL GATE — Orchestrator pauses and presents failures
        ↓                              ↓
Human types YES               Human types NO
        ↓                              ↓
Defect Triage runs            Triage is skipped
(Jira bugs created)           (go straight to report)
        ↓                              ↓
              Phase 6 (Report)
```

---

## Area 1 — The Core Gate (Approval for Bug Filing)

**What it is:** The primary HITL checkpoint that pauses the entire pipeline after Phase 5 test results arrive, before any Jira bug tickets are created.

**Why it exists:** Creating a Jira ticket is the **only irreversible action** in the whole pipeline. Once a ticket exists, it exists forever. A human must approve before any bug is filed — just like a real Test Lead reviews failures before assigning them to developers.

### What You See in Chat

```
╔══════════════════════════════════════════════════════════════╗
║   ⚠️  HITL CHECKPOINT — HUMAN APPROVAL REQUIRED             ║
╠══════════════════════════════════════════════════════════════╣
║  Phase 5 found 2 failure(s) that may need Jira bug tickets  ║
╠══════════════════════════════════════════════════════════════╣
║  GENUINE FAILURES (after filtering known spec gaps):        ║
║    - Generator > TC-GEN-07: Password contains excluded chars ║
║    - Security  > TC-SEC-03: Network request detected        ║
║                                                              ║
║  KNOWN SPEC GAPS (will be SKIPPED — not real bugs):         ║
║    - TC-HIST-03, TC-PRE-01 (expected — not yet built)       ║
╠══════════════════════════════════════════════════════════════╣
║  What would you like to do?                                  ║
║   YES          → File Jira bug tickets for genuine failures  ║
║   NO           → Skip bug filing, proceed to Phase 6 report  ║
║   SHOW DETAILS → Show full error for each failure           ║
╚══════════════════════════════════════════════════════════════╝
```

### Your Three Choices

| You type | What happens |
|---|---|
| `YES` | Orchestrator calls the Defect Triage agent → Jira tickets created for genuine bugs only |
| `NO` | Defect Triage is skipped entirely → pipeline jumps straight to Phase 6 report |
| `SHOW DETAILS` | Orchestrator prints the full error stack trace for each failure → then asks again |

---

## Area 2 — Known Spec Gap Auto-Skip (`HITL_AUTO_SKIP`)

**What it is:** If all failures are already documented as "known gaps" (features not yet built), the HITL prompt is **never shown** — the pipeline skips it automatically.

**Why it exists:** Prevents unnecessary interruptions. If the failures are expected and already known, a human doesn't need to review them. Only new, unexpected failures need human attention.

**Example:** If failures are TC-HIST-03 and TC-PRE-01 (both documented known gaps), the Orchestrator logs `HITL_AUTO_SKIP` and moves directly to Phase 6 without any human prompt.

---

## Area 3 — Partial Approval

**What it is:** The human can approve only a **subset** of genuine failures (e.g., `"YES TC-GEN-07, TC-SEC-03"`) rather than all of them.

**Why it exists:** Gives the human fine-grained control — some failures may be intentionally deferred while others need immediate bug tickets.

**Example:**
- 3 genuine failures exist: TC-GEN-07, TC-SEC-03, TC-BULK-04
- Human types: `YES TC-GEN-07, TC-SEC-03`
- Jira tickets created for TC-GEN-07 and TC-SEC-03 only
- TC-BULK-04 is deferred — noted in the Phase 6 report as "explicitly deferred by human"
- Orchestrator logs: `HITL_DECISION: PARTIAL — 2 of 3 approved by human`

---

## Area 4 — CI/CD Unattended Mode (`HITL_CI_FALLBACK`)

**What it is:** When the pipeline runs via Jenkins (no human present in chat), the HITL gate cannot wait for a reply. A pre-configured fallback policy is applied automatically.

**Why it exists:** Automated CI builds can't pause for a human, so a sensible default must be configured upfront.

### Three Fallback Policies

| Policy Setting | Value | Behaviour |
|---|---|---|
| `HITL_CI_FALLBACK` | `NO` | Skip triage — go straight to reporting |
| `HITL_CI_FALLBACK` | `YES` | Auto-approve — file all genuine bugs |
| `HITL_CI_FALLBACK` | `FAIL_PIPELINE` | Stop the build with exit code 1 |

The Jenkins build summary clearly states which fallback was used, and the Phase 6 report flags the decision as **"AI-automated (no human review)"**.

---

## Area 5 — Timeout Handling (`HITL_TIMEOUT`)

**What it is:** If the human doesn't respond within **5 minutes**, the gate times out and applies the configured timeout action (default: `NO` — skip triage).

**Why it exists:** Prevents the pipeline from hanging indefinitely if the user walks away.

**What you see:**
```
⏰  HITL TIMEOUT — No response received within 5 minutes.
    Applying default timeout action: NO (triage skipped).
    To change this behaviour set HITL_TIMEOUT_ACTION in config.
    Pipeline is now proceeding to Phase 6 reporting.
```

- Orchestrator logs: `HITL_TIMEOUT: 5 min elapsed — defaulted to NO`
- Phase 6 report flags: "TIMEOUT — human did not respond"
- Final summary recommends the human manually reviews the failures

---

## Area 6 — Invalid Input Handling

**What it is:** If the human types something unrecognised (e.g., `"maybe"`), the Orchestrator **rejects it**, explains the valid options, and re-displays the HITL prompt without taking any action.

**Why it exists:** Guards against accidental input causing unintended Jira tickets or pipeline skips.

**What you see:**
```
⚠️  Unrecognised response: "maybe"
Please reply with one of: YES | NO | SHOW DETAILS
The pipeline is still paused — no action has been taken.
```

- Orchestrator logs: `HITL_INVALID_INPUT: 'maybe' — re-prompted`
- Pipeline remains paused, waiting for a valid response

---

## Area 7 — Jira Outage Recovery

**What it is:** If the human approves (`YES`) but Jira is unreachable (HTTP 503), the Defect Triage agent reports the failure cleanly without silently losing data. The pipeline still proceeds to Phase 6, and the ticket is marked "PENDING JIRA — retry needed".

**Why it exists:** Prevents data loss and silent failures when external services are down.

**What you see:**
```
❌  Jira ticket creation FAILED for TC-SEC-03
    Reason: HTTP 503 — Jira service unavailable
    No ticket was created — no partial state was written.
    Action required: retry manually or re-run triage when Jira is back.
```

- Orchestrator logs: `HITL_JIRA_ERROR: TC-SEC-03 — ticket not created`
- Pipeline continues to Phase 6 (does NOT hang)
- Final summary shows: "Jira filing: FAILED (1 ticket pending — see report)"

---

## Area 8 — Audit Log (`hitl-audit.log`)

**What it is:** Every HITL decision (who decided, what they typed, which tickets were created, what was skipped) is **appended** to `pwg-automation/reports/hitl-audit.log` — never overwritten.

**Why it exists:** Provides a compliance trail proving that a human approved every bug ticket filed. A future reviewer can audit every decision with timestamps, run IDs, and ticket numbers.

### Sample Audit Entry

| Field | Value |
|---|---|
| Timestamp | 25-06-2026 14:32:07 UTC |
| Run ID | run_25-06-2026_14-28 |
| Failures presented | TC-GEN-07, TC-SEC-03 |
| Known gaps skipped | TC-HIST-03, TC-PRE-01 |
| Human decision | YES |
| Tickets created | KAN-41 (TC-GEN-07), KAN-42 (TC-SEC-03) |
| Decided by | human (interactive VS Code Chat session) |

The Phase 6 HTML report includes a link to the relevant audit log entry.

---

## Area 9 — Multiple SHOW DETAILS Interactions

**What it is:** The human can type `SHOW DETAILS` as many times as needed before making a final decision. All interactions are individually recorded in the audit log with timestamps.

**Why it exists:** Ensures the human has full information before committing to a decision, without any risk of accidentally creating tickets during the review.

**Example interaction log:**

| Interaction # | Input | Timestamp |
|---|---|---|
| 1 | SHOW DETAILS | 25-06-2026 14:30:01 |
| 2 | SHOW DETAILS | 25-06-2026 14:31:15 |
| 3 | NO | 25-06-2026 14:32:44 |

- Orchestrator logs: `HITL_DECISION: NO — after 2 x SHOW DETAILS interactions`

---

## Summary Table — All HITL Areas

| # | Area | Trigger | Human Action Needed? |
|---|---|---|---|
| 1 | Core Gate | Genuine failures exist | Yes — YES / NO / SHOW DETAILS |
| 2 | Auto-Skip | All failures are known gaps | No — automatic |
| 3 | Partial Approval | Human selects specific failures | Yes — name specific test IDs |
| 4 | CI/CD Fallback | Pipeline runs unattended in Jenkins | No — policy pre-configured |
| 5 | Timeout | No response in 5 minutes | No — default kicks in |
| 6 | Invalid Input | Unrecognised text typed | Yes — re-prompted |
| 7 | Jira Outage | Jira returns HTTP 503 | No — logged, pipeline continues |
| 8 | Audit Log | After every HITL decision | No — automatic |
| 9 | Multi-SHOW DETAILS | Human requests details repeatedly | Yes — final YES/NO needed |

---

## The Real-World Reason

> In a real team, a Test Lead always reviews test failures before a developer is assigned a bug. They ask: *"Is this a real defect or a flaky test? Is it already known? Was the environment unstable?"* The HITL gate gives that same judgement point to the human in this AI pipeline.
