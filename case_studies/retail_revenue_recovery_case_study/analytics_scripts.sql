-- Retail Revenue Recovery Case Study
-- Purpose: Demonstrate a structured SQL workflow for a complex business problem.

-- 1. Monthly revenue trend and active customer count
WITH monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month_start,
        COUNT(DISTINCT customer_id) AS active_customers,
        SUM(order_amount) AS revenue
    FROM retail_orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT *
FROM monthly_metrics
ORDER BY month_start;

-- 2. Segment-level churn and repeat purchase analysis
WITH customer_life AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date,
        MIN(order_date) AS first_order_date,
        COUNT(DISTINCT order_id) AS order_count,
        SUM(order_amount) AS lifetime_value
    FROM retail_orders
    GROUP BY customer_id
),
segmented_customers AS (
    SELECT
        customer_id,
        CASE
            WHEN lifetime_value >= 1000 THEN 'High Value'
            WHEN lifetime_value >= 300 THEN 'Mid Value'
            ELSE 'Low Value'
        END AS value_segment,
        CASE
            WHEN DATE_DIFF('day', last_order_date, CURRENT_DATE) > 90 THEN 'At Risk'
            ELSE 'Active'
        END AS risk_status
    FROM customer_life
)
SELECT
    value_segment,
    risk_status,
    COUNT(*) AS customer_count
FROM segmented_customers
GROUP BY value_segment, risk_status
ORDER BY value_segment, risk_status;

-- 3. Product category contribution to revenue decline
SELECT
    product_category,
    SUM(order_amount) AS revenue,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM retail_orders
GROUP BY product_category
ORDER BY revenue DESC;

-- 4. Channel-level performance comparison
SELECT
    channel,
    SUM(order_amount) AS revenue,
    COUNT(DISTINCT customer_id) AS customers,
    AVG(order_amount) AS avg_order_value
FROM retail_orders
GROUP BY channel
ORDER BY revenue DESC;

-- 5. Recovery campaign uplift estimate
WITH baseline AS (
    SELECT
        customer_id,
        SUM(order_amount) AS baseline_revenue
    FROM retail_orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '180 day'
    GROUP BY customer_id
)
SELECT
    ROUND(AVG(baseline_revenue), 2) AS avg_baseline_revenue
FROM baseline;
