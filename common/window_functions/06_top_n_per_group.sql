-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 06: TOP-N PER GROUP
-- Problem: Find the top 3 customers per region.
-- Solution: Rank customers within each region and filter to rank <= 3.
-- Why this fits: Top-N logic is heavily used in recommendation and performance reporting.
-- =====================================================

WITH ranked AS (
    SELECT
        region,
        customer_id,
        SUM(amount) AS total_spend,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(amount) DESC) AS rn
    FROM analytics.fact_sales
    GROUP BY region, customer_id
)
SELECT *
FROM ranked
WHERE rn <= 3
ORDER BY region, rn;
