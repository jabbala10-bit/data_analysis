-- Fraud detection analysis
SELECT
    customer_id,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount,
    MAX(amount) AS max_amount
FROM payment_transactions
GROUP BY customer_id
ORDER BY transaction_count DESC;
