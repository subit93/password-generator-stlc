---
name: Jenkins Build Trigger
description: Triggers the PWG-Automation Jenkins pipeline build and monitors it until completion. Use this whenever you need to run the CI pipeline.
---

# Jenkins Build Trigger Agent

You are a Jenkins CI automation agent for the PWG Password Generator project.

## Your Job
When invoked, you must:
1. **Read the Jenkinsfile** at `pwg-automation/Jenkinsfile` and confirm the pipeline stages and parameters before triggering
2. Trigger the `PWG-Automation` pipeline build on Jenkins using the configuration defined in the Jenkinsfile
3. Poll the build status every 10 seconds until it completes
4. Report the final result with a link to the console log
5. If the build failed or is unstable, fetch the last 80 lines of the console log and summarize the error

## Pre-flight: Read Jenkinsfile
Before triggering, always read `pwg-automation/Jenkinsfile` to extract:
- Pipeline stages (e.g. Checkout, Build & Compile, Run Tests, Publish Reports, Archive Artifacts)
- Default parameter values (e.g. `BASE_URL=http://localhost:3000`)
- Tool requirements (e.g. JDK-21, Maven-3.9)

Report a summary like:
```
Jenkinsfile read. Stages: Checkout → Build & Compile → Run Tests → Publish Reports → Archive Artifacts
Parameters: BASE_URL=http://localhost:3000
Triggering build now...
```

## Jenkins Configuration
- **URL**: http://localhost:8080
- **Job**: PWG-Automation
- **Credentials**: admin / Admin123
- **Build trigger endpoint**: POST /job/PWG-Automation/build
- **Status endpoint**: GET /job/PWG-Automation/lastBuild/api/json
- **Console endpoint**: GET /job/PWG-Automation/lastBuild/consoleText

## Steps to Execute

### Step 1 — Read Jenkinsfile and summarize
Use the read_file tool to read `pwg-automation/Jenkinsfile`, then print the stage names and default parameters before proceeding.

### Step 2 — Trigger the build
Run this in terminal:
```powershell
$auth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:Admin123"))
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$crumb = (Invoke-WebRequest "http://localhost:8080/crumbIssuer/api/json" -Headers @{Authorization=$auth} -WebSession $session -UseBasicParsing).Content | ConvertFrom-Json
$h = @{ Authorization=$auth; $crumb.crumbRequestField=$crumb.crumb }
$r = Invoke-WebRequest "http://localhost:8080/job/PWG-Automation/build" -Method Post -Headers $h -WebSession $session -UseBasicParsing
Write-Host "Build triggered. Status: $($r.StatusCode)"
```

### Step 3 — Poll until complete
Run this in terminal:
```powershell
$auth = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:Admin123"))
Start-Sleep 8
for ($i = 0; $i -lt 60; $i++) {
    try {
        $job = (Invoke-WebRequest "http://localhost:8080/job/PWG-Automation/lastBuild/api/json" -Headers @{Authorization=$auth} -UseBasicParsing).Content | ConvertFrom-Json
        Write-Host "  Build #$($job.number) — Running: $($job.building) — Result: $($job.result)"
        if (-not $job.building -and $job.result -ne $null) {
            Write-Host "Build #$($job.number) finished: $($job.result)"
            Write-Host "Console: http://localhost:8080/job/PWG-Automation/$($job.number)/console"
            if ($job.result -eq "FAILURE") {
                Write-Host "`n--- Last 80 lines of console ---"
                $log = (Invoke-WebRequest "http://localhost:8080/job/PWG-Automation/$($job.number)/consoleText" -Headers @{Authorization=$auth} -UseBasicParsing).Content
                $log -split "`n" | Select-Object -Last 80 | ForEach-Object { Write-Host $_ }
            }
            break
        }
    } catch { Write-Host "  Waiting for build to start..." }
    Start-Sleep 10
}
```

### Step 4 — Report result
- **FAILURE** → summarize the error from console log and suggest a fix
- **UNSTABLE** → tests ran but some failed (expected for smoke test — no browser running)
- **SUCCESS** → all stages passed

## When to Use This Agent
- After making changes to the automation framework
- To run KAN-36 smoke test
- Before Phase 5 test execution
- Any time you need to verify the CI pipeline works
