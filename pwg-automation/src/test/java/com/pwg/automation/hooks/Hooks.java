package com.pwg.automation.hooks;

import com.pwg.automation.utils.DriverManager;
import com.pwg.automation.utils.ReportManager;
import com.pwg.automation.utils.ScenarioContext;
import io.cucumber.java.After;
import io.cucumber.java.AfterAll;
import io.cucumber.java.Before;
import io.cucumber.java.BeforeAll;
import io.cucumber.java.Scenario;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;

/**
 * Cucumber hooks — WebDriver lifecycle and screenshot on failure.
 */
public class Hooks {

    private static final String BASE_URL = System.getProperty("baseUrl", "http://localhost:3000");

    @BeforeAll
    public static void globalSetup() {
        ReportManager.getInstance();
    }

    @Before
    public void setUp() {
        DriverManager.initDriver();
        DriverManager.getDriver().get(BASE_URL);
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            byte[] screenshot = ((TakesScreenshot) DriverManager.getDriver())
                    .getScreenshotAs(OutputType.BYTES);
            scenario.attach(screenshot, "image/png", "Screenshot on failure");
        }
        ScenarioContext.clear();
        DriverManager.quitDriver();
    }

    @AfterAll
    public static void globalTearDown() {
        ReportManager.flushReports();
    }
}
