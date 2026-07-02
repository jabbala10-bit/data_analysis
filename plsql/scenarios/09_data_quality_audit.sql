-- Purpose: Run a simple data quality audit.
-- Use: Check row counts and missing values in critical fields.
-- Scenario 9: Data quality audit
SELECT
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN customer_name IS NULL THEN 1 END) AS missing_names,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS missing_emails
FROM customer_master;
