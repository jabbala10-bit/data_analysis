-- Purpose: Focus on support, SLA, and operational reporting tasks.
-- Use: Practice summarizing service performance and data freshness.
-- Scenarios 31-40: operational and reporting cases

-- 31. SLA breach summary
SELECT region, COUNT(*) AS sla_breaches
FROM support_cases
WHERE resolution_time_days > 3
GROUP BY region;

-- 32. Product stockout frequency
SELECT product_id, COUNT(*) AS stockout_events
FROM inventory_items
WHERE stock_quantity = 0
GROUP BY product_id;

-- 33. Monthly active users
SELECT TO_CHAR(activity_date, 'YYYY-MM') AS month_key, COUNT(DISTINCT user_id) AS mau
FROM user_activity
GROUP BY TO_CHAR(activity_date, 'YYYY-MM');

-- 34. Subscription cancellation rate
SELECT plan_type, COUNT(*) AS cancelled_subscriptions
FROM subscriptions
WHERE status = 'CANCELLED'
GROUP BY plan_type;

-- 35. Support ticket backlog
SELECT priority_level, COUNT(*) AS ticket_count
FROM support_cases
WHERE status <> 'CLOSED'
GROUP BY priority_level;

-- 36. Customer complaint frequency
SELECT customer_id, COUNT(*) AS complaint_count
FROM support_cases
GROUP BY customer_id
ORDER BY complaint_count DESC;

-- 37. Average handling time review
SELECT agent_id, AVG(handle_time_minutes) AS avg_handle_time
FROM support_cases
GROUP BY agent_id;

-- 38. Top regions by sales contribution
SELECT region, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY region
ORDER BY revenue DESC;

-- 39. Currency conversion audit
SELECT currency, SUM(order_amount) AS revenue
FROM sales_orders
GROUP BY currency;

-- 40. Data freshness check
SELECT MAX(order_date) AS latest_order_date
FROM sales_orders;
