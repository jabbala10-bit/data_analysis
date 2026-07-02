-- Case Study 5: Fraud detection pipeline
-- Step 1: Flag suspicious transactions
SELECT customer_id, COUNT(*) AS tx_count, SUM(amount) AS tx_amount
FROM payment_transactions
GROUP BY customer_id
HAVING COUNT(*) > 5 OR SUM(amount) > 10000;
