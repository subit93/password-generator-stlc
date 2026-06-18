# KAN-20 — Test Plan v1.0 — Review & Sign-off
**Project:** PWG — Password Generator App  
**Phase:** 2 — Test Planning  
**Jira Ticket:** [KAN-20](https://subit93.atlassian.net/browse/KAN-20)  
**Status:** ✅ Done  
**Date:** 2026-06-18  

---

## 1. Purpose
This document consolidates all Phase 2 artifacts into the official **Test Plan v1.0** for the PWG project, records the review walkthrough, and confirms sign-off to proceed to Phase 3.

---

## 2. Test Plan v1.0 — Consolidated Summary

### 2.1 Project Information
| Item | Value |
|------|-------|
| Project | PWG — Password Generator App |
| STLC Epic | [KAN-9](https://subit93.atlassian.net/browse/KAN-9) |
| Test Plan Version | v1.0 |
| Prepared By | PWG STLC Team |
| Date | 2026-06-18 |
| Phase Coverage | Phase 3 → Phase 6 (this plan governs all remaining phases) |

---

### 2.2 Artifact Checklist — Phase 2 Deliverables

| # | Artifact | Jira Key | File | Status |
|---|----------|---------|------|--------|
| 1 | Test Scope & Objectives | [KAN-15](https://subit93.atlassian.net/browse/KAN-15) | `KAN-15-test-scope-and-objectives.md` | ✅ Done |
| 2 | Test Strategy (Manual + Automation + Jenkins) | [KAN-16](https://subit93.atlassian.net/browse/KAN-16) | `KAN-16-test-strategy.md` | ✅ Done |
| 3 | Effort Estimation & Test Schedule | [KAN-17](https://subit93.atlassian.net/browse/KAN-17) | `KAN-17-effort-and-schedule.md` | ✅ Done |
| 4 | Test Data Catalogue & Environment Config | [KAN-18](https://subit93.atlassian.net/browse/KAN-18) | `KAN-18-test-data-and-environment.md` | ✅ Done |
| 5 | Entry & Exit Criteria | [KAN-19](https://subit93.atlassian.net/browse/KAN-19) | `KAN-19-entry-exit-criteria.md` | ✅ Done |

---

### 2.3 Scope Summary
- **Application:** Password Generator (PWG) — Node.js + Express, Vanilla JS frontend
- **Modules in Scope:** 7 (Generator, Bulk, Passphrase, History, Presets, Strength Meter, Security)
- **Total Test Objectives:** 41 (to be expanded into ~55 test cases in Phase 3)
- **Out-of-scope:** Server routes, backend APIs, mobile native, load testing, legacy browsers

---

### 2.4 Strategy Summary
| Aspect | Approach |
|--------|---------|
| Manual Testing | Exploratory + cross-browser (Chrome, Firefox, Edge, Safari) |
| Automation | Java + Selenium WebDriver + POM + Cucumber BDD + ExtentReports + Maven |
| CI/CD | Jenkins LTS (setup Phase 4, execution Phase 5) |
| Pipeline | Build → Test → Report → Archive |
| Design | Gherkin feature files, Page Object Model, Explicit Waits |

---

### 2.5 Schedule Summary
| Phase | Target Dates |
|-------|-------------|
| Phase 3 — Test Case Design | 2026-06-21 → 2026-07-04 |
| Phase 4 — Environment Setup | 2026-07-05 → 2026-07-12 |
| Phase 5 — Automation Execution | 2026-07-13 → 2026-08-02 |
| Phase 6 — Closure | 2026-08-03 → 2026-08-07 |
| **Total Estimated Effort** | **~153.5 hours** |

---

### 2.6 Key Risks
| Risk | Severity | Mitigation |
|------|---------|-----------|
| Non-deterministic crypto output | Medium | Assert on length/charset, not exact value |
| Browser driver version mismatch | Medium | Use WebDriverManager for auto-management |
| Clipboard blocked in headless mode | Low | Skip clipboard tests in headless pipeline |
| localStorage state bleed | Medium | Clear in `@After` Cucumber hook |
| Jenkins not ready for Phase 5 | High | Phase 4 milestone gate enforces this |

---

### 2.7 Entry/Exit Criteria Reference
All phase-level entry and exit criteria are documented in:  
`KAN-19-entry-exit-criteria.md` — [KAN-19](https://subit93.atlassian.net/browse/KAN-19)

---

## 3. Review Walkthrough Record

| Section Reviewed | Reviewer | Outcome |
|-----------------|---------|---------|
| Test Scope (KAN-15) | PWG Test Lead | ✅ Approved |
| Test Strategy (KAN-16) | PWG Test Lead | ✅ Approved — Jenkins placement confirmed |
| Effort & Schedule (KAN-17) | PWG Test Lead | ✅ Approved — Dates agreed |
| Test Data & Environment (KAN-18) | PWG Test Lead | ✅ Approved — Tool versions locked |
| Entry/Exit Criteria (KAN-19) | PWG Test Lead | ✅ Approved |

**Open items from review:** None

---

## 4. Sign-off

| Role | Name | Sign-off Date | Status |
|------|------|--------------|--------|
| Test Lead / Author | PWG STLC Team | 2026-06-18 | ✅ Signed Off |
| Stakeholder | PWG Project Owner | 2026-06-18 | ✅ Acknowledged |

---

## 5. Phase 3 Unblocked

> **Phase 3 — Test Case Design is officially unblocked as of 2026-06-18.**

**First action for Phase 3:**  
Create Phase 3 Jira tasks under KAN-9 and begin writing Gherkin feature files for all 7 modules based on the 41 test objectives in `KAN-15-test-scope-and-objectives.md`.

---

*Deliverable for KAN-20 | Test Plan v1.0 | Author: PWG STLC Team | Date: 2026-06-18*
