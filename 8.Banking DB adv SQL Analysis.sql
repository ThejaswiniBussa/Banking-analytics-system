use Bankingdb;

-- 1. INNER JOIN

-- Find customer details with their account information
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    a.account_id,
    a.account_type,
    a.balance_usd
FROM Customers c
INNER JOIN Accounts a
ON c.customer_id = a.customer_id;

-- Find transactions with merchant names
SELECT
    t.transaction_id,
    m.merchant_name,
    t.amount_usd,
    t.transaction_date
FROM Transactions t
INNER JOIN Merchants m
ON t.merchant_id = m.merchant_id;


-- 2. LEFT JOIN

-- Customers without accounts
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM Customers c
LEFT JOIN Accounts a
ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL;

-- Accounts without cards
SELECT
    a.account_id,
    a.account_type
FROM Accounts a
LEFT JOIN Cards c
ON a.account_id = c.account_id
WHERE c.card_id IS NULL;


-- 3.GROUP BY

-- Number of customers by city
SELECT
    city,
    COUNT(*) AS Total_Customers
FROM Customers
GROUP BY city
ORDER BY Total_Customers DESC;

-- Total balance by account type
SELECT
    account_type,
    SUM(balance_usd) AS Total_Balance
FROM Accounts
GROUP BY account_type;


-- 4.HAVING

-- Cities having more than 50 customers
SELECT
    city,
    COUNT(*) AS Total_Customers
FROM Customers
GROUP BY city
HAVING COUNT(*) > 50;

-- Account types with average balance greater than $5,000
SELECT
    account_type,
    AVG(balance_usd) AS Avg_Balance
FROM Accounts
GROUP BY account_type
HAVING AVG(balance_usd) > 5000;


-- 5. CASE STATEMENT

-- Categorize customers by credit score

SELECT
    customer_id,
    credit_score,
    CASE
        WHEN credit_score >= 750 THEN 'Excellent'
        WHEN credit_score >= 650 THEN 'Good'
        WHEN credit_score >= 550 THEN 'Fair'
        ELSE 'Poor'
    END AS Credit_Category
FROM Customers;

-- Categorize transaction amount
SELECT
    transaction_id,
    amount_usd,
    CASE
        WHEN amount_usd < 100 THEN 'Low'
        WHEN amount_usd BETWEEN 100 AND 1000 THEN 'Medium'
        ELSE 'High'
    END AS Transaction_Size
FROM Transactions;


-- 6. CTE (COMMON TABLE EXPRESSIONS)

-- Top 10 customers by account balance
WITH CustomerBalance AS
(
SELECT
    c.customer_id,
    c.first_name,
    SUM(a.balance_usd) AS Total_Balance
FROM Customers c
JOIN Accounts a
ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.first_name
)

SELECT *
FROM CustomerBalance
ORDER BY Total_Balance DESC
LIMIT 10;

-- 7. WINDOW FUNCTIONS

-- Running total of transactions
SELECT
    transaction_id,
    transaction_date,
    amount_usd,
    SUM(amount_usd)
    OVER(ORDER BY transaction_date)
    AS Running_Total
FROM Transactions;

-- Average transaction amount
SELECT
    transaction_id,
    amount_usd,
    AVG(amount_usd)
    OVER()
    AS Overall_Average
FROM Transactions;


-- 8.RANKING FUNCTIONS

-- Rank customers by balance
SELECT
    customer_id,
    balance_usd,
    RANK()
    OVER(ORDER BY balance_usd DESC)
    AS Balance_Rank
FROM Accounts;

-- DENSE RANK-------------------------------------------------
SELECT
    customer_id,
    balance_usd,
    DENSE_RANK() OVER (ORDER BY balance_usd DESC) AS balance_rank
FROM Accounts;               

-- ROW NUMBER
SELECT
    transaction_id,
    amount_usd,
    ROW_NUMBER()
    OVER(ORDER BY amount_usd DESC)
    AS Row_Num
FROM Transactions;


-- 9. AGGREGATE FUNCTIONS

-- Banking KPI's
SELECT
    COUNT(*) AS Transactions,
    SUM(amount_usd) AS Total_Amount,
    AVG(amount_usd) AS Average_Amount,
    MIN(amount_usd) AS Minimum,
    MAX(amount_usd) AS Maximum
FROM Transactions;


-- 10. DATE FUNCTIONS

-- Monthly transactions
SELECT
    YEAR(transaction_date) AS Year,
    MONTH(transaction_date) AS Month,
    COUNT(*) AS Transactions,
    SUM(amount_usd) AS Amount
FROM Transactions
GROUP BY
YEAR(transaction_date),
MONTH(transaction_date)
ORDER BY
Year,
Month;

-- Customers registered each year
SELECT
    YEAR(created_at) AS Year,
    COUNT(*) AS Customers
FROM Customers
GROUP BY YEAR(created_at);


-- 11. SUBQUERIES

-- Customers with above-average balance
SELECT *
FROM Accounts
WHERE balance_usd >
(
SELECT AVG(balance_usd)
FROM Accounts
);

-- Merchants with above-average transaction amount
SELECT *
FROM Merchants
WHERE merchant_id IN
(
SELECT merchant_id
FROM Transactions
GROUP BY merchant_id
HAVING AVG(amount_usd)>
(
SELECT AVG(amount_usd)
FROM Transactions
)
);


-- 12. Complex Business Questions

-- Top 10 customers by total transactions
SELECT
    c.customer_id,
    c.first_name,
    SUM(t.amount_usd) AS Total_Spent
FROM Customers c
JOIN Accounts a
ON c.customer_id=a.customer_id
JOIN Transactions t
ON a.account_id=t.account_id
GROUP BY
c.customer_id,
c.first_name
ORDER BY Total_Spent DESC
LIMIT 10;

-- Top 10 merchants by revenue
SELECT
    m.merchant_name,
    SUM(t.amount_usd) AS Revenue
FROM Merchants m
JOIN Transactions t
ON m.merchant_id=t.merchant_id
GROUP BY m.merchant_name
ORDER BY Revenue DESC
LIMIT 10;

-- Loan distribution by customer city
SELECT
    c.city,
    COUNT(l.loan_id) AS Loans,
    SUM(l.loan_amount) AS Total_Loan
FROM Customers c
JOIN Loans l
ON c.customer_id=l.customer_id
GROUP BY c.city
ORDER BY Total_Loan DESC;



