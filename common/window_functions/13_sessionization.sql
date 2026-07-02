-- =====================================================
-- WINDOW FUNCTIONS SCENARIO 13: SESSIONIZATION
-- Problem: Identify periods of user activity separated by long gaps.
-- Solution: Flag sessions using a window-based comparison with LAG.
-- Why this fits: Sessionization is useful for web analytics, product usage, and engagement studies.
-- =====================================================

SELECT
    customer_id,
    sale_date,
    amount,
    CASE
        WHEN LAG(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) IS NULL THEN 1
        WHEN sale_date - LAG(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) > 7 THEN 1
        ELSE 0
    END AS new_session_flag
FROM analytics.fact_sales
ORDER BY customer_id, sale_date;
