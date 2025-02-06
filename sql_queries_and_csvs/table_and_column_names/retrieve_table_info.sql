-- Query to retrieve table names from a database.

SELECT 
    table_name
FROM 
    information_schema.tables
WHERE 
    table_type='BASE TABLE'
    AND table_schema='public';



-- Query to retrieve columns names from a table.

SELECT
    column_name
FROM
    information_schema.columns
WHERE
    table_name = 'orders';


