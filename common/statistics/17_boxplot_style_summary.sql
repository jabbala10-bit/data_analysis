-- =====================================================
-- STATISTICS SCENARIO 17: BOXPLOT-STYLE SUMMARY
-- Problem: Provide a compact summary of the distribution.
-- Solution: Calculate quartiles and the interquartile range.
-- Why this fits: Boxplot-style summaries are excellent for rapid exploratory analysis.
-- =====================================================

SELECT
    region,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) AS q1,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY amount) AS median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) AS q3,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) AS iqr
FROM analytics.fact_sales
GROUP BY region;
