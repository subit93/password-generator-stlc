# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║         POC WALKTHROUGH — End-to-End STLC Demonstration Script              ║
# ║         Application Under Test: Password Generator                          ║
# ║         Audience: Layman / Non-Technical Reviewers                          ║
# ║         Written in: Gherkin (Plain English test language)                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# <<LAST_RUN_START>>
# +------------------------------------------------------------------------------+
# |  LAST RUN STATS  (auto-updated by orchestrator after every pipeline run)     |
# |  Run #   : 2                                                                 |
# |  Date    : 23-06-2026 13:30                                                  |
# |  Result  : PASS  |  Total : 138  |  Passed : 138  |  Failed : 0  |  Skipped : 0 |
# |  HITL    : NOT TRIGGERED (zero failures - auto-proceeded)                    |
# |  Report  : pwg-automation\reports\run_23-06-2026_13-28\PWGTestReport.html   |
# +------------------------------------------------------------------------------+
# <<LAST_RUN_END>>
#
# What is Gherkin?
# ─────────────────
# Gherkin is a plain-English way of writing test scenarios so that EVERYONE —
# whether you are a developer, a tester, or a business person — can read and
# understand exactly what is being tested and why.
#
# Every scenario follows three simple words:
#   Given  → the starting condition   (the world is set up like this)
#   When   → the action               (someone does this)
#   Then   → the expected result      (we check that this happens)
#
# Think of it like a recipe card: ingredients → steps → finished dish.
#
# ──────────────────────────────────────────────────────────────────────────────
# STLC = Software Testing Life Cycle
# It is the sequence of steps a professional team follows to ensure that a
# software application works correctly before it reaches real users.
# ──────────────────────────────────────────────────────────────────────────────

# ════════════════════════════════════════════════════════════════════════════
# SECTION 0 — PROJECT AT A GLANCE
# ════════════════════════════════════════════════════════════════════════════

@poc-overview
Feature: POC Overview — What Did We Build and Why?

  """
  PROJECT NAME : Password Generator — Full STLC POC
  APPLICATION  : A fully offline, browser-based secure password generator
  PURPOSE      : Demonstrate every phase of the Software Testing Life Cycle (STLC)
                 using a real, working application and a real, running test suite

  THE PROBLEM WE SOLVED
  ─────────────────────
  Every day people create weak passwords like "password123" or "abc123".
  These are easy to guess and put personal data at serious risk.

  THE SOLUTION WE BUILT
  ─────────────────────
  A web application that generates:
    ✦ Random secure passwords   — customised to the user's needs
    ✦ Bulk passwords            — generate many at once and export them
    ✦ Passphrases               — easy-to-remember word combinations
    ✦ History tracking          — remember what you created this session

  WHY IS THIS A GOOD POC FOR STLC?
  ──────────────────────────────────
  The application is small enough to understand in one sitting but
  rich enough to exercise every single phase of the STLC:

  Phase 1 → Requirement Analysis  (What should the app do?)
  Phase 2 → Test Planning         (How are we going to test it?)
  Phase 3 → Test Case Design      (Write the actual test scenarios)
  Phase 4 → Test Environment Setup(Get everything running)
  Phase 5 → Test Execution        (Run the tests)
  Phase 6 → Test Reporting        (See the results in a nice report)
  Phase 7 → CI/CD Pipeline        (Automate the whole thing — Jenkins)
  """

  Scenario: Introduce the application to the audience
    Given the audience sees the Password Generator running at "http://localhost:3000"
    When the presenter points to the four tabs: Generator, Bulk, Passphrase, History
    Then the audience understands the application has four main features
    And the audience can see the app works entirely in the browser with no internet needed


# ════════════════════════════════════════════════════════════════════════════
# SECTION 1 — STLC PHASE 1: REQUIREMENT ANALYSIS
# ════════════════════════════════════════════════════════════════════════════

@phase-1-requirements
Feature: Phase 1 — Requirement Analysis (Understanding What We Need to Build)

  """
  WHAT IS REQUIREMENT ANALYSIS?
  ──────────────────────────────
  Before writing a single line of code or a single test, the team must
  first understand: "What exactly should this software do?"

  In our project this was done through Jira (a project management tool).
  Each feature of the application was written down as a User Story — a
  sentence from the perspective of the person using the app.

  JIRA STORIES CREATED FOR THIS PROJECT
  ──────────────────────────────────────
  KAN-15 → Master Test Case Register (all 45 test cases listed)
  KAN-21 → Generator Tab requirements  (15 test cases)
  KAN-22 → Bulk Generation requirements (7 test cases)
  KAN-23 → Passphrase requirements      (5 test cases)
  KAN-24 → History requirements         (6 test cases)
  KAN-25 → Presets requirements         (6 test cases)
  KAN-26 → Strength Meter requirements  (8 test cases)
  KAN-27 → Security requirements        (8 test cases)
  ───────────────────────────────────
  TOTAL REQUIREMENTS: 55 scenarios across 7 modules
  """

  Background:
    Given the team has access to Jira project "KAN"
    And a Product Owner has described what the Password Generator must do

  Scenario: Capture the main feature requirements as User Stories
    Given the business need is "Users should be able to create secure passwords easily"
    When the team breaks this down into specific features:
      | Feature               | Description                                                    |
      | Generator             | Generate one password with chosen length and character types   |
      | Bulk Generation       | Generate many passwords at once and download them              |
      | Passphrase            | Generate easy-to-remember word combinations                    |
      | History               | Keep track of recently generated passwords                     |
      | Presets               | One-click configuration for Social, Banking, Work, SuperSecure |
      | Strength Meter        | Show how strong a password is using colour and label           |
      | Security Validation   | Confirm the app never sends passwords over the internet        |
    Then each feature is recorded as a Jira story with acceptance criteria

  Scenario: Define security requirements for the application
    Given security is a critical concern for a password tool
    When the team identifies these non-functional requirements:
      | Requirement                                              |
      | Passwords must be generated using crypto.getRandomValues |
      | No password must ever be sent to any server              |
      | The app must work 100% offline                           |
      | No external CDN or font libraries must be loaded         |
      | No ambiguous characters (O, 0, l, 1, I) when requested  |
    Then these are added to KAN-27 as security acceptance criteria

  Scenario: Define the test coverage target
    Given 7 modules have been identified for testing
    When the team counts all the test cases across all modules:
      | Module         | Test Cases |
      | Generator      | 15         |
      | Bulk           | 7          |
      | Passphrase     | 5          |
      | History        | 6          |
      | Presets        | 6          |
      | Strength Meter | 8          |
      | Security       | 8          |
    Then the total number of test cases is 55
    And each test case is assigned a unique ID (e.g., TC-GEN-01, TC-SEC-04)


