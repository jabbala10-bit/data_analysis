-- Marketing campaign lift analysis
SELECT
    channel,
    COUNT(DISTINCT customer_id) AS exposed_customers,
    SUM(CASE WHEN converted_flag = 1 THEN 1 ELSE 0 END) AS conversions
FROM campaign_activity
GROUP BY channel
ORDER BY conversions DESC;
