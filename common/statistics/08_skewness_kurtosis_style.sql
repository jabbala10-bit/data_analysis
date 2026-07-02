-- =====================================================
-- STATISTICS SCENARIO 08: SKEWNESS AND KURTOSIS-STYLE VIEW
-- Problem: Understand whether the distribution is balanced or extreme.
-- Solution: Compare mean to median and measure spread concentration.
-- Why this fits: These checks help identify heavy tails and distribution shape.
-- =====================================================

SELECT
    region,
    AVG(amount) AS mean_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) AS median_amount,
    MAX(amount) - MIN(amount) AS range_amount,
    STDDEV(amount) AS stddev_amount
FROM analytics.fact_sales
GROUP BY region;
