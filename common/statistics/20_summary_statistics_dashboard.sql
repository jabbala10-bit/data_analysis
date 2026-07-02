-- =====================================================
-- STATISTICS SCENARIO 20: SUMMARY STATISTICS DASHBOARD
-- Problem: Provide a one-row KPI summary for quick review.
-- Solution: Compute key descriptive measures in one query.
-- Why this fits: This is ideal for executive summaries and ad hoc analysis handoffs.
-- =====================================================

SELECT
    COUNT(*) AS total_rows,
    AVG(amount) AS mean_amount,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY amount) AS median_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    STDDEV(amount) AS stddev_amount
FROM analytics.fact_sales;
