-- Purpose: Cover additional analyst tasks like inventory, refunds, and payments.
-- Use: Practice operational and finance-oriented reporting.
-- Scenarios 11-20: additional analytics cases

-- 11. Inventory aging summary
SELECT
    product_id,
    SUM(CASE WHEN days_in_stock > 30 THEN 1 ELSE 0 END) AS aged_stock_count
FROM inventory_items
GROUP BY product_id;

-- 12. Refund rate by category
SELECT
    category,
    SUM(CASE WHEN refund_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS refund_rate_pct
FROM sales_orders
GROUP BY category;

-- 13. Customer purchase frequency
SELECT
    customer_id,
    COUNT(*) AS purchase_count
FROM sales_orders
GROUP BY customer_id
ORDER BY purchase_count DESC;

-- 14. Low-stock alerts
SELECT product_id, stock_quantity
FROM inventory_items
WHERE stock_quantity < 10;

-- 15. Payment failure trend
SELECT
    TRUNC(order_date) AS order_day,
    COUNT(*) AS failed_payments
FROM payment_transactions
WHERE status = 'FAILED'
GROUP BY TRUNC(order_date)
ORDER BY order_day;

-- 16. Average order value by channel
SELECT channel, AVG(order_amount) AS avg_order_value
FROM sales_orders
GROUP BY channel;

-- 17. Sales growth month over month
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month_key,
    SUM(order_amount) AS monthly_sales
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month_key;

-- 18. Employee performance summary
SELECT employee_id, SUM(order_amount) AS sales_generated
FROM sales_orders
GROUP BY employee_id
ORDER BY sales_generated DESC;

-- 19. Duplicate invoice detection
SELECT invoice_id, COUNT(*) AS duplicate_count
FROM invoices
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- 20. Customer segmentation by spend tier
SELECT
    customer_id,
    CASE
        WHEN SUM(order_amount) >= 1000 THEN 'High'
        WHEN SUM(order_amount) >= 300 THEN 'Medium'
        ELSE 'Low'
    END AS spend_tier
FROM sales_orders
GROUP BY customer_id;
