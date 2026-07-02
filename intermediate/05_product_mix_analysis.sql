-- =====================================================
-- INTERMEDIATE SCENARIO: PRODUCT MIX ANALYSIS
-- Problem: Category managers need to understand which products contribute most to revenue and how mix shifts over time.
-- Solution: Compare category contribution and product share within each month.
-- Why this fits: Product mix analysis is crucial for assortment planning, promotions, and margin management.
-- =====================================================

SELECT
    DATE_TRUNC('month', o.order_date)::date AS month,
    p.category,
    p.product_name,
    COUNT(*) AS units_sold,
    SUM(o.order_total) AS revenue,
    ROUND(100.0 * SUM(o.order_total) / NULLIF(SUM(SUM(o.order_total)) OVER (PARTITION BY DATE_TRUNC('month', o.order_date)), 0), 2) AS category_share_pct
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY DATE_TRUNC('month', o.order_date), p.category, p.product_name
ORDER BY month DESC, revenue DESC;
