-- =====================================================
-- ADVANCED SCENARIO: SUPPLIER PERFORMANCE
-- Problem: Procurement teams need to evaluate on-time delivery and quality performance across vendors.
-- Solution: Measure delivery timeliness, quantity accuracy, and defect rates by supplier.
-- Why this fits: Supplier scorecards are widely used in operations and manufacturing settings.
-- =====================================================

SELECT
    supplier_id,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN received_date <= promised_date THEN 1 ELSE 0 END) AS on_time_deliveries,
    SUM(CASE WHEN received_quantity = ordered_quantity THEN 1 ELSE 0 END) AS accurate_quantities,
    SUM(defective_quantity) AS total_defects,
    ROUND(100.0 * SUM(CASE WHEN received_date <= promised_date THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS pct_on_time,
    ROUND(100.0 * SUM(CASE WHEN received_quantity = ordered_quantity THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 2) AS pct_accuracy
FROM purchase_receipts
WHERE received_date >= CURRENT_DATE - INTERVAL '12 months'
GROUP BY supplier_id
ORDER BY pct_on_time DESC, pct_accuracy DESC;
