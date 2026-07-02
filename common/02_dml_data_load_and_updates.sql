-- =====================================================
-- COMMON SQL: DML - INSERT, UPDATE, DELETE, UPSERT PATTERNS
-- Purpose: Standard data movement and maintenance operations
-- =====================================================

INSERT INTO analytics.fact_sales (
    sale_id, customer_id, product_id, region, sale_date, amount, channel, status
)
VALUES
    (1, 101, 1001, 'North', '2024-01-10', 250.00, 'Online', 'Completed'),
    (2, 102, 1002, 'South', '2024-01-11', 180.50, 'Retail', 'Completed');

UPDATE analytics.fact_sales
SET status = 'Completed'
WHERE sale_id = 1;

DELETE FROM analytics.fact_sales
WHERE sale_id = 999;

INSERT INTO analytics.dim_customer (customer_id, customer_name, segment, signup_date, region)
VALUES (101, 'Ava', 'Premium', '2023-01-05', 'North')
ON CONFLICT (customer_id) DO NOTHING;
