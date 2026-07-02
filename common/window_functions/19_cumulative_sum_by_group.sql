-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 19: CUMULATIVE SUM BY GROUP
-- Problem: Show cumulative sales within each region.
-- Solution: Use a partitioned running total by region.
-- Why this fits: Grouped cumulative metrics are frequently used in regional performance dashboards.
-- =====================================================

SELECT
    region,
    sale_date,
    SUM(amount) AS daily_sales,
    SUM(SUM(amount)) OVER (PARTITION BY region ORDER BY sale_date) AS cumulative_sales_by_region
FROM analytics.fact_sales
GROUP BY region, sale_date
ORDER BY region, sale_date;
