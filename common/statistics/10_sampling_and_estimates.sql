-- =====================================================
-- STATISTICS SCENARIO 10: SAMPLING AND ESTIMATES
-- Problem: Estimate overall behavior from a sample of transactions.
-- Solution: Compute sample-based averages and compare against the full sample.
-- Why this fits: Sample-based estimation is common when full population scans are too expensive.
-- =====================================================

SELECT
    AVG(amount) AS sample_mean,
    COUNT(*) AS sample_size
FROM (
    SELECT amount
    FROM analytics.fact_sales
    ORDER BY sale_id
    LIMIT 1000
) sample_data;
