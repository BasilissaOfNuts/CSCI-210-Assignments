SELECT 
	DISTINCT r.customer_id
FROM 
	film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE 
	f.title = 'MONTEZUMA COMMAND';