-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 10: NTILE BUCKETING
-- Problem: Segment customers into quartiles by spend.
-- Solution: Use NTILE to create equal-sized buckets.
-- Why this fits: Bucketing is common in segmentation, scoring, and prioritization.
-- =====================================================

SELECT
    customer_id,
    SUM(amount) AS total_spend,
    NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS spend_quartile
FROM analytics.fact_sales
GROUP BY customer_id
ORDER BY total_spend DESC;
