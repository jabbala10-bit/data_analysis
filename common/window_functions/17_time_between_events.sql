-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 17: TIME BETWEEN EVENTS
-- Problem: Measure the time gap between consecutive events for each customer.
-- Solution: Compare the current event date with the previous event date using LAG.
-- Why this fits: Inter-event time is useful for purchase cadence, engagement, and churn analysis.
-- =====================================================

SELECT
    customer_id,
    sale_date,
    sale_date - LAG(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) AS days_since_prev_event
FROM analytics.fact_sales
ORDER BY customer_id, sale_date;
