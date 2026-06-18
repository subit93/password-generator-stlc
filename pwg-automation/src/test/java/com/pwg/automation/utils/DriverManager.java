package com.pwg.automation.utils;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.edge.EdgeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;

import java.io.File;

/**
 * Manages WebDriver lifecycle — creation, retrieval, and teardown.
 * Uses WebDriverManager to automatically resolve browser drivers.
 */
public class DriverManager {

    private static final ThreadLocal<WebDriver> driver = new ThreadLocal<>();

    private DriverManager() {}

    public static void initDriver() {
        String browser = System.getProperty("browser", "chrome").toLowerCase();
        WebDriver webDriver;
        switch (browser) {
            case "firefox":
                WebDriverManager.firefoxdriver().setup();
                webDriver = new FirefoxDriver();
                break;
            case "edge":
                WebDriverManager.edgedriver().setup();
                webDriver = new EdgeDriver();
                break;
            case "edge-headless":
                WebDriverManager.edgedriver().setup();
                EdgeOptions edgeHeadlessOptions = new EdgeOptions();
                edgeHeadlessOptions.addArguments("--headless", "--no-sandbox", "--disable-dev-shm-usage");
                edgeHeadlessOptions.setBinary("C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe");
                webDriver = new EdgeDriver(edgeHeadlessOptions);
                break;
            case "chrome-headless":
                if (isChromeAvailable()) {
                    WebDriverManager.chromedriver().setup();
                    ChromeOptions headlessOptions = new ChromeOptions();
                    headlessOptions.addArguments("--headless", "--no-sandbox", "--disable-dev-shm-usage");
                    webDriver = new ChromeDriver(headlessOptions);
                } else {
                    // Chrome not found — fall back to Edge headless (available on Windows by default)
                    System.out.println("[DriverManager] Chrome not found, falling back to Edge headless");
                    WebDriverManager.edgedriver().setup();
                    EdgeOptions fallbackOptions = new EdgeOptions();
                    fallbackOptions.addArguments("--headless", "--no-sandbox", "--disable-dev-shm-usage");
                    fallbackOptions.setBinary("C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe");
                    webDriver = new EdgeDriver(fallbackOptions);
                }
                break;
            default:
                WebDriverManager.chromedriver().setup();
                webDriver = new ChromeDriver();
                break;
        }
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

    private static boolean isChromeAvailable() {
        String[] chromePaths = {
            "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
            "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
            System.getenv("LOCALAPPDATA") != null
                ? System.getenv("LOCALAPPDATA") + "\\Google\\Chrome\\Application\\chrome.exe" : ""
        };
        for (String path : chromePaths) {
            if (!path.isEmpty() && new File(path).exists()) return true;
        }
        // Also check if chrome is on PATH
        try {
            Process p = Runtime.getRuntime().exec(new String[]{"where", "chrome"});
            return p.waitFor() == 0;
        } catch (Exception e) {
            return false;
        }
    }
}
