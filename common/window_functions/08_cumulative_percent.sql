-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 08: CUMULATIVE PERCENTAGE
-- Problem: Show cumulative share of revenue over time.
-- Solution: Combine running total with overall total in a window.
-- Why this fits: Cumulative percentages are useful in Pareto and profitability analysis.
-- =====================================================

SELECT
    region,
    SUM(amount) AS region_sales,
    SUM(SUM(amount)) OVER (ORDER BY region) AS cumulative_sales,
    ROUND(100.0 * SUM(SUM(amount)) OVER (ORDER BY region) / SUM(SUM(amount)) OVER (), 2) AS cumulative_pct
FROM analytics.fact_sales
GROUP BY region;
