-- =====================================================
-- STATISTICS SCENARIO 09: BIVARIATE DISTRIBUTION SUMMARY
-- Problem: Compare two numeric measures from the same record.
-- Solution: Summarize pairwise distributions with averages and spread.
-- Why this fits: This is useful in analytics where two metrics should move together or diverge.
-- =====================================================

SELECT
    region,
    AVG(amount) AS avg_amount,
    AVG(amount * 1.1) AS avg_adjusted_amount,
    STDDEV(amount) AS stddev_amount,
    STDDEV(amount * 1.1) AS stddev_adjusted_amount
FROM analytics.fact_sales
GROUP BY region;