# ════════════════════════════════════════════════════════════════════════════
# SECTION 2 — STLC PHASE 2: TEST PLANNING
# ════════════════════════════════════════════════════════════════════════════

@phase-2-test-planning
Feature: Phase 2 — Test Planning (Deciding How We Will Test)

  """
  WHAT IS TEST PLANNING?
  ────────────────────────
  Once we know WHAT to test, we decide HOW we will test it.
  Test planning answers these questions:
    ✦ What tools will we use?
    ✦ Who will run the tests?
    ✦ In what environment will tests run?
    ✦ What counts as a PASS and what counts as a FAIL?

  OUR TEST PLAN DECISIONS
  ────────────────────────
  Testing Type   : Automated Functional + Security Testing
  Test Language  : Gherkin BDD (readable by everyone)
  Test Framework : Cucumber 7.18  (runs the Gherkin scenarios)
  Code Language  : Java 21         (powers the automation)
  Browser Tool   : Selenium 4.21   (controls the browser automatically)
  Browser Used   : Microsoft Edge  (headless — runs without a visible window)
  Build Tool     : Maven 3.9        (compiles and runs everything)
  Report Tool    : ExtentReports 5  (beautiful HTML test reports)
  CI/CD Tool     : Jenkins          (runs tests automatically — parked for Phase 5)
  """

  Scenario: Choose the right tools for automated testing
    Given the team evaluates different testing approaches
    When the team selects Behavior-Driven Development (BDD) with Cucumber
    Then every test is written in plain English (Gherkin)
    And any person — developer, tester, or manager — can read and understand the tests

  Scenario: Define the test execution strategy
    Given 55 test cases need to be run
    When the team organises tests into tagged groups:
      | Tag         | Purpose                                |
      | @generator  | All Generator tab tests                |
      | @bulk       | All Bulk tab tests                     |
      | @passphrase | All Passphrase tab tests               |
      | @history    | All History tab tests                  |
      | @presets    | All Presets tests                      |
      | @strength   | All Strength Meter tests               |
      | @security   | All Security validation tests          |
    Then tests can be run in groups using: mvn test -Dcucumber.filter.tags="@security"
    And the full suite runs with: mvn clean test

  Scenario: Define what happens when a test fails
    Given a test scenario detects unexpected behaviour
    When the test framework captures a screenshot of the browser at the point of failure
    Then the screenshot is embedded into the ExtentReports HTML report
    And the Jira ticket linked to that test case is updated with the failure evidence


# ════════════════════════════════════════════════════════════════════════════
# SECTION 3 — STLC PHASE 3: TEST CASE DESIGN
# ════════════════════════════════════════════════════════════════════════════

