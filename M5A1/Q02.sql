INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date, last_update)
SELECT 
	customer_id, 
	staff_id, 
	16050, 
	4.99, 
	'2023-05-05', 
	'2023-05-05'
FROM 
	rental
WHERE 
	rental_id = 16050;