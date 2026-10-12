# Customer Transaction Analysis

SQL analysis of a retail transactions dataset to identify high-value customers, recurring buyers, and produce a business reporting summary.

## Business Questions

- What does the overall business look like (revenue, orders, customers, average order value)?
- Who are the top customers, and how much revenue comes from the top 10% of customers?
- Which customers buy repeatedly, and how do one-time buyers compare with repeat buyers?
- Which sales channels and product categories bring the most revenue?
- How does performance change month to month?

## Dataset / Schema

- `customer` — customer_id, cust_name, dob, gender, city
- `transactions` — transaction_id, cust_id, tran_date, total_amt, store_type, prod_cat_code, prod_subcat_code, qty
- `product_category` — prod_cat_code, prod_subcat_code, category_name

## What the SQL file covers

| # | Analysis | SQL concepts used |
|---|----------|-------------------|
| 1 | Business summary (revenue, orders, customers, AOV) | Aggregation, DISTINCT |
| 2 | Top 10 high-value customers | JOIN, GROUP BY, ORDER BY, LIMIT |
| 3 | Spend deciles (Pareto check) | CTE, NTILE, window functions |
| 4 | Recurring buyers (3+ active months) | HAVING, DATE_FORMAT |
| 5 | One-time vs repeat customers | CASE, subquery |
| 6 | Revenue by sales channel | Window function for % share |
| 7 | Revenue by product category | Multi-column JOIN |
| 8 | Monthly business report | Date grouping |

All queries are in `customer_transaction_analysis.sql`.

## Tools

SQL (MySQL 8)

## How to run

1. Load the three tables into MySQL.
2. Open `customer_transaction_analysis.sql`.
3. Run the queries one by one.

## Author

Rohit Rajput — [GitHub](https://github.com/Rohit-1209-code) · [LinkedIn](www.linkedin.com/in/rohit-rajput-701641417)
