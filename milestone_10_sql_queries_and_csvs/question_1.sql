-- Q1. How many staff are there in all of the UK stores?

SELECT
    country_code,
    SUM(staff_numbers) as total_staff_numbers
FROM 
    dim_stores
WHERE
    country_code = 'GB'
GROUP BY
    country_code;

