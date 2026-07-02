-- =====================================================
-- STATISTICS SCENARIO 01: MEAN, MEDIAN, MODE-LIKE SUMMARY
-- Problem: Summarize the central tendency of a numeric metric.
-- Solution: Compute average and median values for quick reference.
-- Why this fits: Mean and median are foundational for descriptive analytics and KPI reporting.
-- =====================================================

SELECT
    region,
    AVG(amount) AS mean_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) AS median_amount
FROM analytics.fact_sales
GROUP BY region;
