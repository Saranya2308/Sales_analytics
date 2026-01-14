-- =========================
-- KPI QUERIES (PostgreSQL)
-- Dataset: Superstore (modeled into dimensions + fact)
-- =========================

-- 1) Total Revenue
SELECT ROUND(SUM(sales), 2) AS total_revenue
FROM public.fact_sales;

-- 2) Revenue by Region
SELECT
  o.region,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_orders o ON f.order_id = o.order_id
GROUP BY o.region
ORDER BY revenue DESC;

-- 3) Monthly Revenue Trend
SELECT
  DATE_TRUNC('month', o.order_date) AS month,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_orders o ON f.order_id = o.order_id
GROUP BY 1
ORDER BY 1;

-- 4) Top 10 Customers by Revenue
SELECT
  c.customer_id,
  c.customer_name,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_orders o ON f.order_id = o.order_id
JOIN public.dim_customers c ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY revenue DESC
LIMIT 10;

-- 5) Revenue by Segment
SELECT
  c.segment,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_orders o ON f.order_id = o.order_id
JOIN public.dim_customers c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY revenue DESC;

-- 6) Revenue by Category
SELECT
  p.category,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_products p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 7) Top 10 Sub-Categories by Revenue
SELECT
  p.sub_category,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_products p ON f.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY revenue DESC
LIMIT 10;

-- 8) Ship Mode Mix (Order Count)
SELECT
  ship_mode,
  COUNT(*) AS order_count
FROM public.dim_orders
GROUP BY ship_mode
ORDER BY order_count DESC;

-- 9) Average Shipping Delay (days)
SELECT
  ROUND(AVG(o.ship_date - o.order_date), 2) AS avg_days_to_ship
FROM public.dim_orders o
WHERE o.ship_date IS NOT NULL AND o.order_date IS NOT NULL;

-- 10) Revenue by State (Top 10)
SELECT
  l.state,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_locations l
  ON f.postal_code = l.postal_code
GROUP BY l.state
ORDER BY revenue DESC
LIMIT 10;

-- 11) Revenue by City (Top 10)
SELECT
  l.city,
  l.state,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_locations l
  ON f.postal_code = l.postal_code
GROUP BY l.city, l.state
ORDER BY revenue DESC
LIMIT 10;

-- 12) Customer “LTV proxy” (Total Sales per Customer) + Top 10
SELECT
  c.customer_id,
  c.customer_name,
  ROUND(SUM(f.sales), 2) AS lifetime_sales
FROM public.fact_sales f
JOIN public.dim_orders o ON f.order_id = o.order_id
JOIN public.dim_customers c ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY lifetime_sales DESC
LIMIT 10;

-- 13) High-Value Customers (>= $5,000 total sales)
SELECT
  c.customer_id,
  c.customer_name,
  ROUND(SUM(f.sales), 2) AS revenue
FROM public.fact_sales f
JOIN public.dim_orders o ON f.order_id = o.order_id
JOIN public.dim_customers c ON o.customer_id = c.customer_id
GROUP BY 1,2
HAVING SUM(f.sales) >= 5000
ORDER BY revenue DESC;

-- 14) Data Quality: Fact rows with missing dimension references (should be 0)
SELECT
  (SELECT COUNT(*) FROM public.fact_sales f
   LEFT JOIN public.dim_products p ON f.product_id = p.product_id
   WHERE p.product_id IS NULL) AS missing_products,
  (SELECT COUNT(*) FROM public.fact_sales f
   LEFT JOIN public.dim_orders o ON f.order_id = o.order_id
   WHERE o.order_id IS NULL) AS missing_orders;

-- 15) Contribution %: Revenue by Region
WITH region_rev AS (
  SELECT o.region, SUM(f.sales) AS revenue
  FROM public.fact_sales f
  JOIN public.dim_orders o ON f.order_id = o.order_id
  GROUP BY o.region
),
total AS (
  SELECT SUM(revenue) AS total_revenue FROM region_rev
)
SELECT
  r.region,
  ROUND(r.revenue, 2) AS revenue,
  ROUND(100.0 * r.revenue / t.total_revenue, 2) AS pct_of_total
FROM region_rev r
CROSS JOIN total t
ORDER BY revenue DESC;
