-- =====================================================
-- INTERMEDIATE SCENARIO: REFUND RATE ANALYSIS
-- Problem: Operations wants to identify products or customer segments with unusually high refund behavior.
-- Solution: Calculate refund ratios by product and customer segment.
-- Why this fits: Refund analytics helps reduce losses, improve customer experience, and uncover product issues.
-- =====================================================

SELECT
    p.product_name,
    c.segment,
    COUNT(*) AS orders,
    SUM(CASE WHEN o.order_status = 'Refunded' THEN 1 ELSE 0 END) AS refunded_orders,
    ROUND(100.0 * SUM(CASE WHEN o.order_status = 'Refunded' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS refund_rate_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, c.segment
ORDER BY refund_rate_pct DESC;
