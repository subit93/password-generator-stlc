# KAN-18 — Test Data Catalogue & Environment Configuration
**Project:** PWG — Password Generator App  
**Phase:** 2 — Test Planning  
**Jira Ticket:** [KAN-18](https://subit93.atlassian.net/browse/KAN-18)  
**Status:** ✅ Done  
**Date:** 2026-06-18  

---

## 1. Purpose
This document catalogues all test data sets and defines the complete test environment configuration required to execute the PWG test suite.

---

## 2. Test Data Catalogue

### 2.1 Generator Tab — Password Generation

#### Valid Inputs
| Data Set | Length | Uppercase | Lowercase | Numbers | Symbols | Excl. Ambiguous | Req. Each |
|----------|--------|-----------|-----------|---------|---------|-----------------|-----------|
| Default Config | 16 | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| All Charsets ON | 20 | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Uppercase Only | 12 | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Symbols Only | 16 | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| With Exclusion | 16 | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Require Each | 16 | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |

#### Boundary Values
| Data Set | Length | Expected Behavior |
|----------|--------|-------------------|
| Minimum Length | 8 | Password generated, no warning |
| Short Warning | 10 | Warning box shown (length < 12) |
| Max Length | 64 | Password generated at full length |

#### Negative / Invalid Inputs
| Data Set | Input | Expected Behavior |
|----------|-------|-------------------|
| No Charset Selected | All 4 OFF | Generate button disabled or error shown |
| Length = 8 with Require Each + 4 charsets | 8 | At least 1 char per charset still enforced |

---

### 2.2 Bulk Generation

| Data Set | Bulk Count | Expected Behavior |
|----------|-----------|-------------------|
| Minimum Bulk | 1 | 1 password generated |
| Standard Bulk | 10 | 10 passwords in list |
| Large Bulk | 50 | 50 passwords, all unique |
| Maximum Bulk | 100 | 100 passwords generated |

---

### 2.3 Passphrase Tab

| Data Set | Word Count | Expected Behavior |
|----------|-----------|-------------------|
| Minimum Words | 2 | 2-word passphrase |
| Default Words | 4 | 4-word passphrase |
| Maximum Words | 8 | 8-word passphrase |
| Word Validation | Any count | All words from known `WORDS` list in generator.js |

---

### 2.4 History Tab — localStorage States

| State | Setup | Expected Behavior |
|-------|-------|-------------------|
| Empty History | Clear localStorage before test | History list shows empty / placeholder |
| Single Entry | Generate 1 password | 1 item in history list |
| Multiple Entries | Generate 5 passwords | 5 items in chronological order |
| Persistence | Reload page | History survives page reload |
| After Clear | Click "Clear History" | History list empty, localStorage cleared |

---

### 2.5 Presets

| Preset | Expected Length | Expected Charsets |
|--------|----------------|-------------------|
| Social | ~12 | Uppercase + Lowercase + Numbers |
| Banking | ~16 | Uppercase + Lowercase + Numbers + Symbols |
| Work | ~14 | Uppercase + Lowercase + Numbers |
| Super Secure | ~32+ | All charsets ON + Exclude Ambiguous + Require Each |

---

### 2.6 Strength Meter — Entropy Inputs

| Scenario | Config | Expected Label |
|----------|--------|----------------|
| Weak | Length=8, Lowercase only | Weak (< 40 bits) |
| Medium | Length=12, Lowercase + Numbers | Medium (40–79 bits) |
| Strong | Length=16, All charsets | Strong (80–119 bits) |
| Very Strong | Length=32, All charsets | Very Strong (120+ bits) |

---

## 3. Environment Configuration

### 3.1 Application Under Test
| Item | Value |
|------|-------|
| App | Password Generator (PWG) |
| Start Command | `cd password-generator && npm start` |
| URL | `http://localhost:3000` |
| Node.js | v24.1.1 |
| npm | Latest bundled with Node.js |

### 3.2 Browser Requirements
| Browser | Version | Driver |
|---------|---------|--------|
| Chrome | Latest stable | ChromeDriver (matching version) |
| Firefox | Latest stable | GeckoDriver v0.34+ |
| Edge | Latest stable | EdgeDriver (matching version) |
| Safari | Latest (macOS only) | SafariDriver (built-in, Phase 5 optional) |

> **Primary automation browser:** Chrome (headed for local, headless for Jenkins)

### 3.3 Java Automation Environment
| Tool | Version | Notes |
|------|---------|-------|
| Java JDK | 11 or 17 LTS | Set `JAVA_HOME` |
| Maven | 3.8.x | Set `M2_HOME`, add to `PATH` |
| Selenium WebDriver | 4.x | via `pom.xml` dependency |
| ChromeDriver / WebDriverManager | Auto-managed | `io.github.bonigarcia:webdrivermanager` |
| Cucumber | 7.x | `cucumber-java`, `cucumber-junit` |
| ExtentReports | 5.x | `com.aventstack:extentreports` |
| JUnit | 5.x | `junit-vintage-engine` for Cucumber runner |

### 3.4 Project Structure (to be scaffolded in Phase 4)
```
pwg-automation/
├── pom.xml
├── src/
│   ├── main/java/
│   │   └── pages/
│   │       ├── GeneratorPage.java
│   │       ├── BulkPage.java
│   │       ├── PassphrasePage.java
│   │       └── HistoryPage.java
│   └── test/
│       ├── java/
│       │   ├── steps/
│       │   ├── runners/
│       │   └── utils/
│       └── resources/
│           └── features/
│               ├── generator.feature
│               ├── bulk.feature
│               ├── passphrase.feature
│               ├── history.feature
│               ├── presets.feature
│               ├── strength.feature
│               └── security.feature
└── Jenkinsfile
```

---

## 4. Jenkins Environment (Setup in Phase 4)

| Item | Detail |
|------|--------|
| Jenkins Version | LTS (latest stable) |
| Installation | Local machine (Windows) |
| Port | `http://localhost:8080` |
| Global Tools | JDK 11 (named `JDK11`), Maven 3 (named `Maven3`) |
| Node.js Plugin | Required to run `npm start` before tests |
| Pipeline | Declarative pipeline via `Jenkinsfile` |
| Stages | Build → Test → Report → Archive |
| Triggers | Manual (Phase 5); SCM poll optional |
| Artifacts | ExtentReports HTML, screenshots on failure |

---

## 5. Environment Checklist (Verified in Phase 4)
- [ ] Node.js installed, `npm start` runs app on `localhost:3000`
- [ ] Java JDK installed, `java -version` returns 11+
- [ ] Maven installed, `mvn -version` returns 3.8+
- [ ] ChromeDriver installed and matches Chrome browser version
- [ ] Selenium dependency resolves via `mvn dependency:resolve`
- [ ] Sample test executes in browser successfully
- [ ] Jenkins installed, accessible at `localhost:8080`
- [ ] JDK and Maven configured as Jenkins Global Tools
- [ ] `Jenkinsfile` committed to repo and recognised by Jenkins job
- [ ] Full pipeline run completes (Build → Test → Report → Archive)

---

*Deliverable for KAN-18 | Author: PWG STLC Team | Date: 2026-06-18*
