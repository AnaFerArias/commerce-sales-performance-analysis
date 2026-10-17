-- =====================================================================
-- 03_revenue_drivers.sql
-- Block 2 · Revenue drivers: where does the revenue come from?
-- =====================================================================

-- Q: Which product categories generate the most revenue?
-- Result: Electronics 68,420 € (39.6%) · Clothing 43,935 € · Sports 41,115 € · Beauty 19,515 €
SELECT
    p.product_category,
    COUNT(*)                     AS num_orders,
    SUM(t.total_amount)          AS total_revenue,
    ROUND(AVG(t.total_amount), 2) AS avg_ticket
FROM transactions AS t
INNER JOIN products AS p
    USING (product_id)
WHERE t.order_status = 'completed'
GROUP BY p.product_category
ORDER BY total_revenue DESC;


-- Q: Which price segments generate the most revenue?
-- Result: Medium 50,625 € · Premium 49,220 € · Medium-Premium 38,895 €
--         · Low-Medium 23,595 € · Low 10,650 €
SELECT
    p.price_segment,
    SUM(t.total_amount) AS total_revenue
FROM transactions AS t
INNER JOIN products AS p
    USING (product_id)
WHERE t.order_status = 'completed'
GROUP BY p.price_segment
ORDER BY total_revenue DESC;


-- Q: Which sales channel generates the most revenue?
-- Result: Online 95,870 € (55.4%) · Mobile 52,690 € (30.5%) · Store 24,425 €
SELECT
    payment_channel,
    SUM(total_amount) AS total_sales
FROM transactions
WHERE order_status = 'completed'
GROUP BY payment_channel
ORDER BY total_sales DESC;


-- Q: Which cities concentrate the highest sales volume?
-- Result: Barcelona 22,485 € · Madrid 21,980 € · Londres 18,930 € · Paris 11,480 € · New York 10,380 €
-- Note: 23,560 € of revenue has no known city (NULL customer or NULL city)
SELECT
    c.city,
    SUM(t.total_amount) AS total_revenue
FROM transactions AS t
INNER JOIN customers AS c
    USING (customer_id)
WHERE t.order_status = 'completed'
GROUP BY c.city
ORDER BY total_revenue DESC;
