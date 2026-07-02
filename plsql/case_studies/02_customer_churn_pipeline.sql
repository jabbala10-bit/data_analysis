-- Case Study 2: Customer churn pipeline
-- Step 1: Clean customer activity data
UPDATE customer_activity
SET last_login_date = NVL(last_login_date, SYSDATE - 365)
WHERE last_login_date IS NULL;

-- Step 2: Build churn summary
SELECT customer_id, last_login_date
FROM customer_activity
WHERE last_login_date < SYSDATE - 90;
