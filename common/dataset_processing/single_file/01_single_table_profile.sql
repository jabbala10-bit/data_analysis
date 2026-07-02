-- =====================================================
-- DATASET PROCESSING: SINGLE FILE / SINGLE TABLE PROFILE
-- Problem: Profile one dataset to understand shape, quality, and distribution.
-- Solution: Summarize row counts, nulls, uniqueness, and spread for a single table.
-- Why this fits: This is the first step in most analytics and data quality workflows.
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS null_amounts,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    AVG(amount) AS avg_amount
FROM analytics.fact_sales;
