-- =====================================================
-- STATISTICS SCENARIO 03: PERCENTILES AND QUARTILES
-- Problem: Segment values into distribution bands.
-- Solution: Calculate quartiles and percentile thresholds.
-- Why this fits: Quartiles are a common way to profile high, medium, and low-value customers.
-- =====================================================

SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) AS q1_amount,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY amount) AS median_amount,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) AS q3_amount,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY amount) AS p95_amount
FROM analytics.fact_sales;
