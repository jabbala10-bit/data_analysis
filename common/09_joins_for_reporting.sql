-- =====================================================
-- COMMON SQL: JOINS FOR REPORTING
-- Purpose: Combine transactional and dimension data for business reporting
-- =====================================================

SELECT
    fs.sale_id,
    dc.customer_name,
    dc.segment,
    fs.region,
    fs.sale_date,
    fs.amount,
    fs.channel
FROM analytics.fact_sales fs
LEFT JOIN analytics.dim_customer dc ON fs.customer_id = dc.customer_id
ORDER BY fs.sale_date DESC;
