package com.pwg.automation.utils;

import java.util.HashMap;
import java.util.Map;

/**
 * Thread-safe key-value store for sharing state between Cucumber step definition classes
 * within a single scenario. Cleared by Hooks.tearDown() after each scenario.
 */
public class ScenarioContext {

    private static final ThreadLocal<Map<String, Object>> CTX =
            ThreadLocal.withInitial(HashMap::new);

    private ScenarioContext() {}

    public static void set(String key, Object value) {
        CTX.get().put(key, value);
    }

    @SuppressWarnings("unchecked")
    public static <T> T get(String key) {
        return (T) CTX.get().get(key);
    }

    public static void clear() {
        CTX.remove();
    }
}
