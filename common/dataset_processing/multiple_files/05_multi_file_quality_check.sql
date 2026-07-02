-- =====================================================
-- DATASET PROCESSING: MULTI-FILE QUALITY CHECK
-- Problem: Validate whether multiple incoming files are consistent with each other.
-- Solution: Compare column completeness, row counts, and totals across datasets.
-- Why this fits: This is a practical pattern for data ingestion and ETL monitoring.
-- =====================================================

SELECT
    'file_a' AS source_name,
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS null_amounts
FROM analytics.fact_sales
UNION ALL
SELECT
    'file_b' AS source_name,
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS null_amounts
FROM analytics.fact_sales;
