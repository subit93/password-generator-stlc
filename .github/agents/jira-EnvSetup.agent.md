---
name: Jira EnvSetup
description: Use when creating Phase 4 Test Environment Setup tasks in Jira. Triggers: create environment setup tasks, run EnvSetup, setup phase 4, initialize test environment.
---

# Jira EnvSetup Agent

## Purpose
Creates all 8 Phase 4 (Test Environment Setup) tasks in Jira under Epic KAN-9 for the PWG Password Generator STLC project.

## Context
- **Jira Project**: KAN (`subit93.atlassian.net`)
- **Parent Epic**: KAN-9 — `[PWG] Password Generator App — Full STLC`
- **Issue Type**: Task (KAN project has no Story type)
- **Assignee**: `5ee7620d7835b00abe6aa3a7`
- **Phase**: 4 — Test Environment Setup
- **Depends on**: Phase 3 sign-off (KAN-29)
- **Stack**: Java 17 + Maven + Selenium WebDriver 4.x + Cucumber + WebDriverManager + ExtentReports + Jenkins LTS

## Tasks to Create (KAN-30 to KAN-37)

### KAN-30 — Verify Java & Maven Installation
**Summary**: `[PWG][Phase 4] Verify Java & Maven Installation`
**Description**:
```
Given the test environment setup phase has begun
When the tester runs `java -version` and `mvn -version` on the test machine
Then JDK 17+ and Maven 3.8+ should be confirmed installed and version numbers documented in the environment checklist (ref: KAN-18)
If not installed, install JDK 17 (Temurin/OpenJDK) and Maven 3.9.x and re-verify

Acceptance Criteria:
- `java -version` returns 17.x or higher
- `mvn -version` returns 3.8.x or higher
- Versions documented in environment-checklist.md
```

### KAN-31 — Scaffold Maven Test Project with pom.xml
**Summary**: `[PWG][Phase 4] Scaffold Maven Test Project with pom.xml`
**Description**:
```
Given Java and Maven are verified on the test machine
When a new Maven project is created under `pwg-automation/` in the workspace root
Then the project should have the standard Maven directory structure and a pom.xml with the following dependencies:
  - selenium-java 4.x
  - webdrivermanager 5.x
  - cucumber-java 7.x
  - cucumber-junit 7.x
  - junit 4.13.x
  - extentreports 5.x
  - slf4j-simple (logging)

Acceptance Criteria:
- `pwg-automation/pom.xml` exists with all listed dependencies
- `src/test/java/` and `src/test/resources/` folders created
- `mvn clean compile` runs without errors
```

### KAN-32 — Create Page Object Model (POM) Classes
**Summary**: `[PWG][Phase 4] Create Page Object Model (POM) Classes`
**Description**:
```
Given the Maven project is scaffolded
When Page Object Model classes are created under `src/test/java/pages/`
Then each tab/module of the PWG app should have its own Page class:
  - BasePage.java (WebDriver setup, teardown, shared methods)
  - GeneratorPage.java (length slider, checkboxes, generate button, copy button, output field)
  - BulkPage.java (quantity input, bulk generate, download button)
  - PassphrasePage.java (word count, separator, passphrase output)
  - HistoryPage.java (history list, clear history, export)
  - PresetsPage.java (preset buttons, save preset)
  - StrengthPage.java (strength meter bar, strength label)

Acceptance Criteria:
- All 7 page classes created under `src/test/java/pages/`
- Each class has WebDriver field, constructor, and locator constants as `By` fields
- `BasePage.java` initialises ChromeDriver via WebDriverManager
```

### KAN-33 — Create Cucumber Test Runner & Step Definition Stubs
**Summary**: `[PWG][Phase 4] Create Cucumber Test Runner & Step Definition Stubs`
**Description**:
```
Given Page Object classes are created
When the Cucumber wiring layer is set up
Then the following should be created:
  - `src/test/java/runner/TestRunner.java` — JUnit Cucumber runner pointing to features/ and stepdefs/
  - `src/test/resources/features/` — copy all 7 .feature files from .github/test-cases/
  - `src/test/java/stepdefs/` — one stub step definition class per feature file:
      GeneratorSteps.java, BulkSteps.java, PassphraseSteps.java,
      HistorySteps.java, PresetsSteps.java, StrengthSteps.java, SecuritySteps.java
  - `src/test/resources/cucumber.properties` with pretty formatter

Acceptance Criteria:
- `mvn clean test` compiles and Cucumber runner triggers (scenarios show as pending/undefined — not as compile errors)
- All 7 feature files present under features/
- All 7 step definition stubs present under stepdefs/
```

