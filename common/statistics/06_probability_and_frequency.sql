-- =====================================================
-- STATISTICS SCENARIO 06: PROBABILITY AND FREQUENCY
-- Problem: Estimate relative frequency of outcomes.
-- Solution: Calculate count-based probabilities by category.
-- Why this fits: Frequency distributions are useful for risk, customer analyses, and categorization.
-- =====================================================

SELECT
    region,
    COUNT(*) AS frequency,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS probability_pct
FROM analytics.fact_sales
GROUP BY region
ORDER BY frequency DESC;
