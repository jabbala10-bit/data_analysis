-- Purpose: Highlight missing values in key attributes.
-- Use: Audit completeness for critical fields such as email.
-- Scenario 4: Missing values check
SELECT COUNT(*) AS missing_emails
FROM customer_master
WHERE email IS NULL OR TRIM(email) IS NULL;
