-- =====================================================
-- STATISTICS SCENARIO 02: RANGE, VARIANCE, and STANDARD DEVIATION
-- Problem: Understand dispersion and volatility of sales values.
-- Solution: Calculate spread, variance, and standard deviation.
-- Why this fits: Variability measures are essential for detecting unstable or risky patterns.
-- =====================================================

SELECT
    region,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    MAX(amount) - MIN(amount) AS range_amount,
    VARIANCE(amount) AS variance_amount,
    STDDEV(amount) AS stddev_amount
FROM analytics.fact_sales
GROUP BY region;
