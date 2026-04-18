SELECT 
    f.title, 
    f.description, 
    l.name AS language_name
FROM film f
JOIN language l ON f.language_id = l.language_id
LIMIT 300;