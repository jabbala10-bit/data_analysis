-- =====================================================
-- INTERMEDIATE SCENARIO: REPEAT PURCHASE FREQUENCY
-- Problem: Growth teams need to understand how often customers come back and at what pace.
-- Solution: Measure purchase frequency by customer and identify repeat buyers versus one-time buyers.
-- Why this fits: Repeat purchase behavior is a key driver of retention and lifetime value.
-- =====================================================

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    MIN(order_date) AS first_purchase_date,
    MAX(order_date) AS last_purchase_date,
    CASE
        WHEN COUNT(*) = 1 THEN 'One-Time'
        WHEN COUNT(*) BETWEEN 2 AND 3 THEN 'Occasional'
        ELSE 'Frequent'
    END AS purchase_frequency_band
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;
