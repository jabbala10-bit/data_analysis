
-- Advanced SQL Script Collection for Intermediate to Complex Business Problems
-- Each section includes a solution pattern, optimization technique, and trade-offs.

/*
1. Cohort Retention Analysis: Calculate monthly retention rates by acquisition cohort.
   Uses CTEs and window functions for efficient aggregation. Trade-off: requires good
   indexing on user_date fields, and may be expensive on very large raw event tables.
*/
WITH base_events AS (
    SELECT
        user_id,
        DATE_TRUNC('month', signup_date) AS cohort_month,
        DATE_TRUNC('month', event_date)  AS activity_month
    FROM user_events
    WHERE signup_date IS NOT NULL
),
cohort_activity AS (
    SELECT
        cohort_month,
        activity_month,
        COUNT(DISTINCT user_id) AS active_users
    FROM base_events
    GROUP BY cohort_month, activity_month
),
cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT user_id) AS cohort_size
    FROM base_events
    GROUP BY cohort_month
)
SELECT
    c.cohort_month,
    c.activity_month,
    c.active_users,
    s.cohort_size,
    ROUND(100.0 * c.active_users / NULLIF(s.cohort_size, 0), 2) AS retention_pct,
    DATE_DIFF('month', c.cohort_month, c.activity_month) AS month_offset
FROM cohort_activity c
JOIN cohort_sizes s
    ON c.cohort_month = s.cohort_month
ORDER BY c.cohort_month, c.activity_month;

-- Optimization strategy: filter base_events early, use indexed signup_date/event_date,
-- and compute cohort sizes once. Trade-off: if user_events is extremely wide, consider
-- pre-aggregating into a summarized table.

/*
2. Inventory Reorder Point with Lead Time and Service Level.
   Computes safety stock and reorder points per SKU using demand variability.
*/
WITH demand_stats AS (
    SELECT
        sku_id,
        AVG(daily_demand) AS avg_demand,
        STDDEV_POP(daily_demand) AS demand_stddev,
        AVG(lead_time_days) AS avg_lead_time
    FROM inventory_consumption
    WHERE consumption_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY sku_id
),
service_level AS (
    SELECT
        sku_id,
        1.65 AS z_score  -- approximate for 95% service level
    FROM sku_master
)
SELECT
    d.sku_id,
    d.avg_demand,
    d.demand_stddev,
    d.avg_lead_time,
    GREATEST(CEIL(d.avg_demand * d.avg_lead_time), 0) AS reorder_quantity,
    CEIL(d.avg_demand * d.avg_lead_time + s.z_score * d.demand_stddev * SQRT(d.avg_lead_time)) AS reorder_point
FROM demand_stats d
JOIN service_level s ON d.sku_id = s.sku_id
ORDER BY d.sku_id;

-- Optimization: summarize demand over rolling windows. Trade-off: using STDDEV_POP can be
-- expensive on large data; consider maintaining summary statistics in a separate table.

/*
3. Revenue Attribution Across Multiple Touchpoints.
   Uses a touchpoint sequence and weighted attribution by position.
*/
WITH ordered_touchpoints AS (
    SELECT
        order_id,
        touchpoint_id,
        channel,
        revenue_amount,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY touchpoint_time) AS touch_rank,
        COUNT(*) OVER (PARTITION BY order_id) AS touch_count
    FROM order_touchpoints
    WHERE order_status = 'completed'
),
attribution_weights AS (
    SELECT
        order_id,
        touchpoint_id,
        channel,
        revenue_amount,
        touch_rank,
        touch_count,
        CASE
            WHEN touch_rank = 1 THEN 0.4
            WHEN touch_rank = touch_count THEN 0.4
            ELSE 0.2 / NULLIF(touch_count - 2, 0)
        END AS weight
    FROM ordered_touchpoints
)
SELECT
    channel,
    SUM(revenue_amount * COALESCE(weight, 0)) AS attributed_revenue,
    COUNT(DISTINCT order_id) AS orders_touched
FROM attribution_weights
GROUP BY channel
ORDER BY attributed_revenue DESC;

