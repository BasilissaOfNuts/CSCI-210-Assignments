UPDATE rental
SET return_date = '2023-05-08',
    last_update = CURRENT_TIMESTAMP
WHERE return_date IS NULL;