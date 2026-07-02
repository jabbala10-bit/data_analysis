-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 01: RANKING BASICS
-- Problem: Identify top-performing rows per category.
-- Solution: Use ROW_NUMBER, RANK, and DENSE_RANK to rank rows.
-- Why this fits: Ranking is foundational for leaderboards, top-N reporting, and prioritization.
-- =====================================================

SELECT
    customer_id,
    region,
    amount,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY amount DESC) AS rn,
    RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS dense_rnk
FROM analytics.fact_sales
ORDER BY region, amount DESC;
