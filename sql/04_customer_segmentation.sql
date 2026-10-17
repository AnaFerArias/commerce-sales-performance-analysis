-- =====================================================================
-- 04_customer_segmentation.sql
-- Block 3 · Customers: who generates the revenue?
-- Segments by cumulative spend (completed orders only):
--   Basic < 500 € · Regular 500 € – 1,500 € · VIP > 1,500 €
-- =====================================================================

-- Q: How are customers and revenue distributed by spend level?
-- Result: Basic 91 customers (25,395 € · 16.1%)
--         Regular 88 customers (73,235 € · 46.5%)
--         VIP 30 customers (58,835 € · 37.4%)
-- Insight: 30 VIP customers (14% of identified customers) generate 37% of attributable revenue.
WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_spent
    FROM transactions
    WHERE order_status = 'completed'
      AND customer_id IS NOT NULL
    GROUP BY customer_id
),
segmented AS (
    SELECT
        customer_id,
        total_spent,
        CASE
            WHEN total_spent > 1500 THEN 'VIP'
            WHEN total_spent > 500  THEN 'Regular'
            ELSE 'Basic'
        END AS customer_type
    FROM customer_spending
)
SELECT
    customer_type,
    COUNT(*)          AS num_customers,
    SUM(total_spent)  AS revenue,
    ROUND(100.0 * SUM(total_spent) / SUM(SUM(total_spent)) OVER (), 1) AS pct_revenue
FROM segmented
GROUP BY customer_type
ORDER BY revenue DESC;


-- Customer-level table used as the "Customer Segmentation" source in Tableau
-- Result: 209 rows (one per identified customer with completed orders)
WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(total_amount) AS total_spent
    FROM transactions
    WHERE order_status = 'completed'
      AND customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_spent,
    CASE
        WHEN total_spent > 1500 THEN 'VIP'
        WHEN total_spent > 500  THEN 'Regular'
        ELSE 'Basic'
    END AS customer_type
FROM customer_spending
ORDER BY customer_id;
