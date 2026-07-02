-- =====================================================
-- INTERMEDIATE SCENARIO: DEMAND FORECAST SIGNAL
-- Problem: Operations wants a simple signal for rising or falling demand before stock decisions are made.
-- Solution: Compare the latest month to the prior month and compute a demand change percentage.
-- Why this fits: This is a lightweight forecasting pattern commonly used in planning and replenishment workflows.
-- =====================================================

WITH monthly_demand AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS month,
        SUM(order_total) AS revenue
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) / NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 2) AS momentum_pct
FROM monthly_demand
ORDER BY month DESC;
