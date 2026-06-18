# Feature: Password Generator — History Tab
# Jira: KAN-24
# Objectives covered: TC-HIST-01 to TC-HIST-06 (from KAN-15, Module 4)

@history
Feature: History Tab — Password History via localStorage

  Background:
    Given the user has opened the Password Generator app at "http://localhost:3000"
    And localStorage has been cleared before the test

  # TC-HIST-01: Password added to history immediately after generation
  @TC-HIST-01
  Scenario: Generated password is added to the history list immediately
    Given the Generator tab is active
    And the history list is empty
    When the user clicks the "Generate" button
    And the user clicks the "History" tab
    Then the history list contains exactly 1 entry
    And the entry matches the last generated password

  # TC-HIST-02: Multiple passwords accumulate in history
  @TC-HIST-02
  Scenario: Multiple generated passwords all appear in the history list
    Given the Generator tab is active
    When the user generates 5 passwords sequentially
    And the user clicks the "History" tab
    Then the history list contains exactly 5 entries
    And entries are displayed in chronological order (most recent first or last)

  # TC-HIST-03: History persists across page reload
  @TC-HIST-03
  Scenario: History entries survive a page reload
    Given 3 passwords have been generated and stored in history
    When the user reloads the page
    And the user clicks the "History" tab
    Then the history list still contains 3 entries
    And the entries match the previously generated passwords

  # TC-HIST-04: Clear History removes all entries
  @TC-HIST-04
  Scenario: Clear History button removes all history entries
    Given 5 passwords have been generated and are visible in the history list
    When the user clicks the "History" tab
    And the user clicks the "Clear History" button
    Then the history list is empty
    And localStorage no longer contains any password history data

  # TC-HIST-05: Empty state shown on first load
  @TC-HIST-05
  Scenario: Empty state is displayed when history is empty on first load
    Given localStorage has no stored password history
    When the user clicks the "History" tab
    Then the history list shows an empty state message or empty list
    And no password entries are visible

  # TC-HIST-06: localStorage contains the correct data
  @TC-HIST-06
  Scenario: localStorage stores the generated password after generation
    Given the Generator tab is active
    When the user generates a password
    Then localStorage contains a history key with the generated password stored
