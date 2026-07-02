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
