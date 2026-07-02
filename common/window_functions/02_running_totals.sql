-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 02: RUNNING TOTALS
-- Problem: Finance needs cumulative revenue over time.
-- Solution: Compute a running sum over ordered dates.
-- Why this fits: Running totals are essential in dashboards and financial reporting.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    SUM(SUM(amount)) OVER (ORDER BY sale_date) AS running_total
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
