-- =====================================================================
-- 01_data_quality.sql
-- Data quality checks before the analysis
-- =====================================================================

-- Q: How many NULL values are there in each column of transactions?
-- Result: customer_id 82 (8.2%) · product_id 10 · date 10 · total_amount 10
--         payment_channel 4 · order_status 4 · payment_method 4 (out of 1000 rows)
SELECT
    COUNT(*)                          AS total_rows,
    COUNT(*) - COUNT(customer_id)     AS null_customer_id,
    COUNT(*) - COUNT(product_id)      AS null_product_id,
    COUNT(*) - COUNT(date)            AS null_date,
    COUNT(*) - COUNT(total_amount)    AS null_total_amount,
    COUNT(*) - COUNT(payment_channel) AS null_payment_channel,
    COUNT(*) - COUNT(order_status)    AS null_order_status,
    COUNT(*) - COUNT(payment_method)  AS null_payment_method
FROM transactions;


-- Q: How many customers have no city informed?
-- Result: 7 out of 260 (2.7%)
SELECT
    COUNT(*)                 AS total_customers,
    COUNT(*) - COUNT(city)   AS null_city
FROM customers;


-- Q: Are there duplicated transaction IDs?
-- Result: 0 rows (no duplicates)
SELECT transaction_id, COUNT(*) AS times
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- Q: Are there transactions outside the analysed period (2023)?
-- Result: 2 transactions dated 2024-01-01 (1 completed for 120 €, 1 cancelled).
--         Kept in the dataset and reported as an outlier.
SELECT *
FROM transactions
WHERE date < '2023-01-01'
   OR date >= '2024-01-01';


-- Q: How much completed revenue cannot be attributed to a customer?
-- Result: 15,520 € (9% of the completed revenue)
SELECT
    SUM(total_amount) AS revenue_without_customer,
    ROUND(100.0 * SUM(total_amount)
          / (SELECT SUM(total_amount) FROM transactions WHERE order_status = 'completed'), 1) AS pct_of_revenue
FROM transactions
WHERE order_status = 'completed'
  AND customer_id IS NULL;
