package com.pwg.automation.utils;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.aventstack.extentreports.reporter.configuration.Theme;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;

/**
 * Initialises and provides the shared ExtentReports instance.
 *
 * Report storage strategy:
 *   pwg-automation/reports/run_DD-MM-YYYY_HH-MM/PWGTestReport.html
 *
 * Each run creates its own timestamped subfolder — no report ever
 * overwrites another. After writing the new report, any run folder
 * older than 2 days is automatically deleted.
 */
public class ReportManager {

    private static final DateTimeFormatter FOLDER_FMT =
            DateTimeFormatter.ofPattern("dd-MM-yyyy_HH-mm");

    private static final int RETENTION_DAYS = 2;

    private static ExtentReports extentReports;
    private static String currentReportDir;

    private ReportManager() {}

    public static ExtentReports getInstance() {
        if (extentReports == null) {
            // ── Build timestamped report path ──────────────────────────────
            String timestamp   = LocalDateTime.now().format(FOLDER_FMT);
            String projectRoot = System.getProperty("user.dir");     // pwg-automation/
            String reportsBase = projectRoot + File.separator + "reports";
            currentReportDir   = reportsBase + File.separator + "run_" + timestamp;
            String reportFile  = currentReportDir + File.separator + "PWGTestReport.html";

            new File(currentReportDir).mkdirs();

            // ── Configure ExtentSparkReporter ──────────────────────────────
            ExtentSparkReporter sparkReporter = new ExtentSparkReporter(reportFile);
            sparkReporter.config().setReportName("PWG Password Generator \u2014 Test Execution Report");
            sparkReporter.config().setDocumentTitle("PWG Automation Report");
            sparkReporter.config().setTheme(Theme.DARK);
            sparkReporter.config().setTimeStampFormat("dd MMM yyyy HH:mm:ss");
            sparkReporter.config().setEncoding("UTF-8");
            sparkReporter.config().enableOfflineMode(false);

            // ── Wire up ExtentReports ──────────────────────────────────────
            extentReports = new ExtentReports();
            extentReports.attachReporter(sparkReporter);
            extentReports.setSystemInfo("Application", "PWG Password Generator");
            extentReports.setSystemInfo("Environment", "Local");
            extentReports.setSystemInfo("Browser",
                    System.getProperty("browser", "edge-headless"));
            extentReports.setSystemInfo("Base URL",
                    System.getProperty("baseUrl", "http://localhost:3000"));
            extentReports.setSystemInfo("Run Timestamp", timestamp);
        }
        return extentReports;
    }

    /**
     * Flush the report to disk, then clean up run folders older than
     * {@value RETENTION_DAYS} days from the reports/ directory.
     */
    public static void flushReports() {
        if (extentReports != null) {
            extentReports.flush();
            System.out.println("[ReportManager] Report saved to: " + currentReportDir);
            cleanOldReports(currentReportDir);
        }
    }

    // ── Private helpers ────────────────────────────────────────────────────

    private static void cleanOldReports(String latestReportDir) {
        String projectRoot = System.getProperty("user.dir");
        File reportsBase   = new File(projectRoot + File.separator + "reports");

        if (!reportsBase.exists() || !reportsBase.isDirectory()) return;

        LocalDate cutoff = LocalDate.now().minusDays(RETENTION_DAYS);

        File[] runFolders = reportsBase.listFiles(
                f -> f.isDirectory() && f.getName().startsWith("run_"));

        if (runFolders == null) return;

        for (File folder : runFolders) {
            // Skip the report we just wrote
            if (folder.getAbsolutePath().equals(latestReportDir)) continue;

            LocalDate folderDate = parseFolderDate(folder.getName());
            if (folderDate != null && folderDate.isBefore(cutoff)) {
                try {
                    deleteDirectory(folder.toPath());
                    System.out.println("[ReportManager] Deleted old report: " + folder.getName());
                } catch (Exception e) {
                    System.err.println("[ReportManager] Could not delete: "
                            + folder.getName() + " — " + e.getMessage());
                }
            }
        }
    }

    private static LocalDate parseFolderDate(String folderName) {
        // Folder name format: run_DD-MM-YYYY_HH-mm
        try {
            String datePart = folderName.substring(4, 14); // "DD-MM-YYYY"
            return LocalDate.parse(datePart, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
        } catch (Exception e) {
            return null;
        }
    }

    private static void deleteDirectory(Path path) throws Exception {
        Files.walk(path)
             .sorted(Comparator.reverseOrder())
             .map(Path::toFile)
             .forEach(File::delete);
    }
}
