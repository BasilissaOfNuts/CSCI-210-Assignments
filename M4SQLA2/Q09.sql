SELECT 
	c.city
FROM 
	city c
JOIN country co ON c.country_id = co.country_id
WHERE 
	co.country IN ('France', 'Italy', 'Japan', 'Mexico', 'Turkey');