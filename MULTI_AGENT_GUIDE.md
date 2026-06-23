# PWG STLC — Multi-Agent Orchestrator Guide
### *Plain English Explanation — No Technical Background Needed*

---

## What Is This Document About?

This project uses **AI Agents** — think of them as smart robot assistants — to run the entire software testing process automatically, from start to finish, without anyone needing to press buttons or give commands manually.

This guide explains:
- **What each robot assistant does** (in plain English)
- **How they talk to each other** (using a Gherkin-style walkthrough)
- **Why each one is needed**

---

## The Big Picture — Think of It Like a Restaurant Kitchen

Imagine a professional kitchen. One person takes the customer's order. Different chefs handle different dishes. A head chef oversees everything. A waiter delivers the final meal. No one steps on each other's toes.

Our AI pipeline works exactly the same way:

```
Customer Order = "Run the tests and tell me if everything is OK"

┌─────────────────────────────────────────────────────────────────┐
│                  HEAD CHEF                                      │
│            PWG STLC Orchestrator                                │
│   (Receives your request, assigns tasks, watches everything)    │
└────────────────────┬────────────────────────────────────────────┘
                     │
         ┌───────────┼────────────────────────────┐
         ▼           ▼                            ▼
  ┌─────────────┐  ┌──────────────┐   ┌──────────────────────────┐
  │  Jira Setup │  │  PWG Test    │   │  PWG Report Agent         │
  │   Agent     │  │  Executor    │   │  (Phase 6 Reporting)      │
  │ (Phase 4)   │  │  (Phase 5)   │   │                          │
  └─────────────┘  └──────┬───────┘   └──────────────────────────┘
                          │
                   ┌──────▼───────┐
                   │  PWG Defect  │
                   │  Triage Agent│
                   │ (Phase 5b)   │
                   └──────────────┘
```

---

## Meet the Agents — Your AI Team

---

### 1. PWG STLC Orchestrator
**File:** `.github/agents/pwg-orchestrator.agent.md`
**Role:** The Head Chef / Project Manager

**In plain English:**
> This is the boss agent. When you say "Run the tests", the Orchestrator wakes up, makes a plan, and tells each specialist agent exactly what to do and when. It checks that each step is done before allowing the next one to begin. If anything goes wrong, it stops and reports the problem clearly.

**What it does, step by step:**
1. Checks that all tools are installed (Maven, Node.js, Edge browser driver)
2. Tells the Jira Setup Agent to prepare the test environment in Jira
3. Tells the Test Executor Agent to start the app and run all 138 tests
4. **Stops the app (Node.js server) after all tests are done — no loose ends**
5. If any tests failed → tells the Defect Triage Agent to log bugs in Jira
6. Tells the Report Agent to write a summary of what happened
7. **Updates the `POC_STLC_Walkthrough.feature` file with the latest test stats**
8. Prints a final pass/fail summary in the chat

**Gherkin Walkthrough:**
```gherkin
Feature: How the Orchestrator runs the show

  Scenario: A user says "Run STLC" in the chat
    Given a user types "Run STLC" or "run full pipeline" in VS Code Chat
    When the PWG STLC Orchestrator agent receives this request
    Then it first checks:
      | Check              | What it verifies                                   |
      | Jira is reachable  | Can we log bugs? Is the Jira board working?        |
      | Maven installed    | Is the Java test tool ready?                       |
      | Node.js installed  | Can we start the web app?                          |
      | Edge driver exists | Is the browser remote-control driver in place?     |
    And if all checks pass, it begins the pipeline automatically
    And if any check fails, it stops and tells you exactly what is missing

  Scenario: The Orchestrator manages the app lifecycle
    Given the Orchestrator is about to run Phase 5 tests
    When it hands off to the Test Executor agent
    Then the Test Executor starts the Node.js web app if it is not already running
    And runs all 138 test scenarios automatically
    And when all tests are done, the Node.js app is STOPPED automatically
    And the Orchestrator double-checks that no Node.js process is left running
    And it records "APP_SESSION_CLOSED" or "APP_SESSION_WAS_CLEAN" in the final report
```

