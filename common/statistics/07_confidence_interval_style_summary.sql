-- =====================================================
-- STATISTICS SCENARIO 07: CONFIDENCE-INTERVAL STYLE SUMMARY
-- Problem: Provide a quick estimate of expected value and spread around it.
-- Solution: Compute mean, standard deviation, and a simple interval-style range.
-- Why this fits: This is a practical approximation for summary statistics in business reporting.
-- =====================================================

SELECT
    region,
    AVG(amount) AS avg_amount,
    STDDEV(amount) AS stddev_amount,
    AVG(amount) - 1.96 * STDDEV(amount) AS lower_estimate,
    AVG(amount) + 1.96 * STDDEV(amount) AS upper_estimate
FROM analytics.fact_sales
GROUP BY region;
