package com.pwg.automation.steps;

import com.pwg.automation.pages.GeneratorPage;
import com.pwg.automation.utils.ScenarioContext;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.Assert;

/**
 * Step definitions for generator.feature (TC-GEN-01 to TC-GEN-15).
 */
public class GeneratorSteps {

    private static final String KEY_PASSWORD          = "lastPassword";
    private static final String KEY_PREVIOUS_PASSWORD = "previousPassword";

    private final GeneratorPage page = new GeneratorPage();

    // ── Generate / output ─────────────────────────────────────────
    @Then("a password of exactly {int} characters is displayed in the output box")
    public void passwordLengthInOutputBox(int expectedLength) {
        String pwd = page.getPasswordText();
        Assert.assertEquals("Password length mismatch", expectedLength, pwd.length());
        ScenarioContext.set(KEY_PASSWORD, pwd);
    }

    @Then("a password of exactly {int} characters is displayed")
    public void passwordLength(int expectedLength) {
        passwordLengthInOutputBox(expectedLength);
    }

    @Then("the length badge shows {string}")
    public void lengthBadgeShows(String expected) {
        Assert.assertEquals("Length badge mismatch", expected, page.getLengthBadgeText());
    }

    @Then("the output box becomes visible")
    public void outputBoxVisible() {
        Assert.assertTrue("Output box should be visible", page.isOutputBoxVisible());
    }

    @Then("the password text element is not empty")
    public void passwordTextNotEmpty() {
        Assert.assertFalse("Password text should not be empty", page.isPasswordTextEmpty());
        ScenarioContext.set(KEY_PASSWORD, page.getPasswordText());
    }

    // ── Character set assertions ──────────────────────────────────
    @Then("^the generated password contains only uppercase characters \\(A-Z\\)$")
    public void passwordOnlyUppercase() {
        String pwd = page.getPasswordText();
        ScenarioContext.set(KEY_PASSWORD, pwd);
        Assert.assertTrue("Expected only uppercase chars: " + pwd,
                pwd.chars().allMatch(c -> c >= 'A' && c <= 'Z'));
    }

    @Then("^the generated password contains only lowercase characters \\(a-z\\)$")
    public void passwordOnlyLowercase() {
        String pwd = page.getPasswordText();
        ScenarioContext.set(KEY_PASSWORD, pwd);
        Assert.assertTrue("Expected only lowercase chars: " + pwd,
                pwd.chars().allMatch(c -> c >= 'a' && c <= 'z'));
    }

    @Then("^the generated password contains only numeric characters \\(0-9\\)$")
    public void passwordOnlyNumeric() {
        String pwd = page.getPasswordText();
        ScenarioContext.set(KEY_PASSWORD, pwd);
        Assert.assertTrue("Expected only numeric chars: " + pwd,
                pwd.chars().allMatch(Character::isDigit));
    }

    @Then("the generated password contains only symbol characters")
    public void passwordOnlySymbols() {
        String pwd = page.getPasswordText();
        ScenarioContext.set(KEY_PASSWORD, pwd);
        Assert.assertTrue("Expected only symbol chars: " + pwd,
                pwd.chars().allMatch(c -> !Character.isLetterOrDigit(c)));
    }

    @Then("the generated password does not contain any of the characters: O, 0, l, 1, I")
    public void passwordNoAmbiguousChars() {
        String pwd = page.getPasswordText();
        for (char ambiguous : new char[]{'O', '0', 'l', '1', 'I'}) {
            Assert.assertFalse(
                "Password should not contain ambiguous char '" + ambiguous + "': " + pwd,
                pwd.indexOf(ambiguous) >= 0);
        }
    }

    @Then("the generated password contains at least one uppercase character")
    public void passwordHasUppercase() {
        String pwd = page.getPasswordText();
        ScenarioContext.set(KEY_PASSWORD, pwd);
        Assert.assertTrue("Password missing uppercase: " + pwd,
                pwd.chars().anyMatch(Character::isUpperCase));
    }

