-- =====================================================
-- ADVANCED SCENARIO: REVENUE ATTRIBUTION
-- Purpose: Attribute revenue across multi-touch customer journeys
-- =====================================================

WITH ordered_touchpoints AS (
    SELECT
        order_id,
        touchpoint_id,
        channel,
        revenue_amount,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY touchpoint_time) AS touch_rank,
        COUNT(*) OVER (PARTITION BY order_id) AS touch_count
    FROM order_touchpoints
    WHERE order_status = 'completed'
),
weights AS (
    SELECT
        order_id,
        touchpoint_id,
        channel,
        revenue_amount,
        touch_rank,
        touch_count,
        CASE
            WHEN touch_rank = 1 THEN 0.4
            WHEN touch_rank = touch_count THEN 0.4
            ELSE 0.2 / NULLIF(touch_count - 2, 0)
        END AS weight
    FROM ordered_touchpoints
)
SELECT
    channel,
    SUM(revenue_amount * COALESCE(weight, 0)) AS attributed_revenue,
    COUNT(DISTINCT order_id) AS orders_touched
FROM weights
GROUP BY channel
ORDER BY attributed_revenue DESC;
