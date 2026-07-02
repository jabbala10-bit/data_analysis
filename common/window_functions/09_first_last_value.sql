-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 09: FIRST_VALUE AND LAST_VALUE
-- Problem: Compare each row to the earliest or latest value in a group.
-- Solution: Use FIRST_VALUE and LAST_VALUE to anchor calculations.
-- Why this fits: These patterns are commonly used in trend and lifecycle analyses.
-- =====================================================

SELECT
    customer_id,
    sale_date,
    amount,
    FIRST_VALUE(amount) OVER (PARTITION BY customer_id ORDER BY sale_date) AS first_purchase_amount,
    LAST_VALUE(amount) OVER (PARTITION BY customer_id ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_purchase_amount
FROM analytics.fact_sales
ORDER BY customer_id, sale_date;
