-- =====================================================
-- DATASET PROCESSING: SINGLE FILE SEGMENT SUMMARY
-- Problem: Understand performance by business segment within one dataset.
-- Solution: Aggregate rows by segment and compute revenue KPIs.
-- Why this fits: Segment-level summaries are a core analyst task for decision-making.
-- =====================================================

SELECT
    region,
    COUNT(*) AS row_count,
    SUM(amount) AS total_revenue,
    AVG(amount) AS avg_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM analytics.fact_sales
GROUP BY region
ORDER BY total_revenue DESC;
