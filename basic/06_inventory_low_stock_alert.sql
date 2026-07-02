-- =====================================================
-- BASIC SCENARIO: LOW-STOCK ALERTS
-- Problem: Operations needs to know which products are at risk of stockouts.
-- Solution: Compare current stock to reorder points and flag items that need replenishment.
-- Why this fits: This is a daily operational report used by supply chain teams to avoid missed sales and service issues.
-- =====================================================

SELECT
    product_id,
    product_name,
    current_stock,
    reorder_point,
    current_stock - reorder_point AS stock_gap
FROM inventory
WHERE current_stock <= reorder_point
ORDER BY stock_gap ASC;
