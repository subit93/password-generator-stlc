# PWG Password Generator — STLC Jira Progress Tracker

## Jira Project
- **Project**: KAN (`https://subit93.atlassian.net/browse/KAN`)
- **Epic**: [KAN-9](https://subit93.atlassian.net/browse/KAN-9) — `[PWG] Password Generator App — Full STLC`

---

## How to resume tomorrow
Open Copilot Chat and paste:
> "I'm continuing the PWG STLC Jira setup. Epic is KAN-9 in project KAN on subit93.atlassian.net. Check `.github/STLC-PROGRESS.md` for current status and continue from the next incomplete phase."

---

## Phase Progress

| Phase | Description | Status | Jira Tasks |
|-------|-------------|--------|------------|
| Epic  | PWG Full STLC | ✅ Done | [KAN-9](https://subit93.atlassian.net/browse/KAN-9) |
| Phase 1 | Requirement Analysis | ✅ Done | [KAN-10](https://subit93.atlassian.net/browse/KAN-10), [KAN-11](https://subit93.atlassian.net/browse/KAN-11), [KAN-12](https://subit93.atlassian.net/browse/KAN-12), [KAN-13](https://subit93.atlassian.net/browse/KAN-13), [KAN-14](https://subit93.atlassian.net/browse/KAN-14) |
| Phase 2 | Test Planning | ✅ Done | [KAN-15](https://subit93.atlassian.net/browse/KAN-15), [KAN-16](https://subit93.atlassian.net/browse/KAN-16), [KAN-17](https://subit93.atlassian.net/browse/KAN-17), [KAN-18](https://subit93.atlassian.net/browse/KAN-18), [KAN-19](https://subit93.atlassian.net/browse/KAN-19), [KAN-20](https://subit93.atlassian.net/browse/KAN-20) |
| Phase 3 | Test Case Design | ✅ Done | [KAN-21](https://subit93.atlassian.net/browse/KAN-21), [KAN-22](https://subit93.atlassian.net/browse/KAN-22), [KAN-23](https://subit93.atlassian.net/browse/KAN-23), [KAN-24](https://subit93.atlassian.net/browse/KAN-24), [KAN-25](https://subit93.atlassian.net/browse/KAN-25), [KAN-26](https://subit93.atlassian.net/browse/KAN-26), [KAN-27](https://subit93.atlassian.net/browse/KAN-27), [KAN-28](https://subit93.atlassian.net/browse/KAN-28), [KAN-29](https://subit93.atlassian.net/browse/KAN-29) |
| Phase 4 | Test Environment Setup | 🔄 In Progress | [KAN-30](https://subit93.atlassian.net/browse/KAN-30), [KAN-31](https://subit93.atlassian.net/browse/KAN-31), [KAN-32](https://subit93.atlassian.net/browse/KAN-32), [KAN-33](https://subit93.atlassian.net/browse/KAN-33), [KAN-34](https://subit93.atlassian.net/browse/KAN-34), [KAN-35](https://subit93.atlassian.net/browse/KAN-35), [KAN-36](https://subit93.atlassian.net/browse/KAN-36), [KAN-37](https://subit93.atlassian.net/browse/KAN-37) |
| Phase 5 | Automation Test Execution | ⬜ Pending | Not started |
| Phase 6 | Test Cycle Closure | ⬜ Pending | Not started |

---

## Phase 1 Detail — Requirement Analysis ✅
| Key | Summary |
|-----|---------|
| [KAN-10](https://subit93.atlassian.net/browse/KAN-10) | Analyze Functional Requirements |
| [KAN-11](https://subit93.atlassian.net/browse/KAN-11) | Analyze Non-Functional Requirements |
| [KAN-12](https://subit93.atlassian.net/browse/KAN-12) | Identify Testable vs Non-Testable Requirements |
| [KAN-13](https://subit93.atlassian.net/browse/KAN-13) | Prepare Requirements Traceability Matrix (RTM) |
| [KAN-14](https://subit93.atlassian.net/browse/KAN-14) | Requirement Review & Sign-off |

---

## Phase 2 Detail — Test Planning ✅ Done
| Key | Summary | Deliverable |
|-----|-------|------------|
| [KAN-15](https://subit93.atlassian.net/browse/KAN-15) | Define Test Scope & Test Objectives | [KAN-15-test-scope-and-objectives.md](test-plans/KAN-15-test-scope-and-objectives.md) |
| [KAN-16](https://subit93.atlassian.net/browse/KAN-16) | Define Test Strategy (Manual + Automation) | [KAN-16-test-strategy.md](test-plans/KAN-16-test-strategy.md) |
| [KAN-17](https://subit93.atlassian.net/browse/KAN-17) | Estimate Effort & Create Test Schedule | [KAN-17-effort-and-schedule.md](test-plans/KAN-17-effort-and-schedule.md) |
| [KAN-18](https://subit93.atlassian.net/browse/KAN-18) | Identify Test Data & Test Environment Needs | [KAN-18-test-data-and-environment.md](test-plans/KAN-18-test-data-and-environment.md) |
| [KAN-19](https://subit93.atlassian.net/browse/KAN-19) | Define Entry & Exit Criteria | [KAN-19-entry-exit-criteria.md](test-plans/KAN-19-entry-exit-criteria.md) |
| [KAN-20](https://subit93.atlassian.net/browse/KAN-20) | Test Plan Review & Sign-off | [KAN-20-test-plan-signoff.md](test-plans/KAN-20-test-plan-signoff.md) |

**Note:** All 6 deliverable files created under `.github/test-plans/`. Task descriptions use Given/When/Then (BDD) format. Jenkins CI/CD pipeline declared in KAN-16 and KAN-18 — setup deferred to Phase 4.
**Completed:** 2026-06-18

---

## Phase 3 Detail — Test Case Design ✅ Done
| Key | Summary | Deliverable |
|-----|---------|------------|
| [KAN-21](https://subit93.atlassian.net/browse/KAN-21) | Write Gherkin Test Cases — Generator Tab | [generator.feature](test-cases/generator.feature) |
| [KAN-22](https://subit93.atlassian.net/browse/KAN-22) | Write Gherkin Test Cases — Bulk Generation Tab | [bulk.feature](test-cases/bulk.feature) |
| [KAN-23](https://subit93.atlassian.net/browse/KAN-23) | Write Gherkin Test Cases — Passphrase Tab | [passphrase.feature](test-cases/passphrase.feature) |
| [KAN-24](https://subit93.atlassian.net/browse/KAN-24) | Write Gherkin Test Cases — History Tab | [history.feature](test-cases/history.feature) |
| [KAN-25](https://subit93.atlassian.net/browse/KAN-25) | Write Gherkin Test Cases — Presets | [presets.feature](test-cases/presets.feature) |
| [KAN-26](https://subit93.atlassian.net/browse/KAN-26) | Write Gherkin Test Cases — Strength Meter | [strength.feature](test-cases/strength.feature) |
| [KAN-27](https://subit93.atlassian.net/browse/KAN-27) | Write Gherkin Test Cases — Security & Crypto Engine | [security.feature](test-cases/security.feature) |
| [KAN-28](https://subit93.atlassian.net/browse/KAN-28) | Update RTM with Test Case Mapping | [RTM-updated.md](test-cases/RTM-updated.md) |
| [KAN-29](https://subit93.atlassian.net/browse/KAN-29) | Test Case Review & Sign-off | Sign-off recorded |

**55 Gherkin scenarios created** across 7 feature files. 41/41 requirements covered (100%). RTM updated.
**Completed:** 2026-06-18

---

## Phase 4 Detail — Test Environment Setup 🔄 In Progress
| Key | Summary | Status |
|-----|---------|--------|
| [KAN-30](https://subit93.atlassian.net/browse/KAN-30) | Verify Java & Maven Installation | ✅ Done |
| [KAN-31](https://subit93.atlassian.net/browse/KAN-31) | Scaffold Maven Test Project with pom.xml | ✅ Done |
| [KAN-32](https://subit93.atlassian.net/browse/KAN-32) | Create Page Object Model (POM) Classes | ✅ Done |
| [KAN-33](https://subit93.atlassian.net/browse/KAN-33) | Create Cucumber Test Runner & Step Definition Stubs | ✅ Done |
| [KAN-34](https://subit93.atlassian.net/browse/KAN-34) | Install Jenkins LTS & Configure Global Tools | ⬜ Pending |
| [KAN-35](https://subit93.atlassian.net/browse/KAN-35) | Create Jenkinsfile for CI/CD Pipeline | ⬜ Pending |
| [KAN-36](https://subit93.atlassian.net/browse/KAN-36) | Smoke Test the Pipeline End-to-End | ⬜ Pending |
| [KAN-37](https://subit93.atlassian.net/browse/KAN-37) | Test Environment Setup Review & Sign-off | ⬜ Pending |

**Stack:** Java 21.0.9 (Eclipse Temurin) + Maven 3.9.16 + Selenium 4.x + WebDriverManager + Cucumber 7 + ExtentReports 5 + Jenkins LTS
**Maven project location:** `pwg-automation/` at workspace root
**Jira tasks created:** 2026-06-18 — All assigned to `5ee7620d7835b00abe6aa3a7`
**KAN-30 completed:** 2026-06-18 — Java 21.0.9 (Eclipse Adoptium Temurin), Maven 3.9.16 verified. JAVA_HOME set permanently.
**KAN-31 completed:** 2026-06-18 — pom.xml already scaffolded with correct dependencies.
**KAN-32 completed:** 2026-06-18 — Page Object classes created: BasePage, GeneratorPage, BulkPage, PassphrasePage, HistoryPage + ScenarioContext utility.
**KAN-33 completed:** 2026-06-18 — 8 step definition classes created (CommonSteps, GeneratorSteps, BulkSteps, PassphraseSteps, HistorySteps, PresetsSteps, StrengthSteps, SecuritySteps). All 7 feature files linked to src/test/resources/features/. Compiles cleanly (mvn clean test-compile).

---

## Agents Available
| Agent File | Purpose |
|------------|---------|
| [jira-epic-creator.agent.md](agents/jira-epic-creator.agent.md) | Creates the top-level Epic |
| [jira-phase1-stories.agent.md](agents/jira-phase1-stories.agent.md) | Creates Phase 1 tasks |
| [jira-phase2-stories.agent.md](agents/jira-phase2-stories.agent.md) | Creates Phase 2 tasks (Given/When/Then format, includes Jenkins CI/CD planning) |
| [jira-phase3-stories.agent.md](agents/jira-phase3-stories.agent.md) | Creates Phase 3 tasks (9 tasks: 7 feature files + RTM + sign-off) |
| [jira-phase4-stories.agent.md](agents/jira-phase4-stories.agent.md) | Creates Phase 4 tasks (8 tasks: env setup, Maven scaffold, POM, Cucumber, Jenkins, Jenkinsfile, smoke test, sign-off) |

---

## Notes
- Jira issue type used: **Task** (KAN project does not have Story type)
- All tasks linked to parent Epic KAN-9
- Task descriptions use Given/When/Then (BDD) format from Phase 2 onwards
- Jenkins CI/CD (pipeline: Build → Test → Report → Archive) introduced in Phase 2 planning; setup in Phase 4; execution in Phase 5
- KAN-9 to KAN-20 all assigned to account `5ee7620d7835b00abe6aa3a7`
- **Rule:** This file must be updated every time a phase, task, or agent is created/updated
- Last updated: 2026-06-18 — KAN-31/32/33 complete: pom.xml scaffold done; 5 POM classes + ScenarioContext created; 8 step def classes + 7 feature files linked; compiles cleanly; next: KAN-34 (Jenkins LTS install)

---

## 🚩 Key Flag — Autonomous Orchestrator Agent (Build After All Phases Complete)

> **Trigger this section AFTER Phase 6 is done and all phase agents exist.**

### What to Build
A single **STLC Orchestrator Agent** (`stlc-orchestrator.agent.md`) that runs the full end-to-end pipeline with one command:
> *"Run full PWG STLC pipeline"*

### How It Works
```
[Orchestrator Agent] — single trigger
        ↓
  1. Check Epic KAN-9 status in Jira
        ↓ Hook: epic-verified
  2. Invoke Phase 1 agent → verify Requirement Analysis tasks
        ↓ Hook: phase1-complete
  3. Invoke Phase 2 agent → verify Test Planning tasks
        ↓ Hook: phase2-complete
  4. Invoke Phase 3 agent → generate Test Cases
        ↓ Hook: phase3-complete
  5. Invoke Phase 4 agent → setup environment + Jenkins
        ↓ Hook: phase4-complete
  6. Invoke Phase 5 agent → trigger Jenkins pipeline (Build → Test → Report)
        ↓ Hook: phase5-complete
  7. Invoke Phase 6 agent → generate closure report + archive
        ↓ Hook: phase6-complete → DONE
```

### AI Concepts Used
| Concept | Role |
|---------|------|
| **Orchestrator Agent** | Single entry point — coordinates the full pipeline |
| **Phase Agents (×6)** | Workers — each owns one STLC phase |
| **Hooks** | Lifecycle triggers — auto-fire the next phase agent on completion |
| **Skills** | Shared knowledge consumed by agents (e.g., Cucumber test writing rules) |
| **MCP (Jira)** | Used by all phase agents to read/update Jira tickets |
| **STLC-PROGRESS.md** | Persistent state file read by orchestrator to know current phase |

### Prerequisites Before Building
- [ ] All 6 phase agents created and tested individually
- [ ] Jenkins pipeline (`Jenkinsfile`) committed to the repo
- [ ] All Jira phases have tickets with defined exit criteria
- [ ] `STLC-PROGRESS.md` fully up to date (used as state input by orchestrator)
