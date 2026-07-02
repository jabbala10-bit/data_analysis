-- =====================================================
-- ADVANCED SCENARIO: CUSTOMER LIFETIME VALUE
-- Problem: Leadership wants a scalable way to estimate customer value across acquisition channels.
-- Solution: Build a cohort-based CLV view by channel, using total revenue and active months.
-- Why this fits: CLV is a high-value business metric for marketing, finance, and executive planning.
-- =====================================================

WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.acquisition_channel,
        DATE_TRUNC('month', o.order_date) AS order_month,
        SUM(o.order_total) AS month_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '24 months'
    GROUP BY c.customer_id, c.acquisition_channel, DATE_TRUNC('month', o.order_date)
),
clv_cohorts AS (
    SELECT
        acquisition_channel,
        customer_id,
        MIN(order_month) AS cohort_month,
        SUM(month_revenue) AS total_revenue,
        COUNT(DISTINCT order_month) AS active_months
    FROM customer_orders
    GROUP BY acquisition_channel, customer_id
)
SELECT
    acquisition_channel,
    COUNT(*) AS customers,
    ROUND(AVG(total_revenue), 2) AS avg_clv,
    ROUND(AVG(active_months), 2) AS avg_active_months
FROM clv_cohorts
GROUP BY acquisition_channel
ORDER BY avg_clv DESC;
