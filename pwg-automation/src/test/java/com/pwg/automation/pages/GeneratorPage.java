package com.pwg.automation.pages;

import org.openqa.selenium.By;

public class GeneratorPage extends BasePage {

    // ── Tabs ────────────────────────────────────────────────────
    private static final By TAB_GENERATOR  = By.cssSelector("button.tab[data-tab='generator']");
    private static final By TAB_BULK       = By.cssSelector("button.tab[data-tab='bulk']");
    private static final By TAB_PASSPHRASE = By.cssSelector("button.tab[data-tab='passphrase']");
    private static final By TAB_HISTORY    = By.cssSelector("button.tab[data-tab='history']");

    // ── Length slider ───────────────────────────────────────────
    private static final By LENGTH_SLIDER  = By.id("length-slider");
    private static final By LENGTH_DISPLAY = By.id("length-display");
    private static final By SHORT_WARNING  = By.id("short-warning");

    // ── Character set toggles ───────────────────────────────────
    private static final By CHK_UPPERCASE = By.id("inc-uppercase");
    private static final By CHK_LOWERCASE = By.id("inc-lowercase");
    private static final By CHK_NUMBERS   = By.id("inc-numbers");
    private static final By CHK_SYMBOLS   = By.id("inc-symbols");

    // ── Options ─────────────────────────────────────────────────
    private static final By CHK_EXCL_AMBIGUOUS = By.id("excl-ambiguous");
    private static final By CHK_REQ_EACH       = By.id("req-each");

    // ── Strength / Entropy ──────────────────────────────────────
    private static final By STRENGTH_FILL  = By.id("strength-fill");
    private static final By STRENGTH_LABEL = By.id("strength-label");
    private static final By ENTROPY_LABEL  = By.id("entropy-label");

    // ── Password output ─────────────────────────────────────────
    private static final By OUTPUT_BOX    = By.id("output-box");
    private static final By PASSWORD_TEXT = By.id("password-text");
    private static final By SHOW_HIDE_BTN = By.id("show-hide-btn");

    // ── Action buttons ──────────────────────────────────────────
    private static final By GENERATE_BTN  = By.id("generate-btn");
    private static final By COPY_BTN      = By.id("copy-btn");
    private static final By REGEN_BTN     = By.id("regen-btn");

    // ── Toast ───────────────────────────────────────────────────
    private static final By TOAST = By.id("toast");

    // ── Preset buttons ──────────────────────────────────────────
    private static final By PRESET_SOCIAL       = By.cssSelector("button.preset-btn[data-preset='social']");
    private static final By PRESET_BANKING      = By.cssSelector("button.preset-btn[data-preset='banking']");
    private static final By PRESET_WORK         = By.cssSelector("button.preset-btn[data-preset='work']");
    private static final By PRESET_SUPER_SECURE = By.cssSelector("button.preset-btn[data-preset='superSecure']");

    // ── Tab navigation ───────────────────────────────────────────
    public void clickTab(String tabName) {
        switch (tabName.toLowerCase()) {
            case "generator":  click(TAB_GENERATOR);  break;
            case "bulk":       click(TAB_BULK);        break;
            case "passphrase": click(TAB_PASSPHRASE);  break;
            case "history":    click(TAB_HISTORY);     break;
            default: throw new IllegalArgumentException("Unknown tab: " + tabName);
        }
    }

    // ── Length ───────────────────────────────────────────────────
    public void setLength(int value) {
        setSliderValue(LENGTH_SLIDER, value);
    }

    public int getLengthSliderValue() {
        return Integer.parseInt(getAttribute(LENGTH_SLIDER, "value"));
    }

    public String getLengthBadgeText() {
        return getText(LENGTH_DISPLAY);
    }

    public boolean isShortWarningVisible() {
        return isDisplayed(SHORT_WARNING) &&
               driver.findElement(SHORT_WARNING).getCssValue("display") != "none";
    }

    // ── Character set toggles ────────────────────────────────────
    public void setUppercase(boolean on)          { setCheckbox(CHK_UPPERCASE, on); }
    public void setLowercase(boolean on)          { setCheckbox(CHK_LOWERCASE, on); }
    public void setNumbers(boolean on)            { setCheckbox(CHK_NUMBERS, on); }
    public void setSymbols(boolean on)            { setCheckbox(CHK_SYMBOLS, on); }
    public void setExcludeAmbiguous(boolean on)   { setCheckbox(CHK_EXCL_AMBIGUOUS, on); }
    public void setRequireEach(boolean on)        { setCheckbox(CHK_REQ_EACH, on); }

    public boolean isUppercaseChecked()         { return isChecked(CHK_UPPERCASE); }
    public boolean isLowercaseChecked()         { return isChecked(CHK_LOWERCASE); }
    public boolean isNumbersChecked()           { return isChecked(CHK_NUMBERS); }
    public boolean isSymbolsChecked()           { return isChecked(CHK_SYMBOLS); }
    public boolean isExcludeAmbiguousChecked()  { return isChecked(CHK_EXCL_AMBIGUOUS); }
    public boolean isRequireEachChecked()       { return isChecked(CHK_REQ_EACH); }

    // ── Actions ──────────────────────────────────────────────────
    public void clickGenerate()   { click(GENERATE_BTN); }
    public void clickCopy()       { click(COPY_BTN); }
    public void clickRegenerate() { click(REGEN_BTN); }
    public void clickShowHide()   { click(SHOW_HIDE_BTN); }

    // ── Output ───────────────────────────────────────────────────
    public String getPasswordText()  { return getText(PASSWORD_TEXT); }
    public boolean isOutputBoxVisible() { return isDisplayed(OUTPUT_BOX); }
    public boolean isPasswordTextEmpty() {
        String txt = getPasswordText();
        return txt == null || txt.isBlank() || txt.equals("Click Generate to begin");
    }

    // ── Strength / Entropy ───────────────────────────────────────
    public String getStrengthLabel()  { return getText(STRENGTH_LABEL); }
    public String getEntropyLabel()   { return getText(ENTROPY_LABEL); }
    public String getStrengthFillStyle() { return getAttribute(STRENGTH_FILL, "style"); }

    // ── Toast ────────────────────────────────────────────────────
    public String getToastText() { return getText(TOAST); }

    // ── Presets ──────────────────────────────────────────────────
    public void clickPreset(String presetName) {
        switch (presetName.toLowerCase()) {
            case "social":       click(PRESET_SOCIAL);       break;
            case "banking":      click(PRESET_BANKING);      break;
            case "work":         click(PRESET_WORK);         break;
            case "super secure": click(PRESET_SUPER_SECURE); break;
            default: throw new IllegalArgumentException("Unknown preset: " + presetName);
        }
    }

    // ── Convenience helpers ───────────────────────────────────────
    public void applyDefaultSettings() {
        setLength(16);
        setUppercase(true);
        setLowercase(true);
        setNumbers(true);
        setSymbols(false);
        setExcludeAmbiguous(false);
        setRequireEach(true);
    }

    public void setAllCharacterSetsOn() {
        setUppercase(true);
        setLowercase(true);
        setNumbers(true);
        setSymbols(true);
    }
}
