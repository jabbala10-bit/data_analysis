-- =====================================================
-- BASIC SCENARIO: TOP CUSTOMERS BY MONTH
-- Problem: Finance and account teams need to identify the customers driving the most revenue each month.
-- Solution: Aggregate monthly revenue and order volume per customer and rank them.
-- Why this fits: This is a common executive reporting pattern and a simple way to spot growth, concentration, and churn risk.
-- =====================================================

SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    customer_id,
    COUNT(*) AS order_count,
    SUM(order_total) AS monthly_revenue,
    AVG(order_total) AS avg_order_value
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', order_date), customer_id
ORDER BY month DESC, monthly_revenue DESC;
