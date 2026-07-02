

-- ============================================================================
-- INTERMEDIATE SQL SCRIPTS FOR DATA ANALYSIS PROFESSIONALS
-- Common Use Cases and Practical Examples
-- ============================================================================

-- ============================================================================
-- 1. WINDOW FUNCTIONS - Running Totals, Rankings, and Partitioning
-- ============================================================================

-- Running Total by Department
SELECT 
    employee_id,
    department,
    salary,
    hire_date,
    SUM(salary) OVER (PARTITION BY department ORDER BY hire_date) AS running_total_salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank_in_dept
FROM employees
ORDER BY department, hire_date;

-- Year-over-Year Comparison
SELECT 
    product_id,
    DATE_TRUNC('month', order_date) AS month,
    SUM(amount) AS monthly_revenue,
    LAG(SUM(amount)) OVER (PARTITION BY product_id ORDER BY DATE_TRUNC('month', order_date)) AS prev_month_revenue,
    ROUND(((SUM(amount) - LAG(SUM(amount)) OVER (PARTITION BY product_id ORDER BY DATE_TRUNC('month', order_date))) / 
           LAG(SUM(amount)) OVER (PARTITION BY product_id ORDER BY DATE_TRUNC('month', order_date)) * 100), 2) AS pct_change
FROM orders
GROUP BY product_id, DATE_TRUNC('month', order_date)
ORDER BY product_id, month;

-- ============================================================================
-- 2. COMMON TABLE EXPRESSIONS (CTEs) - Complex Multi-Step Queries
-- ============================================================================

-- CTE for Customer Segmentation
WITH customer_spending AS (
    SELECT 
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(amount) AS total_spent,
        AVG(amount) AS avg_order_value,
        MAX(order_date) AS last_purchase_date
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '365 days'
    GROUP BY customer_id
),
customer_segments AS (
    SELECT 
        customer_id,
        total_orders,
        total_spent,
        avg_order_value,
        last_purchase_date,
        CASE 
            WHEN total_spent > 10000 THEN 'VIP'
            WHEN total_spent > 5000 THEN 'Premium'
            WHEN total_spent > 1000 THEN 'Regular'
            ELSE 'Low-Value'
        END AS segment,
        CASE 
            WHEN last_purchase_date >= CURRENT_DATE - INTERVAL '30 days' THEN 'Active'
            WHEN last_purchase_date >= CURRENT_DATE - INTERVAL '90 days' THEN 'At-Risk'
            ELSE 'Churned'
        END AS churn_status
    FROM customer_spending
)
SELECT * FROM customer_segments
ORDER BY total_spent DESC;

-- ============================================================================
-- 3. AGGREGATION WITH FILTERS - Conditional Aggregation
-- ============================================================================

-- Multi-metric Summary with Conditional Logic
SELECT 
    DATE_TRUNC('month', order_date)::date AS month,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN order_status = 'completed' THEN 1 END) AS completed_orders,
    COUNT(CASE WHEN order_status = 'cancelled' THEN 1 END) AS cancelled_orders,
    SUM(amount) AS total_revenue,
    SUM(CASE WHEN order_status = 'completed' THEN amount ELSE 0 END) AS completed_revenue,
    AVG(CASE WHEN order_status = 'completed' THEN amount ELSE NULL END) AS avg_completed_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(CAST(COUNT(CASE WHEN order_status = 'completed' THEN 1 END) AS FLOAT) / COUNT(*) * 100, 2) AS completion_rate
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month DESC;

-- ============================================================================
-- 4. JOINS - Multi-table Analysis with Aggregations
-- ============================================================================

-- Customer Analysis with Product and Category Data
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.product_id) AS unique_products,
    COUNT(DISTINCT cat.category_id) AS unique_categories,
    SUM(o.amount) AS total_spent,
    STRING_AGG(DISTINCT cat.category_name, ', ' ORDER BY cat.category_name) AS categories_purchased
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
LEFT JOIN categories cat ON p.category_id = cat.category_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 0
ORDER BY total_spent DESC;

-- ============================================================================
-- 5. SUBQUERIES - Nested Query Logic
-- ============================================================================

-- Find Customers Above Average Spending in Their Segment
SELECT 
    customer_id,
    customer_name,
    segment,
    total_spent,
    segment_avg_spent,
    (total_spent - segment_avg_spent) AS difference_from_avg