---

### 2. Jira EnvSetup Agent
**File:** `.github/agents/jira-EnvSetup.agent.md`
**Role:** The Sous Chef who sets up the kitchen before cooking starts

**In plain English:**
> Before tests run, someone needs to make sure the task list in Jira (our project management board) is ready. This agent creates all the "Test Environment Setup" tasks in Jira so the team can track what was set up and when.

**What it does:**
- Creates Jira tasks for: installing tools, configuring browsers, setting up test data
- Links everything to the parent project epic (KAN-9) in Jira
- Confirms back to the Orchestrator: "Kitchen is ready — proceed!"

**Gherkin Walkthrough:**
```gherkin
Feature: How the Jira EnvSetup Agent prepares the project board

  Scenario: Phase 4 environment setup is triggered
    Given the Orchestrator reaches Phase 4 in the pipeline
    When it calls the Jira EnvSetup agent with "create environment setup tasks"
    Then the agent creates tasks in Jira such as:
      | Task                        | Jira Ticket |
      | Install Java 21             | KAN-30      |
      | Install Maven 3.9           | KAN-31      |
      | Install Node.js             | KAN-32      |
      | Configure Edge WebDriver    | KAN-33      |
      | Verify app starts on :3000  | KAN-34      |
    And reports back to the Orchestrator: "Phase 4 complete — KAN-30 through KAN-34 created"
    And the Orchestrator only moves to Phase 5 after receiving this confirmation
```

---

### 3. PWG Test Executor Agent
**File:** `.github/agents/pwg-executor.agent.md`
**Role:** The Cook who actually prepares the dish (runs the tests)

**In plain English:**
> This agent's only job is to run the tests. It starts the web app if it is not already running, fires up the test suite using Maven (a Java build tool), waits for all 138 test scenarios to finish, and then hands the results back to the Orchestrator. It also stops the web app after it is done — like turning off the stove when cooking is finished.

**What it does:**
1. Checks if the Password Generator website is running at `http://localhost:3000`
2. If not → starts it using Node.js (and remembers it started it)
3. Runs all Cucumber test scenarios using Maven
4. Waits for all tests to finish (this takes about 3–5 minutes)
5. **Stops the Node.js server if it started it**
6. Returns a structured result: Total / Passed / Failed / Skipped

**Gherkin Walkthrough:**
```gherkin
Feature: How the Test Executor runs 138 tests and cleans up

  Scenario: Executor starts the app and runs all tests
    Given the Test Executor receives "run pwg tests" from the Orchestrator
    When it checks if http://localhost:3000 is responding
    Then if the app is NOT running:
      | Action                        | What happens                                 |
      | Start Node.js server          | node server.js runs in the background        |
      | Wait up to 15 seconds         | Polls until the app responds with HTTP 200   |
      | Record the process ID         | Remembers PID so it can stop it later        |
    And when the app IS running, the Executor runs the full test suite via Maven
    And all 138 Cucumber scenarios execute one by one in a headless Edge browser

  Scenario: Executor shuts down the app after tests finish
    Given the test suite has completed (pass or fail)
    When the Executor checks if it was the one who started Node.js
    Then if it started Node.js → it stops the process immediately
    And if Node.js was already running → it leaves it running (not its responsibility)
    And it returns structured results to the Orchestrator:
      """
      EXECUTOR_RESULT
        Status  : COMPLETE
        Total   : 138
        Passed  : 138
        Failed  : 0
        Skipped : 0
        Report  : pwg-automation\reports\run_23-06-2026_11-28\PWGTestReport.html
      """
```

---

### 4. PWG Defect Triage Agent
**File:** `.github/agents/pwg-defect-triage.agent.md`
**Role:** The Quality Inspector who decides which problems are real bugs

