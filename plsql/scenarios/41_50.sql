-- Purpose: Support executive-style analytics and KPI review.
-- Use: Build summary metrics for leadership reporting.
-- Scenarios 41-50: executive-style analytic scenarios

-- 41. Quarterly revenue summary
SELECT TO_CHAR(order_date, 'Q') AS quarter_no, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'Q');

-- 42. Top performing sales reps
SELECT employee_id, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY employee_id
ORDER BY revenue DESC;

-- 43. Unusual order volume spike
SELECT customer_id, COUNT(*) AS order_count
FROM sales_orders
GROUP BY customer_id
HAVING COUNT(*) > 20;

-- 44. High-risk accounts
SELECT customer_id, SUM(order_amount) AS exposure
FROM sales_orders
GROUP BY customer_id
HAVING SUM(order_amount) > 10000;

-- 45. Historical trend comparison
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month_key, SUM(order_amount) AS sales
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month_key;

-- 46. Customer retention by tenure
SELECT tenure_months, COUNT(DISTINCT customer_id) AS customers
FROM customer_tenure
GROUP BY tenure_months;

-- 47. Campaign response rate
SELECT channel, SUM(CASE WHEN converted_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS response_rate_pct
FROM campaign_activity
GROUP BY channel;

-- 48. Fraud signal review
SELECT customer_id, COUNT(*) AS suspicious_txn
FROM payment_transactions
WHERE status = 'REVIEW'
GROUP BY customer_id;

-- 49. Cross-sell opportunity flag
SELECT customer_id
FROM sales_orders
WHERE category = 'Electronics'
GROUP BY customer_id;

-- 50. Executive KPI rollup
SELECT
    COUNT(DISTINCT customer_id) AS active_customers,
    SUM(order_amount) AS total_revenue,
    AVG(order_amount) AS avg_order_value
FROM sales_orders;
