-- =====================================================
-- BASIC SCENARIO: PAYMENT FAILURE SUMMARY
-- Problem: Finance wants to understand which payment methods fail most often and where recovery effort should focus.
-- Solution: Summarize failures by payment method, status, and region.
-- Why this fits: Payment failure analysis directly supports operations, finance, and customer success decisions.
-- =====================================================

SELECT
    payment_method,
    payment_status,
    region,
    COUNT(*) AS transaction_count,
    ROUND(100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER (PARTITION BY region), 0), 2) AS share_of_region_failures
FROM payments
WHERE payment_status IN ('Failed', 'Declined', 'Pending')
GROUP BY payment_method, payment_status, region
ORDER BY region, transaction_count DESC;
