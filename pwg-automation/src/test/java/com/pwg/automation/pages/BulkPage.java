package com.pwg.automation.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;

import java.util.List;

public class BulkPage extends BasePage {

    private static final By BULK_COUNT_SLIDER  = By.id("bulk-count");
    private static final By BULK_COUNT_DISPLAY = By.id("bulk-count-display");
    private static final By BULK_GENERATE_BTN  = By.id("bulk-generate-btn");
    private static final By BULK_EXPORT_BTN    = By.id("bulk-export-btn");
    private static final By BULK_CLEAR_BTN     = By.id("bulk-clear-btn");
    private static final By BULK_LIST          = By.id("bulk-list");
    private static final By BULK_ITEM_TEXTS    = By.cssSelector("#bulk-list .bulk-item-text");

    public void setBulkCount(int count) {
        setSliderValue(BULK_COUNT_SLIDER, count);
    }

    public String getBulkCountDisplayText() {
        return getText(BULK_COUNT_DISPLAY);
    }

    public void clickBulkGenerate() { click(BULK_GENERATE_BTN); }
    public void clickBulkExport()   { click(BULK_EXPORT_BTN); }
    public void clickBulkClear()    { click(BULK_CLEAR_BTN); }

    public boolean isBulkListVisible() { return isDisplayed(BULK_LIST); }

    public List<WebElement> getBulkItemTextElements() {
        return driver.findElements(BULK_ITEM_TEXTS);
    }

    public int getBulkPasswordCount() {
        return getBulkItemTextElements().size();
    }

    public boolean isBulkListEmpty() {
        return getBulkPasswordCount() == 0;
    }

    public List<String> getBulkPasswordTexts() {
        return getBulkItemTextElements().stream()
                .map(WebElement::getText)
                .collect(java.util.stream.Collectors.toList());
    }
}
