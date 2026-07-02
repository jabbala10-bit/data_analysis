-- =====================================================
-- BASIC SCENARIO: SALES BY CHANNEL
-- Problem: Marketing wants to compare the performance of online, retail, and partner channels.
-- Solution: Aggregate revenue and order count by channel for a reporting period.
-- Why this fits: Channel performance reporting is one of the most common weekly business reviews for commercial teams.
-- =====================================================

SELECT
    channel,
    COUNT(*) AS order_count,
    SUM(order_total) AS revenue,
    AVG(order_total) AS avg_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY channel
ORDER BY revenue DESC;
