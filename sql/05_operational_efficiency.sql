-- =====================================================================
-- 05_operational_efficiency.sql
-- Block 4 · Operations: how efficient is the business?
-- =====================================================================

-- Q: What are the return and cancellation rates?
-- Result: completed 578 (57.8%) · returned 241 (24.1%) · cancelled 177 (17.7%) · NULL 4 (0.4%)
SELECT
    order_status,
    COUNT(*) AS num_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentage
FROM transactions
GROUP BY order_status
ORDER BY num_orders DESC;


-- Q: How much revenue is lost through cancellations and returns?
-- Result: cancelled 46,650 € (177 orders, avg 266.57 €)
--         returned  67,605 € (241 orders, avg 281.69 €)
--         Total lost: 114,255 € = 40% of gross revenue (288,140 €)
SELECT
    order_status,
    COUNT(*)                     AS num_orders,
    SUM(total_amount)            AS lost_revenue,
    ROUND(AVG(total_amount), 2)  AS avg_ticket
FROM transactions
WHERE order_status IN ('cancelled', 'returned')
GROUP BY order_status;


-- Q: Which category has the highest cancellation and return rates?
-- Result: Clothing has the highest return rate (28.3%);
--         Sports the highest cancellation rate (21.3%)
SELECT
    p.product_category,
    COUNT(*) AS num_orders,
    ROUND(100.0 * AVG(CASE WHEN t.order_status = 'cancelled' THEN 1 ELSE 0 END), 1) AS cancel_rate,
    ROUND(100.0 * AVG(CASE WHEN t.order_status = 'returned'  THEN 1 ELSE 0 END), 1) AS return_rate
FROM transactions AS t
INNER JOIN products AS p
    USING (product_id)
WHERE t.order_status IS NOT NULL
GROUP BY p.product_category
ORDER BY return_rate DESC;


-- Q: Do the rates vary by channel?
-- Result: cancellations are similar across channels (Store 19.0% · Mobile 17.9% · Online 17.4%),
--         so the problem is not specific to the online channels.
--         Returns: Mobile 25.8% · Online 24.2% · Store 21.1%
SELECT
    payment_channel,
    ROUND(100.0 * AVG(CASE WHEN order_status = 'cancelled' THEN 1 ELSE 0 END), 1) AS cancel_rate,
    ROUND(100.0 * AVG(CASE WHEN order_status = 'returned'  THEN 1 ELSE 0 END), 1) AS return_rate
FROM transactions
WHERE order_status IS NOT NULL
  AND payment_channel IS NOT NULL
GROUP BY payment_channel
ORDER BY cancel_rate DESC;
