-- =====================================================
-- BASIC SCENARIO: CUSTOMER HEALTH SNAPSHOT
-- Purpose: Track active, at-risk, and churned customers
-- =====================================================

SELECT
    customer_id,
    customer_name,
    MAX(order_date) AS last_order_date,
    COUNT(*) AS total_orders,
    SUM(order_total) AS lifetime_value,
    CASE
        WHEN MAX(order_date) >= CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
        WHEN MAX(order_date) >= CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
        ELSE 'Churned'
    END AS customer_status
FROM orders
GROUP BY customer_id, customer_name
ORDER BY lifetime_value DESC;
