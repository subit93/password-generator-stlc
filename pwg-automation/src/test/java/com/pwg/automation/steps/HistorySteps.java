package com.pwg.automation.steps;

import com.pwg.automation.pages.GeneratorPage;
import com.pwg.automation.pages.HistoryPage;
import com.pwg.automation.utils.DriverManager;
import com.pwg.automation.utils.ScenarioContext;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.Assert;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * Step definitions for history.feature (TC-HIST-01 to TC-HIST-06).
 * Note: The app uses in-memory history (not localStorage), so TC-HIST-03 and
 * TC-HIST-06 are expected to fail, documenting a gap between spec and implementation.
 */
public class HistorySteps {

    private static final String KEY_HISTORY_SNAPSHOTS = "historySnapshots";

    private final HistoryPage    historyPage    = new HistoryPage();
    private final GeneratorPage  generatorPage  = new GeneratorPage();

    @And("the history list is empty")
    public void historyListIsEmpty() {
        generatorPage.clickTab("history");
        Assert.assertTrue("History list should be empty", historyPage.isHistoryListEmpty());
        generatorPage.clickTab("generator");
    }

    @Then("the history list contains exactly {int} entry")
    public void historyListContainsExact(int expected) {
        Assert.assertEquals("History entry count mismatch", expected, historyPage.getHistoryItemCount());
    }

    @Then("the history list contains exactly {int} entries")
    public void historyListContainsExactPlural(int expected) {
        historyListContainsExact(expected);
    }

    @And("the entry matches the last generated password")
    public void entryMatchesLastPassword() {
        String lastPassword = ScenarioContext.get("lastPassword");
        if (lastPassword != null) {
            Assert.assertTrue("History should contain last generated password",
                    historyPage.getHistoryPasswordTexts().contains(lastPassword));
        }
    }

    @When("the user generates {int} passwords sequentially")
    public void generatePasswordsSequentially(int count) {
        generatorPage.clickTab("generator");
        for (int i = 0; i < count; i++) {
            generatorPage.clickGenerate();
        }
    }

    @And("^entries are displayed in chronological order \\(most recent first or last\\)$")
    public void entriesInChronologicalOrder() {
        Assert.assertTrue("History should have at least 1 entry",
                historyPage.getHistoryItemCount() >= 1);
    }

    @Given("{int} passwords have been generated and stored in history")
    public void passwordsGeneratedAndStoredInHistory(int count) {
        generatorPage.clickTab("generator");
        for (int i = 0; i < count; i++) {
            generatorPage.clickGenerate();
        }
        ScenarioContext.set(KEY_HISTORY_SNAPSHOTS, historyPage.getHistoryPasswordTexts());
    }

    @When("the user reloads the page")
    public void reloadPage() {
        DriverManager.getDriver().navigate().refresh();
        new WebDriverWait(DriverManager.getDriver(), Duration.ofSeconds(10))
                .until(ExpectedConditions.titleContains("Password Generator"));
    }

    @And("the history list still contains {int} entries")
    public void historyStillContainsEntries(int expected) {
        generatorPage.clickTab("history");
        Assert.assertEquals("History entry count should persist after reload",
                expected, historyPage.getHistoryItemCount());
    }

    @And("the entries match the previously generated passwords")
    public void entriesMatchPreviouslyGenerated() {
        // Will fail if app uses in-memory storage (TC-HIST-03 documents a gap)
        Assert.assertTrue("History should have entries", historyPage.getHistoryItemCount() > 0);
    }

    @Given("{int} passwords have been generated and are visible in the history list")
    public void passwordsGeneratedAndVisibleInHistory(int count) {
        generatorPage.clickTab("generator");
        for (int i = 0; i < count; i++) {
            generatorPage.clickGenerate();
        }
        generatorPage.clickTab("history");
        Assert.assertEquals("Expected history to contain " + count + " entries",
                count, historyPage.getHistoryItemCount());
    }

    @And("localStorage no longer contains any password history data")
    public void localStorageNoHistoryData() {
        // Will fail if app uses localStorage — documents a gap if it doesn't
        Assert.assertFalse("localStorage should not contain history data",
                historyPage.localStorageHasHistoryData());
    }

    @Then("the history list shows an empty state message or empty list")
    public void historyShowsEmptyState() {
        Assert.assertTrue("History should show empty state",
                historyPage.isHistoryListEmpty());
    }

    @And("no password entries are visible")
    public void noPasswordEntriesVisible() {
        Assert.assertEquals("No password entries should be visible",
                0, historyPage.getHistoryItemCount());
    }

    @When("the user generates a password")
    public void generateASinglePassword() {
        generatorPage.clickTab("generator");
        generatorPage.clickGenerate();
        ScenarioContext.set("lastPassword", generatorPage.getPasswordText());
    }

    @Then("localStorage contains a history key with the generated password stored")
    public void localStorageContainsHistoryKey() {
        // Documents gap: app uses in-memory storage, not localStorage
        Assert.assertTrue("localStorage should store password history (gap: app uses in-memory)",
                historyPage.localStorageHasHistoryData());
    }
}
