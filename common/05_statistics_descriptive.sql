-- =====================================================
-- COMMON SQL: STATISTICS AND DESCRIPTIVE ANALYSIS
-- Purpose: Summarize distributions, variation, and central tendency
-- =====================================================

SELECT
    region,
    COUNT(*) AS row_count,
    AVG(amount) AS avg_amount,
    MEDIAN(amount) AS median_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    STDDEV(amount) AS stddev_amount,
    VARIANCE(amount) AS variance_amount
FROM analytics.fact_sales
GROUP BY region
ORDER BY avg_amount DESC;
