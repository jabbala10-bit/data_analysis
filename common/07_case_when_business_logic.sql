-- =====================================================
-- COMMON SQL: CASE WHEN FOR BUSINESS RULES
-- Purpose: Create buckets, flags, and decision logic in SQL
-- =====================================================

SELECT
    customer_id,
    amount,
    CASE
        WHEN amount >= 1000 THEN 'High Value'
        WHEN amount >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_band,
    CASE
        WHEN region IN ('North', 'South') THEN 'Domestic'
        ELSE 'International'
    END AS market_type
FROM analytics.fact_sales
ORDER BY amount DESC;
