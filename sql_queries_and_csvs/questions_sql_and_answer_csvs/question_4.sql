/* Q4. Create a view where the rows are the store types and the columns are the total sales, 
percentage of total sales and the count of orders */

/* Run the below query first to create the view store_peformance.
Then run the 2nd statement to see the results. */

CREATE OR REPLACE VIEW store_performance AS
SELECT
    store_type,
    ROUND(SUM(product_quantity * sale_price)::numeric, 2) AS total_sales,
    ROUND(SUM(product_quantity * sale_price)::numeric * 100 / SUM(SUM(product_quantity * sale_price)) OVER ()::numeric, 2) AS "percentage_of_total_sales",
    COUNT(order_date) AS count_of_orders
FROM 
    orders
JOIN 
    dim_products ON orders.product_code = dim_products.product_code
JOIN
    dim_stores ON orders.store_code = dim_stores.store_code
GROUP BY 
    store_type
ORDER BY 
    "percentage_of_total_sales" DESC;


SELECT * FROM store_performance