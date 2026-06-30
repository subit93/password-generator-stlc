# Feature: Password Generator — Security & Crypto Engine
# Jira: KAN-27
# Objectives covered: TC-SEC-01 to TC-SEC-08 (from KAN-15, Module 7)

@security
Feature: Security — Cryptographic Engine Validation

  Background:
    Given the user has opened the Password Generator app at "http://localhost:3000"
    And the Generator tab is active
    And browser network monitoring is active (via browser devtools / WebDriver network interception)

  # TC-SEC-01: crypto.getRandomValues() is used — not Math.random()
  @TC-SEC-01
  Scenario: Application uses crypto.getRandomValues() and not Math.random()
    When the page source and all linked JavaScript files are inspected
    Then the string "crypto.getRandomValues" is found in the JavaScript source
    And the string "Math.random" is NOT used for password character selection

  # TC-SEC-02: No network requests during password generation
  @TC-SEC-02
  Scenario: No network requests are made when generating a password
    Given network request monitoring is enabled
    When the user clicks the "Generate" button
    Then no external network requests are made during password generation
    And the network request log shows zero new requests after clicking Generate

  # TC-SEC-03: Generated password is not sent to any server
  @TC-SEC-03
  Scenario: Generated password value is not transmitted to any external server
    Given network request monitoring is enabled
    When the user generates a password
    And the user clicks the "Copy" button
    Then no HTTP request body contains the generated password value
    And no XHR or fetch calls are triggered with the password as payload

  # TC-SEC-04: Application works fully offline
  @TC-SEC-04
  Scenario: Application is fully functional with no internet connection
    Given the browser is set to offline mode
    When the user navigates to "http://localhost:3000"
    Then the application loads successfully
    And all tabs (Generator, Bulk, Passphrase, History) are accessible
    And password generation works without any network dependency

  # TC-SEC-05: No CDN or external resource dependencies
  @TC-SEC-05
  Scenario: No external resources (CDN, fonts, APIs) are loaded
    Given network request monitoring is enabled
    When the page fully loads
    Then all resources (CSS, JS, fonts) are served from localhost
    And no requests are made to any external domain (e.g., cdn.*, googleapis.*, etc.)

  # TC-SEC-06: Rejection sampling eliminates modulo bias
  @TC-SEC-06
  Scenario: Character selection uses rejection sampling for uniform distribution
    When the JavaScript source of generator.js is inspected
    Then the secureRandom function uses rejection sampling logic
    And the code calculates "limit = 4294967296 - (4294967296 % max)" or equivalent
    And values exceeding the limit are discarded and regenerated

  # TC-SEC-07: Passwords are not logged to the browser console
  @TC-SEC-07
  Scenario: Generated passwords are not printed to the browser console
    Given browser console monitoring is active
    When the user generates 5 passwords
    Then no console.log, console.info, or console.debug statements output the password values

  # TC-SEC-08: App does not use deprecated or insecure APIs
  @TC-SEC-08
  Scenario: Application does not use deprecated or insecure browser APIs
    When the application JavaScript source is reviewed
    Then no usage of deprecated crypto APIs (e.g., window.crypto.getRandomValues via ActiveX) is found
    And no eval() or innerHTML assignments with generated password content are present
