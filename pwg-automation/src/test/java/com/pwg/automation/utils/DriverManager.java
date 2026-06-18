package com.pwg.automation.utils;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.edge.EdgeOptions;

/**
 * Manages WebDriver lifecycle — creation, retrieval, and teardown.
 * Uses Selenium Manager (bundled with Selenium 4.6+) to resolve the Edge driver automatically.
 * No external network calls or WebDriverManager dependency required.
 */
public class DriverManager {

    private static final ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    private DriverManager() {}

    public static void initDriver() {
        // Point directly to the local msedgedriver binary — avoids all CDN/network calls
        System.setProperty("webdriver.edge.driver",
                "C:\\Users\\subit_mishra\\Documents\\Tools\\driver\\msedgedriver.exe");
        EdgeOptions options = new EdgeOptions();
        options.addArguments("--headless", "--no-sandbox", "--disable-dev-shm-usage", "--disable-gpu");
        options.setBinary("C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe");
        WebDriver webDriver = new EdgeDriver(options);
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
