# KAN-17 — Effort Estimation & Test Schedule
**Project:** PWG — Password Generator App  
**Phase:** 2 — Test Planning  
**Jira Ticket:** [KAN-17](https://subit93.atlassian.net/browse/KAN-17)  
**Status:** ✅ Done  
**Date:** 2026-06-18  

---

## 1. Purpose
This document provides the effort estimates (in hours) for each remaining STLC phase and lays out the test schedule with milestones and sign-off gates.

---

## 2. Effort Estimation

### Phase 3 — Test Case Design
| Activity | Basis | Hours |
|----------|-------|-------|
| Write Gherkin feature files (41 test objectives → ~55 test cases) | 55 cases × 30 min each | 27.5 h |
| Peer review of test cases | 25% of writing time | 7 h |
| Update RTM with test case mapping | 1 case = 5 min | 5 h |
| Sign-off walkthrough | Fixed | 1.5 h |
| **Phase 3 Total** | | **~41 h** |

### Phase 4 — Test Environment Setup
| Activity | Basis | Hours |
|----------|-------|-------|
| Install JDK 11, Maven, Selenium | Tool installation + verify | 3 h |
| Create Maven project structure (POM) | Project scaffold + pom.xml | 4 h |
| Implement Page Object Model classes | 4 page classes + BaseTest | 8 h |
| Setup ChromeDriver / GeckoDriver | Download, path config, test | 2 h |
| Install Jenkins LTS, configure tools | Jenkins setup + job creation | 6 h |
| Create `Jenkinsfile` (pipeline-as-code) | 4-stage pipeline | 3 h |
| Smoke test environment end-to-end | Run 5 sample tests via Jenkins | 3 h |
| **Phase 4 Total** | | **~29 h** |

### Phase 5 — Automation Test Execution
| Activity | Basis | Hours |
|----------|-------|-------|
| Implement all Cucumber step definitions | 55 scenarios × 45 min | 41 h |
| Dry run (local) — fix failures | 20% rework | 8 h |
| Full regression run via Jenkins | Pipeline execution + review | 4 h |
| Defect logging in Jira | Est. 10 defects × 30 min | 5 h |
| Re-test after defect fixes | Est. 10 defects × 20 min | 3.5 h |
| **Phase 5 Total** | | **~61.5 h** |

### Phase 6 — Test Cycle Closure
| Activity | Basis | Hours |
|----------|-------|-------|
| Final defect triage | Fixed | 2 h |
| Generate ExtentReports final HTML | Automated | 0.5 h |
| Write closure report | Fixed | 3 h |
| Lessons learned documentation | Fixed | 1.5 h |
| Final stakeholder sign-off meeting | Fixed | 1 h |
| **Phase 6 Total** | | **~8 h** |

---

## 3. Total Effort Summary

| Phase | Estimated Hours |
|-------|----------------|
| Phase 3 — Test Case Design | 41 h |
| Phase 4 — Test Environment Setup | 29 h |
| Phase 5 — Automation Test Execution | 61.5 h |
| Phase 6 — Test Cycle Closure | 8 h |
| **Buffer (10%)** | **~14 h** |
| **GRAND TOTAL** | **~153.5 h** |

---

## 4. Test Schedule

> Single tester/developer executing all work.

| Phase | Start Date | End Date | Key Milestone / Gate |
|-------|-----------|----------|---------------------|
| Phase 2 Sign-off (KAN-20) | 2026-06-18 | 2026-06-20 | ✅ Unblocks Phase 3 |
| Phase 3 — Test Case Design | 2026-06-21 | 2026-07-04 | Phase 3 sign-off required before Phase 4 |
| Phase 4 — Environment Setup | 2026-07-05 | 2026-07-12 | Jenkins smoke test must pass before Phase 5 |
| Phase 5 — Automation Execution | 2026-07-13 | 2026-08-02 | All critical/high tests must pass |
| Phase 6 — Closure | 2026-08-03 | 2026-08-07 | Final report published; Epic KAN-9 closed |

---

## 5. Milestones

| Milestone | Target Date |
|-----------|-------------|
| Phase 2 sign-off (KAN-20) | 2026-06-20 |
| All test cases written (Phase 3 exit) | 2026-07-04 |
| Jenkins pipeline green (Phase 4 exit) | 2026-07-12 |
| All regression tests pass (Phase 5 exit) | 2026-08-02 |
| STLC Closure Report published | 2026-08-07 |

---

## 6. Assumptions
- One tester working approximately 4 hours/day on this project
- No major scope changes after Phase 2 sign-off
- Jenkins installed on local machine (no cloud CI required for this cycle)
- Buffer covers re-testing, unexpected issues, and environment troubleshooting

---

*Deliverable for KAN-17 | Author: PWG STLC Team | Date: 2026-06-18*
