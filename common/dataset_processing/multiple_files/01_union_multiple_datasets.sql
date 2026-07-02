-- =====================================================
-- DATASET PROCESSING: UNION MULTIPLE DATASETS
-- Problem: Combine several similar datasets into one analytic view.
-- Solution: Stack data from multiple sources using UNION ALL.
-- Why this fits: This is common when monthly or regional files must be analyzed together.
-- =====================================================

SELECT '2024-01' AS source_month, sale_id, customer_id, amount FROM analytics.fact_sales
UNION ALL
SELECT '2024-02' AS source_month, sale_id, customer_id, amount FROM analytics.fact_sales;
