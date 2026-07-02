-- Purpose: Summarize daily sales for reporting and trend review.
-- Use: Build a daily revenue view from transactional data.
-- Scenario 1: Daily sales summary
SELECT
    TRUNC(order_date) AS order_day,
    SUM(order_amount) AS total_sales
FROM sales_orders
GROUP BY TRUNC(order_date)
ORDER BY order_day;
