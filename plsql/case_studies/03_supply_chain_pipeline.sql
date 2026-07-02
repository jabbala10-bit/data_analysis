-- Case Study 3: Supply chain pipeline
-- Step 1: Standardize delivery dates
UPDATE supply_chain_events
SET delivery_date = TRUNC(delivery_date)
WHERE delivery_date IS NOT NULL;

-- Step 2: Report disruption severity
SELECT supplier_id, COUNT(*) AS incident_count
FROM supply_chain_events
GROUP BY supplier_id
ORDER BY incident_count DESC;