@phase-3-test-design
Feature: Phase 3 — Test Case Design (Writing the Test Scenarios)

  """
  WHAT IS TEST CASE DESIGN?
  ──────────────────────────
  This is the creative heart of testing. We take each requirement and
  write out specific test scenarios that prove the app either WORKS or
  DOESN'T WORK as expected.

  Our test cases use THREE techniques:
    1. Happy Path    — test the most common, expected usage
    2. Boundary Test — test the extreme edges (minimum & maximum values)
    3. Negative Test — test what happens when something goes wrong

  HOW OUR TEST FILES ARE ORGANISED
  ─────────────────────────────────
  Location: pwg-automation/src/test/resources/features/
  Files:    generator.feature   → 15 scenarios (TC-GEN-01 to TC-GEN-15)
            bulk.feature        →  7 scenarios (TC-BLK-01 to TC-BLK-07)
            passphrase.feature  →  5 scenarios (TC-PH-01  to TC-PH-05)
            history.feature     →  6 scenarios (TC-HIST-01 to TC-HIST-06)
            presets.feature     →  6 scenarios (TC-PRE-01 to TC-PRE-06)
            strength.feature    →  8 scenarios (TC-STR-01 to TC-STR-08)
            security.feature    →  8 scenarios (TC-SEC-01 to TC-SEC-08)
  """

  # ── MODULE 1: GENERATOR TAB ──────────────────────────────────────────────

  Scenario: [TC-GEN-01] Show the audience the simplest generator test
    Given the audience understands what "default settings" means
      | Setting   | Default Value |
      | Length    | 16 characters |
      | Uppercase | ON            |
      | Lowercase | ON            |
      | Numbers   | ON            |
      | Symbols   | OFF           |
    When the user clicks the "Generate" button
    Then a 16-character password appears on screen immediately

  Scenario Outline: [TC-GEN-02 to TC-GEN-04] Show boundary testing — testing the edges
    """
    WHY DO WE TEST EDGES?
    We test the smallest value (8) and the largest value (64) because
    software bugs most commonly hide at the boundaries, not in the middle.
    This technique is called "Boundary Value Analysis".
    """
    Given the length slider is dragged to <length>
    When the user clicks "Generate"
    Then the password produced is exactly <length> characters long
    And the badge number next to the slider shows "<length>"

    Examples:
      | length | what_it_proves                           |
      | 8      | Minimum length works                     |
      | 16     | Standard default works                   |
      | 32     | Longer passwords work                    |
      | 64     | Maximum length works                     |

  Scenario: [TC-GEN-09] Show negative / exclusion testing
    """
    WHAT IS THIS TESTING?
    Certain characters look alike on screen — the letter 'O' and the number
    '0', or the letter 'l' (lowercase L) and the number '1'. These can cause
    confusion when users type a password manually. The "Exclude Ambiguous"
    option removes these problem characters.
    """
    Given "Exclude Ambiguous" is turned ON
    And all character sets are selected
    And password length is set to 64
    When the user generates a password
    Then none of the following characters appear in the result: O, 0, l, 1, I

  Scenario: [TC-GEN-15] Show warning message testing
    """
    WHAT IS THIS TESTING?
    The app warns users when their chosen password is dangerously short.
    A password under 12 characters is considered "Weak" by security standards.
    We test that this warning appears and disappears at exactly the right length.
    """
    Given the length slider is set to 8
    Then a yellow warning box appears saying the password is too short
    When the slider is moved to 12
    Then the warning box disappears automatically

  # ── MODULE 2: BULK GENERATION ────────────────────────────────────────────

  Scenario: [TC-BLK-01] Show bulk generation capability
    """
    WHY IS BULK GENERATION USEFUL?
    A system administrator may need to create 50 new employee passwords
    in one go. The Bulk tab generates multiple passwords simultaneously.
    """
    Given the user navigates to the "Bulk" tab
    And the count slider is set to 10
    When the user clicks "Generate All"
    Then 10 passwords appear in a list on screen
    And each password is unique — no two passwords are the same

  Scenario: [TC-BLK-03] Show file export capability
    Given 10 passwords have been generated in the Bulk tab
    When the user clicks the "Export .txt" button
    Then the browser downloads a text file
    And the file contains exactly 10 passwords, one on each line

  # ── MODULE 3: PASSPHRASE ─────────────────────────────────────────────────

  Scenario: [TC-PH-01] Explain and demonstrate passphrase generation
    """
    WHAT IS A PASSPHRASE?
    Instead of a random string like "Xk9#mQ2!", a passphrase combines
    real English words: "harvest-crystal-balance-echo".
    It is LONGER, STRONGER, and much EASIER to remember.
    Security experts recommend passphrases for important accounts.
    """
    Given the user navigates to the "Passphrase" tab
    And the word count slider is set to 4
    When the user clicks "Generate Phrase"
    Then a passphrase of 4 real English words joined by hyphens is shown
    And example: "harvest-crystal-balance-echo"

  Scenario Outline: [TC-PH-01 Data] Passphrase word count controls
    Given the word count slider is set to <wordCount>
    When "Generate Phrase" is clicked
    Then the result contains exactly <wordCount> words separated by hyphens

    Examples:
      | wordCount | security_level                      |
      | 2         | Minimal — quick but weaker          |
      | 4         | Recommended — good balance          |
      | 8         | Maximum — extremely hard to crack   |

  # ── MODULE 4: HISTORY ────────────────────────────────────────────────────

  Scenario: [TC-HIST-01] Show how history tracking works
    """
    WHAT IS THE HISTORY TAB?
    Every password you generate during your browser session is saved
    automatically. If you forget what you just generated, check History.
    Note: History is stored LOCALLY in your browser — nothing goes to a server.
    """
    Given the user has generated 3 passwords on the Generator tab
    When the user clicks the "History" tab
    Then 3 entries appear, each showing the password and the time it was created
    And the most recently generated password appears at the top

  Scenario: [TC-HIST-03] Show that history survives a page refresh
    Given 3 passwords exist in the History list
    When the user presses F5 to refresh the browser
    And navigates back to the History tab
    Then all 3 passwords are still listed
    """
    HOW DOES THIS WORK?
    The history is stored in "localStorage" — a small database built into
    every modern browser. It keeps data safe even after the page is refreshed.
    """

  Scenario: [TC-HIST-04] Show the clear history feature
    Given the History tab shows 5 generated passwords
    When the user clicks "Clear All"
    Then the list becomes completely empty
    And the browser's localStorage no longer contains any password data

  # ── MODULE 5: PRESETS ────────────────────────────────────────────────────

  Scenario Outline: [TC-PRE-01 to TC-PRE-04] Show how presets save time
    """
    WHAT ARE PRESETS?
    Most people use passwords for specific purposes: social media, banking,
    work email. Each of these needs different rules. Presets apply the right
    configuration with a single click.
    """
    Given the user is on the Generator tab
    When the user clicks the "<presetName>" preset button
    Then the length slider jumps to <expectedLength>
    And the character set toggles change to match the <presetName> rules

    Examples:
      | presetName   | expectedLength | key_rule                                    |
      | Social       | 12             | No symbols — many social sites block them   |
      | Banking      | 16             | Excludes confusing chars like O and 0       |
      | Work         | 16             | No symbols — corporate systems often reject |
      | Super Secure | 32             | Everything ON — maximum possible security   |

  # ── MODULE 6: STRENGTH METER ─────────────────────────────────────────────

  Scenario Outline: [TC-STR-01 to TC-STR-04] Show the colour-coded strength indicator
    """
    WHAT IS THE STRENGTH METER?
    The strength meter uses ENTROPY — a mathematical measure of how
    unpredictable a password is. The more unpredictable, the harder
    it is for hackers to guess.

    ENTROPY THRESHOLDS (Industry Standard):
      < 40 bits  → Weak       (red bar)
      40-79 bits → Medium     (orange bar)
      80-119 bits→ Strong     (green bar)
      120+ bits  → Very Strong(teal/cyan bar)
    """
    Given the length is set to <length> and character sets are "<charsets>"
    When the user clicks Generate
    Then the strength label reads "<expectedStrength>"
    And the bar fills to the corresponding colour

    Examples:
      | length | charsets              | expectedStrength | why_it_matters                  |
      | 8      | lowercase only        | Weak             | A hacker could crack this today |
      | 12     | lowercase and numbers | Medium           | Acceptable for low-risk accounts|
      | 16     | all four charsets     | Strong           | Good for most accounts          |
      | 32     | all four charsets     | Very Strong      | Bank and admin account level    |

  Scenario: [TC-STR-07] Show that strength updates live without re-generating
    Given the user has set the length to 8 and the strength shows "Weak"
    When the user drags the length slider to 32 (without pressing Generate)
    Then the strength bar and label instantly update to "Very Strong"
    """
    WHY IS THIS IMPORTANT?
    Users can SEE in real time how their settings affect security.
    There is no "submit" button needed — feedback is instant.
    """

  # ── MODULE 7: SECURITY TESTS ─────────────────────────────────────────────

  Scenario: [TC-SEC-01] Prove cryptographic security — no Math.random() used
    """
    WHY DOES THIS MATTER?
    JavaScript's built-in Math.random() is NOT truly random. A skilled
    attacker can predict its output and guess your password.

    Our app uses crypto.getRandomValues() — the same cryptographic
    randomness used by banks and governments. This is PROVEN by
    inspecting the JavaScript source code automatically in our test.
    """
    Given the automated test inspects the file "generator.js"
    When it searches for the function name "crypto.getRandomValues"
    Then the function IS found — confirming secure randomness is used
    And the string "Math.random" is NOT found — confirming the insecure method is absent

  Scenario: [TC-SEC-02] Prove the app never sends data to a server
    """
    WHY IS THIS CRITICAL?
    If the app sent your generated password to a server, that server
    could store it or it could be intercepted. Our test PROVES this
    never happens by monitoring all network activity during generation.
    """
    Given browser network monitoring is switched ON
    When the user generates a password
    Then the network monitor records ZERO outgoing requests
    And the password never leaves your device

  Scenario: [TC-SEC-04] Prove the app works fully offline
    Given the browser is switched to offline mode
    When the user opens the app at "http://localhost:3000"
    Then all four tabs load and work correctly
    And passwords can be generated with zero internet connection


