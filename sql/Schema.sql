-- Drop & recreate schema (clean runs)
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_orders;
DROP TABLE IF EXISTS dim_locations;
DROP TABLE IF EXISTS dim_products;
DROP TABLE IF EXISTS dim_customers;

CREATE TABLE dim_customers (
  customer_id   TEXT PRIMARY KEY,
  customer_name TEXT,
  segment       TEXT
);

CREATE TABLE dim_products (
  product_id    TEXT PRIMARY KEY,
  product_name  TEXT,
  category      TEXT,
  sub_category  TEXT
);

CREATE TABLE dim_locations (
  location_id   BIGSERIAL PRIMARY KEY,
  country       TEXT,
  region        TEXT,
  state         TEXT,
  city          TEXT,
  postal_code   TEXT
);

CREATE TABLE dim_orders (
  order_id     TEXT PRIMARY KEY,
  order_date   DATE,
  ship_date    DATE,
  ship_mode    TEXT,
  customer_id  TEXT REFERENCES dim_customers(customer_id),
  region       TEXT
);

CREATE TABLE fact_sales (
  row_id      INTEGER PRIMARY KEY,
  order_id    TEXT REFERENCES dim_orders(order_id),
  product_id  TEXT REFERENCES dim_products(product_id),
  sales       NUMERIC(12,2),
  postal_code TEXT
);

CREATE INDEX idx_fact_sales_order   ON fact_sales(order_id);
CREATE INDEX idx_fact_sales_product ON fact_sales(product_id);
CREATE INDEX idx_orders_customer    ON dim_orders(customer_id);
CREATE INDEX idx_orders_order_date  ON dim_orders(order_date);
