-- =====================================================
-- ADVANCED SCENARIO: CHURN RISK SEGMENTATION
-- Problem: Retention teams need to identify customers likely to leave based on recent activity and purchase cadence.
-- Solution: Calculate recency, frequency, and activity windows to classify churn risk.
-- Why this fits: This is a practical retention analytics pattern used in CRM and customer success workflows.
-- =====================================================

WITH customer_usage AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(*) AS order_count,
        DATE_PART('day', CURRENT_DATE - MAX(order_date)) AS recency_days,
        COUNT(DISTINCT DATE_TRUNC('month', order_date)) AS active_months
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '24 months'
    GROUP BY customer_id
)
SELECT
    customer_id,
    order_count,
    recency_days,
    active_months,
    CASE
        WHEN recency_days > 90 OR order_count <= 1 THEN 'High Risk'
        WHEN recency_days BETWEEN 31 AND 90 OR order_count BETWEEN 2 AND 3 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS churn_risk
FROM customer_usage
ORDER BY churn_risk, recency_days DESC;
