/* Top 10 Customers By revenue and profit */

SELECT 
    l.customer_name,
    SUM(d.amount) AS total_revenue,
    SUM(d.profit) AS total_profit
FROM list_of_orders l
JOIN order_details d
ON l.order_id = d.order_id
GROUP BY l.customer_name
ORDER BY total_revenue DESC,total_profit DESC
LIMIT 10;

/*Category Performance (Revenue vs Profit) */
SELECT 
    category,
    SUM(amount) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit)/SUM(amount)*100,2) AS profit_margin_pct
FROM order_details
GROUP BY category
ORDER BY total_profit DESC;

/* State Wise sales performance */
SELECT 
    l.state_name,
    SUM(d.amount) AS total_sales,
    SUM(d.profit) AS total_profit
FROM list_of_orders l
JOIN order_details d
ON l.order_id = d.order_id
GROUP BY l.state_name
ORDER BY total_sales DESC;

/*Top Cities by Profit*/
SELECT 
    l.city,
    SUM(d.profit) AS total_profit
FROM list_of_orders l
JOIN order_details d
ON l.order_id = d.order_id
GROUP BY l.city
ORDER BY total_profit DESC
LIMIT 10;

/*Loss-Making Products*/
SELECT 
    sub_category,
    SUM(profit) AS total_profit
FROM order_details
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

/*Monthly Sales Trend*/
SELECT 
    TO_CHAR(order_date, 'Mon-YYYY') AS month,
    SUM(d.amount) AS total_sales
FROM list_of_orders l
JOIN order_details d
ON l.order_id = d.order_id
GROUP BY month
ORDER BY MIN(order_date);

/*Target vs Actual Performance*/
SELECT 
    t.month_of_order_date,
    t.category,
    t.target,
    COALESCE(a.actual_sales, 0) AS actual_sales,
    COALESCE(a.actual_sales, 0) - t.target AS difference
FROM sales_target t
LEFT JOIN (
    SELECT 
        TO_CHAR(order_date, 'Mon-YY') AS month,
        d.category,
        SUM(d.amount) AS actual_sales
    FROM list_of_orders l
    JOIN order_details d
    ON l.order_id = d.order_id
    GROUP BY month, d.category
) a
ON t.month_of_order_date = a.month
AND t.category = a.category;

/*High-Value Orders*/
SELECT *
FROM order_details
WHERE amount > (
    SELECT AVG(amount) FROM order_details
);

/* Business View */
CREATE VIEW customer_summary AS
SELECT 
    l.customer_name,
    SUM(d.amount) AS total_spent,
    SUM(d.profit) AS total_profit
FROM list_of_orders l
JOIN order_details d
ON l.order_id = d.order_id
GROUP BY l.customer_name;

SELECT * FROM customer_summary
ORDER BY total_spent DESC;

/* Customer Segmentation */
SELECT 
    customer_name,
    SUM(amount) AS total_spent,
    CASE 
        WHEN SUM(amount) > 10000 THEN 'High Value'
        WHEN SUM(amount) BETWEEN 5000 AND 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM list_of_orders l
JOIN order_details d
ON l.order_id = d.order_id
GROUP BY customer_name
ORDER BY total_spent DESC;