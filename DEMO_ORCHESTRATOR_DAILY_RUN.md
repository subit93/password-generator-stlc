# PWG STLC — Daily Orchestrator Demo Guide

## The One-Command Story

> **Every day, one command runs the entire testing lifecycle — from test execution to Jira updates to defect management — automatically.**

```
You type:  "Run STLC"
           ↓
Orchestrator takes over — you sit back and watch.
```

---

## What Happens in a Single Run

| Step | What Happens | Who Does It |
|------|--------------|-------------|
| 1 | Checks Jira, Maven, Node.js, and EdgeDriver are all alive | Orchestrator |
| 2 | Starts the Password Generator app if it's not running | Executor |
| 3 | Runs **all Cucumber test scenarios** against the live app | Executor |
| 4 | Checks all open Jira defect tickets — **if a previously failing test now PASSES, the Jira ticket auto-moves to Done** | Executor |
| 5 | Stops the app cleanly after tests finish | Orchestrator |
| 6 | ⚠️ HITL Gate fires if new failures are found — **you decide YES or NO** (15 minutes to read and decide) | You (Human) |
| 7 | If YES — new defect ticket created in Jira, assigned to you, **added to the current active sprint automatically** | Defect Triage |
| 8 | Phase 6 report generated — shows live Jira status, sprint name, assignee, and what was auto-closed | Reporter |

---

## Sprint-by-Sprint — What the Audience Sees

### Sprint 1 — Day 1 Run (defect found)

```
Tests run
  → 1 failure found (TC-SEC-03: password leaks to analytics endpoint)
  → HITL Gate fires — you read the details (15 min window)
  → You type: YES
  → KAN-43 created in Jira
  → KAN-43 assigned to you
  → KAN-43 added to Sprint 1 automatically
  → Phase 6 report shows: "1 new defect filed → KAN-43 | Sprint 1 | To Do"
```

### Sprint 1 — Day 2 Run (developer fixed the app, re-run)

```
Tests run
  → TC-SEC-03 now PASSES
  → Executor checks open Jira tickets
  → KAN-43 matches the passing scenario
  → KAN-43 automatically moves to Done with an audit comment
  → HITL Gate: NOT triggered (0 new failures)
  → Phase 6 report shows: "AUTO-CLOSED this run → KAN-43 ✅ Done"
```

### Sprint 2 — New features added to the app

```
Tests run
  → New scenarios for new features fail
  → HITL Gate fires
  → You approve → new tickets created → added to Sprint 2
  → Old Sprint 1 tickets remain Done — not re-opened
```

---

## The Full Closed Loop (Visual)

```
  "Run STLC"
       │
       ▼
  ┌─────────────────────────────────────────────┐
  │  Phase 5 — Test Execution                   │
  │  • Runs all 55+ Cucumber scenarios          │
  │  • Checks open Jira bugs vs passing tests   │
  │  • Auto-closes resolved defect tickets      │
  └───────────────────┬─────────────────────────┘
                      │ failures found?
          ┌───────────┴──────────┐
         YES                    NO
          │                      │
          ▼                      ▼
  ┌──────────────┐     ┌──────────────────────┐
  │  HITL Gate   │     │  Skip to Phase 6     │
  │  You decide  │     │  Report              │
  └──────┬───────┘     └──────────────────────┘
         │
    ┌────┴────┐
   YES        NO
    │          │
    ▼          ▼
  Create    Skip triage
  Jira Bug  → Phase 6
  + Assign
  + Sprint
    │
    ▼
  Phase 6 Report
  • Module pass/fail table
  • Live Jira status per defect
  • Sprint assignment shown
  • Auto-closed tickets listed
  • HITL decision recorded
```

---

## What the Audience Will See in Jira After Each Run

| Ticket | Summary | Sprint | Status | Auto-managed by |
|--------|---------|--------|--------|-----------------|
| KAN-43 | [PWG][BUG] TC-SEC-03: Password transmitted to analytics | Sprint 1 | To Do → Done | Automation |
| KAN-4X | [PWG][BUG] Next failure (if any) | Sprint 2 | To Do | Automation |

Every ticket has:
- Full defect description with steps to reproduce
- Failure evidence (error message from test output)
- Acceptance criteria for the fix
- Sprint assignment
- Audit comment when auto-closed

---

## The One Gap (Be Ready to Answer This)

**Q: Does the Orchestrator create new feature stories for upcoming sprints?**

**A:** No — and that is deliberate. Story creation is a planning activity owned by the team (Product Owner / Test Lead). What the Orchestrator manages automatically is:

| ✅ Managed automatically | ❌ Team's responsibility |
|--------------------------|--------------------------|
| Test execution every run | Creating new feature stories |
| Defect ticket creation | Sprint planning / backlog grooming |
| Sprint assignment of defects | Acceptance sign-off by Product Owner |
| Defect closure when fixed | Release decisions |
| Live status in every report | |
| Human approval (HITL) before any ticket | |

---

## How to Trigger for the Demo

| Method | Command |
|--------|---------|
| VS Code Chat (recommended) | Type `Run STLC` with agent mode set to `PWG STLC Orchestrator` |
| Run from Phase 5 only | Type `run pwg tests` with agent mode set to `PWG Test Executor` |
| PowerShell direct | `cd pwg-automation ; powershell -File scripts\run-tests.ps1` |

---

## Key Messages for the Audience

1. **One command, every day** — no manual steps, no copy-pasting test results into Jira
2. **Human is always in control** — the HITL gate means no bug is ever filed without your approval
3. **Sprint-aware** — defects land in the active sprint automatically, carry forward if unresolved
4. **Self-healing** — when a developer fixes a bug, the Jira ticket closes itself on the next run
5. **Full audit trail** — every decision (who approved, what was filed, what was auto-closed) is recorded in the report and in Jira comments
