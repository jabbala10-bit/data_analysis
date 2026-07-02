-- Purpose: Analyze product category contribution.
-- Use: Review which categories drive the most revenue.
-- Scenario 7: Product category mix
SELECT category, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY category
ORDER BY revenue DESC;
