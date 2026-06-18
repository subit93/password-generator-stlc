package com.pwg.automation.runner;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

/**
 * KAN-33 — Cucumber Test Runner
 * Wires feature files to step definitions and generates reports.
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/resources/features",
        glue = {"com.pwg.automation.steps", "com.pwg.automation.hooks"},
        plugin = {
                "pretty",
                "html:target/cucumber-reports/cucumber.html",
                "json:target/cucumber-reports/cucumber.json"
        },
        monochrome = true,
        tags = "not @ignore"
)
public class TestRunner {
    // Entry point for Maven Surefire — no code required here
}
