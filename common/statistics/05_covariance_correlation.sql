-- =====================================================
-- STATISTICS SCENARIO 05: COVARIANCE AND CORRELATION
-- Problem: Measure whether two numeric series move together.
-- Solution: Compute covariance and correlation-like patterns between two metrics.
-- Why this fits: Correlation supports feature analysis, forecasting, and business dependency checks.
-- =====================================================

SELECT
    AVG(x) AS mean_x,
    AVG(y) AS mean_y,
    AVG((x - AVG(x)) * (y - AVG(y))) OVER () AS covariance,
    STDDEV(x) AS stddev_x,
    STDDEV(y) AS stddev_y
FROM (
    SELECT
        amount AS x,
        amount * 0.9 AS y
    FROM analytics.fact_sales
) s;
