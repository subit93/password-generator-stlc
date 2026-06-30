# KAN-19 — Entry & Exit Criteria
**Project:** PWG — Password Generator App  
**Phase:** 2 — Test Planning  
**Jira Ticket:** [KAN-19](https://subit93.atlassian.net/browse/KAN-19)  
**Status:** ✅ Done  
**Date:** 2026-06-18  

---

## 1. Purpose
This document defines the formal **entry criteria** (what must be true before a phase can start) and **exit criteria** (what must be true before a phase can be declared done) for all 6 STLC phases of the PWG project.

---

## 2. Phase Gates Overview

```
Phase 1 ──→ [EXIT GATE 1] ──→ Phase 2 ──→ [EXIT GATE 2] ──→ Phase 3
                                                              ↓
Phase 6 ←── [EXIT GATE 5] ←── Phase 5 ←── [EXIT GATE 4] ←── Phase 4
```

---

## 3. Criteria Per Phase

### Phase 1 — Requirement Analysis

#### Entry Criteria
| # | Criterion |
|---|-----------|
| 1.1 | Password Generator app source code is accessible in the workspace |
| 1.2 | Jira project (KAN) and Epic (KAN-9) are created |
| 1.3 | Phase 1 Jira tasks (KAN-10 to KAN-14) are created and assigned |

#### Exit Criteria
| # | Criterion | Jira Ref |
|---|-----------|---------|
| 1.1 | Functional requirements documented (all 7 modules covered) | KAN-10 |
| 1.2 | Non-functional requirements documented (performance, security, usability) | KAN-11 |
| 1.3 | Testable vs. non-testable requirements classified | KAN-12 |
| 1.4 | Requirements Traceability Matrix (RTM) created and baselined | KAN-13 |
| 1.5 | Phase 1 sign-off obtained (KAN-14 moved to Done) | KAN-14 |

---

### Phase 2 — Test Planning

#### Entry Criteria
| # | Criterion |
|---|-----------|
| 2.1 | Phase 1 exit criteria 1.1–1.5 all met |
| 2.2 | RTM is baselined and accessible |
| 2.3 | Phase 2 Jira tasks (KAN-15 to KAN-20) created and assigned |

#### Exit Criteria
| # | Criterion | Jira Ref |
|---|-----------|---------|
| 2.1 | Test scope document created (7 modules in-scope, out-of-scope justified) | KAN-15 |
| 2.2 | Test strategy document created (manual + automation + Jenkins pipeline declared) | KAN-16 |
| 2.3 | Effort estimates and test schedule agreed | KAN-17 |
| 2.4 | Test data catalogue and environment checklist documented | KAN-18 |
| 2.5 | Entry/exit criteria (this document) reviewed and approved | KAN-19 |
| 2.6 | Test Plan v1.0 signed off (KAN-20 moved to Done) | KAN-20 |

---

### Phase 3 — Test Case Design

#### Entry Criteria
| # | Criterion |
|---|-----------|
| 3.1 | Phase 2 exit criteria 2.1–2.6 all met (KAN-20 Done) |
| 3.2 | Test scope document (KAN-15) is accessible |
| 3.3 | RTM from Phase 1 is available for test case mapping |
| 3.4 | Phase 3 Jira tasks created |

#### Exit Criteria
| # | Criterion |
|---|-----------|
| 3.1 | Gherkin feature files created for all 7 modules (all 41+ objectives covered) |
| 3.2 | Each test case mapped to at least one RTM requirement |
| 3.3 | Test cases peer-reviewed (or self-reviewed as sole tester) |
| 3.4 | RTM updated with test case IDs |
| 3.5 | Phase 3 sign-off task in Jira moved to Done |

---

### Phase 4 — Test Environment Setup

#### Entry Criteria
| # | Criterion |
|---|-----------|
| 4.1 | Phase 3 exit criteria all met |
| 4.2 | Test strategy (KAN-16) and environment checklist (KAN-18) are available |
| 4.3 | Tool versions agreed and documented in KAN-18 |

#### Exit Criteria
| # | Criterion |
|---|-----------|
| 4.1 | Java JDK, Maven, and Selenium installed and verified (`java -version`, `mvn -version`) |
| 4.2 | Maven project (`pom.xml`) created with all dependencies resolving |
| 4.3 | Page Object Model classes (GeneratorPage, BulkPage, PassphrasePage, HistoryPage) scaffolded |
| 4.4 | ChromeDriver/GeckoDriver installed and working |
| 4.5 | 5 sample test scenarios execute successfully in browser |
| 4.6 | Jenkins LTS installed and accessible at `localhost:8080` |
| 4.7 | JDK and Maven configured as Jenkins Global Tools |
| 4.8 | `Jenkinsfile` committed to repo; Jenkins job created and pipeline recognised |
| 4.9 | Full pipeline (Build → Test → Report → Archive) completes with sample tests |
| 4.10 | Phase 4 sign-off task in Jira moved to Done |

---

### Phase 5 — Automation Test Execution

#### Entry Criteria
| # | Criterion |
|---|-----------|
| 5.1 | Phase 4 exit criteria all met |
| 5.2 | All Cucumber feature files from Phase 3 are available |
| 5.3 | PWG app starts successfully at `localhost:3000` |
| 5.4 | Jenkins pipeline is green with sample tests |

#### Exit Criteria
| # | Criterion |
|---|-----------|
| 5.1 | All step definitions implemented for all 7 modules |
| 5.2 | Full regression suite executed via Jenkins pipeline at least once |
| 5.3 | All **Critical** and **High** priority test cases pass |
| 5.4 | Defect rate for Critical/High ≤ 0 (no open critical/high defects) |
| 5.5 | All defects logged in Jira with reproducible steps |
| 5.6 | ExtentReports HTML report generated and published |
| 5.7 | Phase 5 sign-off task in Jira moved to Done |

---

### Phase 6 — Test Cycle Closure

#### Entry Criteria
| # | Criterion |
|---|-----------|
| 6.1 | Phase 5 exit criteria all met |
| 6.2 | All planned test cycles executed |
| 6.3 | Defect log is up to date |
| 6.4 | ExtentReports final HTML is available |

#### Exit Criteria
| # | Criterion |
|---|-----------|
| 6.1 | Final defect triage complete — all open defects triaged |
| 6.2 | Test Closure Report published (pass/fail metrics, defect summary, coverage %) |
| 6.3 | Lessons learned documented |
| 6.4 | All STLC phase Jira tasks moved to Done |
| 6.5 | Epic KAN-9 moved to Done in Jira |
| 6.6 | STLC-PROGRESS.md all phases marked ✅ Done |

---

## 4. Suspension & Resumption Criteria

| Condition | Action |
|-----------|--------|
| PWG app fails to start | Suspend testing; fix app; resume from last known good state |
| Jenkins pipeline broken | Suspend Phase 5 execution; fix pipeline; re-run full regression |
| Critical blocker defect found | Suspend execution; log defect; wait for fix; re-test before continuing |
| Test environment wiped/reset | Re-verify all Phase 4 exit criteria before resuming Phase 5 |

---

*Deliverable for KAN-19 | Author: PWG STLC Team | Date: 2026-06-18*