# ════════════════════════════════════════════════════════════════════════════
# SECTION 4 — STLC PHASE 4: TEST ENVIRONMENT SETUP
# ════════════════════════════════════════════════════════════════════════════

@phase-4-environment-setup
Feature: Phase 4 — Test Environment Setup (Getting Everything Ready to Run)

  """
  WHAT IS TEST ENVIRONMENT SETUP?
  ─────────────────────────────────
  Before tests can run, the right tools must be installed and configured.
  Think of this like setting up a kitchen before you start cooking.

  OUR ENVIRONMENT — WHAT WE INSTALLED
  ─────────────────────────────────────
  1. Node.js   — runs the Password Generator web server
  2. Java 21   — powers the Selenium automation code
  3. Maven 3.9 — downloads dependencies and runs the tests
  4. msedgedriver.exe — the "remote control" that drives the Edge browser

  HOW IT ALL FITS TOGETHER
  ─────────────────────────
  ┌──────────────────┐      HTTP      ┌──────────────────────┐
  │  Node.js server  │ ◄──────────── │  Selenium WebDriver  │
  │  (localhost:3000)│               │  (Java + Edge)       │
  └──────────────────┘               └──────────────────────┘
           ▲                                    ▲
     Password Generator                  Cucumber Test Scenarios
       (the app we test)                   (our BDD test scripts)

  FILE LOCATIONS IN THIS PROJECT
  ─────────────────────────────────
  Application:   password-generator/server.js
  Automation:    pwg-automation/
  Test features: pwg-automation/src/test/resources/features/
  Step code:     pwg-automation/src/test/java/.../steps/
  Page objects:  pwg-automation/src/test/java/.../pages/
  Reports:       pwg-automation/reports/run_DD-MM-YYYY_HH-MM/PWGTestReport.html
  """

  Scenario: Start the Password Generator application
    Given Node.js is installed on the test machine
    When the presenter runs: "node password-generator/server.js"
    Then the terminal prints: "Password Generator is running!"
    And the app is accessible at "http://localhost:3000" in any browser

  Scenario: Verify the automation project compiles correctly
    Given Java 21 and Maven 3.9 are installed
    When the presenter runs: "mvn clean test-compile" inside pwg-automation/
    Then Maven downloads all required libraries from the internet once
    And the Java test code compiles without errors

  Scenario: Understand the Page Object Model design pattern
    """
    WHAT IS PAGE OBJECT MODEL (POM)?
    ─────────────────────────────────
    Instead of writing raw browser instructions in every test, we create
    a "Page Object" — a Java class that represents one page of the app.

    EXAMPLE: GeneratorPage.java represents the Generator tab.
      page.clickGenerate()        → clicks the Generate button
      page.getPasswordText()      → reads the password from the screen
      page.setLength(32)          → moves the length slider to 32
      page.isUppercaseChecked()   → checks if the Uppercase toggle is ON

    BENEFIT: If the web page changes, you update ONE file (the Page Object),
    not every single test that uses it. This is called "maintainability".

    FILES:
      GeneratorPage.java  — controls Generator and Presets tab elements
      BulkPage.java       — controls Bulk tab elements
      PassphrasePage.java — controls Passphrase tab elements
      HistoryPage.java    — controls History tab elements
      BasePage.java       — shared helper methods (click, type, read text)
    """
    Given the audience sees the file GeneratorPage.java
    When the presenter points to methods like clickGenerate() and setLength()
    Then the audience understands how Selenium commands are wrapped in readable methods


# ════════════════════════════════════════════════════════════════════════════
# SECTION 5 — STLC PHASE 5: TEST EXECUTION
# ════════════════════════════════════════════════════════════════════════════

