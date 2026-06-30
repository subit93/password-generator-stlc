---
name: pwg-preflight-check
description: >
  Run the PWG pre-flight dependency check before any test phase.
  Verifies Jira connectivity, Maven, Node.js, and msedgedriver are all
  available. If any check fails the pipeline must STOP immediately.
  Use before Phase 4 or Phase 5 in the PWG STLC pipeline.
---

# Skill: PWG Pre-Flight Dependency Check

Validates that every dependency the test pipeline needs is available before allowing any phase to begin.

---

## When to Use
- At the start of every orchestrated pipeline run (STEP 1 of the Orchestrator)
- Before manually triggering Phase 5 test execution
- When diagnosing "why did the pipeline fail to start?"

---

## Checks to Perform (in order)

### Check 1 — Jira Reachable
Call `mcp_jira_get_ticket` with ticket `KAN-9`.
- ✅ Pass: ticket data returned
- ❌ Fail: log `PREFLIGHT_FAIL: Jira unreachable` → STOP pipeline

### Check 2 — Maven Available
```powershell
mvn --version
```
- ✅ Pass: output contains `Apache Maven`
- ❌ Fail: log `PREFLIGHT_FAIL: Maven not found` → STOP pipeline

### Check 3 — Node.js Available
```powershell
node --version
```
- ✅ Pass: version string returned (e.g. `v20.x.x`)
- ❌ Fail: log `PREFLIGHT_FAIL: Node.js not found` → STOP pipeline

### Check 4 — msedgedriver Present
```powershell
Test-Path "C:\Users\subit_mishra\Documents\Tools\driver\msedgedriver.exe"
```
- ✅ Pass: returns `True`
- ❌ Fail: log `PREFLIGHT_FAIL: msedgedriver.exe not found at expected path` → STOP pipeline

---

## Output Format
```
PREFLIGHT_RESULT
  Jira         : OK | FAIL
  Maven        : OK | FAIL  (<version string>)
  Node.js      : OK | FAIL  (<version string>)
  msedgedriver : OK | FAIL
  Overall      : PASS | FAIL
```

## Constraints
- All 4 checks must pass for `Overall: PASS`
- On ANY failure → do not proceed to Phase 4 or Phase 5
- Do not attempt to fix the missing dependency — report and stop
