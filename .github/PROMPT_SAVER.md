# Prompt Saver Checklist — PWG Password Generator Project

> A living log of every significant prompt used in this project.
> Captures the technique, the actual prompt (or summary), the context, and usage guidance.

---

## How to Use This File
- Add a new entry every time a well-crafted prompt is used in this project.
- Format: Technique → Context → Prompt Summary → When to Reuse.

---

## Prompt Log

---

### #1 — Jenkins Startup & Build Trigger

| Field       | Detail |
|-------------|--------|
| **Technique** | **Zero-Shot Imperative** |
| **When Used** | June 19, 2026 — Diagnosing Jenkins home mismatch and triggering build #18 |
| **Prompt Summary** | "Start Jenkins using the correct home directory `C:\Jenkins` and trigger a fresh build of PWG-Automation using the Jenkinsfile" |
| **Why This Technique** | Single, concrete task with all context already known. No ambiguity. Direct instruction is the most efficient approach. |
| **When to Reuse** | Any time you need a single well-defined operation executed without exploration — start a service, run a command, trigger a pipeline. |

---

### #2 — Jenkins Home Mismatch Diagnosis

| Field       | Detail |
|-------------|--------|
| **Technique** | **Chain-of-Thought (CoT)** |
| **When Used** | June 19, 2026 — Figuring out why Jenkins showed "Unlock Jenkins" screen instead of yesterday's session |
| **Prompt Summary** | "Jenkins is showing the unlock screen again. Find where my Jenkins data is stored, why it started fresh, and fix it so I get my previous jobs back." |
| **Why This Technique** | Problem required multi-step reasoning: find WAR → identify JENKINS_HOME → compare timestamps → diagnose wrong home → fix startup command. CoT forces the agent to reason step-by-step rather than jump to a wrong answer. |
| **When to Reuse** | Any time the root cause is unclear and needs elimination-style diagnosis (e.g., environment bugs, config mismatches, test failures with unknown origin). |

---

### #3 — TC-BLK-06 Test Failure Fix

| Field       | Detail |
|-------------|--------|
| **Technique** | **Root Cause Analysis Prompt (RCA)** |
| **When Used** | June 19, 2026 — Build #18 returned UNSTABLE; one Cucumber scenario failing with `expected:<20> but was:<0>` |
| **Prompt Summary** | "Check the build console log and fix the failure so that all scripts should pass." |
| **Why This Technique** | The symptom (length = 0) was misleading. RCA-style prompting forces the agent to trace back from error message → step definition → page object → DOM interaction → root cause (hidden panel + headless getText()). Prevents surface-level patch fixes. |
| **When to Reuse** | Any time a test, build, or runtime error needs more than a one-line fix — trace the symptom to its origin before writing code. |

---

### #4 — Jenkins Pre-flight Hook Addition

| Field       | Detail |
|-------------|--------|
| **Technique** | **Specification-by-Example** |
| **When Used** | June 19, 2026 — Adding a startup hook to `jenkins-build-trigger.agent.md` |
| **Prompt Summary** | "Before starting the build process, the hook should start Jenkins and prompt me to open localhost. Mention this as a hook in the agent file." |
| **Why This Technique** | The user described the desired *behaviour with an example outcome* ("prompt me to open localhost") rather than the implementation. This guided the agent to produce the right polling loop + browser-open pattern rather than a simple Start-Process call. |
| **When to Reuse** | When you want to add behaviour to an existing workflow and it is easier to describe the expected observable outcome than the code. |

---

### #5 — Agent Restructure (RISEN Framework)

| Field       | Detail |
|-------------|--------|
| **Technique** | **RISEN Framework** *(Role · Instructions · Steps · End Goal · Narrowing)* |
| **When Used** | June 22, 2026 — Removing the Epic agent and renaming all STLC phase agents to descriptive names |
| **Full Prompt** | See below |
| **Why This Technique** | Multi-action destructive + rename task touching multiple files. RISEN eliminates ambiguity by separating *who acts*, *what to do*, *exact steps*, *success state*, and *hard no-touch boundaries*. Critical for operations that cannot easily be undone (delete + rename). |
| **When to Reuse** | Any task involving: file deletion, mass renaming, refactoring across multiple files, infrastructure changes, or any operation where a wrong move is hard to reverse. |

**Full RISEN Prompt Used:**
```
[ROLE]
You are a VS Code workspace automation agent managing the `.github/agents/` directory
of a Cucumber/Selenium test automation project (PWG Password Generator).

[INSTRUCTIONS]
Restructure the GitHub Agents configuration by removing all Jira Epic-related agents
and renaming the remaining STLC phase agents to use clear, phase-descriptive names
following the pattern `jira-<PhaseRole>.agent.md`.

[STEPS]
1. Discover — List all `.agent.md` files currently inside `.github/agents/`.
2. Delete — Permanently remove any agent file responsible for creating Jira Epics.
   Remove any Epic-specific logic or cross-references from other agent files.
3. Rename — Rename the remaining STLC phase agents:
   - Requirement Analysis  → jira-ReAnalyser.agent.md
   - Test Planning         → jira-TestPlanCreator.agent.md
   - Test Case Design      → jira-TestCaseDesigner.agent.md
   - Test Environment Setup→ jira-EnvSetup.agent.md
   Update every internal name: frontmatter field and cross-agent link.
4. Verify — Confirm no remaining references to deleted/old names exist.

[END GOAL]
A clean `.github/agents/` directory with only STLC phase agents named with
the `jira-<PhaseRole>.agent.md` convention.

[NARROWING]
- Do NOT touch jenkins-build-trigger.agent.md or any non-Jira agents.
- Do NOT modify test source files, Jenkinsfile, or feature files.
- Operate ONLY on .agent.md files inside .github/agents/.
- Preserve all Jira ticket-creation logic — only delete, rename, update references.
- Ask for confirmation BEFORE deleting any file.
```

---

## Quick Reference — Technique Selection Guide

| Situation | Best Technique |
|---|---|
| Single clear action, context known | Zero-Shot Imperative |
| Multi-step diagnosis / root cause unknown | Chain-of-Thought (CoT) |
| Destructive / irreversible multi-file operations | RISEN Framework |
| Describe desired behaviour, not implementation | Specification-by-Example |
| Complex debugging with error trace | Root Cause Analysis (RCA) |
| Generating test cases / edge cases | Few-Shot with Examples |
| Iterative refinement of a document/code | Self-Refinement Loop |
| Choosing between approaches | Comparative Prompting |

---

*Last updated: June 22, 2026*