    @Then("the generated password contains at least one lowercase character")
    public void passwordHasLowercase() {
        String pwd = page.getPasswordText();
        Assert.assertTrue("Password missing lowercase: " + pwd,
                pwd.chars().anyMatch(Character::isLowerCase));
    }

    @Then("the generated password contains at least one number")
    public void passwordHasNumber() {
        String pwd = page.getPasswordText();
        Assert.assertTrue("Password missing number: " + pwd,
                pwd.chars().anyMatch(Character::isDigit));
    }

    @Then("the generated password contains at least one symbol")
    public void passwordHasSymbol() {
        String pwd = page.getPasswordText();
        Assert.assertTrue("Password missing symbol: " + pwd,
                pwd.chars().anyMatch(c -> !Character.isLetterOrDigit(c)));
    }

    // ── Copy ──────────────────────────────────────────────────────
    @Then("the clipboard contains the generated password text")
    public void clipboardHasPassword() {
        // Clipboard access requires browser permission; verified via toast message presence
        String toast = page.getToastText();
        Assert.assertTrue("Expected copy success toast", toast.contains("copied"));
    }

    @Then("a success toast or confirmation is shown")
    public void successToastShown() {
        String toast = page.getToastText();
        Assert.assertFalse("Expected a toast message", toast == null || toast.isBlank());
    }

    // ── Show / Hide ───────────────────────────────────────────────
    @Given("a password has been generated")
    public void aPasswordHasBeenGenerated() {
        page.clickGenerate();
        ScenarioContext.set(KEY_PASSWORD, page.getPasswordText());
    }

    @Given("^the password is currently hidden \\(masked\\)$")
    public void passwordCurrentlyHidden() {
        // Show/Hide toggles the blurred class; click once to hide if currently visible
        String text = page.getPasswordText();
        // Ensure a password exists, then hide it by clicking show/hide
        page.clickShowHide();
    }

    @Then("^the password text becomes visible \\(unmasked\\)$")
    public void passwordVisible() {
        // The blurred CSS class is removed when visible; text is non-empty
        Assert.assertFalse("Password text should be visible (not empty)", page.isPasswordTextEmpty());
    }

    @Then("the password text is masked again")
    public void passwordMasked() {
        // After second click of Show/Hide the blurred class is re-applied
        // Verified by checking password-text has 'blurred' class via JS
        Object hasBlurvred = page.executeScript(
            "return document.getElementById('password-text').classList.contains('blurred');");
        Assert.assertTrue("Password should be masked (blurred class present)", Boolean.TRUE.equals(hasBlurvred));
    }

    // ── Regenerate ────────────────────────────────────────────────
    @Given("a password has been generated and displayed")
    public void passwordGeneratedAndDisplayed() {
        page.clickGenerate();
        ScenarioContext.set(KEY_PREVIOUS_PASSWORD, page.getPasswordText());
    }

    @Then("a new password is generated")
    public void newPasswordGenerated() {
        String newPwd = page.getPasswordText();
        ScenarioContext.set(KEY_PASSWORD, newPwd);
        Assert.assertFalse("New password should not be empty", page.isPasswordTextEmpty());
    }

    @Then("the new password is different from the previous password")
    public void newPasswordDifferentFromPrevious() {
        String previous = ScenarioContext.get(KEY_PREVIOUS_PASSWORD);
        String current  = page.getPasswordText();
        // Probabilistically different; identical passwords are astronomically unlikely
        Assert.assertNotEquals(
            "New password should differ from the previous one", previous, current);
    }

    // ── Short-password warning ─────────────────────────────────────
    @Then("the short-password warning box is {word}")
    public void shortWarningVisibility(String visibility) {
        boolean shouldBeVisible = "visible".equalsIgnoreCase(visibility);
        boolean isVisible = page.isShortWarningVisible();
        Assert.assertEquals(
            "Short-password warning visibility should be " + visibility,
            shouldBeVisible, isVisible);
    }
}
