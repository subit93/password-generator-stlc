# KAN-16 — Test Strategy (Manual + Automation + Jenkins)
**Project:** PWG — Password Generator App  
**Phase:** 2 — Test Planning  
**Jira Ticket:** [KAN-16](https://subit93.atlassian.net/browse/KAN-16)  
**Status:** ✅ Done  
**Date:** 2026-06-18  

---

## 1. Purpose
This document defines the overall testing approach for the PWG application — covering both manual and automated testing, the full tool stack, and the Jenkins CI/CD pipeline strategy.

---

## 2. Testing Scope Split

### 2.1 Manual Testing Scope
| Area | Description |
|------|-------------|
| Exploratory Testing | Free-form exploration of all 7 modules for usability and edge-case discovery |
| Cross-Browser Testing | Chrome (latest), Firefox (latest), Edge (latest), Safari (latest) |
| Accessibility | Basic keyboard navigation, contrast checks, ARIA role verification |
| Visual/Layout | UI rendering, tab switching, responsive layout on standard screen sizes |
| Clipboard Operations | Verify copy-to-clipboard behavior in each browser |

### 2.2 Automation Testing Scope
| Area | Description |
|------|-------------|
| Functional Tests | All 41 test objectives defined in KAN-15 |
| Regression Tests | Full suite run on every Jenkins build |
| Boundary Tests | Min/max values for length, bulk count, passphrase word count |
| Negative Tests | Invalid combinations (no charset selected, length=0, etc.) |
| localStorage Tests | History persistence, clear, max-size behaviour |

---

## 3. Automation Tool Stack

| Layer | Tool / Technology | Version |
|-------|-------------------|---------|
| Language | Java | JDK 11+ |
| Build Tool | Maven | 3.x |
| Test Framework | JUnit 5 / TestNG | Latest |
| BDD Framework | Cucumber | 7.x |
| Gherkin Format | Feature files (Given/When/Then) | — |
| UI Automation | Selenium WebDriver | 4.x |
| Design Pattern | Page Object Model (POM) | — |
| Reporting | ExtentReports (HTML) | 5.x |
| Browser Drivers | ChromeDriver, GeckoDriver | Matching browser versions |

---

## 4. Test Design Approach
- All test cases written in **Gherkin (Given/When/Then)** format
- Page Objects created per module tab: `GeneratorPage`, `BulkPage`, `PassphrasePage`, `HistoryPage`
- Shared utilities: `DriverFactory`, `BaseTest`, `ReportManager`
- Test data driven via **Cucumber DataTables** or **Examples** tables (Scenario Outline)
- No hardcoded waits — use **Explicit Waits** (`WebDriverWait`) throughout

---

## 5. Jenkins CI/CD Pipeline Strategy

> **Declared here in Phase 2. Setup deferred to Phase 4. Execution in Phase 5.**

### 5.1 Pipeline Tool
**Jenkins LTS** — pipeline-as-code using a `Jenkinsfile` committed to the project repository.

### 5.2 Pipeline Stages
```
Pipeline: PWG-Test-Pipeline
┌─────────┐   ┌──────┐   ┌────────┐   ┌─────────┐
│  Build  │ → │ Test │ → │ Report │ → │ Archive │
└─────────┘   └──────┘   └────────┘   └─────────┘
```

| Stage | Action |
|-------|--------|
| **Build** | `mvn clean compile` — compile Java test project |
| **Test** | `mvn test` — launch Selenium suite against `localhost:3000` |
| **Report** | Publish ExtentReports HTML to Jenkins build artifacts |
| **Archive** | Archive test results, screenshots on failure, and report file |

### 5.3 Jenkins Global Tool Requirements (configured in Phase 4)
- JDK 11+ named `JDK11`
- Maven 3.x named `Maven3`
- Node.js plugin (to `npm start` the app during pipeline)

### 5.4 Jenkinsfile Location
`password-generator/Jenkinsfile` — to be created in Phase 4.

---

## 6. Risk & Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| `crypto.getRandomValues()` makes output non-deterministic | Tests cannot predict exact password value | Assert on **length** and **character set membership**, not exact string |
| Browser driver version mismatch | Tests fail on CI | Pin ChromeDriver version in `pom.xml`; use WebDriverManager |
| Clipboard API blocked in headless browsers | Copy tests fail | Run tests in headed mode; skip clipboard in headless pipeline run |
| `localStorage` state bleeds between tests | Flaky history tests | Clear localStorage in `@After` hook |
| Jenkins not yet installed | Phase 5 blocked | Treat Jenkins setup as Phase 4 milestone; log risk in KAN-18 |

---

## 7. Approval
| Role | Action |
|------|--------|
| Test Lead | Authored — 2026-06-18 |
| Stakeholder | Acknowledged — Phase 3 unblocked after KAN-20 sign-off |

---

*Deliverable for KAN-16 | Author: PWG STLC Team | Date: 2026-06-18*
