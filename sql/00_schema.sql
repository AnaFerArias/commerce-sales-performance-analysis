-- =====================================================================
-- 00_schema.sql
-- Commerce Sales Performance Analysis · PostgreSQL
-- Database: commerce_retail_sales
-- Creates the 3 tables and loads the CSV files from /data
-- =====================================================================

-- ---------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

CREATE TABLE customers (
    customer_id        VARCHAR(10) PRIMARY KEY,
    gender             VARCHAR(10),
    age                INTEGER,
    city               VARCHAR(50),
    subscribed         BOOLEAN,
    registration_date  DATE
);

CREATE TABLE products (
    product_id         VARCHAR(10) PRIMARY KEY,
    product_category   VARCHAR(20),
    price_segment      VARCHAR(20),
    base_price         NUMERIC(10,2)
);

-- customer_id and product_id contain controlled NULLs,
-- so no foreign key constraints are enforced on this table.
CREATE TABLE transactions (
    transaction_id     INTEGER PRIMARY KEY,
    date               DATE,
    week_day           INTEGER,
    customer_id        VARCHAR(10),
    product_id         VARCHAR(10),
    quantity           INTEGER,
    price_per_unit     NUMERIC(10,2),
    total_amount       NUMERIC(10,2),
    payment_channel    VARCHAR(10),   -- online / mobile / store
    order_status       VARCHAR(10),   -- completed / cancelled / returned
    payment_method     VARCHAR(10)
);

-- ---------------------------------------------------------------------
-- Data load
-- The CSV files use ";" as delimiter and include a header row.
-- Replace <path> with the local path to the /data folder.
-- (In pgAdmin you can also use: right click on the table > Import/Export Data)
-- ---------------------------------------------------------------------

COPY customers    FROM '<path>/customers_table.csv'    WITH (FORMAT csv, HEADER true, DELIMITER ';');
COPY products     FROM '<path>/products_table.csv'     WITH (FORMAT csv, HEADER true, DELIMITER ';');
COPY transactions FROM '<path>/transactions_table.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';');

-- ---------------------------------------------------------------------
-- Load check
-- Expected: customers 260 · products 175 · transactions 1000
-- ---------------------------------------------------------------------

SELECT 'customers' AS table_name, COUNT(*) AS num_rows FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions;
