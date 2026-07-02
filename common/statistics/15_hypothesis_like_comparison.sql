-- =====================================================
-- STATISTICS SCENARIO 15: HYPOTHESIS-LIKE COMPARISON
-- Problem: Compare two groups to see whether there is a meaningful difference.
-- Solution: Compute group averages and standard deviations for quick comparison.
-- Why this fits: This is a lightweight, business-friendly approximation of hypothesis testing.
-- =====================================================

SELECT
    region,
    AVG(amount) AS avg_amount,
    STDDEV(amount) AS stddev_amount,
    COUNT(*) AS sample_size
FROM analytics.fact_sales
WHERE region IN ('North', 'South')
GROUP BY region
ORDER BY region;
