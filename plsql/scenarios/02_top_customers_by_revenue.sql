-- Purpose: Identify the highest-value customers.
-- Use: Rank customers by revenue contribution.
-- Scenario 2: Top customers by revenue
SELECT customer_id, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY customer_id
ORDER BY revenue DESC;
