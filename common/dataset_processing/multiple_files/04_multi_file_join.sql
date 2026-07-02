-- =====================================================
-- DATASET PROCESSING: MULTI-FILE JOIN
-- Problem: Combine multiple datasets that share a common key.
-- Solution: Join the consolidated datasets on customer or transaction keys.
-- Why this fits: Multi-file joins are common when facts and dimensions are delivered separately.
-- =====================================================

SELECT
    a.sale_id,
    a.customer_id,
    a.amount,
    b.customer_name,
    b.segment
FROM analytics.fact_sales a
LEFT JOIN analytics.dim_customer b ON a.customer_id = b.customer_id;
