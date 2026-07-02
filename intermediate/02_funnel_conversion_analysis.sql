-- =====================================================
-- INTERMEDIATE SCENARIO: FUNNEL CONVERSION ANALYSIS
-- Purpose: Measure drop-off between key steps in a customer journey
-- =====================================================

WITH funnel_base AS (
    SELECT
        customer_id,
        MIN(CASE WHEN event_type = 'visit' THEN event_date END) AS visit_date,
        MIN(CASE WHEN event_type = 'signup' THEN event_date END) AS signup_date,
        MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_date
    FROM event_log
    WHERE event_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS total_users,
    COUNT(signup_date) AS signed_up,
    COUNT(purchase_date) AS purchased,
    ROUND(100.0 * COUNT(signup_date) / NULLIF(COUNT(*), 0), 2) AS signup_rate_pct,
    ROUND(100.0 * COUNT(purchase_date) / NULLIF(COUNT(signup_date), 0), 2) AS purchase_rate_pct
FROM funnel_base;
