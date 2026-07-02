-- =====================================================
-- DATASET PROCESSING: CONSOLIDATE MONTHLY FILES
-- Problem: Create one reporting dataset from monthly extracts.
-- Solution: Union monthly datasets and aggregate by month.
-- Why this fits: Analysts often need a unified view across time-based files.
-- =====================================================

SELECT
    source_month,
    COUNT(*) AS row_count,
    SUM(amount) AS monthly_revenue
FROM (
    SELECT '2024-01' AS source_month, sale_id, customer_id, amount FROM analytics.fact_sales
    UNION ALL
    SELECT '2024-02' AS source_month, sale_id, customer_id, amount FROM analytics.fact_sales
) combined_data
GROUP BY source_month
ORDER BY source_month;
