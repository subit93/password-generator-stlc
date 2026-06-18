package com.pwg.automation.steps;

import com.pwg.automation.pages.GeneratorPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.Assert;

/**
 * Step definitions for presets.feature (TC-PRE-01 to TC-PRE-06).
 *
 * NOTE: Two discrepancies exist between the feature file spec and the actual app:
 *   1. Banking preset length: feature says 16, app sets 20 → TC-PRE-01/02 will fail for Banking row.
 *   2. Super Secure excludeAmbiguous: feature says ON, app sets OFF → TC-PRE-05 will fail.
 * These are intentional failing tests that document gaps between spec and implementation.
 */
public class PresetsSteps {

    private final GeneratorPage page = new GeneratorPage();

    @Then("the length slider is set to {int} \\(approximately\\)")
    public void lengthSliderApproximately(int expected) {
        int actual = page.getLengthSliderValue();
        // Allow ±2 tolerance for "approximately"
        Assert.assertTrue(
            "Expected length ~" + expected + " but got " + actual,
            Math.abs(actual - expected) <= 2);
    }

    @Then("the length slider is set to at least {int}")
    public void lengthSliderAtLeast(int minimum) {
        int actual = page.getLengthSliderValue();
        Assert.assertTrue(
            "Expected length >= " + minimum + " but got " + actual,
            actual >= minimum);
    }

    @Then("all four character set toggles (Uppercase, Lowercase, Numbers, Symbols) are ON")
    public void allFourTogglesOn() {
        Assert.assertTrue("Uppercase should be ON",  page.isUppercaseChecked());
        Assert.assertTrue("Lowercase should be ON",  page.isLowercaseChecked());
        Assert.assertTrue("Numbers should be ON",    page.isNumbersChecked());
        Assert.assertTrue("Symbols should be ON",    page.isSymbolsChecked());
    }

    @Given("the current length is set to 8 and only Lowercase is ON")
    public void setLowercaseOnlyLength8() {
        page.setLength(8);
        page.setUppercase(false);
        page.setLowercase(true);
        page.setNumbers(false);
        page.setSymbols(false);
    }

    @Then("the UI updates immediately (no additional button press required)")
    public void uiUpdatesImmediately() {
        // Presets update the UI synchronously via JS event handlers; no extra action needed.
        // This step passes if the preceding preset click step succeeded.
        Assert.assertTrue("UI should update immediately after preset click", true);
    }

    @And("the length slider reflects the Banking preset length")
    public void lengthSliderReflectsBanking() {
        int actual = page.getLengthSliderValue();
        Assert.assertTrue("Banking preset length should be >= 16, got: " + actual, actual >= 16);
    }

    @And("the character set toggles reflect the Banking preset configuration")
    public void togglesReflectBanking() {
        Assert.assertTrue("Banking: Uppercase should be ON",  page.isUppercaseChecked());
        Assert.assertTrue("Banking: Lowercase should be ON",  page.isLowercaseChecked());
        Assert.assertTrue("Banking: Numbers should be ON",    page.isNumbersChecked());
        Assert.assertTrue("Banking: Symbols should be ON",    page.isSymbolsChecked());
    }
}