-- Strategy: use window functions to rank touchpoints. Trade-off: fixed weights may oversimplify
-- the customer journey; a data-driven model may be better for very complex attribution.

/*
4. Anomaly Detection in Sales Using Rolling Z-score.
   Identify outlier daily revenue for each region using rolling mean and stddev.
*/
WITH daily_revenue AS (
    SELECT
        region_id,
        sales_date,
        SUM(sales_amount) AS revenue
    FROM sales_facts
    WHERE sales_date >= CURRENT_DATE - INTERVAL '180 days'
    GROUP BY region_id, sales_date
),
rolling_stats AS (
    SELECT
        region_id,
        sales_date,
        revenue,
        AVG(revenue) OVER (PARTITION BY region_id ORDER BY sales_date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS rolling_avg,
        STDDEV_POP(revenue) OVER (PARTITION BY region_id ORDER BY sales_date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS rolling_stddev
    FROM daily_revenue
)
SELECT
    region_id,
    sales_date,
    revenue,
    rolling_avg,
    rolling_stddev,
    CASE
        WHEN rolling_stddev > 0 THEN (revenue - rolling_avg) / rolling_stddev
        ELSE NULL
    END AS z_score
FROM rolling_stats
WHERE rolling_stddev > 0
  AND ABS((revenue - rolling_avg) / rolling_stddev) >= 3
ORDER BY region_id, sales_date;

-- Optimization: limit to recent window and pre-aggregate. Trade-off: rolling window can be
-- expensive; consider approximate methods or sample-based anomaly detection for huge datasets.

/*
5. Soft Delete with Audit Trail and Upsert Pattern.
   Ensures historical changes are preserved while maintaining current state.
*/
-- current_customer_state contains the latest row per customer
-- customer_audit stores every change event

BEGIN;

INSERT INTO customer_audit (customer_id, name, email, status, updated_at, change_type)
SELECT customer_id, name, email, status, NOW(), 'upsert'
FROM staging_customers
ON CONFLICT (customer_id) DO UPDATE
SET name = EXCLUDED.name,
    email = EXCLUDED.email,
    status = EXCLUDED.status,
    updated_at = NOW(),
    change_type = 'upsert';

INSERT INTO current_customer_state (customer_id, name, email, status, latest_updated_at)
SELECT customer_id, name, email, status, NOW()
FROM staging_customers
ON CONFLICT (customer_id) DO UPDATE
SET name = EXCLUDED.name,
    email = EXCLUDED.email,
    status = EXCLUDED.status,
    latest_updated_at = EXCLUDED.latest_updated_at;

COMMIT;

-- Strategy: keep audit trail with insert-only writes; use ON CONFLICT for idempotent upserts.
-- Trade-off: additional storage for audit data, but essential for compliance and rollback analysis.

/*
6. Dynamic Pivot for Quarterly Performance by Business Unit.
   Uses conditional aggregation to avoid database-specific PIVOT syntax.
*/
SELECT
    business_unit,
    SUM(CASE WHEN quarter = 'Q1' THEN revenue ELSE 0 END) AS revenue_q1,
    SUM(CASE WHEN quarter = 'Q2' THEN revenue ELSE 0 END) AS revenue_q2,
    SUM(CASE WHEN quarter = 'Q3' THEN revenue ELSE 0 END) AS revenue_q3,
    SUM(CASE WHEN quarter = 'Q4' THEN revenue ELSE 0 END) AS revenue_q4
FROM (
    SELECT
        business_unit,
        CONCAT('Q', CEILING(EXTRACT(month FROM sales_date)::numeric / 3)) AS quarter,
        sales_amount AS revenue
    FROM sales_facts
    WHERE sales_date >= DATE_TRUNC('year', CURRENT_DATE)
) quarter_data
GROUP BY business_unit
ORDER BY business_unit;

-- Optimization: use a derived table and conditional aggregation. Trade-off: fixed number of pivot columns,
-- but portable across SQL dialects.

/*
7. Customer Lifetime Value (CLV) Cohorts.
   Segments customers by acquisition source and calculates cumulative revenue
   and projected lifetime value using weighted recency.
*/
WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.acquisition_channel,
        DATE_TRUNC('month', o.order_date) AS order_month,
        SUM(o.order_total) AS month_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '24 months'
    GROUP BY c.customer_id, c.acquisition_channel, DATE_TRUNC('month', o.order_date)
),
clv_cohorts AS (
    SELECT
        acquisition_channel,
        customer_id,
        MIN(order_month) AS cohort_month,
        SUM(month_revenue) AS total_revenue,
        COUNT(DISTINCT order_month) AS active_months
    FROM customer_orders
    GROUP BY acquisition_channel, customer_id
),
channel_ltv AS (
    SELECT
        acquisition_channel,
        COUNT(customer_id) AS customers,
        ROUND(AVG(total_revenue), 2) AS avg_clv,
        ROUND(AVG(active_months), 2) AS avg_active_months
    FROM clv_cohorts
    GROUP BY acquisition_channel
)
SELECT
    acquisition_channel,
    customers,
    avg_clv,
    avg_active_months,
    CASE
        WHEN avg_active_months > 0 THEN ROUND(avg_clv / avg_active_months, 2)
        ELSE NULL
    END AS avg_monthly_value
FROM channel_ltv
ORDER BY avg_clv DESC;

-- Optimization: compute cohort metrics once and reuse. Trade-off: may smooth over
-- individual customer variability in long-tailed revenue distributions.

/*
8. Churn Risk Segmentation Using Recency and Frequency.
   Flags at-risk customers based on recent activity and purchase cadence.
*/
WITH customer_usage AS (
    SELECT
        customer_id,
        MAX(order_date) AS last_order_date,
        COUNT(order_id) AS order_count,
        DATE_DIFF('day', MAX(order_date), CURRENT_DATE) AS recency_days,
        COUNT(DISTINCT DATE_TRUNC('month', order_date)) AS active_months
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '24 months'
    GROUP BY customer_id
)
SELECT
    customer_id,
    order_count,
    recency_days,
    active_months,
    CASE
        WHEN recency_days > 90 OR order_count <= 1 THEN 'high'
        WHEN recency_days BETWEEN 31 AND 90 OR order_count BETWEEN 2 AND 3 THEN 'medium'
        ELSE 'low'
    END AS churn_risk
FROM customer_usage
ORDER BY churn_risk, recency_days DESC;

-- Optimization: reduce state to summary metrics. Trade-off: simple thresholds may
-- miss customers with irregular but valuable patterns.

/*
9. Price Elasticity and Demand Sensitivity.
   Applies aggregate regression to measure SKU-level revenue sensitivity to price changes.
*/
WITH price_history AS (
    SELECT
        sku_id,
        AVG(sale_price) AS avg_price,
        SUM(quantity_sold) AS total_quantity,
        SUM(sale_price * quantity_sold) AS revenue,
        SUM(POWER(sale_price, 2)) AS price_sq,
        SUM(sale_price * quantity_sold) AS price_quantity
    FROM sales_records
    WHERE sale_date >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY sku_id, sale_price
),
elasticity AS (
    SELECT
        sku_id,
        COUNT(*) AS n,
        SUM(avg_price) AS sum_price,
        SUM(total_quantity) AS sum_quantity,
        SUM(price_sq) AS sum_price_sq,
        SUM(price_quantity) AS sum_price_quantity
    FROM price_history
    GROUP BY sku_id
)
SELECT
    sku_id,
    ROUND((sum_price_quantity - (sum_price * sum_quantity) / n) /
          NULLIF((sum_price_sq - (sum_price * sum_price) / n), 0), 6) AS price_sensitivity,
    CASE
        WHEN (sum_price_quantity - (sum_price * sum_quantity) / n) /
             NULLIF((sum_price_sq - (sum_price * sum_price) / n), 0) < 0 THEN 'elastic'
        ELSE 'inelastic'
    END AS elasticity_label
FROM elasticity
ORDER BY price_sensitivity;

-- Optimization: aggregate price-demand pairs before regression. Trade-off: assumes a
-- linear relationship and may be distorted by promotions or seasonality.

/*
10. Supplier Performance and Quality Metrics.
   Combines on-time delivery, quantity accuracy, and defect rates by vendor.
*/
WITH supplier_delivery AS (
    SELECT
        supplier_id,
        COUNT(*) AS total_shipments,
        SUM(CASE WHEN received_date <= promised_date THEN 1 ELSE 0 END) AS on_time_deliveries,
        SUM(CASE WHEN received_quantity = ordered_quantity THEN 1 ELSE 0 END) AS accurate_quantities,
        SUM(defective_quantity) AS total_defects,
        SUM(received_quantity) AS total_received
    FROM purchase_receipts
    WHERE received_date >= CURRENT_DATE - INTERVAL '12 months'
    GROUP BY supplier_id
)
SELECT
    supplier_id,
    total_shipments,
    ROUND(100.0 * on_time_deliveries / NULLIF(total_shipments, 0), 2) AS pct_on_time,
    ROUND(100.0 * accurate_quantities / NULLIF(total_shipments, 0), 2) AS pct_accuracy,
    ROUND(100.0 * total_defects / NULLIF(total_received, 0), 2) AS defect_rate
FROM supplier_delivery
ORDER BY pct_on_time DESC, defect_rate ASC;

-- Optimization: pre-aggregate receipt data and compute ratios once. Trade-off: summary
-- metrics may hide occasional large failures in a vendor's performance.

/*
11. Marketing Campaign Lift with Control Group Comparison.
   Evaluates incremental revenue by comparing exposed and holdout groups.
*/
WITH campaign_users AS (
    SELECT
        user_id,
        campaign_id,
        CASE WHEN group_type = 'exposed' THEN 1 ELSE 0 END AS exposed_flag,
        SUM(order_total) AS total_revenue
    FROM marketing_exposures me
    LEFT JOIN orders o ON me.user_id = o.customer_id
        AND o.order_date BETWEEN me.exposure_date AND me.exposure_date + INTERVAL '30 days'
    GROUP BY user_id, campaign_id, group_type
),
campaign_summary AS (
    SELECT
        campaign_id,
        SUM(total_revenue) FILTER (WHERE exposed_flag = 1) AS revenue_exposed,
        COUNT(DISTINCT user_id) FILTER (WHERE exposed_flag = 1) AS exposed_users,
        SUM(total_revenue) FILTER (WHERE exposed_flag = 0) AS revenue_control,
        COUNT(DISTINCT user_id) FILTER (WHERE exposed_flag = 0) AS control_users
    FROM campaign_users
    GROUP BY campaign_id
)
SELECT
    campaign_id,
    revenue_exposed,
    revenue_control,
    ROUND(100.0 * (revenue_exposed - revenue_control) / NULLIF(revenue_control, 0), 2) AS lift_pct,
    ROUND((revenue_exposed - revenue_control), 2) AS incremental_revenue
FROM campaign_summary
ORDER BY lift_pct DESC;

-- Optimization: join exposures to orders using date windows. Trade-off: requires
-- reliable control assignments and may be sensitive to selection bias.

/*
12. Hierarchical Cost Allocation Using Recursive CTE.
   Propagates overhead costs from parent cost centers to leaf business units.
*/
WITH RECURSIVE cost_hierarchy AS (
    SELECT
        cost_center_id,
        parent_center_id,
        overhead_amount,
        cost_center_id AS root_center_id,
        1.0 AS allocation_share
    FROM cost_centers
    WHERE parent_center_id IS NULL
    UNION ALL
    SELECT
        c.cost_center_id,
        c.parent_center_id,
        c.overhead_amount,
        h.root_center_id,
        h.allocation_share * c.allocation_ratio
    FROM cost_centers c
    JOIN cost_hierarchy h ON c.parent_center_id = h.cost_center_id
)
SELECT
    root_center_id,
    cost_center_id,
    SUM(overhead_amount * allocation_share) AS allocated_overhead
FROM cost_hierarchy
GROUP BY root_center_id, cost_center_id
ORDER BY root_center_id, cost_center_id;

-- Optimization: use a recursive traversal to allocate shared costs. Trade-off: requires
-- stable hierarchy and accurate allocation ratios to avoid compounding errors.
