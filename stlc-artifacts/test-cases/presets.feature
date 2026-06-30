# Feature: Password Generator — Presets
# Jira: KAN-25
# Objectives covered: TC-PRE-01 to TC-PRE-06 (from KAN-15, Module 5)

@presets
Feature: Presets — Quick Configuration Buttons

  Background:
    Given the user has opened the Password Generator app at "http://localhost:3000"
    And the Generator tab is active

  # TC-PRE-01 to TC-PRE-04: Each preset applies correct configuration (Scenario Outline)
  @TC-PRE-01 @TC-PRE-02 @TC-PRE-03 @TC-PRE-04
  Scenario Outline: Clicking a preset applies the correct length and charset configuration
    When the user clicks the "<preset>" preset button
    Then the length slider is set to <expectedLength> (approximately)
    And the Uppercase toggle is <uppercase>
    And the Lowercase toggle is <lowercase>
    And the Numbers toggle is <numbers>
    And the Symbols toggle is <symbols>

    Examples:
      | preset       | expectedLength | uppercase | lowercase | numbers | symbols |
      | Social       | 12             | ON        | ON        | ON      | OFF     |
      | Banking      | 16             | ON        | ON        | ON      | ON      |
      | Work         | 14             | ON        | ON        | ON      | OFF     |
      | Super Secure | 32             | ON        | ON        | ON      | ON      |

  # TC-PRE-05: Super Secure applies max-strength config
  @TC-PRE-05
  Scenario: Super Secure preset applies maximum-strength configuration
    When the user clicks the "Super Secure" preset button
    Then all four character set toggles (Uppercase, Lowercase, Numbers, Symbols) are ON
    And the "Exclude Ambiguous" option is ON
    And the "Require Each" option is ON
    And the length slider is set to at least 32

  # TC-PRE-06: Preset immediately updates UI
  @TC-PRE-06
  Scenario: Selecting a preset immediately updates the UI without requiring a separate action
    Given the current length is set to 8 and only Lowercase is ON
    When the user clicks the "Banking" preset button
    Then the UI updates immediately (no additional button press required)
    And the length slider reflects the Banking preset length
    And the character set toggles reflect the Banking preset configuration
