-- =====================================================
-- BASIC SCENARIO: DAILY SALES SUMMARY
-- Purpose: Daily reporting for operations and finance teams
-- =====================================================

SELECT
    CAST(order_date AS DATE) AS order_day,
    COUNT(*) AS order_count,
    SUM(order_total) AS gross_revenue,
    AVG(order_total) AS avg_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY CAST(order_date AS DATE)
ORDER BY order_day DESC;
