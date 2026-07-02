-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 07: DEDUPLICATION WITH ROW_NUMBER
-- Problem: Remove duplicate records while retaining the latest row.
-- Solution: Use ROW_NUMBER to keep the most recent row per business key.
-- Why this fits: Deduplication is essential in ETL, master data, and analytics pipelines.
-- =====================================================

WITH ranked_rows AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id, sale_date
            ORDER BY sale_id DESC
        ) AS rn
    FROM analytics.fact_sales
)
SELECT *
FROM ranked_rows
WHERE rn = 1;
