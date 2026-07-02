-- =====================================================
-- BASIC SCENARIO: PRODUCT PERFORMANCE BY REGION
-- Purpose: Find top-selling products and regional trends
-- =====================================================

SELECT
    p.product_name,
    c.region,
    COUNT(*) AS orders,
    SUM(o.order_total) AS revenue,
    AVG(o.order_total) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY p.product_name, c.region
ORDER BY revenue DESC;