FROM (
    SELECT 
        c.customer_id,
        c.customer_name,
        CASE 
            WHEN c.registration_date >= CURRENT_DATE - INTERVAL '90 days' THEN 'New'
            WHEN c.registration_date >= CURRENT_DATE - INTERVAL '365 days' THEN 'Recent'
            ELSE 'Established'
        END AS segment,
        SUM(o.amount) AS total_spent,
        AVG(SUM(o.amount)) OVER (
            PARTITION BY CASE 
                WHEN c.registration_date >= CURRENT_DATE - INTERVAL '90 days' THEN 'New'
                WHEN c.registration_date >= CURRENT_DATE - INTERVAL '365 days' THEN 'Recent'
                ELSE 'Established'
            END
        ) AS segment_avg_spent
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, c.registration_date
) subq
WHERE total_spent > segment_avg_spent
ORDER BY segment, total_spent DESC;

-- ============================================================================
-- 6. PIVOTING - Converting Rows to Columns
-- ============================================================================

-- Sales by Product Category and Month (Pivot)
SELECT 
    DATE_TRUNC('month', o.order_date)::date AS month,
    SUM(CASE WHEN cat.category_name = 'Electronics' THEN o.amount ELSE 0 END) AS electronics,
    SUM(CASE WHEN cat.category_name = 'Clothing' THEN o.amount ELSE 0 END) AS clothing,
    SUM(CASE WHEN cat.category_name = 'Books' THEN o.amount ELSE 0 END) AS books,
    SUM(CASE WHEN cat.category_name = 'Home & Garden' THEN o.amount ELSE 0 END) AS home_garden,
    SUM(o.amount) AS total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month DESC;

-- ============================================================================
-- 7. DATA QUALITY & PROFILING - Identifying Data Issues
-- ============================================================================

-- Data Quality Report
SELECT 
    'customers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS null_customer_id,
    COUNT(CASE WHEN customer_name IS NULL THEN 1 END) AS null_customer_name,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS null_email,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_customer_ids,
    MIN(registration_date) AS earliest_registration,
    MAX(registration_date) AS latest_registration
FROM customers
UNION ALL
SELECT 
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN order_id IS NULL THEN 1 END) AS null_order_id,
    COUNT(CASE WHEN customer_id IS NULL THEN 1 END) AS null_customer_id,
    COUNT(CASE WHEN amount IS NULL THEN 1 END) AS null_amount,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_ids,
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM orders;

-- ============================================================================
-- 8. COHORT ANALYSIS - Tracking User Behavior Over Time
-- ============================================================================

-- Monthly Cohort Retention Analysis
WITH first_order AS (
    SELECT 
        customer_id,
        MIN(DATE_TRUNC('month', order_date)::date) AS cohort_month
    FROM orders
    GROUP BY customer_id
),
customer_months AS (
    SELECT 
        o.customer_id,
        DATE_TRUNC('month', o.order_date)::date AS order_month,
        fo.cohort_month,
        DATE_PART('month', (DATE_TRUNC('month', o.order_date) - DATE_TRUNC('month', fo.cohort_month))) AS months_since_first_order
    FROM orders o
    JOIN first_order fo ON o.customer_id = fo.customer_id
)
SELECT 
    cohort_month,
    COUNT(DISTINCT CASE WHEN months_since_first_order = 0 THEN customer_id END) AS month_0,
    COUNT(DISTINCT CASE WHEN months_since_first_order = 1 THEN customer_id END) AS month_1,
    COUNT(DISTINCT CASE WHEN months_since_first_order = 2 THEN customer_id END) AS month_2,
    COUNT(DISTINCT CASE WHEN months_since_first_order = 3 THEN customer_id END) AS month_3,
    COUNT(DISTINCT CASE WHEN months_since_first_order >= 4 THEN customer_id END) AS month_4_plus
FROM customer_months
GROUP BY cohort_month
ORDER BY cohort_month DESC;

-- ============================================================================
-- 9. PERFORMANCE OPTIMIZATION - Efficient Queries
-- ============================================================================

-- Indexed Query Pattern for Large Datasets
SELECT 
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(amount) AS total_amount,
    MAX(order_date) AS last_purchase
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '12 months'
    AND order_status = 'completed'
    AND amount > 0
GROUP BY customer_id
HAVING COUNT(*) >= 2
ORDER BY total_amount DESC
LIMIT 100;

-- ============================================================================
-- 10. ANOMALY DETECTION - Identifying Outliers
-- ============================================================================

