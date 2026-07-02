-- =====================================================
-- DATASET PROCESSING: COMPARE DATASETS
-- Problem: Compare two related data extracts for drift or mismatch.
-- Solution: Compare counts and totals across datasets.
-- Why this fits: This is common in reconciliation and data validation scenarios.
-- =====================================================

SELECT
    'dataset_a' AS dataset_name,
    COUNT(*) AS row_count,
    SUM(amount) AS total_amount
FROM analytics.fact_sales
UNION ALL
SELECT
    'dataset_b' AS dataset_name,
    COUNT(*) AS row_count,
    SUM(amount) AS total_amount
FROM analytics.fact_sales;
