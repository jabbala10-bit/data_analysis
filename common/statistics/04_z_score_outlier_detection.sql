-- =====================================================
-- STATISTICS SCENARIO 04: Z-SCORE OUTLIER DETECTION
-- Problem: Find unusually high or low transactions.
-- Solution: Compute z-scores using mean and standard deviation.
-- Why this fits: Z-scores are commonly used in anomaly detection and quality checks.
-- =====================================================

WITH stats AS (
    SELECT
        AVG(amount) AS avg_amount,
        STDDEV(amount) AS stddev_amount
    FROM analytics.fact_sales
)
SELECT
    sale_id,
    amount,
    avg_amount,
    stddev_amount,
    CASE
        WHEN stddev_amount = 0 THEN NULL
        ELSE (amount - avg_amount) / stddev_amount
    END AS z_score
FROM analytics.fact_sales, stats
WHERE stddev_amount > 0
ORDER BY ABS((amount - avg_amount) / stddev_amount) DESC;
