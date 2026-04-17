INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id, last_update)
VALUES (
    '2023-05-05',
    (
        -- Find lowest inventory_id for "Panic Club" at store 1 that is not currently out
        SELECT 
        	MIN(i.inventory_id)
        FROM 
        	inventory i
        JOIN film f ON i.film_id = f.film_id
        LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL -- Preserve the table
        WHERE f.title = 'PANIC CLUB'
          AND i.store_id = 1
          AND r.rental_id IS NULL
    ),
    (
        -- Find the customer_id for Rodney Moeller
        SELECT 
        	c.customer_id 
        FROM 
        	customer c 
        WHERE first_name = 'RODNEY' AND last_name = 'MOELLER'
    ),
    1,
    '2023-05-05'
);