@phase-5-test-execution
Feature: Phase 5 — Test Execution (Running the Tests)

  """
  WHAT HAPPENS DURING TEST EXECUTION?
  ──────────────────────────────────────
  This is the exciting phase! The automation framework takes over and:
    1. Opens the Edge browser (invisibly in "headless" mode)
    2. Navigates to http://localhost:3000
    3. Clicks buttons, reads text, checks conditions — automatically
    4. Records PASS or FAIL for every scenario
    5. Takes a screenshot if any test fails
    6. Closes the browser and moves to the next test

  IMPORTANT: The browser runs HEADLESS — meaning it runs in the
  background without appearing on screen. This is faster and is
  how tests run on CI servers (like Jenkins) that have no monitor.
  """

  Scenario: Run the full test suite with a single command
    Given the Password Generator app is running on localhost:3000
    And the presenter is inside the pwg-automation/ folder
    When the presenter types and runs: "mvn clean test"
    Then Maven compiles the test code
    And Cucumber discovers all 7 feature files
    And Selenium opens Edge in headless mode
    And all 55 test scenarios execute one by one automatically
    And a test report is generated in the reports/ folder

  Scenario: Run only Security tests using a tag filter
    Given the presenter wants to demonstrate security tests specifically
    When this command is run: "mvn test -Dcucumber.filter.tags=@security"
    Then only the 8 scenarios tagged with @security are executed
    And all other tests are skipped

  Scenario: Understand what happens automatically before and after EACH test
    """
    HOOKS — The Setup and Teardown System
    ──────────────────────────────────────
    The Hooks.java file runs automatically around every single scenario.

    BEFORE each scenario:
      1. A new Edge browser window opens (headless)
      2. It navigates to http://localhost:3000
      3. The ExtentReports logger creates a new test entry

    AFTER each scenario:
      1. If the test PASSED  → logs "PASS" in the report
      2. If the test FAILED  → takes a screenshot, attaches it to the report
      3. Clears any shared data (ScenarioContext is wiped)
      4. The browser is closed
      5. Ready for the next scenario

    AFTER ALL scenarios:
      1. ExtentReports writes the final HTML report to disk
      2. Old reports (more than 2 days old) are automatically deleted
    """
    Given the presenter opens Hooks.java for the audience
    When @BeforeAll, @Before, @After, and @AfterAll annotations are pointed out
    Then the audience understands the full lifecycle of one test scenario

  Scenario: Understand how tests share data between steps
    """
    SCENARIO CONTEXT — Sharing Data Between Steps
    ──────────────────────────────────────────────
    Sometimes one step generates a value that a later step needs to verify.
    Example: Step 1 generates a password. Step 2 checks the password was copied.

    ScenarioContext.java is a thread-safe "shared notepad" for one scenario.
    After each scenario it is automatically wiped clean (no data leaks).

    Example usage in a test step:
      ScenarioContext.set("lastPassword", generatedPassword);   // save
      String pwd = ScenarioContext.get("lastPassword");          // retrieve
    """
    Given the presenter opens ScenarioContext.java
    When the set() and get() methods are shown
    Then the audience understands how steps in the same scenario communicate


# ════════════════════════════════════════════════════════════════════════════
# SECTION 6 — STLC PHASE 6: TEST REPORTING
# ════════════════════════════════════════════════════════════════════════════

@phase-6-test-reporting
Feature: Phase 6 — Test Reporting (Seeing the Results Clearly)

  """
  WHAT DOES A GOOD TEST REPORT CONTAIN?
  ──────────────────────────────────────
  A test report is the final deliverable — the PROOF that the application
  was tested. Our project generates THREE report formats:

  1. EXTENTREPORTS HTML (pwg-automation/reports/run_DD-MM-YYYY_HH-MM/PWGTestReport.html)
     → Rich, beautiful dark-themed HTML report
     → Shows PASS/FAIL per scenario
     → Embeds failure screenshots
     → Timestamp on every test entry

  2. CUCUMBER HTML (pwg-automation/target/cucumber-reports/cucumber.html)
     → Standard Cucumber report
     → Step-by-step view of every scenario

  3. CUCUMBER JSON (pwg-automation/target/cucumber-reports/cucumber.json)
     → Machine-readable format
     → Used by Jenkins to publish results on the CI dashboard

  REPORT RETENTION POLICY
  ─────────────────────────
  Reports older than 2 days are automatically deleted by ReportManager.java.
  This prevents the disk from filling up on long-running CI servers.
  """

  Scenario: View the ExtentReports HTML report after a test run
    Given the test suite has finished executing
    When the presenter opens the file: "pwg-automation/reports/run_22-06-2026_11-46/PWGTestReport.html"
    Then the report shows a summary of passed and failed tests
    And each scenario is listed with its full step details
    And failed scenarios show an embedded screenshot of what went wrong

  Scenario: Understand the timestamped report folder strategy
    Given a new test run is started every time
    When the ReportManager creates the output folder
    Then the folder name includes the date and time: "run_22-06-2026_11-46"
    And the previous run's report is never overwritten
    And reports older than 2 days are automatically cleaned up

  Scenario: Read a test result like a professional tester
    """
    HOW TO READ THE REPORT — A GUIDE FOR THE AUDIENCE
    ───────────────────────────────────────────────────
    GREEN  = PASSED  → The feature works exactly as expected
    RED    = FAILED  → Something went wrong; the screenshot shows what
    ORANGE = SKIPPED → The test was not run (e.g., blocked by an earlier failure)

    Each scenario row in the report shows:
      • Scenario name      (e.g., "Generate password with default settings")
      • Status             (PASS / FAIL)
      • Duration           (how long it took in seconds)
      • Steps executed     (Given → When → Then with individual pass/fail)
      • Screenshot         (attached automatically on failure)
    """
    Given the audience is looking at the ExtentReports HTML file
    When the presenter clicks on any scenario row
    Then the full step-by-step execution log expands
    And the audience can trace exactly what the automated browser did