**In plain English:**
> Not every failed test means there is a real bug. Some tests are known to fail because the feature they are testing is not fully built yet (called "spec gaps"). This agent is smart enough to know the difference. It looks at the list of failed tests, filters out the expected failures, and only creates Jira bug tickets for genuine new problems.

**Known "spec gaps" it will ignore (these are expected):**
| Test Case | Why it is ignored |
|---|---|
| TC-HIST-03 | Persistent history (localStorage) is not yet implemented |
| TC-HIST-06 | History export feature is not yet implemented |
| TC-PRE-01 to TC-PRE-05 | Preset buttons are not yet wired up in the UI |

**Gherkin Walkthrough:**
```gherkin
Feature: How the Defect Triage Agent filters noise from real bugs

  Scenario: Some tests failed — triage decides what to log
    Given the Orchestrator received these failed scenarios from the Executor:
      | Failed Test         | Feature                     |
      | TC-HIST-03          | History tab                 |
      | TC-PRE-01           | Presets tab                 |
      | TC-GEN-07 (new bug) | Generator tab               |
    When the Defect Triage agent reviews the list
    Then it checks each failure against the known "spec gaps" list
    And TC-HIST-03 is skipped — it is a known gap, NOT a bug
    And TC-PRE-01 is skipped — it is a known gap, NOT a bug
    And TC-GEN-07 is a NEW failure — it creates a Jira bug ticket: KAN-XX
    And it reports back: "1 bug filed: KAN-XX | 2 known gaps skipped"

  Scenario: All tests passed — nothing to triage
    Given the Executor reported 0 failures
    When the Orchestrator checks whether to call the Defect Triage agent
    Then the Defect Triage agent is NOT called — there is nothing to triage
    And the Orchestrator moves directly to Phase 6 reporting
```

---

### 5. PWG Report Agent
**File:** `.github/agents/pwg-reporter.agent.md`
**Role:** The Waiter who delivers the final result to the customer

**In plain English:**
> After all tests have run and any bugs have been logged, this agent reads the test results from two places — the machine-readable `cucumber.json` file and the human-readable ExtentReports HTML file — and writes a clear, professional summary in plain English. It tells you what passed, what failed (and why), and what you should do next.

**Gherkin Walkthrough:**
```gherkin
Feature: How the Report Agent produces the final summary

  Scenario: Report Agent creates the Phase 6 summary
    Given the Test Executor has completed and cucumber.json exists
    When the Orchestrator calls the Report Agent with "generate test report summary"
    Then the Report Agent reads cucumber.json to get exact pass/fail counts
    And reads the ExtentReports HTML file for failure details and screenshots
    And writes a narrative summary like:
      """
      138 out of 138 scenarios passed across 7 modules (Generator, Bulk,
      Passphrase, History, Presets, Strength, Security). The 4 known spec
      gaps (TC-HIST-03, TC-PRE-01, TC-PRE-02, TC-PRE-05) are flagged as
      expected and are NOT counted as defects. No new bugs were found.
      Recommended next step: implement the History persistence and Presets
      features to close the outstanding spec gaps.
      """
    And the Report Agent returns this summary to the Orchestrator to include in the final output
```

---

## How They All Work Together — The Full Pipeline

