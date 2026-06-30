# KAN-15 — Test Scope & Test Objectives
**Project:** PWG — Password Generator App  
**Phase:** 2 — Test Planning  
**Jira Ticket:** [KAN-15](https://subit93.atlassian.net/browse/KAN-15)  
**Status:** ✅ Done  
**Date:** 2026-06-18  

---

## 1. Purpose
This document defines **what will be tested**, **what will not be tested**, and the **test objectives** for each in-scope module of the Password Generator application.

---

## 2. Application Under Test (AUT) Overview
| Property | Value |
|----------|-------|
| App Name | Password Generator (PWG) |
| Technology | Node.js + Express (server), Vanilla JS (frontend) |
| Runs On | `localhost:3000` |
| Random Source | `crypto.getRandomValues()` — browser crypto API |
| Data Storage | `localStorage` (password history, presets) |
| Network Calls | None — fully offline/client-side |

---

## 3. In-Scope Modules & Test Objectives

### Module 1 — Generator Tab
**Description:** Core password generation with configurable length and character sets.

| # | Test Objective |
|---|----------------|
| 1.1 | Verify password is generated with correct length when slider is set (range: 8–64) |
| 1.2 | Verify Uppercase (A–Z) characters appear when Uppercase toggle is ON |
| 1.3 | Verify Lowercase (a–z) characters appear when Lowercase toggle is ON |
| 1.4 | Verify Numeric (0–9) characters appear when Numbers toggle is ON |
| 1.5 | Verify Symbol characters appear when Symbols toggle is ON |
| 1.6 | Verify ambiguous characters (O, 0, l, 1, I) are excluded when "Exclude Ambiguous" is ON |
| 1.7 | Verify "Require Each" forces at least one character from every selected set |
| 1.8 | Verify generated password is displayed in the output box |
| 1.9 | Verify Copy button copies password to clipboard |
| 1.10 | Verify Show/Hide toggle masks and unmasks the password |
| 1.11 | Verify Regenerate button produces a different password |
| 1.12 | Verify warning is shown when length < 12 |

---

### Module 2 — Bulk Generation Tab
**Description:** Generates multiple passwords at once, allows export.

| # | Test Objective |
|---|----------------|
| 2.1 | Verify the bulk count slider controls number of passwords generated |
| 2.2 | Verify all bulk passwords are listed in the output list |
| 2.3 | Verify Export button downloads passwords as a file |
| 2.4 | Verify Clear button removes all bulk passwords from the list |
| 2.5 | Verify bulk passwords use the same character settings as the Generator tab |

---

### Module 3 — Passphrase Tab
**Description:** Generates human-readable passphrases from a curated word list.

| # | Test Objective |
|---|----------------|
| 3.1 | Verify passphrase is generated with the correct number of words (from phrase-count slider) |
| 3.2 | Verify all words in the passphrase come from the known word list |
| 3.3 | Verify Copy button copies the passphrase to clipboard |
| 3.4 | Verify regeneration produces a different passphrase |

---

### Module 4 — History Tab
**Description:** Stores previously generated passwords in `localStorage`.

| # | Test Objective |
|---|----------------|
| 4.1 | Verify generated password is added to history list after generation |
| 4.2 | Verify history persists across page reloads (localStorage) |
| 4.3 | Verify "Clear History" button removes all history entries |
| 4.4 | Verify history list is empty on first load with no prior history |

---

### Module 5 — Presets
**Description:** One-click quick configuration presets (Social, Banking, Work, Super Secure).

| # | Test Objective |
|---|----------------|
| 5.1 | Verify "Social" preset applies expected length and character set configuration |
| 5.2 | Verify "Banking" preset applies expected length and character set configuration |
| 5.3 | Verify "Work" preset applies expected length and character set configuration |
| 5.4 | Verify "Super Secure" preset applies maximum-strength configuration |
| 5.5 | Verify selecting a preset immediately updates the UI sliders and toggles |

---

### Module 6 — Strength Meter
**Description:** Visual entropy-based password strength indicator.

| # | Test Objective |
|---|----------------|
| 6.1 | Verify strength label shows "Weak" when entropy < 40 bits |
| 6.2 | Verify strength label shows "Medium" when entropy is 40–79 bits |
| 6.3 | Verify strength label shows "Strong" when entropy is 80–119 bits |
| 6.4 | Verify strength label shows "Very Strong" when entropy ≥ 120 bits |
| 6.5 | Verify strength fill bar width reflects the entropy percentage |
| 6.6 | Verify entropy value displayed (in bits) matches expected calculation |

---

### Module 7 — Security (Crypto Engine)
**Description:** Underlying security guarantees — crypto random, no network, no backend storage.

| # | Test Objective |
|---|----------------|
| 7.1 | Verify `crypto.getRandomValues()` is used (no `Math.random()`) |
| 7.2 | Verify no network requests are made during password generation |
| 7.3 | Verify generated passwords are NOT sent to any external server |
| 7.4 | Verify app works fully offline (no CDN or remote resource dependency) |
| 7.5 | Verify character distribution is uniform (no modulo bias) using rejection sampling |

---

## 4. Out-of-Scope Items

| Item | Reason |
|------|--------|
| Node.js/Express server routes (`/`) | Static file serving only — no business logic in server |
| Server-side API endpoints | None exist — app is 100% client-side |
| Database / backend storage | No database in scope; only `localStorage` is used |
| Cross-browser compatibility (IE/Safari legacy) | Project targets modern browsers only |
| Mobile native app testing | Web app only, no native app exists |
| Load / performance testing | Single-user app, no scalability concern |
| Security penetration testing | Out of scope for this STLC cycle |
| Node.js version compatibility | Fixed at Node.js v24.1.1 for this cycle |

---

## 5. Test Approach Summary
| Type | Tool / Method |
|------|--------------|
| Manual Testing | Browser-based exploratory and scripted testing |
| Automation Testing | Java + Selenium WebDriver + Cucumber BDD |
| Test Reporting | ExtentReports (HTML) |
| CI Execution | Jenkins (configured in Phase 4) |

---

## 6. Entry Criteria (to start testing)
- Application starts successfully on `localhost:3000` via `npm start`
- All 7 modules are accessible in the browser
- Test environment is set up (defined in KAN-18)

## 7. Exit Criteria (Phase 2 — KAN-20 sign-off gates this)
- All test objectives (Sections 3.1–7.5) have corresponding test cases written (Phase 3)
- Test scope document reviewed and acknowledged

---

*Deliverable for KAN-15 | Author: PWG STLC Team | Date: 2026-06-18*
