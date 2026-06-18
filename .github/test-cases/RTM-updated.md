# Requirements Traceability Matrix (RTM) — Updated
# Phase 3 — Test Case Mapping
# Jira: KAN-28
# Updated: 2026-06-18

## Summary
| Metric | Value |
|--------|-------|
| Total Requirements (from Phase 1) | 41 (7 modules × objectives) |
| Total Test Cases Created | 55 |
| Requirements Covered | 41/41 |
| Coverage % | 100% |
| Gaps | 0 |

---

## Module 1 — Generator Tab

| Req ID | Requirement | Test Case IDs | Feature File |
|--------|-------------|--------------|-------------|
| REQ-GEN-01 | Password generated with correct length (8–64) | TC-GEN-02 (Scenario Outline) | generator.feature |
| REQ-GEN-02 | Uppercase (A–Z) included when toggle ON | TC-GEN-05 | generator.feature |
| REQ-GEN-03 | Lowercase (a–z) included when toggle ON | TC-GEN-06 | generator.feature |
| REQ-GEN-04 | Numbers (0–9) included when toggle ON | TC-GEN-07 | generator.feature |
| REQ-GEN-05 | Symbols included when toggle ON | TC-GEN-08 | generator.feature |
| REQ-GEN-06 | Ambiguous chars (O,0,l,1,I) excluded when toggle ON | TC-GEN-09 | generator.feature |
| REQ-GEN-07 | Require Each forces ≥1 char from each selected set | TC-GEN-10 | generator.feature |
| REQ-GEN-08 | Generated password displayed in output box | TC-GEN-01, TC-GEN-11 | generator.feature |
| REQ-GEN-09 | Copy button copies password to clipboard | TC-GEN-12 | generator.feature |
| REQ-GEN-10 | Show/Hide toggle masks and unmasks password | TC-GEN-13 | generator.feature |
| REQ-GEN-11 | Regenerate button produces a different password | TC-GEN-14 | generator.feature |
| REQ-GEN-12 | Warning shown when length < 12 | TC-GEN-15 (Scenario Outline) | generator.feature |

---

## Module 2 — Bulk Generation Tab

| Req ID | Requirement | Test Case IDs | Feature File |
|--------|-------------|--------------|-------------|
| REQ-BLK-01 | Bulk count slider controls number of passwords | TC-BLK-01 (Scenario Outline) | bulk.feature |
| REQ-BLK-02 | All bulk passwords listed in output | TC-BLK-02 | bulk.feature |
| REQ-BLK-03 | Export button downloads passwords as file | TC-BLK-03 | bulk.feature |
| REQ-BLK-04 | Clear button removes all bulk passwords | TC-BLK-04 | bulk.feature |
| REQ-BLK-05 | Bulk passwords use same character settings | TC-BLK-05, TC-BLK-06, TC-BLK-07 | bulk.feature |

---

## Module 3 — Passphrase Tab

| Req ID | Requirement | Test Case IDs | Feature File |
|--------|-------------|--------------|-------------|
| REQ-PH-01 | Correct number of words generated | TC-PH-01 (Scenario Outline) | passphrase.feature |
| REQ-PH-02 | All words from known WORDS list | TC-PH-02 | passphrase.feature |
| REQ-PH-03 | Copy button copies passphrase | TC-PH-03 | passphrase.feature |
| REQ-PH-04 | Regeneration produces different passphrase | TC-PH-04, TC-PH-05 | passphrase.feature |

---

## Module 4 — History Tab

| Req ID | Requirement | Test Case IDs | Feature File |
|--------|-------------|--------------|-------------|
| REQ-HIST-01 | Generated password added to history | TC-HIST-01 | history.feature |
| REQ-HIST-02 | History persists across page reload (localStorage) | TC-HIST-03, TC-HIST-06 | history.feature |
| REQ-HIST-03 | Clear History removes all entries | TC-HIST-04 | history.feature |
| REQ-HIST-04 | Empty state on first load | TC-HIST-05 | history.feature |

---

## Module 5 — Presets

| Req ID | Requirement | Test Case IDs | Feature File |
|--------|-------------|--------------|-------------|
| REQ-PRE-01 | Social preset applies correct config | TC-PRE-01 | presets.feature |
| REQ-PRE-02 | Banking preset applies correct config | TC-PRE-02 | presets.feature |
| REQ-PRE-03 | Work preset applies correct config | TC-PRE-03 | presets.feature |
| REQ-PRE-04 | Super Secure applies max-strength config | TC-PRE-04, TC-PRE-05 | presets.feature |
| REQ-PRE-05 | Preset immediately updates UI | TC-PRE-06 | presets.feature |

---

## Module 6 — Strength Meter

| Req ID | Requirement | Test Case IDs | Feature File |
|--------|-------------|--------------|-------------|
| REQ-STR-01 | "Weak" shown when entropy < 40 bits | TC-STR-01 | strength.feature |
| REQ-STR-02 | "Medium" shown when entropy 40–79 bits | TC-STR-02 | strength.feature |
| REQ-STR-03 | "Strong" shown when entropy 80–119 bits | TC-STR-03 | strength.feature |
| REQ-STR-04 | "Very Strong" shown when entropy ≥ 120 bits | TC-STR-04 | strength.feature |
| REQ-STR-05 | Fill bar width reflects entropy % | TC-STR-05 | strength.feature |
| REQ-STR-06 | Entropy value in bits displayed | TC-STR-06 | strength.feature |

---

## Module 7 — Security (Crypto Engine)

| Req ID | Requirement | Test Case IDs | Feature File |
|--------|-------------|--------------|-------------|
| REQ-SEC-01 | crypto.getRandomValues() used (not Math.random()) | TC-SEC-01 | security.feature |
| REQ-SEC-02 | No network requests during generation | TC-SEC-02 | security.feature |
| REQ-SEC-03 | Passwords NOT sent to external server | TC-SEC-03 | security.feature |
| REQ-SEC-04 | App works fully offline | TC-SEC-04, TC-SEC-05 | security.feature |
| REQ-SEC-05 | Character distribution is uniform (rejection sampling) | TC-SEC-06 | security.feature |

---

## Additional Test Cases (Beyond 41 objectives)

| Test Case ID | Description | Rationale |
|-------------|-------------|-----------|
| TC-HIST-02 | Multiple passwords in history | Extended coverage |
| TC-BLK-07 | All bulk passwords are unique | Quality assurance |
| TC-STR-07 | Strength updates on slider change | Dynamic UI coverage |
| TC-STR-08 | Strength updates on charset toggle | Dynamic UI coverage |
| TC-SEC-07 | No passwords in console logs | Security hygiene |
| TC-SEC-08 | No insecure APIs used | Security hygiene |
| TC-GEN-04 | Default config generation | Smoke test |

---

## Gaps & Uncovered Items
**None** — all 41 requirements are covered by at least one test case.

---

*RTM Updated for Phase 3 | Author: PWG STLC Team | Date: 2026-06-18*
