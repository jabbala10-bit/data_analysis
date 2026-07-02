-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 05: PERCENT OF TOTAL
-- Problem: Understand how much each region contributes to total revenue.
-- Solution: Divide each region's sales by the overall total using a window.
-- Why this fits: Share-of-total metrics are common in executive reporting and dashboards.
-- =====================================================

SELECT
    region,
    SUM(amount) AS region_sales,
    ROUND(100.0 * SUM(amount) / SUM(SUM(amount)) OVER (), 2) AS pct_of_total
FROM analytics.fact_sales
GROUP BY region;
