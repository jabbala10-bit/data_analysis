-- =====================================================
-- STATISTICS SCENARIO 13: MOVING STANDARD DEVIATION
-- Problem: Track short-term volatility over time.
-- Solution: Apply a rolling standard deviation over daily sales.
-- Why this fits: Volatility monitoring is essential for finance and operations dashboards.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    STDDEV_SAMP(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_stddev
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
