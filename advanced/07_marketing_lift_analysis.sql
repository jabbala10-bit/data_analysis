-- =====================================================
-- ADVANCED SCENARIO: MARKETING LIFT ANALYSIS
-- Problem: Marketing wants to measure the incremental impact of campaigns compared to a control group.
-- Solution: Compare exposed users and control users over a defined post-exposure window.
-- Why this fits: Lift analysis is a common experiment-based decision tool for growth teams.
-- =====================================================

WITH campaign_users AS (
    SELECT
        me.user_id,
        me.campaign_id,
        CASE WHEN me.group_type = 'exposed' THEN 1 ELSE 0 END AS exposed_flag,
        SUM(o.order_total) AS total_revenue
    FROM marketing_exposures me
    LEFT JOIN orders o ON me.user_id = o.customer_id
        AND o.order_date BETWEEN me.exposure_date AND me.exposure_date + INTERVAL '30 days'
    GROUP BY me.user_id, me.campaign_id, me.group_type
)
SELECT
    campaign_id,
    SUM(total_revenue) FILTER (WHERE exposed_flag = 1) AS revenue_exposed,
    SUM(total_revenue) FILTER (WHERE exposed_flag = 0) AS revenue_control,
    ROUND(100.0 * (SUM(total_revenue) FILTER (WHERE exposed_flag = 1) - SUM(total_revenue) FILTER (WHERE exposed_flag = 0)) / NULLIF(SUM(total_revenue) FILTER (WHERE exposed_flag = 0), 0), 2) AS lift_pct
FROM campaign_users
GROUP BY campaign_id
ORDER BY lift_pct DESC;
