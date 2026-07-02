-- =====================================================
-- BASIC DATA ANALYSIS QUERIES WITH OPTIMIZATION
-- =====================================================

-- 1. AGGREGATION WITH GROUP BY
-- =====================================================
-- Formula: SUM, COUNT, AVG over grouped data
-- Use Case: Find total sales by region
-- 
-- Optimization Strategy:
--   - Add WHERE clause BEFORE grouping to filter rows early
--   - Index on GROUP BY columns improves performance
--   - Use HAVING for post-aggregate filtering

SELECT 
    region,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_sales,
    AVG(amount) AS avg_transaction,
    MIN(amount) AS min_sale,
    MAX(amount) AS max_sale
FROM sales
WHERE transaction_date >= '2024-01-01'  -- Filter before aggregation
GROUP BY region
HAVING COUNT(*) > 10  -- Filter after aggregation
ORDER BY total_sales DESC;

-- Optimization: Create index on (region, transaction_date)
-- CREATE INDEX idx_sales_region_date ON sales(region, transaction_date);


-- 2. WINDOW FUNCTIONS FOR RANKING & RUNNING TOTALS
-- =====================================================
-- Formula: ROW_NUMBER(), RANK(), DENSE_RANK(), LAG/LEAD
-- Use Case: Rank products by sales, calculate month-over-month growth
-- 
-- Optimization Strategy:
--   - Window functions avoid self-joins (reduces complexity)
--   - Partition on indexed columns for better execution
--   - Use WHERE after CTE for early filtering

WITH ranked_sales AS (
    SELECT 
        product_id,
        product_name,
        sales_amount,
        sale_date,
        ROW_NUMBER() OVER (ORDER BY sales_amount DESC) AS rank_all,
        RANK() OVER (PARTITION BY category ORDER BY sales_amount DESC) AS rank_by_category,
        LAG(sales_amount) OVER (ORDER BY sale_date) AS prev_sale,
        LEAD(sales_amount) OVER (ORDER BY sale_date) AS next_sale,
        SUM(sales_amount) OVER (ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
    FROM sales
)
SELECT *
FROM ranked_sales
WHERE rank_by_category <= 10;  -- Filter top 10 per category

-- Optimization: Window functions are efficient; use partitioning to reduce dataset size


-- 3. JOIN WITH AGGREGATION
-- =====================================================
-- Formula: INNER/LEFT JOIN + GROUP BY
-- Use Case: Customer purchase frequency with demographic data
-- 
-- Optimization Strategy:
--   - Filter smaller table (customers) before join
--   - Join on indexed columns (IDs)
--   - Use INNER JOIN when possible (reduces result set)

SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_total) AS lifetime_value,
    AVG(o.order_total) AS avg_order_value,
    MAX(o.order_date) AS last_order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.status = 'Active'  -- Filter on smaller table first
    AND o.order_date >= DATEADD(YEAR, -1, GETDATE())
GROUP BY c.customer_id, c.customer_name, c.city
HAVING COUNT(o.order_id) >= 5
ORDER BY lifetime_value DESC;

-- Optimization: Index on (customer_id, status) for customers; (customer_id, order_date) for orders


-- 4. PERCENTILE & QUARTILE ANALYSIS
-- =====================================================
-- Formula: PERCENTILE_CONT(), NTILE()
-- Use Case: Understand data distribution, identify outliers
-- 
-- Optimization Strategy:
--   - Pre-filter data to relevant subset before percentile calculation
--   - Use materialized views for large datasets
--   - NTILE is more efficient than manual quartile calculation

SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) OVER () AS q1_salary,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary) OVER () AS median_salary,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) OVER () AS q3_salary,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY salary) OVER () AS p95_salary,
    NTILE(4) OVER (ORDER BY salary) AS quartile,
    employee_id,
    salary,
    department
FROM employees
WHERE hire_date >= '2022-01-01'
ORDER BY salary DESC;

-- Optimization: PERCENTILE_CONT avoids sorting entire dataset multiple times


-- 5. CUMULATIVE SUM & GROWTH RATE
-- =====================================================
-- Formula: SUM() OVER + LAG for growth calculation
-- Use Case: Monthly revenue trends, cumulative profit tracking
-- 
-- Optimization Strategy:
--   - Use monthly/aggregate view before window function (reduces rows)
--   - Partition by relevant dimensions to parallelize computation