-- Detect Orders Outside Normal Range
WITH order_stats AS (
    SELECT 
        product_id,
        AVG(amount) AS avg_amount,
        STDDEV(amount) AS stddev_amount,
        AVG(amount) - (2 * STDDEV(amount)) AS lower_bound,
        AVG(amount) + (2 * STDDEV(amount)) AS upper_bound
    FROM orders
    WHERE order_status = 'completed'
    GROUP BY product_id
)
SELECT 
    o.order_id,
    o.customer_id,
    o.product_id,
    o.amount,
    os.avg_amount,
    os.stddev_amount,
    CASE 
        WHEN o.amount < os.lower_bound THEN 'Unusually Low'
        WHEN o.amount > os.upper_bound THEN 'Unusually High'
        ELSE 'Normal'
    END AS anomaly_flag,
    o.order_date
FROM orders o
JOIN order_stats os ON o.product_id = os.product_id
WHERE o.amount < os.lower_bound OR o.amount > os.upper_bound
ORDER BY o.order_date DESC;

-- ============================================================================
-- 11. FORECASTING & TREND ANALYSIS - Demand and Revenue Patterns
-- ============================================================================

-- Rolling Sales Trend and Year-over-Year Growth
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date)::date AS month,
        SUM(amount) AS monthly_revenue
    FROM orders
    WHERE order_status = 'completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    month,
    monthly_revenue,
    ROUND(AVG(monthly_revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_average_3m,
    LAG(monthly_revenue, 12) OVER (ORDER BY month) AS revenue_last_year,
    ROUND(((monthly_revenue - LAG(monthly_revenue, 12) OVER (ORDER BY month)) / NULLIF(LAG(monthly_revenue, 12) OVER (ORDER BY month), 0)) * 100, 2) AS yoy_pct_change
FROM monthly_sales
ORDER BY month;

-- ============================================================================
-- 12. SUPPLY CHAIN & INVENTORY MANAGEMENT - Stock Health and Reorder Signals
-- ============================================================================

-- Inventory Turnover and Days on Hand
SELECT 
    p.product_id,
    p.product_name,
    COALESCE(SUM(CASE WHEN im.transaction_type = 'receipt' THEN im.quantity ELSE 0 END), 0) AS total_received,
    COALESCE(SUM(CASE WHEN im.transaction_type = 'sale' THEN im.quantity ELSE 0 END), 0) AS total_sold,
    COALESCE(SUM(CASE WHEN im.transaction_type = 'receipt' THEN im.quantity ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN im.transaction_type = 'sale' THEN im.quantity ELSE 0 END), 0) AS current_stock,
    CASE 
        WHEN SUM(CASE WHEN im.transaction_type = 'sale' THEN im.quantity ELSE 0 END) = 0 THEN NULL
        ELSE ROUND(COALESCE(SUM(CASE WHEN im.transaction_type = 'receipt' THEN im.quantity ELSE 0 END), 0) / NULLIF(SUM(CASE WHEN im.transaction_type = 'sale' THEN im.quantity ELSE 0 END), 0), 2)
    END AS inventory_turnover_ratio
FROM products p
LEFT JOIN inventory_movements im ON p.product_id = im.product_id
GROUP BY p.product_id, p.product_name
ORDER BY inventory_turnover_ratio DESC NULLS LAST;

-- Reorder Recommendation Based on Minimum Stock and Demand
SELECT 
    p.product_id,
    p.product_name,
    p.reorder_point,
    COALESCE(SUM(CASE WHEN im.transaction_type = 'receipt' THEN im.quantity ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN im.transaction_type = 'sale' THEN im.quantity ELSE 0 END), 0) AS available_stock,
    CASE 
        WHEN COALESCE(SUM(CASE WHEN im.transaction_type = 'receipt' THEN im.quantity ELSE 0 END), 0) - 
             COALESCE(SUM(CASE WHEN im.transaction_type = 'sale' THEN im.quantity ELSE 0 END), 0) <= p.reorder_point
        THEN 'Reorder'
        ELSE 'Sufficient'
    END AS reorder_status
FROM products p
LEFT JOIN inventory_movements im ON p.product_id = im.product_id
GROUP BY p.product_id, p.product_name, p.reorder_point
HAVING p.reorder_point IS NOT NULL
ORDER BY reorder_status DESC, available_stock ASC;

-- ============================================================================
-- 13. MARKETING EFFECTIVENESS - Campaign Impact and Return
-- ============================================================================

-- Campaign ROI and Channel Conversion
WITH campaign_metrics AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        c.channel,
        SUM(me.cost) AS total_cost,
        COUNT(DISTINCT me.customer_id) AS engaged_customers,
        COUNT(DISTINCT o.order_id) AS campaign_orders,
        SUM(o.amount) AS campaign_revenue
    FROM marketing_events me
    LEFT JOIN orders o ON me.customer_id = o.customer_id
        AND o.order_date BETWEEN c.start_date AND c.end_date
    JOIN campaigns c ON me.campaign_id = c.campaign_id
    GROUP BY c.campaign_id, c.campaign_name, c.channel
)
SELECT 
    campaign_id,
    campaign_name,
    channel,
    total_cost,
    engaged_customers,
    campaign_orders,
    campaign_revenue,
    ROUND(CASE WHEN total_cost = 0 THEN NULL ELSE campaign_revenue / total_cost END, 2) AS roi,
    ROUND(CASE WHEN engaged_customers = 0 THEN NULL ELSE campaign_orders::numeric / engaged_customers * 100 END, 2) AS conversion_rate
FROM campaign_metrics
ORDER BY roi DESC NULLS LAST;

-- ============================================================================
-- 14. RISK & FRAUD DETECTION - Suspicious Transactions and Accounts
-- ============================================================================

-- Rapid Order Frequency and Refund Ratio
WITH customer_risk AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count,
        SUM(CASE WHEN order_status = 'refunded' THEN amount ELSE 0 END) AS refunded_amount,
        SUM(amount) AS total_amount,
        ROUND(COUNT(*)::numeric / NULLIF(DATE_PART('day', MAX(order_date) - MIN(order_date)) + 1, 0), 2) AS avg_orders_per_day
    FROM orders
    GROUP BY customer_id
)
SELECT 
    customer_id,
    order_count,
    total_amount,
    refunded_amount,
    ROUND(CASE WHEN total_amount = 0 THEN NULL ELSE refunded_amount / total_amount * 100 END, 2) AS refund_rate_pct,
    avg_orders_per_day,
    CASE 
        WHEN refund_rate_pct > 30 OR avg_orders_per_day > 2 THEN 'High Risk'
        WHEN refund_rate_pct > 15 OR avg_orders_per_day > 1 THEN 'Medium Risk'
        ELSE 'Normal'
    END AS risk_category
