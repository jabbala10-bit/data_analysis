-- Purpose: Summarize exceptions from an audit or error log.
-- Use: Prioritize the most frequent issues.
-- Scenario 10: Exception log summary
SELECT error_code, COUNT(*) AS error_count
FROM audit_log
GROUP BY error_code
ORDER BY error_count DESC;
