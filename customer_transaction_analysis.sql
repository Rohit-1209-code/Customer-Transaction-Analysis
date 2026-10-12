-- ============================================================
-- Customer Transaction Analysis  (MySQL 8+)
-- Tables: customer, transactions, product_category
-- Note: if your data has returns (negative qty / total_amt),
-- add  WHERE total_amt > 0  to the queries below for sales-only numbers.
-- ============================================================

-- 1. Business summary (overall health of the business)
SELECT
    COUNT(DISTINCT transaction_id)                              AS total_transactions,
    COUNT(DISTINCT cust_id)                                     AS total_customers,
    SUM(qty)                                                    AS total_units,
    ROUND(SUM(total_amt), 2)                                    AS total_revenue,
    ROUND(SUM(total_amt) / COUNT(DISTINCT transaction_id), 2)   AS avg_order_value
FROM transactions;


-- 2. Top 10 high-value customers by total spend
SELECT
    c.customer_id,
    c.cust_name,
    c.city,
    COUNT(DISTINCT t.transaction_id)  AS orders,
    ROUND(SUM(t.total_amt), 2)        AS total_spend,
    ROUND(AVG(t.total_amt), 2)        AS avg_order_value
FROM transactions t
JOIN customer c ON c.customer_id = t.cust_id
GROUP BY c.customer_id, c.cust_name, c.city
ORDER BY total_spend DESC
LIMIT 10;


-- 3. Spend deciles: how much revenue comes from the top 10% customers (Pareto check)
WITH spend AS (
    SELECT cust_id, SUM(total_amt) AS total_spend
    FROM transactions
    GROUP BY cust_id
),
ranked AS (
    SELECT cust_id, total_spend,
           NTILE(10) OVER (ORDER BY total_spend DESC) AS decile
    FROM spend
)
SELECT
    decile,
    COUNT(*)                                                         AS customers,
    ROUND(SUM(total_spend), 2)                                       AS revenue,
    ROUND(100 * SUM(total_spend) / SUM(SUM(total_spend)) OVER (), 2) AS revenue_pct
FROM ranked
GROUP BY decile
ORDER BY decile;


-- 4. Recurring buyers: customers who bought in 3 or more different months
SELECT
    cust_id,
    COUNT(DISTINCT transaction_id)                  AS orders,
    COUNT(DISTINCT DATE_FORMAT(tran_date, '%Y-%m')) AS active_months,
    MIN(tran_date)                                  AS first_purchase,
    MAX(tran_date)                                  AS last_purchase,
    ROUND(SUM(total_amt), 2)                        AS total_spend
FROM transactions
GROUP BY cust_id
HAVING COUNT(DISTINCT DATE_FORMAT(tran_date, '%Y-%m')) >= 3
ORDER BY active_months DESC, total_spend DESC;


-- 5. One-time vs repeat customers
SELECT
    CASE WHEN orders = 1 THEN 'One-time' ELSE 'Repeat' END AS buyer_type,
    COUNT(*)                                               AS customers,
    ROUND(SUM(spend), 2)                                   AS revenue
FROM (
    SELECT cust_id,
           COUNT(DISTINCT transaction_id) AS orders,
           SUM(total_amt)                 AS spend
    FROM transactions
    GROUP BY cust_id
) x
GROUP BY buyer_type;


-- 6. Revenue by sales channel (store_type)
SELECT
    store_type,
    COUNT(DISTINCT transaction_id)                                   AS orders,
    ROUND(SUM(total_amt), 2)                                         AS revenue,
    ROUND(100 * SUM(total_amt) / SUM(SUM(total_amt)) OVER (), 2)     AS revenue_pct
FROM transactions
GROUP BY store_type
ORDER BY revenue DESC;


-- 7. Revenue by product category
SELECT
    p.category_name,
    SUM(t.qty)                  AS units_sold,
    ROUND(SUM(t.total_amt), 2)  AS revenue
FROM transactions t
JOIN product_category p
  ON  t.prod_cat_code    = p.prod_cat_code
  AND t.prod_subcat_code = p.prod_subcat_code
GROUP BY p.category_name
ORDER BY revenue DESC;


-- 8. Monthly business report (summary for reporting)
SELECT
    DATE_FORMAT(tran_date, '%Y-%m')                             AS month,
    COUNT(DISTINCT transaction_id)                              AS orders,
    COUNT(DISTINCT cust_id)                                     AS active_customers,
    ROUND(SUM(total_amt), 2)                                    AS revenue,
    ROUND(SUM(total_amt) / COUNT(DISTINCT transaction_id), 2)   AS avg_order_value
FROM transactions
GROUP BY DATE_FORMAT(tran_date, '%Y-%m')
ORDER BY month;
