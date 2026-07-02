-- =====================================================
-- DATASET PROCESSING: SINGLE FILE CLEANING
-- Problem: Clean a single dataset by filtering invalid records and standardizing values.
-- Solution: Remove nulls and normalize text values before analysis.
-- Why this fits: Cleaning is required before trustworthy reporting or model training.
-- =====================================================

SELECT
    sale_id,
    customer_id,
    UPPER(TRIM(COALESCE(region, 'UNKNOWN'))) AS region_clean,
    amount,
    status
FROM analytics.fact_sales
WHERE amount IS NOT NULL
  AND customer_id IS NOT NULL
ORDER BY sale_id;
