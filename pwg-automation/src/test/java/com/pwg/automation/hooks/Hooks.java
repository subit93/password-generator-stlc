package com.pwg.automation.hooks;

import com.aventstack.extentreports.ExtentTest;
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
 * Cucumber hooks — WebDriver lifecycle, screenshot on failure, and Extent reporting.
 */
public class Hooks {

    private static final String BASE_URL = System.getProperty("baseUrl", "http://localhost:3000");
    private static final ThreadLocal<ExtentTest> currentTest = new ThreadLocal<>();

    @BeforeAll
    public static void globalSetup() {
        ReportManager.getInstance();
    }

    @Before
    public void setUp(Scenario scenario) {
        ExtentTest test = ReportManager.getInstance().createTest(scenario.getName());
        currentTest.set(test);
        DriverManager.initDriver();
        DriverManager.getDriver().get(BASE_URL);
    }

    @After
    public void tearDown(Scenario scenario) {
        ExtentTest test = currentTest.get();
        if (scenario.isFailed()) {
            if (DriverManager.getDriver() != null) {
                byte[] screenshot = ((TakesScreenshot) DriverManager.getDriver())
                        .getScreenshotAs(OutputType.BYTES);
                scenario.attach(screenshot, "image/png", "Screenshot on failure");
                if (test != null) {
                    test.fail("Scenario failed: " + scenario.getName());
                    String base64 = java.util.Base64.getEncoder().encodeToString(screenshot);
                    test.addScreenCaptureFromBase64String(base64, "Screenshot on failure");
                }
            } else if (test != null) {
                test.fail("Scenario failed (no driver available)");
            }
        } else if (test != null) {
            test.pass("Scenario passed");
        }
        currentTest.remove();
        ScenarioContext.clear();
        DriverManager.quitDriver();
    }

    @AfterAll
    public static void globalTearDown() {
        ReportManager.flushReports();
    }
}
