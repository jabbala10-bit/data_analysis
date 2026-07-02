-- =====================================================
-- DATASET PROCESSING: SINGLE FILE OUTLIER CHECK
-- Problem: Detect extreme values inside one dataset.
-- Solution: Compare each row to the dataset median and IQR-style range.
-- Why this fits: Outlier detection is critical for data quality and business anomaly review.
-- =====================================================

WITH stats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) AS q3
    FROM analytics.fact_sales
)
SELECT
    fs.sale_id,
    fs.amount,
    s.q1,
    s.q3,
    CASE
        WHEN fs.amount < s.q1 - 1.5 * (s.q3 - s.q1) THEN 'Possible Low Outlier'
        WHEN fs.amount > s.q3 + 1.5 * (s.q3 - s.q1) THEN 'Possible High Outlier'
        ELSE 'Normal'
    END AS outlier_flag
FROM analytics.fact_sales fs
CROSS JOIN stats s
ORDER BY fs.amount DESC;
