-- =====================================================
-- ADVANCED SCENARIO: RECONCILIATION AND BALANCE CHECK
-- Purpose: Compare records across systems and spot mismatches
-- =====================================================

SELECT
    source_system,
    COUNT(*) AS row_count,
    SUM(amount) AS total_amount
FROM (
    SELECT 'erp' AS source_system, transaction_id, amount FROM erp_transactions
    UNION ALL
    SELECT 'crm' AS source_system, transaction_id, amount FROM crm_transactions
    UNION ALL
    SELECT 'billing' AS source_system, transaction_id, amount FROM billing_transactions
) combined_data
GROUP BY source_system;

SELECT
    COALESCE(erp.transaction_id, crm.transaction_id, billing.transaction_id) AS transaction_id,
    erp.amount AS erp_amount,
    crm.amount AS crm_amount,
    billing.amount AS billing_amount
FROM erp_transactions erp
FULL OUTER JOIN crm_transactions crm ON erp.transaction_id = crm.transaction_id
FULL OUTER JOIN billing_transactions billing ON COALESCE(erp.transaction_id, crm.transaction_id) = billing.transaction_id
WHERE COALESCE(erp.amount, 0) <> COALESCE(crm.amount, 0)
   OR COALESCE(erp.amount, 0) <> COALESCE(billing.amount, 0)
   OR COALESCE(crm.amount, 0) <> COALESCE(billing.amount, 0);
