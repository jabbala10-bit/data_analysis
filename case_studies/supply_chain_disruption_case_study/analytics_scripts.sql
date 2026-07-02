-- Supply chain disruption analysis
SELECT
    supplier_id,
    COUNT(*) AS incident_count,
    AVG(delivery_delay_days) AS avg_delay_days
FROM supply_chain_events
GROUP BY supplier_id
ORDER BY avg_delay_days DESC;
