-- =====================================================
-- COMMON SQL: WINDOW FUNCTIONS
-- Purpose: Ranking, running totals, prior/next values, and partitioned calculations
-- =====================================================

SELECT
    customer_id,
    sale_date,
    amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date) AS row_num,
    RANK() OVER (ORDER BY amount DESC) AS amount_rank,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY sale_date) AS running_total,
    LAG(amount) OVER (PARTITION BY customer_id ORDER BY sale_date) AS prev_amount,
    LEAD(amount) OVER (PARTITION BY customer_id ORDER BY sale_date) AS next_amount
FROM analytics.fact_sales
ORDER BY customer_id, sale_date;