SELECT 
    year_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY year_month) AS cumulative_revenue,
    LAG(monthly_revenue) OVER (ORDER BY year_month) AS prev_month_revenue,
    CASE 
        WHEN LAG(monthly_revenue) OVER (ORDER BY year_month) IS NULL THEN 0
        ELSE ROUND(
            ((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY year_month)) 
             / LAG(monthly_revenue) OVER (ORDER BY year_month)) * 100, 2)
    END AS growth_rate_pct
FROM (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS year_month,
        SUM(amount) AS monthly_revenue
    FROM sales
    GROUP BY FORMAT(order_date, 'yyyy-MM')
) monthly_data
ORDER BY year_month;

-- Optimization: Pre-aggregate to monthly before window functions


-- 6. DISTINCT COUNT & CARDINALITY
-- =====================================================
-- Formula: COUNT(DISTINCT column)
-- Use Case: Unique customers, unique products sold
-- 
-- Optimization Strategy:
--   - Use APPROXIMATE COUNT DISTINCT for very large datasets (10M+ rows)
--   - Combine with GROUP BY to count per segment

SELECT 
    region,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products_sold,
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT customer_id) * 1.0 / COUNT(*) AS customer_transaction_ratio
FROM sales
WHERE year = 2024
GROUP BY region
ORDER BY unique_customers DESC;

-- Optimization: Index on (region, customer_id, product_id) helps; use approximate for billions of rows
-- Approximate: SELECT APPROX_COUNT_DISTINCT(customer_id) FROM sales;


-- 7. CONDITIONAL AGGREGATION (CASE + SUM)
-- =====================================================
-- Formula: SUM(CASE WHEN condition)
-- Use Case: Segment revenue by customer tier without multiple queries
-- 
-- Optimization Strategy:
--   - Better than multiple subqueries
--   - Single table scan instead of multiple scans

SELECT 
    region,
    SUM(CASE WHEN customer_segment = 'Premium' THEN amount ELSE 0 END) AS premium_revenue,
    SUM(CASE WHEN customer_segment = 'Standard' THEN amount ELSE 0 END) AS standard_revenue,
    SUM(CASE WHEN customer_segment = 'Basic' THEN amount ELSE 0 END) AS basic_revenue,
    COUNT(CASE WHEN payment_status = 'Paid' THEN 1 END) AS paid_transactions,
    COUNT(CASE WHEN payment_status = 'Pending' THEN 1 END) AS pending_transactions
FROM sales
WHERE transaction_date >= '2024-01-01'
GROUP BY region;

-- Optimization: Single pass through data; avoids 3+ separate queries


-- 8. DATE-BASED ANALYSIS & TIME SERIES
-- =====================================================
-- Formula: DATEDIFF, DATEADD, DATE functions
-- Use Case: Customer lifetime, cohort analysis, retention
-- 
-- Optimization Strategy:
--   - Pre-calculate date ranges in WHERE clause
--   - Avoid functions in WHERE (they prevent index usage)

SELECT 
    DATEDIFF(DAY, first_purchase_date, last_purchase_date) AS customer_lifetime_days,
    DATEDIFF(MONTH, first_purchase_date, GETDATE()) AS months_as_customer,
    CASE 
        WHEN DATEDIFF(DAY, last_purchase_date, GETDATE()) <= 30 THEN 'Active'
        WHEN DATEDIFF(DAY, last_purchase_date, GETDATE()) <= 90 THEN 'At Risk'
        ELSE 'Churned'
    END AS customer_status,
    COUNT(*) AS customer_count,
    SUM(lifetime_value) AS segment_value
FROM customers
WHERE first_purchase_date >= '2023-01-01'
GROUP BY 
    DATEDIFF(DAY, first_purchase_date, last_purchase_date),
    DATEDIFF(MONTH, first_purchase_date, GETDATE())
ORDER BY months_as_customer DESC;

-- Optimization: Avoid DATEPART() in WHERE; use direct date comparison instead
-- Bad:  WHERE YEAR(order_date) = 2024
-- Good: WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
