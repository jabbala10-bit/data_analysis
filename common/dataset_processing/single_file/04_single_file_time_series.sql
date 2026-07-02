-- =====================================================
-- DATASET PROCESSING: SINGLE FILE TIME SERIES
-- Problem: Track one dataset over time.
-- Solution: Aggregate metrics by day or month.
-- Why this fits: Time-series analysis is central to reporting, forecasting, and trend analysis.
-- =====================================================

SELECT
    DATE_TRUNC('month', sale_date) AS month,
    COUNT(*) AS transaction_count,
    SUM(amount) AS monthly_revenue,
    AVG(amount) AS avg_transaction_value
FROM analytics.fact_sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;
