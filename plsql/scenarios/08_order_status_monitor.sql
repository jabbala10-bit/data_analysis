-- Purpose: Track order status distribution.
-- Use: Monitor operational bottlenecks and fulfillment health.
-- Scenario 8: Order status monitor
SELECT status, COUNT(*) AS order_count
FROM sales_orders
GROUP BY status
ORDER BY order_count DESC;
