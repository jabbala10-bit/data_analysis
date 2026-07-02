-- =====================================================
-- INTERMEDIATE SCENARIO: CUSTOMER SEGMENTATION
-- Purpose: Segment customers by spending behavior and recency
-- =====================================================

WITH customer_spend AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(order_total) AS total_spent,
        MAX(order_date) AS last_purchase_date
    FROM orders
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_orders,
    total_spent,
    last_purchase_date,
    CASE
        WHEN total_spent >= 10000 THEN 'VIP'
        WHEN total_spent >= 5000 THEN 'Premium'
        WHEN total_spent >= 1000 THEN 'Regular'
        ELSE 'Low Value'
    END AS segment,
    CASE
        WHEN last_purchase_date >= CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
        WHEN last_purchase_date >= CURRENT_DATE - INTERVAL '90 days' THEN 'At Risk'
        ELSE 'Dormant'
    END AS activity_status
FROM customer_spend
ORDER BY total_spent DESC;