FROM customer_risk
ORDER BY refund_rate_pct DESC, avg_orders_per_day DESC;

-- High-value Transactions from New or Dormant Customers
SELECT 
    t.transaction_id,
    t.customer_id,
    t.transaction_amount,
    c.registration_date,
    DATE_PART('day', t.transaction_date - c.registration_date) AS days_since_registration,
    CASE 
        WHEN DATE_PART('day', t.transaction_date - c.registration_date) <= 30 THEN 'New Customer'
        WHEN t.customer_id IN (
            SELECT customer_id FROM orders
            WHERE order_date < t.transaction_date - INTERVAL '180 days'
            GROUP BY customer_id
        ) THEN 'Dormant Customer'
        ELSE 'Established Customer'
    END AS customer_status
FROM transaction_logs t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.transaction_amount > 1000
ORDER BY t.transaction_amount DESC;

-- ============================================================================
-- 15. CUSTOMER LIFETIME VALUE & ENGAGEMENT - Revenue Potential and Retention
-- ============================================================================

-- Projected Lifetime Value by Cohort
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(DATE_TRUNC('month', order_date)::date) AS cohort_month
    FROM orders
    GROUP BY customer_id
), cohort_revenue AS (
    SELECT 
        fo.customer_id,
        fo.cohort_month,
        DATE_TRUNC('month', o.order_date)::date AS order_month,
        SUM(o.amount) AS revenue
    FROM first_purchase fo
    JOIN orders o ON fo.customer_id = o.customer_id
    GROUP BY fo.customer_id, fo.cohort_month, DATE_TRUNC('month', o.order_date)
), cohort_summary AS (
    SELECT 
        cohort_month,
        SUM(revenue) AS total_revenue,
        COUNT(DISTINCT customer_id) AS cohort_size,
        ROUND(SUM(revenue)::numeric / COUNT(DISTINCT customer_id), 2) AS avg_lifetime_value
    FROM cohort_revenue
    GROUP BY cohort_month
)
SELECT * FROM cohort_summary
ORDER BY cohort_month DESC;