```gherkin
Feature: Full end-to-end pipeline — what happens when you type "Run STLC"

  Background:
    Given a user is in VS Code Chat
    And the agent mode is set to "PWG STLC Orchestrator"

  Scenario: The happy path — all tests pass
    When the user types: "Run STLC" or clicks the run-stlc prompt
    Then the Orchestrator runs these steps in order:

      Step 1 — Pre-flight checks (30 seconds)
        | Check          | Status  |
        | Jira reachable | PASS    |
        | Maven ready    | PASS    |
        | Node.js ready  | PASS    |
        | EdgeDriver OK  | PASS    |

      Step 2 — Phase 4: Environment Setup (via Jira EnvSetup Agent)
        → Jira tasks created for environment configuration
        → Orchestrator waits for confirmation before proceeding

      Step 3 — Phase 5: Test Execution (via PWG Test Executor Agent)
        → Node.js app started automatically at http://localhost:3000
        → All 138 Cucumber/Selenium tests run in headless Edge browser
        → Tests take approximately 3–5 minutes to complete
        → Node.js app STOPPED automatically when tests finish

      Step 3.5 — App Session Cleanup (Orchestrator direct action)
        → Orchestrator verifies no Node.js process is left running
        → Records: APP_SESSION_WAS_CLEAN

      Step 4 — Defect Triage: SKIPPED (0 failures found)

      Step 5 — Phase 6: Reporting (via PWG Report Agent)
        → Reads cucumber.json and ExtentReports HTML
        → Produces AI-written narrative summary

      Step 6 — Update Living Document
        → POC_STLC_Walkthrough.feature updated with today's run stats
        → Run count, date, total/passed/failed all recorded

      Step 7 — Final Summary printed in chat:
      """
      ╔══════════════════════════════════════════════════════════╗
      ║         PWG STLC — ORCHESTRATOR FINAL SUMMARY           ║
      ╠══════════════════════════════════════════════════════════╣
      ║  Phase 4 — Environment Setup  : COMPLETE                ║
      ║  Phase 5 — Test Execution     : COMPLETE                ║
      ║  Phase 5b— Defect Triage      : NONE (0 failures)       ║
      ║  Phase 6 — Report Generated   : YES                     ║
      ║  App Session                  : WAS_CLEAN               ║
      ║  Walkthrough Updated          : YES                     ║
      ╠══════════════════════════════════════════════════════════╣
      ║  Total Scenarios : 138                                  ║
      ║  Passed          : 138  ✅                              ║
      ║  Failed          :   0  ❌                              ║
      ║  Skipped         :   0  ⏭                              ║
      ╠══════════════════════════════════════════════════════════╣
      ║  Jira Bugs Filed : NONE                                 ║
      ║  Extent Report   : pwg-automation\reports\run_...\...  ║
      ╚══════════════════════════════════════════════════════════╝
      All 138 scenarios passed — the Password Generator application
      is fully functional across all 7 modules. No defects found.
      """

  Scenario: The failure path — some tests fail
    When 3 tests fail during Phase 5
    Then the Orchestrator does NOT stop — it continues to Defect Triage
    And the PWG Defect Triage Agent reviews the 3 failures
    And known spec gaps are filtered out (e.g. TC-HIST-03)
    And only genuine new bugs get a Jira ticket created
    And the final summary shows the real failure count and Jira IDs
```

---

## The Living Walkthrough Document

After every pipeline run, the file `POC_STLC_Walkthrough.feature` is **automatically updated** at the top with the latest run statistics:

```
# <<LAST_RUN_START>>
# +------------------------------------------------------------------------------+
# |  LAST RUN STATS  (auto-updated by run-tests.ps1 after every pipeline run)    |
# |  Run #   : 2                                                                 |
# |  Date    : 23-06-2026 14:30                                                  |
# |  Result  : PASS  |  Total : 138  |  Passed : 138  |  Failed : 0  |  Skipped : 0 |
# |  Report  : pwg-automation\reports\run_23-06-2026_14-28\PWGTestReport.html   |
# +------------------------------------------------------------------------------+
# <<LAST_RUN_END>>
```

This means anyone opening the project can instantly see — **at the top of the file** — the last time the tests ran, how many passed, and where to find the report. No hunting through folders.

---

## The HITL Gate — Human-in-the-Loop Checkpoint

### Where It Sits

Between Phase 5 (test results come in) and Defect Triage (Jira bugs are created), the Orchestrator **pauses and asks you**.

```
[Phase 5 complete] → ⚠️ HITL PAUSE → You decide → [YES: file bugs] or [NO: skip to report]
```

This is the **only irreversible action in the whole pipeline** — once a Jira ticket is created, it exists. The HITL gate puts a human in front of that action every single time.

