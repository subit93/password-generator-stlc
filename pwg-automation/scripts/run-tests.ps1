# ============================================================
#  run-tests.ps1 - PWG Automation Test Runner
#  Called by  : PWG Executor Agent (Phase 5)
#  Purpose    : Start app (if needed), run Cucumber/Maven suite,
#               output structured results for Orchestrator to consume
# ============================================================

param(
    [string]$BaseUrl = "http://localhost:3000",
    [string]$Browser = "edge-headless",
    [string]$Tags    = ""
)

$ROOT    = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation"
$APPDIR  = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\password-generator"
$JSON    = "$ROOT\target\cucumber-reports\cucumber.json"
# Log files are intentionally kept OUTSIDE target/ so that 'mvn clean' can
# delete the target directory without hitting a locked-file error.
$LOGFILE = "$ROOT\mvn-output.txt"
$ERRFILE = "$ROOT\mvn-error.txt"

Set-Location $ROOT

Write-Host ""
Write-Host "============================================================"
Write-Host " PWG STLC - Phase 5: Test Execution"
Write-Host " Base URL : $BaseUrl"
Write-Host " Browser  : $Browser"
Write-Host " Tags     : $(if ($Tags) { $Tags } else { 'ALL' })"
Write-Host "============================================================"
Write-Host ""

# -- Step 1: Check if app is running, start it if not ------------
Write-Host "(Pre-flight) Checking if app is running at $BaseUrl ..."
$appRunning = $false
try {
    $resp = Invoke-WebRequest $BaseUrl -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    $appRunning = $resp.StatusCode -eq 200
} catch { $appRunning = $false }

$nodeProcess = $null
if (-not $appRunning) {
    Write-Host "(Pre-flight) App not running. Starting Node.js server..."
    $nodeProcess = Start-Process -FilePath "node" `
        -ArgumentList "server.js" `
        -WorkingDirectory $APPDIR `
        -PassThru `
        -NoNewWindow
    # Wait up to 15 seconds for the server to be ready
    $ready = $false
    for ($i = 0; $i -lt 15; $i++) {
        Start-Sleep 1
        try {
            $r = Invoke-WebRequest $BaseUrl -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
            if ($r.StatusCode -eq 200) { $ready = $true; break }
        } catch {}
    }
    if (-not $ready) {
        Write-Host "APP_START_FAILED - Could not reach $BaseUrl after 15 seconds"
        exit 2
    }
    Write-Host "(Pre-flight) App started successfully (PID: $($nodeProcess.Id))"
} else {
    Write-Host "(Pre-flight) App already running at $BaseUrl"
}

# -- Step 2: Build Maven command --------------------------------
$mvnArgs = @(
    "clean", "test",
    "-Dbrowser=$Browser",
    "-DbaseUrl=$BaseUrl",
    "-Dmaven.test.failure.ignore=true"
)
if ($Tags) { $mvnArgs += "-Dcucumber.filter.tags=$Tags" }

Write-Host ""
Write-Host "(Phase 5) Executing: mvn $($mvnArgs -join ' ')"
Write-Host ""