# ════════════════════════════════════════════════════════════════════════════
# SECTION 7 — STLC PHASE 7: CI/CD PIPELINE (JENKINS)
# ════════════════════════════════════════════════════════════════════════════

@phase-7-cicd-pipeline
Feature: Phase 7 — CI/CD Pipeline (Automating the Entire Process)

  """
  WHAT IS CI/CD?
  ────────────────
  CI  = Continuous Integration  — every code change is automatically built and tested
  CD  = Continuous Delivery     — tested code is automatically packaged for release

  THINK OF IT LIKE THIS:
  ─────────────────────
  Without CI/CD: A developer writes code → tells a tester → tester runs tests → waits.
  With CI/CD:    A developer commits code → Jenkins wakes up → builds → tests →
                 reports results → emails the team — all in under 5 minutes.

  OUR JENKINS PIPELINE (Jenkinsfile)
  ──────────────────────────────────
  Location: pwg-automation/Jenkinsfile
  Status:   DORMANT — parked, ready to be activated when a Jenkins server is available

  PIPELINE STAGES:
  ┌─────────────┐  ┌─────────────────────┐  ┌───────────────┐  ┌─────────────────┐
  │  1.Checkout │→ │  2.Build & Compile   │→ │  3.Run Tests  │→ │  4.Publish      │
  │  (Git pull) │  │  (mvn test-compile)  │  │  (mvn test)   │  │    Reports      │
  └─────────────┘  └─────────────────────┘  └───────────────┘  └─────────────────┘
                                                                         ▼
                                                                ┌─────────────────┐
                                                                │  5.Archive       │
                                                                │    Artifacts     │
                                                                │  (store reports) │
                                                                └─────────────────┘
  """

  Scenario: Walk through the Jenkins pipeline stages
    Given the presenter opens the Jenkinsfile in the project
    When each stage is pointed out to the audience:
      | Stage           | What Jenkins Does                                     |
      | Checkout        | Downloads the latest code from Git                    |
      | Build & Compile | Compiles the Java test code (mvn clean test-compile)  |
      | Run Tests       | Executes all 55 test scenarios (mvn clean test)       |
      | Publish Reports | Converts JSON results into a visual dashboard report  |
      | Archive         | Saves the HTML report so it can be downloaded later   |
    Then the audience understands the pipeline runs entirely without human intervention

  Scenario: Explain the value of a CI/CD pipeline to a non-technical audience
    """
    REAL-WORLD VALUE — WHY THIS MATTERS
    ─────────────────────────────────────
    Imagine a team of 10 developers, each making 5 code changes per day.
    That is 50 changes per day. Without CI/CD, a tester must manually
    run tests after every change — an impossible workload.

    With Jenkins CI/CD:
      ✦ Tests run automatically when code is pushed to Git
      ✦ The team gets results in minutes, not hours or days
      ✦ Broken features are caught before they reach customers
      ✦ The entire team sees a shared dashboard of test results
      ✦ Quality gates can block bad code from being released
    """
    Given the audience understands the problem of manual testing at scale
    When the presenter explains Jenkins automates this entire process
    Then the audience sees why CI/CD is essential for professional software delivery

  Scenario: Show the pipeline parameter — configurable base URL
    Given the Jenkinsfile has a configurable parameter called "BASE_URL"
    When the default value is set to "http://localhost:3000"
    Then a Jenkins user can override this at runtime for different environments:
      | Environment | BASE_URL                         |
      | Local Dev   | http://localhost:3000            |
      | Test Server | http://test-server:3000          |
      | Staging     | http://staging.company.com:3000  |


# ════════════════════════════════════════════════════════════════════════════
# SECTION 7b — HITL: HUMAN-IN-THE-LOOP CHECKPOINT
# ════════════════════════════════════════════════════════════════════════════

