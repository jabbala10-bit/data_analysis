-- =====================================================
-- STATISTICS SCENARIO 16: DISTRIBUTION BANDING
-- Problem: Classify values into low, medium, and high bands.
-- Solution: Bucket values using quartile thresholds.
-- Why this fits: Banding is widely used in segmentation, reporting, and prioritization.
-- =====================================================

WITH quartiles AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) AS q1,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY amount) AS q2,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) AS q3
    FROM analytics.fact_sales
)
SELECT
    fs.sale_id,
    fs.amount,
    CASE
        WHEN fs.amount <= q.q1 THEN 'Low'
        WHEN fs.amount <= q.q2 THEN 'Medium-Low'
        WHEN fs.amount <= q.q3 THEN 'Medium-High'
        ELSE 'High'
    END AS distribution_band
FROM analytics.fact_sales fs
CROSS JOIN quartiles q
ORDER BY fs.amount DESC;
