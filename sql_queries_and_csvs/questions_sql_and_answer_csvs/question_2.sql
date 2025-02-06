-- Q2. Which month in 2022 has had the highest revenue?

SELECT ROUND(SUM(product_quantity * sale_price)::numeric, 2) AS total_sales,
       month_name
FROM 
    orders
JOIN 
    dim_date ON orders.order_date = dim_date.date
JOIN 
    dim_products ON orders.product_code = dim_products.product_code
WHERE
    year = 2022
GROUP BY
    month_name
ORDER BY 
    total_sales DESC
LIMIT 
    1;