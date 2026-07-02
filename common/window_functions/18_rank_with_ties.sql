-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 18: RANK WITH TIES
-- Problem: Handle tied scores while preserving ranking order.
-- Solution: Use RANK and DENSE_RANK to show ties clearly.
-- Why this fits: Ranking ties is common in contests, performance reviews, and benchmark studies.
-- =====================================================

SELECT
    customer_id,
    region,
    amount,
    RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS rank_with_ties,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS dense_rank_with_ties
FROM analytics.fact_sales
ORDER BY region, amount DESC;