@hitl-human-in-the-loop
Feature: Phase 5b — Human-in-the-Loop (HITL) Checkpoint (Keeping Humans in Control)

  """
  WHAT IS HUMAN-IN-THE-LOOP (HITL)?
  ───────────────────────────────────
  HITL is a design principle where an AI pipeline deliberately PAUSES
  and asks a human to make a decision before taking an irreversible action.

  WHY DO WE NEED IT HERE?
  ────────────────────────
  Once a Jira bug ticket is created, it exists in the project forever.
  If the AI agent creates tickets for false alarms (flaky tests, known gaps,
  or environment blips), the team wastes time investigating fake bugs.

  The HITL gate sits between Phase 5 (test results) and Phase 5b (bug filing).
  A human reviews the failures and decides: "Yes, these are real bugs" or
  "No, skip it — I know why these failed."

  THE DECISION POINT IN OUR PIPELINE:
  ─────────────────────────────────────
  [Phase 5 results arrive]
         ↓
  ⚠️  HITL GATE — Orchestrator pauses and presents failures to the human
         ↓                              ↓
  Human types YES               Human types NO
         ↓                              ↓
  Defect Triage runs            Triage is skipped
  (Jira bugs created)           (go straight to report)
  """

  Background:
    Given Phase 5 has completed and the Orchestrator holds the test results
    And at least one test failure was detected

  Scenario: [HITL-01] Orchestrator pauses and presents the approval checkpoint
    Given the test suite returned 4 failures
    When the Orchestrator checks each failure against the known spec gaps list:
      | Failure         | Is Known Gap? | Action            |
      | TC-HIST-03      | YES           | Auto-skip — no bug|
      | TC-PRE-01       | YES           | Auto-skip — no bug|
      | TC-GEN-07       | NO            | Needs human review|
      | TC-SEC-03       | NO            | Needs human review|
    Then the Orchestrator displays a HITL checkpoint box in the chat:
      """
      ╔══════════════════════════════════════════════════════════════╗
      ║   ⚠️  HITL CHECKPOINT — HUMAN APPROVAL REQUIRED             ║
      ║  2 genuine failure(s) found — 2 known gaps auto-skipped     ║
      ║  Genuine: TC-GEN-07, TC-SEC-03                              ║
      ║  Reply: YES to file bugs | NO to skip | SHOW DETAILS        ║
      ╚══════════════════════════════════════════════════════════════╝
      """
    And the pipeline STOPS and waits — no Jira ticket is created yet

  Scenario: [HITL-02] Human approves — Jira tickets are created
    Given the HITL checkpoint is displayed with 2 genuine failures
    When the human types "YES" in the chat
    Then the Orchestrator calls the PWG Defect Triage agent
    And the Defect Triage agent creates Jira bug tickets: KAN-XX and KAN-XY
    And the Orchestrator logs "HITL_DECISION: YES — 2 tickets filed"
    And the pipeline proceeds to Phase 6 reporting

  Scenario: [HITL-03] Human declines — bug filing is skipped
    Given the HITL checkpoint is displayed with 2 genuine failures
    When the human types "NO" in the chat
    Then the Defect Triage agent is NOT called
    And NO Jira tickets are created
    And the Orchestrator logs "HITL_DECISION: NO — triage skipped by human"
    And the pipeline proceeds directly to Phase 6 reporting

  Scenario: [HITL-04] Human asks for more details before deciding
    Given the HITL checkpoint shows 2 genuine failures
    When the human types "SHOW DETAILS"
    Then the Orchestrator reads cucumber.json and prints the full error message:
      """
      TC-GEN-07 — Generator tab: Expected password to not contain 'O'
                  but found 'O' at position 4: xOkP9m...
      TC-SEC-03 — Security: Expected 0 network requests
                  but captured 1 request to api.example.com
      """
    And the HITL prompt is shown again: YES / NO / SHOW DETAILS
    And the pipeline remains paused until the human makes a final decision

  Scenario: [HITL-05] All failures are known gaps — HITL auto-skips
    Given the test suite returned 2 failures: TC-HIST-03 and TC-PRE-01
    When the Orchestrator checks both against the known spec gaps list
    Then BOTH are identified as known spec gaps
    And the Orchestrator logs "HITL_AUTO_SKIP: all failures were known spec gaps"
    And the HITL prompt is NOT shown — no human input needed
    And the pipeline moves directly to Phase 6 reporting
    """
    WHY IS THIS SMART?
    ──────────────────
    Not every failure needs human attention. Known gaps are expected — we
    already documented them. Auto-skipping them means the human only sees
    failures that are actually new, unexpected, and worth their time.
    """

  Scenario: [HITL-06] No failures — HITL gate is not triggered at all
    Given Phase 5 completed with 0 failures (138/138 passed)
    When the Orchestrator reaches the HITL checkpoint step
    Then the HITL prompt is NOT displayed
    And the pipeline flows directly to Phase 6 reporting without any pause
    And the final summary shows "HITL Gate: NOT TRIGGERED (0 failures)"


# ════════════════════════════════════════════════════════════════════════════
# SECTION 8 — OVERALL STLC SUMMARY & WHAT CAN BE IMPROVED
# ════════════════════════════════════════════════════════════════════════════

@poc-summary
Feature: POC Summary — What We Achieved and What Can Be Enhanced

  """
  WHAT THIS POC DEMONSTRATES — THE COMPLETE STLC IN ONE PROJECT
  ──────────────────────────────────────────────────────────────

  ╔══════╦═════════════════════════════╦════════════════════════════════════════╗
  ║ Phase║ STLC Phase                  ║ What We Did in This Project            ║
  ╠══════╬═════════════════════════════╬════════════════════════════════════════╣
  ║  1   ║ Requirement Analysis        ║ 7 Jira stories, 55 acceptance criteria ║
  ║  2   ║ Test Planning               ║ Tool selection, tagging strategy       ║
  ║  3   ║ Test Case Design            ║ 55 Gherkin scenarios in 7 .feature files║
  ║  4   ║ Test Environment Setup      ║ Node.js + Java + Maven + EdgeDriver    ║
  ║  5   ║ Test Execution              ║ mvn clean test → 55 automated scenarios║
  ║  6   ║ Test Reporting              ║ ExtentReports HTML + Cucumber JSON/HTML║
  ║  7   ║ CI/CD Pipeline              ║ Jenkins Jenkinsfile (ready to activate)║
  ╚══════╩═════════════════════════════╩════════════════════════════════════════╝

  TECHNOLOGY STACK USED
  ──────────────────────
  Application Layer:  Node.js · Express · Vanilla JavaScript · HTML · CSS
  Automation Layer:   Java 21 · Selenium 4.21 · Cucumber 7.18 · JUnit 4 · Maven 3.9
  Browser:            Microsoft Edge (headless)
  Reporting:          ExtentReports 5 · Cucumber HTML · Cucumber JSON
  CI/CD:              Jenkins (Jenkinsfile authored, pipeline ready)
  Project Management: Jira (KAN project — stories KAN-15 through KAN-35)
  """

  Scenario: Summarise what the POC proves to the audience
    Given the audience has seen all seven STLC phases in action
    When the presenter summarises the key takeaways:
      | Key Takeaway                                                              |
      | STLC is not just "running tests" — it is a structured, documented process |
      | BDD (Gherkin) makes tests readable by everyone, not just developers       |
      | Page Object Model makes tests maintainable and change-resistant            |
      | Automated tests are faster, more reliable, and repeatable vs manual tests |
      | CI/CD pipelines remove human bottlenecks from the testing process          |
      | ExtentReports provides audit-ready evidence of testing                    |
      | Security validation is as important as functional validation               |
    Then the audience understands this project is a professional-grade STLC example

  Scenario: Identify areas where this POC can be further enhanced
    """
    GAPS IDENTIFIED — WHERE WE CAN GROW
    ──────────────────────────────────────
    The following improvements would make this an even more complete STLC POC:

    1. REQUIREMENTS TRACEABILITY MATRIX (RTM)
       A table mapping each Jira requirement → Test Case → Test Result.
       Proves that every requirement is covered by at least one test.

    2. TEST DATA MANAGEMENT
       Currently test data (lengths, words) is hardcoded in tests.
       A data-driven approach using Excel/CSV files would be more realistic.

    3. DEFECT LIFECYCLE DEMONSTRATION
       Show a real bug being found → logged in Jira → fixed → re-tested.
       This would complete the "defect management" phase of STLC.

    4. API TESTING LAYER
       The Node.js server has a static file API. Adding REST API tests
       (e.g., with RestAssured) would add another layer of test coverage.

    5. SMOKE vs REGRESSION TAG SEPARATION
       Add @smoke tag for the 5 most critical tests and @regression for all 55.
       Jenkins would run @smoke on every commit and @regression nightly.

    6. CROSS-BROWSER TESTING
       Add Chrome and Firefox drivers alongside Edge.
       Proves the app works across different browsers.

    7. PERFORMANCE TESTING
       Measure how long it takes to generate 1000 passwords in a loop.
       Tools: Apache JMeter or Gatling.

    8. ACCESSIBILITY TESTING
       Verify the app works with screen readers (for users with disabilities).
       Tools: Axe or WAVE.

    9. ACTIVATE JENKINS CI
       The Jenkinsfile is authored and ready.
       Connecting it to a live Jenkins server completes the CI/CD loop.

    10. DOCKER CONTAINERISATION
        Package the app and tests in a Docker image so the entire POC
        can run on any machine with a single command: docker-compose up
    """
    Given the audience has seen the complete current STLC implementation
    When the presenter walks through each enhancement opportunity
    Then the audience understands the project is production-ready as a POC
    And the path to a full enterprise-grade implementation is clear

  Scenario: Final call to action for the audience
    Given the audience has completed the full STLC walkthrough
    When the presenter invites questions
    Then the audience can ask about any of the seven phases
    And the presenter can demonstrate any specific test by running: "mvn test -Dcucumber.filter.tags=@<any-tag>"
    And live test results will appear in under 60 seconds


