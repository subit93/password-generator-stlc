# Feature: Password Generator — Generator Tab
# Jira: KAN-21
# Objectives covered: TC-GEN-01 to TC-GEN-15 (from KAN-15, Module 1)

@generator
Feature: Generator Tab — Core Password Generation

  Background:
    Given the user has opened the Password Generator app at "http://localhost:3000"
    And the Generator tab is active

  # TC-GEN-01: Generate password at default length
  @TC-GEN-01
  Scenario: Generate password with default settings
    Given all default settings are applied (length=16, uppercase ON, lowercase ON, numbers ON, symbols OFF)
    When the user clicks the "Generate" button
    Then a password of exactly 16 characters is displayed in the output box

  # TC-GEN-02 to TC-GEN-04: Length boundary values
  @TC-GEN-02
  Scenario Outline: Generate password at boundary lengths
    Given the length slider is set to <length>
    When the user clicks the "Generate" button
    Then a password of exactly <length> characters is displayed
    And the length badge shows "<length>"

    Examples:
      | length |
      | 8      |
      | 12     |
      | 16     |
      | 32     |
      | 64     |

  # TC-GEN-05: Uppercase characters included
  @TC-GEN-05
  Scenario: Generated password contains uppercase characters when Uppercase is ON
    Given the Uppercase toggle is ON
    And the Lowercase toggle is OFF
    And the Numbers toggle is OFF
    And the Symbols toggle is OFF
    And the length slider is set to 20
    When the user clicks the "Generate" button
    Then the generated password contains only uppercase characters (A-Z)

  # TC-GEN-06: Lowercase characters included
  @TC-GEN-06
  Scenario: Generated password contains lowercase characters when Lowercase is ON
    Given the Lowercase toggle is ON
    And the Uppercase toggle is OFF
    And the Numbers toggle is OFF
    And the Symbols toggle is OFF
    And the length slider is set to 20
    When the user clicks the "Generate" button
    Then the generated password contains only lowercase characters (a-z)

  # TC-GEN-07: Numbers included
  @TC-GEN-07
  Scenario: Generated password contains numbers when Numbers is ON
    Given the Numbers toggle is ON
    And the Uppercase toggle is OFF
    And the Lowercase toggle is OFF
    And the Symbols toggle is OFF
    And the length slider is set to 20
    When the user clicks the "Generate" button
    Then the generated password contains only numeric characters (0-9)

  # TC-GEN-08: Symbols included
  @TC-GEN-08
  Scenario: Generated password contains symbols when Symbols is ON
    Given the Symbols toggle is ON
    And the Uppercase toggle is OFF
    And the Lowercase toggle is OFF
    And the Numbers toggle is OFF
    And the length slider is set to 20
    When the user clicks the "Generate" button
    Then the generated password contains only symbol characters

  # TC-GEN-09: Exclude ambiguous characters
  @TC-GEN-09
  Scenario: Ambiguous characters are excluded when Exclude Ambiguous is ON
    Given all character sets are ON
    And the "Exclude Ambiguous" option is ON
    And the length slider is set to 64
    When the user clicks the "Generate" button
    Then the generated password does not contain any of the characters: O, 0, l, 1, I

  # TC-GEN-10: Require Each character from selected sets
  @TC-GEN-10
  Scenario: Password contains at least one char from each selected set when Require Each is ON
    Given the Uppercase toggle is ON
    And the Lowercase toggle is ON
    And the Numbers toggle is ON
    And the Symbols toggle is ON
    And the "Require Each" option is ON
    And the length slider is set to 16
    When the user clicks the "Generate" button
    Then the generated password contains at least one uppercase character
    And the generated password contains at least one lowercase character
    And the generated password contains at least one number
    And the generated password contains at least one symbol

  # TC-GEN-11: Password displayed in output box
  @TC-GEN-11
  Scenario: Generated password is displayed in the output box
    When the user clicks the "Generate" button
    Then the output box becomes visible
    And the password text element is not empty

  # TC-GEN-12: Copy to clipboard
  @TC-GEN-12
  Scenario: Copy button copies password to clipboard
    Given a password has been generated
    When the user clicks the "Copy" button
    Then the clipboard contains the generated password text
    And a success toast or confirmation is shown

  # TC-GEN-13: Show/Hide toggle
  @TC-GEN-13
  Scenario: Show/Hide toggle masks and unmasks the password
    Given a password has been generated
    And the password is currently hidden (masked)
    When the user clicks the "Show/Hide" button
    Then the password text becomes visible (unmasked)
    When the user clicks the "Show/Hide" button again
    Then the password text is masked again

  # TC-GEN-14: Regenerate button
  @TC-GEN-14
  Scenario: Regenerate button produces a different password
    Given a password has been generated and displayed
    When the user clicks the "Regenerate" button
    Then a new password is generated
    And the new password is different from the previous password

  # TC-GEN-15: Short password warning
  @TC-GEN-15
  Scenario Outline: Warning shown for passwords shorter than 12 characters
    Given the length slider is set to <length>
    Then the short-password warning box is <visibility>

    Examples:
      | length | visibility |
      | 8      | visible    |
      | 10     | visible    |
      | 11     | visible    |
      | 12     | hidden     |
      | 16     | hidden     |
