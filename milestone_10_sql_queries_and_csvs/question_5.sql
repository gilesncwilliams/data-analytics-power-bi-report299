-- Q5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021?


SELECT 
       category, 
       (SUM(product_quantity) * SUM(sale_price - cost_price))::numeric AS profit
FROM 
    orders
JOIN
    dim_date on orders.order_date = dim_date.date
JOIN 
    dim_products ON orders.product_code = dim_products.product_code
JOIN
    dim_stores ON orders.store_code = dim_stores.store_code
WHERE
    year = 2021
    AND geography = 'Wiltshire, United Kingdom'
GROUP BY
    category
ORDER BY
    profit DESC;



