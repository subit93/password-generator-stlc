package com.pwg.automation.utils;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.edge.EdgeDriverService;
import org.openqa.selenium.edge.EdgeOptions;

import java.io.File;

/**
 * Manages WebDriver lifecycle — creation, retrieval, and teardown.
 * Uses EdgeDriverService with explicit driver path to bypass Selenium Manager entirely.
 */
public class DriverManager {

    private static final ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    private DriverManager() {}

    public static void initDriver() {
        // Use EdgeDriverService directly — bypasses Selenium Manager and all CDN/network calls.
        // Note: do NOT call options.setBinary() — that triggers Selenium Manager in Selenium 4.21+.
        EdgeDriverService service = new EdgeDriverService.Builder()
                .usingDriverExecutable(new File(
                        "C:\\Users\\subit_mishra\\Documents\\Tools\\driver\\msedgedriver.exe"))
                .build();
        EdgeOptions options = new EdgeOptions();
        options.addArguments("--headless", "--no-sandbox", "--disable-dev-shm-usage", "--disable-gpu");
        WebDriver webDriver = new EdgeDriver(service, options);
        webDriver.manage().window().maximize();
        driver.set(webDriver);
    }

    public static WebDriver getDriver() {
        return driver.get();
    }

    public static void quitDriver() {
        if (driver.get() != null) {
            driver.get().quit();
            driver.remove();
        }
    }
}
