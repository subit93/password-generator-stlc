# Feature: Password Generator — Passphrase Tab
# Jira: KAN-23
# Objectives covered: TC-PH-01 to TC-PH-05 (from KAN-15, Module 3)

@passphrase
Feature: Passphrase Tab — Generate Human-Readable Passphrases

  Background:
    Given the user has opened the Password Generator app at "http://localhost:3000"
    And the user clicks the "Passphrase" tab

  # TC-PH-01: Correct number of words generated
  @TC-PH-01
  Scenario Outline: Passphrase is generated with the correct number of words
    Given the phrase count slider is set to <wordCount>
    When the user clicks the "Generate Passphrase" button
    Then the generated passphrase contains exactly <wordCount> words
    And the phrase count display badge shows "<wordCount>"

    Examples:
      | wordCount |
      | 2         |
      | 3         |
      | 4         |
      | 6         |
      | 8         |

  # TC-PH-02: Words come from the known word list
  @TC-PH-02
  Scenario: All words in the passphrase are from the known word list
    Given the phrase count slider is set to 4
    When the user clicks the "Generate Passphrase" button
    Then each word in the passphrase exists in the application's known WORDS list
    And no word in the passphrase is a number or symbol

  # TC-PH-03: Copy to clipboard
  @TC-PH-03
  Scenario: Copy button copies the passphrase to clipboard
    Given a passphrase has been generated
    When the user clicks the "Passphrase Copy" button
    Then the clipboard contains the full generated passphrase text
    And a success toast or confirmation is shown

  # TC-PH-04: Passphrase output box is populated
  @TC-PH-04
  Scenario: Generated passphrase is displayed in the passphrase output box
    Given the phrase count slider is set to 4
    When the user clicks the "Generate Passphrase" button
    Then the passphrase output box becomes visible
    And the passphrase text element is not empty

  # TC-PH-05: Regeneration produces a different passphrase
  @TC-PH-05
  Scenario: Clicking Generate again produces a different passphrase
    Given the phrase count slider is set to 4
    And the user has already generated a passphrase
    And the first passphrase is recorded
    When the user clicks the "Generate Passphrase" button again
    Then the new passphrase is different from the previously recorded passphrase
