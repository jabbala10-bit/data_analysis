-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 20: AVERAGE OVER PREVIOUS ROWS
-- Problem: Compare each day's sales to the recent average.
-- Solution: Use a rolling average over prior rows.
-- Why this fits: This is a classic KPI smoothing pattern for operational monitoring.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    AVG(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_avg
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
