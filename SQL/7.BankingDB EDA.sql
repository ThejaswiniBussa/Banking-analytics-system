use bankingDB;

-- 1.CUSTOMER ANALYSIS

-- TOTAL CUSTOMERS
SELECT COUNT(*) AS Total_Customers
FROM Customers;

-- CUSTOMERS BY CITY
SELECT
    city,
    COUNT(*) AS Total_Customers
FROM Customers
GROUP BY city
ORDER BY Total_Customers DESC;

-- AVERAGE CREDIT SCORE
SELECT
    ROUND(AVG(credit_score),2) AS Average_Credit_Score
FROM Customers;

-- CREDIT SCORE DISTRIBUTION
SELECT
CASE
    WHEN credit_score BETWEEN 300 AND 499 THEN 'Poor'
    WHEN credit_score BETWEEN 500 AND 649 THEN 'Fair'
    WHEN credit_score BETWEEN 650 AND 749 THEN 'Good'
    ELSE 'Excellent'
END AS Credit_Category,
COUNT(*) AS Customers
FROM Customers
GROUP BY Credit_Category;

-- CUSTOMER REGISTRATIONS BY YEAR
SELECT
YEAR(created_at) AS Registration_Year,
COUNT(*) AS Customers
FROM Customers
GROUP BY YEAR(created_at)
ORDER BY Registration_Year;

-- 2. ACCOUNT ANALYSIS

-- TOTAL ANALYSIS
SELECT COUNT(*) AS Total_Accounts
FROM Accounts;

-- ACCOUNTS BY TYPE
SELECT
account_type,
COUNT(*) AS Total_Accounts
FROM Accounts
GROUP BY account_type;

-- TOTAL BANK BALANCE
SELECT
SUM(balance_usd) AS Total_Balance
FROM Accounts;

-- AVG ACCOUNT BALANCE
SELECT
ROUND(AVG(balance_usd),2) AS Average_Balance
FROM Accounts;

-- HIGHEST BALANCE ACCOUNTS--------------
SELECT *
FROM Accounts
ORDER BY balance_usd DESC
LIMIT 10;


-- TRANSACTION ANALYSIS

-- TOTAL TRANSACTIONS
SELECT COUNT(*) AS Total_Transactions
FROM Transactions;

-- TOTAL TRANSACTION VALUE
SELECT
SUM(amount_usd) AS Total_Transaction_Value
FROM Transactions;

-- AVERAGE TRANSACTION AMOUNT
SELECT
ROUND(AVG(amount_usd),2) AS Average_Transaction
FROM Transactions;

-- MONTHLY TRANSACTION TREND
SELECT
YEAR(transaction_date) AS Year,
MONTH(transaction_date) AS Month,
COUNT(*) AS Transactions,
SUM(amount_usd) AS Total_Amount
FROM Transactions
GROUP BY
YEAR(transaction_date),
MONTH(transaction_date)
ORDER BY
Year,Month;

-- LARGEST TRANSACTIONS
SELECT *
FROM Transactions
ORDER BY amount_usd DESC
LIMIT 10;

-- 4. MERCHANT ANALYSIS

-- TRANSACTIONS BY MERCHANT
SELECT
m.merchant_name,
COUNT(*) AS Total_Transactions,
SUM(t.amount_usd) AS Revenue
FROM Transactions t
JOIN Merchants m
ON t.merchant_id=m.merchant_id
GROUP BY m.merchant_name
ORDER BY Revenue DESC;

-- TOP 10 MERCHANTS
SELECT
m.merchant_name,
SUM(t.amount_usd) AS Sales
FROM Transactions t
JOIN Merchants m
ON t.merchant_id=m.merchant_id
GROUP BY m.merchant_name
ORDER BY Sales DESC
LIMIT 10;

-- 5.LOAN ANALYSIS

-- TOTAL LOANS
SELECT COUNT(*) AS Total_Loans
FROM Loans;

-- TOTAL LOAN AMOUNT
SELECT
SUM(loan_amount) AS Total_Loan_Amount
FROM Loans;

-- AVERAGE LOAN AMOUNT
SELECT
ROUND(AVG(loan_amount),2) AS Average_Loan
FROM Loans;

-- LOAN DISTRIBUTION AMOUNT BY INTEREST
SELECT
interest_rate,
COUNT(*) AS Loans
FROM Loans
GROUP BY interest_rate
ORDER BY interest_rate;

-- 6.CARD ANALYSIS

-- CARDS BY TYPE
SELECT
card_type,
COUNT(*) AS Total_Cards
FROM Cards
GROUP BY card_type;

-- CARDS EXPIRY BY YEAR
SELECT
YEAR(expiration_date) AS Expiry_Year,
COUNT(*) AS Cards
FROM Cards
GROUP BY YEAR(expiration_date)
ORDER BY Expiry_Year;

-- 7. BUSINESS KPI'S

-- TOTAL BANKING CUSTOMERS 
SELECT COUNT(*) AS Customers
FROM Customers;

-- TOTAL DEPOSITS
SELECT SUM(balance_usd)
FROM Accounts;

-- TOTAL TRANSACTION VOLUME
SELECT SUM(amount_usd)
FROM Transactions;

-- AVG CUSTOMER BALANCE
SELECT
ROUND(AVG(balance_usd),2)
FROM Accounts;

-- AVG CREDIT SCORE
SELECT
ROUND(AVG(credit_score),2)
FROM Customers;

-- TOTAL LOAN PORTFOLIO
SELECT
SUM(loan_amount)
FROM Loans;

-- TOTAL MERCHANTS
SELECT COUNT(*)
FROM Merchants;

-- TOTAL CARDS ISSUED
SELECT COUNT(*)
FROM Cards;
