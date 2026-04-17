SELECT 
	DISTINCT a.*
FROM 
	actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE 
	f.rental_rate = 0.99;