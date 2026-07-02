-- Purpose: Review retention behavior over time.
-- Use: Measure how often customers return each month.
-- Scenario 6: Monthly retention
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month_key,
    COUNT(DISTINCT customer_id) AS retained_customers
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month_key;
