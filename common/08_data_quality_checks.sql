-- =====================================================
-- COMMON SQL: DATA QUALITY CHECKS
-- Purpose: Detect missing values, duplicates, and inconsistent records
-- =====================================================

SELECT
    'fact_sales' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS null_customer_ids,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS null_amounts,
    COUNT(DISTINCT sale_id) AS distinct_sale_ids
FROM analytics.fact_sales;

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM analytics.fact_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;
