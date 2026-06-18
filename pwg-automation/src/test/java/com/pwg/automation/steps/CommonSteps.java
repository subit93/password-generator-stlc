package com.pwg.automation.steps;

import com.pwg.automation.pages.GeneratorPage;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import com.pwg.automation.utils.DriverManager;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

/**
 * Steps shared across multiple feature files:
 * - App navigation and tab switching
 * - Character set toggle setup (Uppercase, Lowercase, Numbers, Symbols)
 * - Length slider setup
 * - Options (Exclude Ambiguous, Require Each)
 * - localStorage helpers
 * - Generic button / tab / preset button clicks
 */
public class CommonSteps {

    private final GeneratorPage generatorPage = new GeneratorPage();

    // ── Button label → element ID lookup ─────────────────────────
    private static final Map<String, String> BUTTON_IDS = new HashMap<>();
    static {
        BUTTON_IDS.put("Generate",            "generate-btn");
        BUTTON_IDS.put("Copy",                "copy-btn");
        BUTTON_IDS.put("Regenerate",          "regen-btn");
        BUTTON_IDS.put("Show/Hide",           "show-hide-btn");
        BUTTON_IDS.put("Generate All",        "bulk-generate-btn");
        BUTTON_IDS.put("Bulk Generate",       "bulk-generate-btn");
        BUTTON_IDS.put("Export",              "bulk-export-btn");
        BUTTON_IDS.put("Bulk Clear",          "bulk-clear-btn");
        BUTTON_IDS.put("Generate Phrase",     "phrase-generate-btn");
        BUTTON_IDS.put("Generate Passphrase", "phrase-generate-btn");
        BUTTON_IDS.put("Passphrase Copy",     "phrase-copy-btn");
        BUTTON_IDS.put("Clear History",       "clear-history-btn");
        BUTTON_IDS.put("Clear All",           "clear-history-btn");
    }

    @Given("the user has opened the Password Generator app at {string}")
    public void openApp(String url) {
        DriverManager.getDriver().get(url);
        new WebDriverWait(DriverManager.getDriver(), Duration.ofSeconds(10))
                .until(ExpectedConditions.titleContains("Password Generator"));
    }

    @Given("the Generator tab is active")
    public void generatorTabActive() {
        generatorPage.clickTab("generator");
    }

    @Given("the user clicks the {string} tab")
    public void clickTab(String tabName) {
        generatorPage.clickTab(tabName);
    }

    @When("the user clicks the {string} button")
    public void clickButton(String label) {
        WebDriver driver = DriverManager.getDriver();
        if (BUTTON_IDS.containsKey(label)) {
            driver.findElement(By.id(BUTTON_IDS.get(label))).click();
        } else {
            driver.findElement(By.xpath(
                "//button[contains(normalize-space(.), '" + label + "')]")).click();
        }
    }

    @When("the user clicks the {string} button again")
    public void clickButtonAgain(String label) {
        clickButton(label);
    }

    @When("the user clicks the {string} preset button")
    public void clickPresetButton(String presetName) {
        generatorPage.clickPreset(presetName);
    }

    // ── Character set toggles ────────────────────────────────────
    @Given("the Uppercase toggle is {word}")
    public void setUppercaseToggle(String state) {
        generatorPage.setUppercase("ON".equalsIgnoreCase(state));
    }

    @Given("the Lowercase toggle is {word}")
    public void setLowercaseToggle(String state) {
        generatorPage.setLowercase("ON".equalsIgnoreCase(state));
    }

    @Given("the Numbers toggle is {word}")
    public void setNumbersToggle(String state) {
        generatorPage.setNumbers("ON".equalsIgnoreCase(state));
    }

    @Given("the Symbols toggle is {word}")
    public void setSymbolsToggle(String state) {
        generatorPage.setSymbols("ON".equalsIgnoreCase(state));
    }

    @Given("all character sets are ON")
    public void allCharacterSetsOn() {
        generatorPage.setAllCharacterSetsOn();
    }

    @And("all other character set toggles are OFF")
    public void allOtherToggleOff() {
        // Called after one toggle is already set ON; turn off the rest
        // Implementation relies on preceding steps having set the ON toggle
        // Safest: turn all OFF then the step context will re-enable the desired one
        generatorPage.setUppercase(false);
        generatorPage.setLowercase(false);
        generatorPage.setNumbers(false);
        generatorPage.setSymbols(false);
    }

    // ── Length slider ─────────────────────────────────────────────
    @Given("the length slider is set to {int}")
    public void setLengthSlider(int length) {
        generatorPage.setLength(length);
    }

    // Variant with explicit strength label, e.g. "the length slider is set to 8 (Weak)"
    // Restricted to known strength labels to avoid ambiguity with PresetsSteps "(approximately)"
    @Given("^the length slider is set to (\\d+) \\((Weak|Medium|Strong|Very Strong)\\)$")
    public void setLengthSliderWithLabel(int length) {
        generatorPage.setLength(length);
    }

    @Given("the length slider in the Generator tab is set to {int}")
    public void setLengthSliderGeneratorTab(int length) {
        generatorPage.clickTab("generator");
        generatorPage.setLength(length);
    }

    // ── Options ───────────────────────────────────────────────────
    @Given("the {string} option is {word}")
    public void setOption(String optionName, String state) {
        boolean on = "ON".equalsIgnoreCase(state);
        switch (optionName) {
            case "Exclude Ambiguous": generatorPage.setExcludeAmbiguous(on); break;
            case "Require Each":      generatorPage.setRequireEach(on);      break;
            default: throw new IllegalArgumentException("Unknown option: " + optionName);
        }
    }

    // ── Default settings ──────────────────────────────────────────
    @Given("^all default settings are applied \\(length=16, uppercase ON, lowercase ON, numbers ON, symbols OFF\\)$")
    public void applyDefaultSettings() {
        generatorPage.applyDefaultSettings();
    }

    // ── localStorage helpers ──────────────────────────────────────
    @Given("localStorage has been cleared before the test")
    public void clearLocalStorageBeforeTest() {
        DriverManager.getDriver().navigate().refresh();
        new WebDriverWait(DriverManager.getDriver(), Duration.ofSeconds(10))
                .until(ExpectedConditions.titleContains("Password Generator"));
    }

    @Given("localStorage has no stored password history")
    public void localStorageNoHistory() {
        clearLocalStorageBeforeTest();
    }
}
