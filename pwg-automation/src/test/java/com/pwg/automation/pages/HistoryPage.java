package com.pwg.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;

public class HistoryPage extends BasePage {

    private static final By HISTORY_LIST     = By.id("history-list");
    private static final By CLEAR_HISTORY    = By.id("clear-history-btn");
    private static final By HISTORY_ITEMS    = By.cssSelector("#history-list .history-item");
    private static final By HISTORY_TEXTS    = By.cssSelector("#history-list .history-text");
    private static final By EMPTY_MSG        = By.cssSelector("#history-list .empty-msg");

    public void clickClearHistory() { click(CLEAR_HISTORY); }

    public List<WebElement> getHistoryItems() {
        return driver.findElements(HISTORY_ITEMS);
    }

    public List<String> getHistoryPasswordTexts() {
        return driver.findElements(HISTORY_TEXTS).stream()
                .map(WebElement::getText)
                .collect(java.util.stream.Collectors.toList());
    }

    public int getHistoryItemCount() {
        return getHistoryItems().size();
    }

    public boolean isHistoryListEmpty() {
        return getHistoryItemCount() == 0 || isDisplayed(EMPTY_MSG);
    }

    public boolean isEmptyMsgVisible() {
        return isDisplayed(EMPTY_MSG);
    }

    public boolean isHistoryListVisible() {
        return isDisplayed(HISTORY_LIST);
    }

    public void clearLocalStorage() {
        executeScript("localStorage.clear();");
    }

    public Object getLocalStorageItem(String key) {
        return executeScript("return localStorage.getItem(arguments[0]);", key);
    }

    public boolean localStorageHasHistoryData() {
        Object result = executeScript(
            "return Object.keys(localStorage)" +
            ".filter(k => k.toLowerCase().includes('history') || k.toLowerCase().includes('password'))" +
            ".length > 0;");
        return Boolean.TRUE.equals(result);
    }
}
