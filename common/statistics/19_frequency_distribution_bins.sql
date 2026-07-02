-- =====================================================
-- STATISTICS SCENARIO 19: FREQUENCY DISTRIBUTION BINS
-- Problem: Count how many values fall into each amount band.
-- Solution: Use CASE to create bins and count frequencies.
-- Why this fits: Frequency bins are useful for histogram-style analysis and capacity planning.
-- =====================================================

SELECT
    CASE
        WHEN amount < 100 THEN '0-99'
        WHEN amount < 500 THEN '100-499'
        WHEN amount < 1000 THEN '500-999'
        ELSE '1000+' 
    END AS amount_bin,
    COUNT(*) AS frequency
FROM analytics.fact_sales
GROUP BY 1
ORDER BY 1;