### What You See in Chat

When tests fail, the Orchestrator prints this and **waits for your reply**:

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

### What Happens When All Tests Pass

If 0 failures → the HITL gate is **never shown**. The pipeline flows through automatically.

If failures exist but ALL are known spec gaps → Orchestrator logs `HITL_AUTO_SKIP` and proceeds. No prompt needed because there is nothing actionable to approve.

### Why This Matters (The Real-World Reason)

> In a real team, a Test Lead always reviews test failures before a developer is assigned a bug. They ask: *"Is this a real defect or a flaky test? Is it already known? Was the environment unstable?"* The HITL gate gives that same judgement point to the human in this AI pipeline.

---

## How to Trigger the Pipeline — Three Easy Ways

| Method | How | Best For |
|---|---|---|
| **Chat command** | Type `Run STLC` in VS Code Chat with agent mode `PWG STLC Orchestrator` | Daily use — quickest |
| **Prompt shortcut** | Select the `/run-stlc` prompt from VS Code Chat | Demonstrations |
| **Direct PowerShell** | Run `pwg-automation\scripts\run-tests.ps1` in a terminal | Debugging |

---

## Frequently Asked Questions

**Q: What happens if I close VS Code while tests are running?**
> The Maven test process continues in the background. However the Orchestrator's cleanup step (stopping Node.js) will not run. You can manually stop the server by running `Stop-Process -Name "node" -Force` in a terminal.

**Q: Will Jira be updated automatically?**
> Yes — but only for genuine new bug tickets. Known spec gaps are never logged to Jira.

**Q: Where do I find the test report after a run?**
> Look in `pwg-automation/reports/run_DD-MM-YYYY_HH-MM/PWGTestReport.html`. The most recent folder is your latest report.

**Q: Can I run just one module instead of all tests?**
> Yes. In the chat, type: `Run STLC @security` — the Orchestrator passes the tag to the Executor, which tells Maven to run only the Security tests.

**Q: What are "known spec gaps"?**
> These are features that are not yet built in the application. The tests for them exist but will always fail until the feature is implemented. The Defect Triage agent knows about them and does not create Jira bug tickets for them.

---

## File Map — Where Everything Lives

```
Copilot_POC/
│
├── .github/
│   ├── agents/
│   │   ├── pwg-orchestrator.agent.md     ← Master Orchestrator (this whole guide)
│   │   ├── pwg-executor.agent.md         ← Phase 5: runs the tests + stops app
│   │   ├── pwg-reporter.agent.md         ← Phase 6: writes the report summary
│   │   ├── pwg-defect-triage.agent.md    ← Filters known gaps, logs real bugs
│   │   ├── jira-EnvSetup.agent.md        ← Phase 4: creates Jira env tasks
│   │   ├── jira-ReAnalyser.agent.md      ← Phase 1: creates Jira requirements
│   │   ├── jira-TestPlanCreator.agent.md ← Phase 2: creates test plan in Jira
│   │   └── jira-TestCaseDesigner.agent.md← Phase 3: creates test case tasks
│   └── prompts/
│       └── run-stlc.prompt.md            ← One-click pipeline trigger
│
├── password-generator/                   ← The web app being tested
│   └── server.js                         ← Node.js server (started & stopped by pipeline)
│
├── pwg-automation/                       ← Java/Maven test project
│   ├── scripts/
│   │   └── run-tests.ps1                 ← PowerShell runner (called by Executor)
│   ├── reports/                          ← ExtentReports HTML output (one folder per run)
│   └── target/cucumber-reports/
│       └── cucumber.json                 ← Machine-readable test results (read by agents)
│
├── POC_STLC_Walkthrough.feature          ← Living walkthrough doc (auto-updated each run)
└── MULTI_AGENT_GUIDE.md                  ← This document
```

---

*Last updated: June 23, 2026 — PWG STLC Multi-Agent Pipeline v1.0*
