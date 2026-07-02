-- =====================================================
-- INTERMEDIATE SCENARIO: CAMPAIGN ROI
-- Problem: Marketing wants to know whether campaigns generate enough revenue to justify spend.
-- Solution: Join campaign exposure data with sales and calculate revenue, cost, and ROI.
-- Why this fits: ROI analysis is a standard business case for marketing and product teams.
-- =====================================================

WITH campaign_metrics AS (
    SELECT
        c.campaign_id,
        c.campaign_name,
        SUM(c.cost) AS total_cost,
        COUNT(DISTINCT me.customer_id) AS engaged_customers,
        SUM(o.order_total) AS campaign_revenue
    FROM campaigns c
    LEFT JOIN marketing_events me ON c.campaign_id = me.campaign_id
    LEFT JOIN orders o ON me.customer_id = o.customer_id
        AND o.order_date BETWEEN c.start_date AND c.end_date
    GROUP BY c.campaign_id, c.campaign_name
)
SELECT
    campaign_id,
    campaign_name,
    total_cost,
    engaged_customers,
    campaign_revenue,
    ROUND(CASE WHEN total_cost = 0 THEN NULL ELSE campaign_revenue / total_cost END, 2) AS roi
FROM campaign_metrics
ORDER BY roi DESC NULLS LAST;
