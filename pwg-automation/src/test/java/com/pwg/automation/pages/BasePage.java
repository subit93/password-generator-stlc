package com.pwg.automation.pages;

import com.pwg.automation.utils.DriverManager;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class BasePage {

    protected WebDriver driver;
    protected WebDriverWait wait;

    public BasePage() {
        this.driver = DriverManager.getDriver();
        this.wait   = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    protected WebElement waitForVisible(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    protected void click(By locator) {
        waitForVisible(locator).click();
    }

    protected String getText(By locator) {
        return waitForVisible(locator).getText();
    }

    protected boolean isChecked(By locator) {
        return driver.findElement(locator).isSelected();
    }

    protected void setCheckbox(By locator, boolean checked) {
        WebElement el = driver.findElement(locator);
        if (el.isSelected() != checked) {
            el.click();
        }
    }

    protected void setSliderValue(By locator, int value) {
        WebElement slider = driver.findElement(locator);
        ((JavascriptExecutor) driver).executeScript(
            "arguments[0].value = arguments[1]; " +
            "arguments[0].dispatchEvent(new Event('input', { bubbles: true }));",
            slider, value);
    }

    protected String getAttribute(By locator, String attribute) {
        return driver.findElement(locator).getAttribute(attribute);
    }

    protected boolean isDisplayed(By locator) {
        try {
            return driver.findElement(locator).isDisplayed();
        } catch (NoSuchElementException e) {
            return false;
        }
    }

    protected Object executeScript(String script, Object... args) {
        return ((JavascriptExecutor) driver).executeScript(script, args);
    }
}
