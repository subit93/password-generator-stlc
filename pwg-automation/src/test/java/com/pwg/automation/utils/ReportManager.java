package com.pwg.automation.utils;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;

/**
 * Initialises and provides the shared ExtentReports instance.
 */
public class ReportManager {

    private static ExtentReports extentReports;

    private ReportManager() {}

    public static ExtentReports getInstance() {
        if (extentReports == null) {
            String reportPath = System.getProperty("user.dir") + "/target/extent-reports/PWGTestReport.html";
            ExtentSparkReporter sparkReporter = new ExtentSparkReporter(reportPath);
            sparkReporter.config().setReportName("PWG Password Generator — Automation Report");
            sparkReporter.config().setDocumentTitle("PWG Test Execution Report");
            extentReports = new ExtentReports();
            extentReports.attachReporter(sparkReporter);
            extentReports.setSystemInfo("Application", "PWG Password Generator");
            extentReports.setSystemInfo("Environment", "Local");
            extentReports.setSystemInfo("Browser", System.getProperty("browser", "chrome"));
        }
        return extentReports;
    }

    public static void flushReports() {
        if (extentReports != null) {
            extentReports.flush();
        }
    }
}
