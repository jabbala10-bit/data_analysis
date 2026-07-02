-- Customer churn analysis
SELECT
    signup_month,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(CASE WHEN active_flag = 1 THEN 1 ELSE 0 END) AS active_customers
FROM subscription_activity
GROUP BY signup_month
ORDER BY signup_month;
