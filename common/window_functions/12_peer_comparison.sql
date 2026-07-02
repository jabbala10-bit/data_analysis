-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 12: PEER COMPARISON
-- Problem: Compare each customer's spend to the average of their region.
-- Solution: Use AVG over a partition to compute peer-group benchmarks.
-- Why this fits: Peer comparisons are useful in benchmarking and performance review workflows.
-- =====================================================

SELECT
    customer_id,
    region,
    SUM(amount) AS customer_spend,
    AVG(SUM(amount)) OVER (PARTITION BY region) AS avg_region_spend,
    SUM(amount) - AVG(SUM(amount)) OVER (PARTITION BY region) AS spend_diff_vs_region_avg
FROM analytics.fact_sales
GROUP BY customer_id, region
ORDER BY region, customer_spend DESC;
