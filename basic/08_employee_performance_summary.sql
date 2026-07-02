-- =====================================================
-- BASIC SCENARIO: EMPLOYEE PERFORMANCE SUMMARY
-- Problem: Managers need a quick view of top-performing sales or service representatives.
-- Solution: Aggregate closed deals or completed tasks by employee and compare output.
-- Why this fits: This is a common manager dashboard query that supports coaching and resource planning.
-- =====================================================

SELECT
    employee_id,
    employee_name,
    COUNT(*) AS completed_items,
    SUM(order_total) AS total_value,
    AVG(order_total) AS avg_value_per_item
FROM orders
WHERE order_status = 'Completed'
GROUP BY employee_id, employee_name
ORDER BY total_value DESC;