# ════════════════════════════════════════════════════════════════════════════
# APPENDIX — QUICK COMMAND REFERENCE CARD
# ════════════════════════════════════════════════════════════════════════════

@appendix-commands
Feature: Appendix — Quick Command Reference for the Presenter

  """
  ╔════════════════════════════════════════════════════════════════════╗
  ║                   QUICK COMMAND REFERENCE                         ║
  ╠════════════════════════════════════════════════════════════════════╣
  ║ START THE APP                                                      ║
  ║   cd password-generator                                            ║
  ║   node server.js                                                   ║
  ║   → Open browser: http://localhost:3000                            ║
  ╠════════════════════════════════════════════════════════════════════╣
  ║ RUN ALL TESTS                                                      ║
  ║   cd pwg-automation                                                ║
  ║   mvn clean test                                                   ║
  ╠════════════════════════════════════════════════════════════════════╣
  ║ RUN TESTS BY MODULE (TAG)                                          ║
  ║   mvn test -Dcucumber.filter.tags="@generator"                    ║
  ║   mvn test -Dcucumber.filter.tags="@security"                     ║
  ║   mvn test -Dcucumber.filter.tags="@bulk"                         ║
  ║   mvn test -Dcucumber.filter.tags="@history"                      ║
  ║   mvn test -Dcucumber.filter.tags="@passphrase"                   ║
  ║   mvn test -Dcucumber.filter.tags="@presets"                      ║
  ║   mvn test -Dcucumber.filter.tags="@strength"                     ║
  ╠════════════════════════════════════════════════════════════════════╣
  ║ RUN A SPECIFIC SINGLE TEST CASE                                    ║
  ║   mvn test -Dcucumber.filter.tags="@TC-GEN-01"                    ║
  ║   mvn test -Dcucumber.filter.tags="@TC-SEC-02"                    ║
  ╠════════════════════════════════════════════════════════════════════╣
  ║ VIEW THE HTML REPORT                                               ║
  ║   pwg-automation/reports/run_<DATE>/PWGTestReport.html            ║
  ║   pwg-automation/target/cucumber-reports/cucumber.html            ║
  ╠════════════════════════════════════════════════════════════════════╣
  ║ PROJECT STRUCTURE AT A GLANCE                                      ║
  ║   password-generator/          → The application (AUT)            ║
  ║     server.js                  → Node.js web server               ║
  ║     public/index.html          → The UI (4 tabs)                  ║
  ║     public/js/generator.js     → Password generation engine       ║
  ║     public/js/strength.js      → Entropy strength scoring         ║
  ║     public/js/history.js       → localStorage history manager     ║
  ║     public/js/presets.js       → Preset configurations            ║
  ║   pwg-automation/              → The test framework               ║
  ║     pom.xml                    → Maven dependencies               ║
  ║     Jenkinsfile                → CI/CD pipeline (ready)           ║
  ║     src/test/resources/features/ → 7 Gherkin feature files        ║
  ║     src/test/java/.../steps/   → Step definition Java classes     ║
  ║     src/test/java/.../pages/   → Page Object Model classes        ║
  ║     src/test/java/.../hooks/   → Before/After hooks               ║
  ║     src/test/java/.../utils/   → DriverManager, ReportManager     ║
  ║     reports/                   → ExtentReports HTML output        ║
  ╚════════════════════════════════════════════════════════════════════╝
  """

  Scenario: Present the command reference card to the audience
    Given the audience has the command reference card above
    When the presenter highlights the most important commands
    Then the audience can independently run any part of the STLC demo
    And they have everything they need to explore the project on their own
