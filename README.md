# Sales_analytics

# Sales & Operations Analytics Dashboard

Overview
This project demonstrates an end-to-end data analytics workflow using real-world sales data. 
The objective is to model transactional data, generate key business KPIs using SQL, and present insights through an executive-level Power BI dashboard.

Dataset
- Source: Public sales dataset (CSV format)
- Records: ~9,800 sales transactions
- Data was cleaned and modeled into fact and dimension tables.

Data Model
A star schema was implemented to support analytical queries:

Fact Table
  - fact_sales (sales amount, order_id, product_id, customer_id)

Dimension Tables
  - dim_customers
  - dim_orders
  - dim_products
  - dim_locations (not used in dashboard visuals)

Relationships were validated to ensure accurate aggregations.

Key KPIs (SQL & Power BI)
- Total Revenue
- Total Orders
- Total Customers
- Average Shipping Days

Power BI Dashboard
The Power BI dashboard provides a one-page executive view of:
- Revenue by Region
- Monthly Revenue Trends
- Revenue by Product Category
- Top Customers by Revenue

[Power BI Dashboard]

Tools & Technologies
- PostgreSQL (data modeling & SQL analysis)
- Power BI (data visualization)
- GitHub (version control)

Key Takeaways
- The West region generates the highest revenue.
- Furniture is the top-performing product category.
- Average shipping time is under 4 days, indicating efficient operations.

How to Run
1. Load the CSV files into PostgreSQL.
2. Execute the SQL scripts in the `sql/` folder.
3. Open the Power BI file or review the dashboard screenshot.

