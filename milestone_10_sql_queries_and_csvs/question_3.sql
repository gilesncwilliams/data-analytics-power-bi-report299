-- Q3. Which German store type had the highest revenue for 2022?

SELECT 
       store_type, 
       ROUND(SUM(product_quantity * sale_price)::numeric, 2) AS total_sales
FROM 
    orders
JOIN 
    dim_date ON orders.order_date = dim_date.date
JOIN 
    dim_products ON orders.product_code = dim_products.product_code
JOIN
    dim_stores ON orders.store_code = dim_stores.store_code
WHERE
    year = 2022
GROUP BY
    store_type
ORDER BY 
    total_sales DESC;