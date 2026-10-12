-- customer_transaction_analysis.sql
-- Business question: Who are our high-value, recurring customers, and how
-- can transaction activity be summarized for business reporting?

-- Customer details alongside each of their transactions (JOIN)
SELECT
    c.customer_id,
    c.cust_name,
    c.city,
    t.transaction_id,
    t.tran_date,
    t.total_amt
FROM customer AS c
JOIN transactions AS t
  ON c.customer_id = t.cust_id;

-- Valid (non-return) transactions, tagged by value tier (WHERE + CASE)
SELECT
    c.cust_name,
    t.total_amt,
    CASE
        WHEN t.total_amt > 5000 THEN 'High'
        WHEN t.total_amt BETWEEN 1000 AND 5000 THEN 'Medium'
        ELSE 'Low'
    END AS transaction_tier
FROM customer AS c
JOIN transactions AS t
  ON c.customer_id = t.cust_id
WHERE t.total_amt > 0;

-- High-value customers: total spend above the overall average (GROUP BY + HAVING)
SELECT
    c.cust_name,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.total_amt)        AS total_spend
FROM customer AS c
JOIN transactions AS t
  ON c.customer_id = t.cust_id
WHERE t.total_amt > 0
GROUP BY c.cust_name
HAVING SUM(t.total_amt) > (
    SELECT AVG(total_amt) FROM transactions WHERE total_amt > 0
)
ORDER BY total_spend DESC;

-- Recurring customers: 3 or more transactions
SELECT
    c.cust_name,
    COUNT(t.transaction_id) AS transaction_count
FROM customer AS c
JOIN transactions AS t
  ON c.customer_id = t.cust_id
GROUP BY c.cust_name
HAVING COUNT(t.transaction_id) >= 3
ORDER BY transaction_count DESC;

-- Business reporting summary: one row per customer with key metrics
SELECT
    c.cust_name,
    c.city,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(CASE WHEN t.total_amt > 0 THEN t.total_amt ELSE 0 END) AS gross_spend,
    ROUND(AVG(CASE WHEN t.total_amt > 0 THEN t.total_amt END), 2) AS avg_transaction_value
FROM customer AS c
JOIN transactions AS t
  ON c.customer_id = t.cust_id
GROUP BY c.cust_name, c.city
ORDER BY gross_spend DESC;
