# Feature: Password Generator — Bulk Generation Tab
# Jira: KAN-22
# Objectives covered: TC-BLK-01 to TC-BLK-07 (from KAN-15, Module 2)

@bulk
Feature: Bulk Generation Tab — Generate Multiple Passwords

  Background:
    Given the user has opened the Password Generator app at "http://localhost:3000"
    And the user clicks the "Bulk" tab

  # TC-BLK-01: Bulk count slider controls number of passwords
  @TC-BLK-01
  Scenario Outline: Bulk count slider controls how many passwords are generated
    Given the bulk count slider is set to <count>
    When the user clicks the "Bulk Generate" button
    Then the bulk output list contains exactly <count> passwords
    And the bulk count display badge shows "<count>"

    Examples:
      | count |
      | 1     |
      | 5     |
      | 10    |
      | 50    |
      | 100   |

  # TC-BLK-02: All passwords appear in output list
  @TC-BLK-02
  Scenario: All generated bulk passwords are displayed in the output list
    Given the bulk count slider is set to 10
    When the user clicks the "Bulk Generate" button
    Then the bulk output list is visible
    And the bulk output list contains 10 password entries
    And each entry is a non-empty string

  # TC-BLK-03: Export button downloads passwords
  @TC-BLK-03
  Scenario: Export button downloads bulk passwords as a text file
    Given 10 passwords have been bulk generated
    When the user clicks the "Export" button
    Then a file download is triggered
    And the downloaded file contains 10 passwords, one per line

  # TC-BLK-04: Clear button removes all bulk passwords
  @TC-BLK-04
  Scenario: Clear button removes all passwords from the bulk output list
    Given 10 passwords have been bulk generated and are visible in the list
    When the user clicks the "Bulk Clear" button
    Then the bulk output list is empty
    And no passwords are displayed

  # TC-BLK-05 to TC-BLK-07: Bulk passwords respect character settings
  @TC-BLK-05
  Scenario: Bulk passwords contain only uppercase when only Uppercase is selected
    Given the Uppercase toggle is ON
    And all other character set toggles are OFF
    And the bulk count slider is set to 5
    When the user clicks the "Bulk Generate" button
    Then all 5 generated passwords contain only uppercase characters (A-Z)

  @TC-BLK-06
  Scenario: Bulk passwords respect length setting from Generator tab
    Given the length slider in the Generator tab is set to 20
    And the bulk count slider is set to 5
    When the user clicks the "Bulk Generate" button
    Then all 5 generated passwords are exactly 20 characters long

  @TC-BLK-07
  Scenario: All bulk generated passwords are unique
    Given the bulk count slider is set to 20
    And all character sets are ON
    And the length slider is set to 16
    When the user clicks the "Bulk Generate" button
    Then all 20 passwords in the list are unique (no duplicates)
