package com.pwg.automation.pages;

import org.openqa.selenium.By;

public class PassphrasePage extends BasePage {

    private static final By PHRASE_COUNT_SLIDER  = By.id("phrase-count");
    private static final By PHRASE_COUNT_DISPLAY = By.id("phrase-count-display");
    private static final By PHRASE_OUTPUT_BOX    = By.id("phrase-output-box");
    private static final By PHRASE_TEXT          = By.id("phrase-text");
    private static final By PHRASE_GENERATE_BTN  = By.id("phrase-generate-btn");
    private static final By PHRASE_COPY_BTN      = By.id("phrase-copy-btn");

    public void setPhraseCount(int count) {
        setSliderValue(PHRASE_COUNT_SLIDER, count);
    }

    public String getPhraseCountDisplayText() {
        return getText(PHRASE_COUNT_DISPLAY);
    }

    public void clickGeneratePhrase() { click(PHRASE_GENERATE_BTN); }
    public void clickCopyPhrase()     { click(PHRASE_COPY_BTN); }

    public String getPhraseText() {
        return getText(PHRASE_TEXT);
    }

    public boolean isPhraseOutputVisible() {
        return isDisplayed(PHRASE_OUTPUT_BOX);
    }

    public boolean isPhraseTextEmpty() {
        String text = getPhraseText();
        return text == null || text.isBlank() || text.equals("Click Generate to begin");
    }

    public int getWordCount() {
        String text = getPhraseText();
        if (text == null || text.isBlank()) return 0;
        return text.split("-").length;
    }
}
