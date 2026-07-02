-- =====================================================
-- COMMON SQL: CTE PIPELINE FOR ANALYTICS
-- Purpose: Break complex analysis into readable steps
-- =====================================================

WITH sales_base AS (
    SELECT
        customer_id,
        region,
        sale_date,
        amount
    FROM analytics.fact_sales
    WHERE status = 'Completed'
),
customer_summary AS (
    SELECT
        customer_id,
        region,
        COUNT(*) AS orders,
        SUM(amount) AS total_spend,
        MAX(sale_date) AS last_purchase_date
    FROM sales_base
    GROUP BY customer_id, region
)
SELECT
    region,
    COUNT(*) AS customer_count,
    AVG(total_spend) AS avg_customer_spend,
    MAX(last_purchase_date) AS latest_purchase
FROM customer_summary
GROUP BY region
ORDER BY avg_customer_spend DESC;
