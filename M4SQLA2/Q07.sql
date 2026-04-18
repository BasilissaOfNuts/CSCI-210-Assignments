SELECT 
    a.first_name, 
    a.last_name, 
    COUNT(fa.film_id) AS film_count
FROM 
	actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY 
	a.actor_id, a.first_name, a.last_name;