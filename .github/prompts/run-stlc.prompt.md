---
name: Run PWG STLC Pipeline
description: >
  One-click trigger for the full PWG STLC Orchestrator pipeline.
  Use when: "run stlc", "start the pipeline", "run all tests", "execute full pipeline",
  "run end to end", "go", "trigger orchestrator".
mode: agent
tools: [run_in_terminal, read_file, search, todo, agent, mcp_jira_create_ticket, mcp_jira_execute_jql, mcp_jira_get_task]
---

Invoke the **PWG STLC Orchestrator** agent to run the full end-to-end STLC pipeline for the PWG Password Generator project.

Use the argument: `${input:scope:full | phase5-only | @security | @generator | @bulk | @passphrase | @history | @presets | @strength}`

The Orchestrator will:
1. Run pre-flight dependency checks (Jira, Maven, Node, msedgedriver)
2. Hand off to **Jira EnvSetup** agent for Phase 4 environment verification
3. Hand off to **PWG Test Executor** agent to run the Cucumber/Maven test suite
4. Hand off to **PWG Defect Triage** agent to file Jira bugs for any new failures
5. Hand off to **PWG Report Agent** to generate an AI-written summary
6. Return a unified final summary with all pass/fail counts, Jira tickets, and report path
