use bankingdb;

-- NEGATIVE ACCOUNT BALANCE
SELECT *
FROM Accounts
WHERE balance_usd<0;

-- NEGATIVE TRANSACTION AMOUNT 
SELECT *
FROM Transactions
WHERE amount_usd<0;

-- INVALID INTEREST RATES
SELECT *
FROM Loans
WHERE interest_rate<0
OR interest_rate>100;

-- FUTURE OPEN DATES
SELECT *
FROM Accounts
WHERE open_date>CURDATE();

-- FUTURE CUSTOMER REGISTRATION
SELECT *
FROM Customers
WHERE created_at>CURDATE();

-- FUTURE LOAN DATES
SELECT *
FROM Loans
WHERE start_date>CURDATE();

-- FUTURE TRANSACTIONS
SELECT *
FROM Transactions
WHERE transaction_date>NOW();

-- DUPLICATE EMAIL ADDRESSES ------------------------------------------
SELECT email,COUNT(*)
FROM Customers
GROUP BY email
HAVING COUNT(*)>1;


SELECT *
FROM Customers
WHERE email IN (
    SELECT email
    FROM Customers
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email, customer_id;

-- ------------------------------

SELECT c.customer_id,
       c.first_name,
       c.last_name,
       c.email,
       c.city,
       c.credit_score,
       c.created_at,
       dup.email_count
FROM Customers c
INNER JOIN (
    SELECT email,
           COUNT(*) AS email_count
    FROM Customers
    GROUP BY email
    HAVING COUNT(*) > 1
) dup
ON c.email = dup.email
ORDER BY dup.email_count DESC, c.email;

-- ----------------------------------------

-- ACCOUNTS WITHOUT CUSTOMERS
SELECT a.*
FROM Accounts a
LEFT JOIN Customers c
ON a.customer_id=c.customer_id
WHERE c.customer_id IS NULL;

-- TRANSACTIONS WITHOUT ACCOUNTS
SELECT t.*
FROM Transactions t
LEFT JOIN Accounts a
ON t.account_id=a.account_id
WHERE a.account_id IS NULL;

-- TRANSACTIONS WITHOUT MERCHANTS
SELECT t.*
FROM Transactions t
LEFT JOIN Merchants m
ON t.merchant_id=m.merchant_id
WHERE m.merchant_id IS NULL;

-- CARDS WITHOUT ACCOUNTS
SELECT c.*
FROM Cards c
LEFT JOIN Accounts a
ON c.account_id=a.account_id
WHERE a.account_id IS NULL;

-- LOANS WITHOUT CUSTOMERS
SELECT l.*
FROM Loans l
LEFT JOIN Customers c
ON l.customer_id=c.customer_id
WHERE c.customer_id IS NULL;



