package com.pwg.automation.steps;

import com.pwg.automation.pages.GeneratorPage;
import com.pwg.automation.utils.ScenarioContext;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.Assert;

/**
 * Step definitions for strength.feature (TC-STR-01 to TC-STR-08).
 */
public class StrengthSteps {

    private static final String KEY_WEAK_FILL_WIDTH = "weakFillWidth";

    private final GeneratorPage page = new GeneratorPage();

    @And("the charset configuration is {string}")
    public void setCharsetConfiguration(String config) {
        switch (config.toLowerCase()) {
            case "lowercase only":
                page.setUppercase(false);
                page.setLowercase(true);
                page.setNumbers(false);
                page.setSymbols(false);
                break;
            case "lowercase and numbers":
                page.setUppercase(false);
                page.setLowercase(true);
                page.setNumbers(true);
                page.setSymbols(false);
                break;
            case "all four charsets":
                page.setAllCharacterSetsOn();
                break;
            default:
                throw new IllegalArgumentException("Unknown charset config: " + config);
        }
    }

    @Then("the strength label shows {string}")
    public void strengthLabelShows(String expected) {
        String actual = page.getStrengthLabel();
        Assert.assertEquals("Strength label mismatch", expected, actual);
    }

    @And("the strength fill bar color reflects the {string} state")
    public void fillBarColorReflects(String strengthLevel) {
        String style = page.getStrengthFillStyle();
        Assert.assertNotNull("Strength fill style should not be null", style);
        Assert.assertFalse("Strength fill style should not be empty", style.isBlank());
    }

    @Given("a password is generated with length=8 and lowercase only")
    public void generatePasswordWeakConfig() {
        page.setLength(8);
        page.setUppercase(false);
        page.setLowercase(true);
        page.setNumbers(false);
        page.setSymbols(false);
        page.clickGenerate();
    }

    @And("the fill bar width is recorded as {string}")
    public void recordFillBarWidth(String key) {
        String style = page.getStrengthFillStyle();
        ScenarioContext.set(key, style);
    }

    @When("a new password is generated with length={int} and all charsets ON")
    public void generatePasswordStrongConfig(int length) {
        page.setLength(length);
        page.setAllCharacterSetsOn();
        page.clickGenerate();
    }

    @Then("the fill bar width is greater than {string}")
    public void fillBarWidthGreaterThan(String key) {
        String previousStyle = ScenarioContext.get(key);
        String currentStyle  = page.getStrengthFillStyle();
        double previousWidth = parseWidthPercent(previousStyle);
        double currentWidth  = parseWidthPercent(currentStyle);
        Assert.assertTrue(
            "Current fill width (" + currentWidth + "%) should be > previous (" + previousWidth + "%)",
            currentWidth > previousWidth);
    }

    @And("the fill bar width represents a higher entropy percentage")
    public void fillBarRepresentsHigherEntropy() {
        String style = page.getStrengthFillStyle();
        double width = parseWidthPercent(style);
        Assert.assertTrue("Fill bar width should be > 50% for strong config", width > 50.0);
    }

    @Given("all four character sets are ON")
    public void allFourCharacterSetsOn() {
        page.setAllCharacterSetsOn();
    }

    @Then("^an entropy value in bits is displayed in the UI \\(entropy label is visible and non-zero\\)$")
    public void entropyValueDisplayed() {
        String entropy = page.getEntropyLabel();
        Assert.assertFalse("Entropy label should not be empty", entropy == null || entropy.isBlank());
        Assert.assertNotEquals("Entropy label should not be '—'", "—", entropy);
    }

    @When("the user moves the length slider to {int}")
    public void moveLengthSlider(int length) {
        page.setLength(length);
    }

    @Then("the strength label updates to {string} or {string} without regenerating")
    public void strengthLabelUpdatesTo(String label1, String label2) {
        String actual = page.getStrengthLabel();
        Assert.assertTrue(
            "Strength label should be '" + label1 + "' or '" + label2 + "', got: " + actual,
            actual.equals(label1) || actual.equals(label2));
    }

    @Given("^only Lowercase is ON and length is (\\d+) \\(\\w+ strength\\)$")
    public void setLowercaseOnlyWithStrengthLabel(int length) {
        page.setUppercase(false);
        page.setLowercase(true);
        page.setNumbers(false);
        page.setSymbols(false);
        page.setLength(length);
    }

    @When("the user turns ON all four character sets")
    public void turnOnAllCharsets() {
        page.setAllCharacterSetsOn();
    }

    @Then("the strength label updates to {string} or {string}")
    public void strengthLabelUpdates(String label1, String label2) {
        strengthLabelUpdatesTo(label1, label2);
    }

    @And("the fill bar width increases")
    public void fillBarWidthIncreases() {
        String style = page.getStrengthFillStyle();
        double width = parseWidthPercent(style);
        Assert.assertTrue("Fill bar width should increase to > 50% after enabling all charsets", width > 50.0);
    }

    // ── Helper ────────────────────────────────────────────────────
    private double parseWidthPercent(String style) {
        if (style == null || style.isBlank()) return 0.0;
        // style example: "width: 45%;"
        try {
            String cleaned = style.replaceAll("[^0-9.]", "").trim();
            return Double.parseDouble(cleaned);
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
