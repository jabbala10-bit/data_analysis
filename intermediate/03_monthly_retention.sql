-- =====================================================
-- INTERMEDIATE SCENARIO: MONTHLY RETENTION
-- Purpose: Measure repeat usage by acquisition month
-- =====================================================

WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(DATE_TRUNC('month', order_date)::date) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
activity_by_month AS (
    SELECT
        fp.customer_id,
        fp.cohort_month,
        DATE_TRUNC('month', o.order_date)::date AS order_month
    FROM first_purchase fp
    JOIN orders o ON fp.customer_id = o.customer_id
)
SELECT
    cohort_month,
    COUNT(DISTINCT CASE WHEN order_month = cohort_month THEN customer_id END) AS month_0,
    COUNT(DISTINCT CASE WHEN order_month = cohort_month + INTERVAL '1 month' THEN customer_id END) AS month_1,
    COUNT(DISTINCT CASE WHEN order_month = cohort_month + INTERVAL '2 months' THEN customer_id END) AS month_2
FROM activity_by_month
GROUP BY cohort_month
ORDER BY cohort_month DESC;
