---
name: pwg-app-lifecycle
description: >
  Manages the Node.js Password Generator app lifecycle during the PWG
  STLC pipeline. Ensures the app is running before tests start, and
  guarantees the process is stopped after execution completes — even
  on failure. Never leave a dangling Node.js server running.
---

# Skill: PWG App Lifecycle Management

Controls the start and stop of the Node.js Password Generator server (`http://localhost:3000`) around test execution.

---

## When to Use
- Before Phase 5 test execution (to ensure the app is available)
- After Phase 5 completes — whether tests passed, failed, or errored (STEP 3.5 of Orchestrator)
- When diagnosing "app not responding" or "port 3000 already in use" errors

---

## App Details
| Item | Value |
|---|---|
| App directory | `c:\Users\subit_mishra\Documents\AITask\Copilot_POC\password-generator` |
| Start command | `node server.js` |
| Default URL | `http://localhost:3000` |
| Process name | `node` |

---

## Start Check (Pre-Execution)
The PWG Test Executor (`run-tests.ps1`) handles app startup automatically. It:
1. Checks if Node.js is already running on port 3000
2. If not running → starts it and waits for readiness
3. Passes the running app URL to Maven

Do not start the app manually if delegating to the Executor.

---

## Stop / Cleanup (Post-Execution — MANDATORY)

Run this **always** after Phase 5, even on failure:

```powershell
$nodeProc = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProc) {
    Write-Host "Node.js still running — stopping now..."
    Stop-Process -Name "node" -Force -ErrorAction SilentlyContinue
    Write-Host "APP_SESSION_CLOSED: Node.js stopped by Orchestrator cleanup."
} else {
    Write-Host "APP_SESSION_WAS_CLEAN: Node.js already stopped by Executor."
}
```

Log the result as either:
- `APP_SESSION_CLOSED` — Orchestrator had to stop it
- `APP_SESSION_WAS_CLEAN` — Executor already cleaned up

Include this status in the Orchestrator Final Summary.

---

## Troubleshooting

**Port 3000 already in use:**
```powershell
netstat -ano | findstr :3000
# Find the PID, then:
Stop-Process -Id <PID> -Force
```

**App starts but tests fail to connect:**
- Verify `http://localhost:3000` responds in browser
- Check `password-generator/server.js` is not modified

---

## Constraints
- Cleanup step is **mandatory** — must run even if Phase 5 returned failures
- Do NOT kill the Node.js process before tests complete
- Do NOT leave the server running after `EXECUTION_COMPLETE` is confirmed
