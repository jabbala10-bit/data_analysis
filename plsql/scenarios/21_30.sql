-- Purpose: Add more practical business scenarios around customers and fulfillment.
-- Use: Reinforce grouping, filtering, and basic reconciliation logic.
-- Scenarios 21-30: more practical business scenarios

-- 21. High-value customer identification
SELECT customer_id, SUM(order_amount) AS lifetime_value
FROM sales_orders
GROUP BY customer_id
HAVING SUM(order_amount) > 5000;

-- 22. Return rate by warehouse
SELECT warehouse_id, SUM(CASE WHEN return_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS return_rate_pct
FROM inventory_movements
GROUP BY warehouse_id;

-- 23. Repeat purchase window
SELECT customer_id, COUNT(*) AS repeat_purchases
FROM sales_orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 24. Orders without shipment details
SELECT *
FROM sales_orders
WHERE shipment_id IS NULL;

-- 25. Revenue contribution by product
SELECT product_id, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY product_id
ORDER BY revenue DESC;

-- 26. New customer acquisition count
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month_key, COUNT(DISTINCT customer_id) AS new_customers
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM');

-- 27. Late delivery count
SELECT COUNT(*) AS late_deliveries
FROM supply_chain_events
WHERE delivery_date > promised_date;

-- 28. Bin packing or shipment size summary
SELECT shipment_id, SUM(order_amount) AS shipment_value
FROM sales_orders
GROUP BY shipment_id;

-- 29. Account balance review
SELECT customer_id, SUM(amount) AS balance
FROM payment_transactions
GROUP BY customer_id
ORDER BY balance DESC;

-- 30. Reconciliation mismatch check
SELECT invoice_id
FROM invoices
WHERE balance_amount <> 0;
