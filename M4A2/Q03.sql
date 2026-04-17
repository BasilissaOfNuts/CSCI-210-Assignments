SELECT 
	r.*, 
	i.*
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NULL 
  AND i.store_id = 1;