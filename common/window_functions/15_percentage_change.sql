-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 15: PERCENTAGE CHANGE
-- Problem: Measure how much revenue changed versus the prior period.
-- Solution: Use LAG in a ratio calculation.
-- Why this fits: Percentage change is essential in trend and KPI reporting.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    ROUND(
        100.0 * (SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY sale_date)) / NULLIF(LAG(SUM(amount)) OVER (ORDER BY sale_date), 0),
        2
    ) AS pct_change
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