### KAN-34 — Install Jenkins LTS & Configure Global Tools
**Summary**: `[PWG][Phase 4] Install Jenkins LTS & Configure Global Tools`
**Description**:
```
Given the Maven test project is set up and compiles
When Jenkins LTS is installed on the local machine (via jenkins.war or Windows installer)
Then:
  - Jenkins should be accessible at http://localhost:8080
  - Manage Jenkins → Global Tool Configuration should have:
      - JDK 17 configured (name: JDK17, JAVA_HOME pointing to installed JDK)
      - Maven 3.9.x configured (name: Maven39, auto-install or path)
  - A new Pipeline job named `PWG-Automation` should be created

Acceptance Criteria:
- Jenkins dashboard accessible at http://localhost:8080
- JDK17 and Maven39 visible in Global Tool Configuration
- PWG-Automation pipeline job created (no Jenkinsfile wired yet)
```

### KAN-35 — Create Jenkinsfile for CI/CD Pipeline
**Summary**: `[PWG][Phase 4] Create Jenkinsfile for CI/CD Pipeline`
**Description**:
```
Given Jenkins is installed and the Maven project compiles
When a Jenkinsfile is created at the workspace root
Then the pipeline should have 4 stages:
  Stage 1 — Checkout: git checkout of feature/stlc-phase3 branch from https://github.com/subit93/password-generator-stlc.git
  Stage 2 — Build: `mvn clean compile -f pwg-automation/pom.xml`
  Stage 3 — Test: `mvn test -f pwg-automation/pom.xml`
  Stage 4 — Report: archive ExtentReports HTML from `pwg-automation/target/extent-reports/`
  Stage 5 — Archive: archive test results (surefire XML reports)

Acceptance Criteria:
- `Jenkinsfile` exists at workspace root with all 5 stages
- Pipeline uses JDK17 and Maven39 tool names
- Post section: always archive reports, on failure send console log
```

### KAN-36 — Smoke Test the Pipeline End-to-End
**Summary**: `[PWG][Phase 4] Smoke Test the Pipeline End-to-End`
**Description**:
```
Given Jenkinsfile is created and PWG-Automation job is configured in Jenkins
When the pipeline is triggered manually (Build Now)
Then:
  - Checkout stage: PASS (clones repo)
  - Build stage: PASS (mvn compile succeeds)
  - Test stage: runs (scenarios are pending/undefined — not a compile failure)
  - Report stage: ExtentReports HTML archived
  - Archive stage: surefire XML reports archived

Acceptance Criteria:
- All pipeline stages complete without BUILD FAILURE on compile errors
- Jenkins Blue Ocean or stage view shows all stages green or yellow (pending tests)
- Archived artifacts visible in Jenkins build workspace
```

### KAN-37 — Phase 4 Environment Setup Review & Sign-off
**Summary**: `[PWG][Phase 4] Test Environment Setup Review & Sign-off`
**Description**:
```
Given all Phase 4 tasks (KAN-30 to KAN-36) are completed
When the test environment is reviewed against the environment checklist (ref: KAN-18)
Then:
  - All checklist items verified: JDK, Maven, Selenium, Cucumber, ExtentReports, Jenkins, ChromeDriver
  - pwg-automation/ Maven project committed to feature/stlc-phase3 branch
  - Jenkinsfile committed to repo
  - STLC-PROGRESS.md updated: Phase 4 marked Done
  - Sign-off recorded in this ticket

Acceptance Criteria:
- Environment checklist 100% complete
- Code pushed to GitHub (feature/stlc-phase3)
- STLC-PROGRESS.md updated
- Phase 5 (Automation Test Execution) ready to begin
```

## Instructions for Agent

When triggered, execute the following steps in order:

1. Call `mcp_jira_create_ticket` 8 times (one per task above) with:
   - `project`: "KAN"
   - `issuetype`: "Task"
   - `summary`: as specified above
   - `description`: as specified above
   - `parent`: "KAN-9"

2. Call `mcp_jira_assign_ticket` 8 times with `accountId: "5ee7620d7835b00abe6aa3a7"` for each created ticket.

3. Update `.github/STLC-PROGRESS.md` — Phase 4 section with all Jira keys.

4. Confirm completion with a summary table of all created tickets.
