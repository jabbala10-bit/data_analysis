-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 03: MOVING AVERAGE
-- Problem: Analysts want smoother trend lines for revenue.
-- Solution: Use a rolling average over the last 3 periods.
-- Why this fits: Moving averages are a common way to reduce noise in time-series analysis.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    AVG(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3d
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
