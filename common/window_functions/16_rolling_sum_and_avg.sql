-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 16: ROLLING SUM AND AVERAGE
-- Problem: Smooth short-term fluctuations in operational metrics.
-- Solution: Apply rolling window aggregates over recent rows.
-- Why this fits: Rolling metrics are perfect for monitoring KPIs in near real time.
-- =====================================================

SELECT
    sale_date,
    SUM(amount) AS daily_sales,
    SUM(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_7d_sum,
    AVG(SUM(amount)) OVER (ORDER BY sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_7d_avg
FROM analytics.fact_sales
GROUP BY sale_date
ORDER BY sale_date;