# -- Step 3: Run tests -------------------------------------------
$proc = Start-Process -FilePath "mvn" `
    -ArgumentList $mvnArgs `
    -WorkingDirectory $ROOT `
    -NoNewWindow -Wait -PassThru `
    -RedirectStandardOutput $LOGFILE `
    -RedirectStandardError  $ERRFILE

$exitCode = $proc.ExitCode
Write-Host "(Phase 5) Maven exit code: $exitCode"

# -- Step 4: Stop app if we started it --------------------------
if ($nodeProcess -ne $null) {
    Write-Host "(Post-run) Stopping Node.js server (PID: $($nodeProcess.Id)) ..."
    Stop-Process -Id $nodeProcess.Id -Force -ErrorAction SilentlyContinue
}

# -- Step 5: Parse cucumber.json ---------------------------------
if (-not (Test-Path $JSON)) {
    Write-Host "EXECUTION_FAILED - cucumber.json not found. Check $LOGFILE for details."
    exit 1
}

$jsonData = Get-Content $JSON -Raw | ConvertFrom-Json
$total    = 0; $passed = 0; $failed = 0; $skipped = 0
$failedScenarios = @()

foreach ($feature in $jsonData) {
    foreach ($scenario in $feature.elements) {
        $total++
        $status = "passed"
        foreach ($step in $scenario.steps) {
            if ($step.result.status -eq "failed")  { $status = "failed";  break }
            if ($step.result.status -eq "skipped" -or
                $step.result.status -eq "pending") { $status = "skipped"; break }
        }
        switch ($status) {
            "passed"  { $passed++  }
            "failed"  { $failed++;  $failedScenarios += [PSCustomObject]@{ Name = $scenario.name; Feature = $feature.name } }
            "skipped" { $skipped++ }
        }
    }
}

# -- Step 6: Locate latest Extent report -------------------------
$latestReport = Get-ChildItem "$ROOT\reports" -Filter "PWGTestReport.html" -Recurse -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1 -ExpandProperty FullName

# -- Step 7: Structured output for Orchestrator ------------------
Write-Host ""
Write-Host "============================================================"
Write-Host " EXECUTION_COMPLETE"
Write-Host " Total   : $total"
Write-Host " Passed  : $passed"
Write-Host " Failed  : $failed"
Write-Host " Skipped : $skipped"
Write-Host " JSON    : $JSON"
Write-Host " Report  : $(if ($latestReport) { $latestReport } else { 'Not generated' })"
if ($failedScenarios.Count -gt 0) {
    Write-Host " FAILED_SCENARIOS:"
    $failedScenarios | ForEach-Object {
        Write-Host "   FAILED: $($_.Feature) > $($_.Name)"
    }
}
Write-Host "============================================================"
Write-Host ""

# -- Step 8: Update POC_STLC_Walkthrough.feature -----------------
$walkthroughFile = "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\POC_STLC_Walkthrough.feature"
if (Test-Path $walkthroughFile) {
    # Count how many report folders exist to derive a run number
    $runCount = (Get-ChildItem "c:\Users\subit_mishra\Documents\AITask\Copilot_POC\pwg-automation\reports" `
        -Directory -ErrorAction SilentlyContinue | Measure-Object).Count

    $runDate     = Get-Date -Format "dd-MM-yyyy HH:mm"
    $reportShort = if ($latestReport) {
        $latestReport -replace [regex]::Escape("c:\Users\subit_mishra\Documents\AITask\Copilot_POC\"), ""
    } else { "Not generated" }

    $statusIcon  = if ($failed -gt 0) { "FAIL" } else { "PASS" }

    $newBlock = @"
# <<LAST_RUN_START>>
# +------------------------------------------------------------------------------+
# |  LAST RUN STATS  (auto-updated by run-tests.ps1 after every pipeline run)   |
# |  Run #   : $runCount                                                         |
# |  Date    : $runDate                                                          |
# |  Result  : $statusIcon  |  Total : $total  |  Passed : $passed  |  Failed : $failed  |  Skipped : $skipped |
# |  Report  : $reportShort |
# +------------------------------------------------------------------------------+
# <<LAST_RUN_END>>
"@

    $content = Get-Content $walkthroughFile -Raw
    if ($content -match '# <<LAST_RUN_START>>') {
        # Replace existing block (multiline match)
        $content = [regex]::Replace($content,
            '(?s)# <<LAST_RUN_START>>.*?# <<LAST_RUN_END>>',
            $newBlock.TrimEnd())
    } else {
        # First time: insert after the closing box header line (# <<end-of-header>>)
        $content = [regex]::Replace($content,
            '(?m)(^# =+[\r\n]+)',
            "`$1`n$($newBlock.TrimEnd())`n")
    }
    [System.IO.File]::WriteAllText($walkthroughFile, $content, [System.Text.Encoding]::UTF8)
    Write-Host "(Step 8) POC_STLC_Walkthrough.feature updated - Run #$runCount | $runDate | $statusIcon $passed/$total"
} else {
    Write-Host "(Step 8) WARNING: POC_STLC_Walkthrough.feature not found - skipping update."
}

# -- Step 9: Append to cumulative run-history.log ---------------
$historyLog = "$ROOT\reports\run-history.log"
$runId      = if ($latestReport) { Split-Path (Split-Path $latestReport -Parent) -Leaf } else { "run_unknown" }
$runDate    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$statusIcon = if ($failed -gt 0) { "FAIL" } else { "PASS" }
$bugsLine   = if ($failedScenarios.Count -gt 0) {
    "Failed scenarios: " + ($failedScenarios | ForEach-Object { $_.Name } | Join-String -Separator ", ")
} else { "No failures" }

# Derive run number from how many history entries already exist
$runNumber = 1
if (Test-Path $historyLog) {
    $runNumber = ((Get-Content $historyLog | Measure-Object -Line).Lines) + 1
}

$historyEntry = "[$runDate] Run#$runNumber | $statusIcon | Total:$total Passed:$passed Failed:$failed Skipped:$skipped | $bugsLine | Report:$runId"
Add-Content -Path $historyLog -Value $historyEntry -Encoding UTF8
Write-Host "(Step 9) run-history.log updated — $historyEntry"

# Exit with non-zero if any failures (Orchestrator uses this)
if ($failed -gt 0) { exit 1 } else { exit 0 }
