-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 11: COHORT MONTH OFFSET
-- Problem: Measure customer activity in relation to their first purchase month.
-- Solution: Use window functions to derive month offsets within cohorts.
-- Why this fits: Cohort analysis is a standard retention and lifecycle analytics pattern.
-- =====================================================

WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(sale_date) AS first_sale_date
    FROM analytics.fact_sales
    GROUP BY customer_id
)
SELECT
    fp.customer_id,
    fp.first_sale_date,
    fs.sale_date,
    DATE_PART('month', fs.sale_date - fp.first_sale_date) AS month_offset
FROM first_purchase fp
JOIN analytics.fact_sales fs ON fp.customer_id = fs.customer_id
ORDER BY fp.customer_id, fs.sale_date;
