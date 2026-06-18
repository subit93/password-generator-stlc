# Feature: Password Generator — Strength Meter
# Jira: KAN-26
# Objectives covered: TC-STR-01 to TC-STR-08 (from KAN-15, Module 6)

@strength
Feature: Strength Meter — Entropy-Based Password Strength Indicator

  Background:
    Given the user has opened the Password Generator app at "http://localhost:3000"
    And the Generator tab is active

  # TC-STR-01 to TC-STR-04: Strength label thresholds (Scenario Outline)
  @TC-STR-01 @TC-STR-02 @TC-STR-03 @TC-STR-04
  Scenario Outline: Strength label reflects entropy thresholds
    Given the length slider is set to <length>
    And the charset configuration is "<charsets>"
    When the user clicks the "Generate" button
    Then the strength label shows "<expectedLabel>"
    And the strength fill bar color reflects the "<expectedLabel>" state

    Examples:
      | length | charsets              | expectedLabel |
      | 8      | lowercase only        | Weak          |
      | 12     | lowercase and numbers | Medium        |
      | 16     | all four charsets     | Strong        |
      | 32     | all four charsets     | Very Strong   |

  # TC-STR-05: Strength fill bar width changes with entropy
  @TC-STR-05
  Scenario: Strength fill bar width increases as password strength increases
    Given a password is generated with length=8 and lowercase only
    And the fill bar width is recorded as "weak_width"
    When a new password is generated with length=32 and all charsets ON
    Then the fill bar width is greater than "weak_width"
    And the fill bar width represents a higher entropy percentage

  # TC-STR-06: Entropy value is displayed in bits
  @TC-STR-06
  Scenario: Entropy value in bits is displayed in the UI
    Given the length slider is set to 16
    And all four character sets are ON
    When the user clicks the "Generate" button
    Then an entropy value in bits is displayed in the UI (entropy label is visible and non-zero)

  # TC-STR-07: Strength updates dynamically on config change
  @TC-STR-07
  Scenario: Strength meter updates when length slider is changed
    Given the charset configuration is "lowercase only"
    And the length slider is set to 8 (Weak)
    And the strength label shows "Weak"
    When the user moves the length slider to 32
    Then the strength label updates to "Strong" or "Very Strong" without regenerating

  # TC-STR-08: Strength updates when charset is toggled
  @TC-STR-08
  Scenario: Strength meter updates when character sets are toggled
    Given only Lowercase is ON and length is 14 (Medium strength)
    When the user turns ON all four character sets
    Then the strength label updates to "Strong" or "Very Strong"
    And the fill bar width increases
