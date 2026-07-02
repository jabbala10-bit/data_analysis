-- =====================================================
-- STATISTICS SCENARIO 11: GROUPED DISTRIBUTION SUMMARY
-- Problem: Compare distributions across business groups.
-- Solution: Compute group-level means, medians, and spread.
-- Why this fits: This is useful for segmentation, performance benchmarking, and regional analysis.
-- =====================================================

SELECT
    region,
    COUNT(*) AS group_size,
    AVG(amount) AS mean_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) AS median_amount,
    STDDEV(amount) AS stddev_amount
FROM analytics.fact_sales
GROUP BY region
ORDER BY mean_amount DESC;