-- Engagement and Repeat Purchase Analysis
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    MAX(o.order_date) AS last_order_date,
    DATE_PART('day', CURRENT_DATE - MAX(o.order_date)) AS days_since_last_order,
    SUM(o.amount) AS total_spent,
    ROUND(SUM(o.amount) / NULLIF(COUNT(o.order_id), 0), 2) AS avg_order_value,
    CASE 
        WHEN COUNT(o.order_id) >= 5 THEN 'Loyal'
        WHEN COUNT(o.order_id) BETWEEN 2 AND 4 THEN 'Repeat'
        ELSE 'Occasional'
    END AS loyalty_tier
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 0
ORDER BY total_spent DESC;

-- ============================================================================
-- 16. PRODUCT BASKET ANALYSIS - Cross-sell and Bundling Opportunities
-- ============================================================================

-- Most Frequent Product Pairs in the Same Order
WITH order_pairs AS (
    SELECT 
        o1.product_id AS product_a,
        o2.product_id AS product_b,
        COUNT(DISTINCT o1.order_id) AS pair_count
    FROM order_items o1
    JOIN order_items o2 ON o1.order_id = o2.order_id AND o1.product_id < o2.product_id
    GROUP BY o1.product_id, o2.product_id
)
SELECT 
    op.product_a,
    p1.product_name AS product_a_name,
    op.product_b,
    p2.product_name AS product_b_name,
    op.pair_count
FROM order_pairs op
JOIN products p1 ON op.product_a = p1.product_id
JOIN products p2 ON op.product_b = p2.product_id
ORDER BY op.pair_count DESC
LIMIT 25;

-- Bestseller Contribution by Category and Product
SELECT 
    cat.category_name,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    ROUND(SUM(oi.quantity * oi.unit_price) / NULLIF(SUM(SUM(oi.quantity * oi.unit_price)) OVER (PARTITION BY cat.category_name), 0) * 100, 2) AS category_revenue_share
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name, p.product_name
ORDER BY category_name, revenue DESC;

-- ============================================================================
-- 17. REGIONAL PERFORMANCE & SEGMENTATION - Geographic Insights
-- ============================================================================

-- Revenue and Growth by Region
SELECT 
    r.region_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.amount) AS total_revenue,
    AVG(o.amount) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_revenue DESC;

-- Regional Month-over-Month Revenue Change
WITH sales_region AS (
    SELECT 
        r.region_name,
        DATE_TRUNC('month', o.order_date)::date AS month,
        SUM(o.amount) AS revenue
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN regions r ON c.region_id = r.region_id
    GROUP BY r.region_name, DATE_TRUNC('month', o.order_date)
)
SELECT 
    region_name,
    month,
    revenue,
    LAG(revenue) OVER (PARTITION BY region_name ORDER BY month) AS prior_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (PARTITION BY region_name ORDER BY month)) / NULLIF(LAG(revenue) OVER (PARTITION BY region_name ORDER BY month), 0)) * 100, 2) AS month_over_month_pct_change
FROM sales_region
ORDER BY region_name, month;

-- ============================================================================
-- 18. DATA PIPELINE & INTEGRITY CHECKS - Validation and Staleness
-- ============================================================================

-- Source-to-Target Row Count Validation
SELECT 
    'orders' AS table_name,
    (SELECT COUNT(*) FROM orders_staging) AS staging_count,
    (SELECT COUNT(*) FROM orders) AS production_count,
    (SELECT COUNT(*) FROM orders_staging) - (SELECT COUNT(*) FROM orders) AS count_difference
UNION ALL
SELECT 
    'customers' AS table_name,
    (SELECT COUNT(*) FROM customers_staging) AS staging_count,
    (SELECT COUNT(*) FROM customers) AS production_count,
    (SELECT COUNT(*) FROM customers_staging) - (SELECT COUNT(*) FROM customers) AS count_difference;

-- Detect Stale Data Imports
SELECT 
    table_name,
    MAX(load_timestamp) AS last_load,
    CURRENT_TIMESTAMP - MAX(load_timestamp) AS age_since_last_load
FROM data_load_history
GROUP BY table_name
HAVING CURRENT_TIMESTAMP - MAX(load_timestamp) > INTERVAL '1 day'
ORDER BY age_since_last_load DESC;
