-- =====================================================
-- STATISTICS SCENARIO 18: RANKED PERCENTAGE POINTS
-- Problem: Show how far a value is above a reference percentile.
-- Solution: Compare each row to a percentile benchmark.
-- Why this fits: Percentile benchmarks are common in scorecards and KPI thresholds.
-- =====================================================

WITH pct AS (
    SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY amount) AS p90
    FROM analytics.fact_sales
)
SELECT
    fs.sale_id,
    fs.amount,
    p.p90,
    ROUND(100.0 * (fs.amount - p.p90) / NULLIF(p.p90, 0), 2) AS pct_above_p90
FROM analytics.fact_sales fs
CROSS JOIN pct p
ORDER BY pct_above_p90 DESC;
