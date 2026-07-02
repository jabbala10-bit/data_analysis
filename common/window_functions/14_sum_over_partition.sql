-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 14: SUM OVER PARTITION
-- Problem: Calculate category totals while preserving row-level detail.
-- Solution: Use SUM over a partition to keep row-level and aggregate values together.
-- Why this fits: This is a common pattern in detailed reporting and drill-down dashboards.
-- =====================================================

SELECT
    region,
    customer_id,
    SUM(amount) AS customer_sales,
    SUM(SUM(amount)) OVER (PARTITION BY region) AS region_total_sales
FROM analytics.fact_sales
GROUP BY region, customer_id
ORDER BY region, customer_sales DESC;
