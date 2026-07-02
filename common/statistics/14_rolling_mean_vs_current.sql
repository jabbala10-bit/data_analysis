-- =====================================================
-- STATISTICS SCENARIO 14: ROLLING MEAN VS CURRENT
-- Problem: Compare each period to a short-term baseline.
-- Solution: Compute a rolling mean and compare it to the current value.
-- Why this fits: This is a common way to spot deviations from recent trend.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    AVG(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS rolling_mean,
    SUM(amount) - AVG(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS deviation_from_baseline
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
