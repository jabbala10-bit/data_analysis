-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 04: LAG AND LEAD FOR GROWTH
-- Problem: Compare current values to previous and next periods.
-- Solution: Use LAG and LEAD to calculate period-over-period changes.
-- Why this fits: Growth analysis is a core business reporting pattern.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    LAG(SUM(amount)) OVER (ORDER BY sale_date) AS prev_day_sales,
    LEAD(SUM(amount)) OVER (ORDER BY sale_date) AS next_day_sales
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
