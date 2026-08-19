# Customer Transaction Analysis

SQL analysis of customer transactions to identify high-value customers, recurring purchase patterns, and a business-ready reporting summary.

## Business Questions
- Which customers are high-value (spending above average)?
- Which customers are recurring/repeat buyers?
- How can transaction activity be summarized per customer for reporting?

## Schema
- `customer` — customer_id, cust_name, city
- `transactions` — transaction_id, cust_id, tran_date, total_amt

## File
`customer_transaction_analysis.sql` — covers:
- JOIN — combining customer details with their transactions
- WHERE + CASE — filtering valid transactions and tagging by value tier
- GROUP BY + HAVING — high-value and recurring customers
- Aggregate functions (COUNT, SUM, AVG) — a per-customer summary report
