-- Purpose: Detect duplicate customer records.
-- Use: Find repeated names or identities that need deduplication.
-- Scenario 3: Duplicate customer detection
SELECT customer_name, COUNT(*) AS duplicate_count
FROM customer_master
GROUP BY customer_name
HAVING COUNT(*) > 1;
