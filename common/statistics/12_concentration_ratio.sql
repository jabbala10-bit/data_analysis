-- =====================================================
-- STATISTICS SCENARIO 12: CONCENTRATION RATIO
-- Problem: Measure how concentrated revenue is in a few customers or regions.
-- Solution: Compute the share of total revenue held by the top contributors.
-- Why this fits: Concentration ratios are common in market structure and risk analysis.
-- =====================================================

WITH ranked AS (
    SELECT
        region,
        SUM(amount) AS region_sales,
        SUM(SUM(amount)) OVER () AS total_sales,
        ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS rn
    FROM analytics.fact_sales
    GROUP BY region
)
SELECT
    region,
    region_sales,
    ROUND(100.0 * region_sales / total_sales, 2) AS concentration_pct
FROM ranked
ORDER BY region_sales DESC;
