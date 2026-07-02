-- Purpose: Compare regional revenue performance.
-- Use: Create a region-level sales summary.
-- Scenario 5: Revenue by region
SELECT region, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY region
ORDER BY revenue DESC;
